import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:intl/intl.dart' as intl;
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_manager/photo_manager.dart';
import 'package:printing/printing.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/// Usable column width in PDF points. A4 = 595pt, margins 32pt each = 531pt.
const double _kColumnWidthPt = 531.0;

/// Render scale: how many device pixels we allocate per PDF point.
/// 2.0 gives crisp text on screen and print. Increase to 3.0 for laser-print
/// quality (at the cost of a larger PDF file).
const double _kRenderScale = 2.0;

const double _kColumnWidthPx = _kColumnWidthPt * _kRenderScale;

// ---------------------------------------------------------------------------
// Delta parsing — preserves every inline + block attribute
// ---------------------------------------------------------------------------

class _Run {
  const _Run(
      this.text, {
        this.bold = false,
        this.italic = false,
        this.underline = false,
        this.strikethrough = false,
      });
  final String text;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
}

class _Line {
  const _Line(this.runs, this.blockAttrs);
  final List<_Run> runs;
  final Map<String, dynamic>? blockAttrs;

  String get plainText => runs.map((r) => r.text).join();
  bool get isEmpty => plainText.trim().isEmpty;

  bool get isBullet => blockAttrs?['list'] == 'bullet';
  bool get isOrdered => blockAttrs?['list'] == 'ordered';
  bool get isBlockquote => blockAttrs?['blockquote'] == true;
  int get headerLevel {
    final h = blockAttrs?['header'];
    return h is int ? h : 0;
  }
}

List<_Line> _parseLines(List<dynamic> deltaJson) {
  final List<_Run> cur = [];
  final List<_Line> out = [];

  for (final op in deltaJson) {
    final insert = op['insert'];
    if (insert is! String) continue;
    final attrs = op['attributes'] as Map<String, dynamic>?;
    final parts = insert.split('\n');

    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        cur.add(_Run(
          part,
          bold: attrs?['bold'] == true,
          italic: attrs?['italic'] == true,
          underline: attrs?['underline'] == true,
          strikethrough: attrs?['strike'] == true,
        ));
      }
      if (i < parts.length - 1) {
        // The newline op carries the block-level attributes in Quill Delta.
        out.add(_Line(List.from(cur), attrs));
        cur.clear();
      }
    }
  }
  // Flush any trailing content (edge case for malformed deltas).
  if (cur.isNotEmpty) out.add(_Line(cur, null));
  return out;
}

// ---------------------------------------------------------------------------
// Core rendering: Flutter TextPainter → PNG bytes
//
// WHY: The `pdf` package uses its own HarfBuzz build that lacks the full ICU
// locale data required for Indic conjunct shaping. Text rendered with
// pw.Text always passes through this limited shaper, which splits syllables.
//
// Rendering via Flutter's own ui.ParagraphBuilder / TextPainter uses the
// SAME engine that draws text on screen — full ICU, full HarfBuzz, every
// language correct. We then embed the PNG as an image in the PDF.
// ---------------------------------------------------------------------------

Future<({Uint8List png, double heightPt})> _renderLineAsPng(
    _Line line,
    int orderedIndex, // only used when line.isOrdered
    ) async {
  final double fontSizePx = _baseFontSizePx(line);

  // Build the span list.
  final List<InlineSpan> spans = [];

  // List prefix rendered inline so it flows with the text direction.
  if (line.isBullet) {
    spans.add(TextSpan(
      text: '• ',
      style: TextStyle(
        fontSize: fontSizePx,
        color: Colors.black,
        height: 1.45,
      ),
    ));
  } else if (line.isOrdered) {
    spans.add(TextSpan(
      text: '$orderedIndex. ',
      style: TextStyle(
        fontSize: fontSizePx,
        color: Colors.black,
        height: 1.45,
      ),
    ));
  }

  for (final run in line.runs) {
    final decorations = <TextDecoration>[];
    if (run.underline) decorations.add(TextDecoration.underline);
    if (run.strikethrough) {
      decorations.add(TextDecoration.lineThrough);
    }

    spans.add(TextSpan(
      text: run.text,
      style: TextStyle(
        fontSize: fontSizePx,
        fontWeight: (run.bold || line.headerLevel > 0)
            ? FontWeight.bold
            : FontWeight.normal,
        fontStyle: run.italic ? FontStyle.italic : FontStyle.normal,
        decoration: decorations.isEmpty
            ? TextDecoration.none
            : TextDecoration.combine(decorations),
        decorationColor: Colors.black,
        color: Colors.black,
        height: 1.45,
      ),
    ));
  }

  // Detect overall text direction from the content.
  final bool isRtl = intl.Bidi.hasAnyRtl(line.plainText);
  final TextDirection dir =
  isRtl ? TextDirection.rtl : TextDirection.ltr;

  // Measurement logic
  const double blockquotePadPx = 14.0 * _kRenderScale;

  final double availableWidthPx = line.isBlockquote
      ? _kColumnWidthPx - blockquotePadPx
      : _kColumnWidthPx;

  // Measure.
  final painter = TextPainter(
    text: TextSpan(
      children: spans,
      // No explicit font family: Flutter will automatically use the system
      // font for each script (Noto on Android, appropriate system font on iOS).
    ),
    textDirection: dir,
    textAlign: isRtl ? TextAlign.right : TextAlign.left,
  )..layout(maxWidth: availableWidthPx);

  // Add a small vertical buffer so descenders / top diacritics are not clipped.
  final double extraPx = fontSizePx * 0.35;
  final double totalHeightPx = painter.height + extraPx;
  const double totalWidthPx = _kColumnWidthPx;

  // Draw.
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Blockquote: draw side bar.
  if (line.isBlockquote) {
    final barPaint = Paint()
      ..color = const Color(0xFFBBBBBB)
      ..strokeWidth = 3.0 * _kRenderScale
      ..style = PaintingStyle.fill;

    final double barX = isRtl
        ? totalWidthPx - 2.0 * _kRenderScale
        : 2.0 * _kRenderScale;

    canvas.drawRect(
      Rect.fromLTWH(barX, 0, 3.0 * _kRenderScale, totalHeightPx),
      barPaint,
    );
  }

  final double textOffsetX = line.isBlockquote
      ? (isRtl ? 0.0 : blockquotePadPx)
      : 0.0;

  painter.paint(canvas, Offset(textOffsetX, extraPx * 0.5));

  final picture = recorder.endRecording();

  // Rasterise to a ui.Image then encode as PNG.
  final img = await picture.toImage(
    totalWidthPx.ceil(),
    totalHeightPx.ceil(),
  );
  final byteData =
  await img.toByteData(format: ui.ImageByteFormat.png);

  img.dispose();

  final png = byteData!.buffer.asUint8List();
  final double heightPt = totalHeightPx / _kRenderScale;

  return (png: png, heightPt: heightPt);
}

double _baseFontSizePx(_Line line) {
  final double basePt = switch (line.headerLevel) {
    1 => 24.0,
    2 => 20.0,
    _ => 16.0,
  };
  return basePt * _kRenderScale;
}

// ---------------------------------------------------------------------------
// Media helpers
// ---------------------------------------------------------------------------

class _VisualMedia {
  const _VisualMedia(this.bytes, this.isVideo);
  final Uint8List bytes;
  final bool isVideo;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

class PdfGenerator {
  static Future<void> generateAndSharePdf(JournalEntry entry) async {
    try {
      final pdf = pw.Document();

      // --- Fonts (only for the non-rasterised sections) ---
      final boldFont = await PdfGoogleFonts.notoSansBold();
      final baseFont = await PdfGoogleFonts.notoSansRegular();
      final symFont = await PdfGoogleFonts.notoSansSymbolsBold();
      final theme = pw.ThemeData.withFont(
        base: baseFont,
        bold: boldFont,
      );

      // --- SVG assets ---
      final appIconSvg =
      await rootBundle.loadString('assets/app_icon.svg');
      String? moodSvg;
      if (entry.moodIndex != null) {
        moodSvg = await rootBundle
            .loadString('assets/${entry.moodIndex! + 1}.svg');
      }

      // --- Media ---
      final List<_VisualMedia> visualMedia = [];
      for (final asset in entry.galleryImages) {
        try {
          final file = await asset.file;
          if (file != null) {
            if (asset.type == AssetType.video) {
              final thumb = await VideoThumbnail.thumbnailData(
                  video: file.path, maxWidth: 600, quality: 80);
              if (thumb != null) {
                visualMedia.add(_VisualMedia(thumb, true));
              }
            } else {
              visualMedia.add(
                  _VisualMedia(await file.readAsBytes(), false));
            }
          }
        } catch (_) {}
      }
      for (final photo in entry.cameraPhotos) {
        try {
          visualMedia.add(
              _VisualMedia(await photo.file.readAsBytes(), false));
        } catch (_) {}
      }

      // --- Rasterise text lines via Flutter's engine ---
      final lines = _parseLines(entry.content.toDelta().toJson());
      final List<pw.Widget> textWidgets = [];
      int orderedCounter = 1;

      for (final line in lines) {
        if (line.isEmpty) {
          textWidgets.add(pw.SizedBox(height: 10));
          if (!line.isOrdered) orderedCounter = 1;
          continue;
        }

        final rendered =
        await _renderLineAsPng(line, orderedCounter);

        if (line.isOrdered) {
          orderedCounter++;
        } else {
          orderedCounter = 1;
        }

        textWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 1),
            child: pw.Image(
              pw.MemoryImage(rendered.png),
              width: _kColumnWidthPt,
              height: rendered.heightPt,
              fit: pw.BoxFit.fill,
            ),
          ),
        );
      }

      // --- Assemble PDF ---
      pdf.addPage(
        pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          footer: (_) => _buildFooter(appIconSvg, boldFont),
          build: (context) => [
            if (visualMedia.isNotEmpty) ...[
              pw.Center(child: _buildMediaGrid(visualMedia)),
              pw.SizedBox(height: 32),
            ],
            if (entry.recordings.isNotEmpty ||
                entry.galleryAudios.isNotEmpty) ...[
              pw.Center(child: _buildAudioList(entry, symFont)),
              pw.SizedBox(height: 32),
            ],
            _buildDateHeader(entry, boldFont),
            pw.SizedBox(height: 8),
            pw.Center(
                child: _buildLocationAndMood(entry, moodSvg)),
            pw.SizedBox(height: 40),
            if (textWidgets.isNotEmpty) ...textWidgets,
          ],
        ),
      );

      final bytes = await pdf.save();
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'Journal_Entry_${intl.DateFormat('yyyy-MM-dd_HH-mm').format(entry.createdAt)}.pdf',
      );
    } catch (e) {
      // PDF generation failed
      rethrow;
    }
  }

  // -------------------------------------------------------------------------
  // Non-text section builders
  // -------------------------------------------------------------------------

  static pw.Widget _buildDateHeader(
      JournalEntry entry, pw.Font boldFont) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text(
        intl.DateFormat('EEEE, MMM d, yyyy  •  h:mm a')
            .format(entry.createdAt),
        style: pw.TextStyle(
            font: boldFont,
            fontSize: 14,
            color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget _buildLocationAndMood(
      JournalEntry entry, String? moodSvg) {
    if (entry.location == null && moodSvg == null) {
      return pw.SizedBox.shrink();
    }
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        if (moodSvg != null) ...[
          pw.SvgImage(svg: moodSvg, width: 24, height: 24),
          pw.SizedBox(width: 12),
        ],
        if (entry.location != null)
          pw.Text(
            '${entry.location!.coordinates.latitude.toStringAsFixed(4)}, '
                '${entry.location!.coordinates.longitude.toStringAsFixed(4)}',
            style: const pw.TextStyle(
                fontSize: 14, color: PdfColors.grey700),
          ),
      ],
    );
  }

  static pw.Widget _buildMediaGrid(List<_VisualMedia> media) {
    return pw.Wrap(
      spacing: 12,
      runSpacing: 12,
      children: media.take(6).map((item) {
        return pw.Container(
          width: 150,
          height: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
                color: PdfColors.grey300, width: 1.5),
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.ClipRRect(
            horizontalRadius: 10.5,
            verticalRadius: 10.5,
            child: pw.Stack(
              alignment: pw.Alignment.center,
              children: [
                pw.Image(
                  pw.MemoryImage(item.bytes),
                  width: 150,
                  height: 150,
                  fit: pw.BoxFit.cover,
                ),
                if (item.isVideo)
                  pw.Text(
                    '►',
                    style: const pw.TextStyle(
                        color: PdfColor(1, 1, 1, 0.78),
                        fontSize: 48),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _buildAudioList(
      JournalEntry entry, pw.Font sym) {
    String fmt(Duration d) => d == Duration.zero
        ? '--:--'
        : '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    pw.Widget item(String t, String d) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(
          vertical: 6, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#EFEFEF'),
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text('♫',
              style: pw.TextStyle(
                  font: sym,
                  fontSize: 16,
                  color: PdfColors.grey800)),
          pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Text(
              t,
              style: const pw.TextStyle(fontSize: 14),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(d,
              style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey600)),
        ],
      ),
    );

    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final r in entry.recordings)
          item(r.name, fmt(r.duration)),
        for (final a in entry.galleryAudios)
          item(a.title ?? 'Audio',
              fmt(Duration(seconds: a.duration))),
      ],
    );
  }

  static pw.Widget _buildFooter(
      String appIconSvg, pw.Font boldFont) {
    return pw.Center(
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.SvgImage(svg: appIconSvg, width: 18, height: 18),
          pw.SizedBox(width: 8),
          pw.Text(
            'OpenJot',
            style: pw.TextStyle(
                font: boldFont,
                fontSize: 14,
                color: PdfColors.black),
          ),
        ],
      ),
    );
  }
}