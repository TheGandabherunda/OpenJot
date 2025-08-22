import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
// Assuming JournalEntry is in this path, adjust if necessary.
import 'package:open_jot/app/core/models/journal_entry.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_manager/photo_manager.dart';
import 'package:printing/printing.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// A helper class to hold the parsed information for a single line of text.
class _PdfLine {
  final List<pw.InlineSpan> spans;
  final Map<String, dynamic>? attributes;

  _PdfLine(this.spans, this.attributes);
}

// Helper class to distinguish between image bytes and video thumbnail bytes.
class _VisualMedia {
  final Uint8List bytes;
  final bool isVideo;

  _VisualMedia(this.bytes, this.isVideo);
}

/// A PDF generator for journal entries with emoji support.
///
/// This version is optimized for English content and uses the 'Inter' font,
/// with fallbacks for emoji and symbol characters.
class PdfGenerator {
  /// Generates a PDF from a journal entry and initiates a share dialog.
  static Future<void> generateAndSharePdf(JournalEntry entry) async {
    final pdf = pw.Document();

    // --- 1. Load Fonts ---
    // Load standard text fonts.
    final font = await PdfGoogleFonts.interRegular();
    final boldFont = await PdfGoogleFonts.interBold();
    final italicFont = await PdfGoogleFonts.interItalic();
    final boldItalicFont = await PdfGoogleFonts.interBoldItalic();
    final mediumFont = await PdfGoogleFonts.interMedium();

    // Load fonts for symbols and emojis.
    final symbolFont = await PdfGoogleFonts.notoSansSymbolsBold();
    final emojiFont = await PdfGoogleFonts.notoColorEmoji();

    // ** UPDATED: Create a theme that uses Inter and falls back ONLY to the emoji font. **
    // This handles emojis anywhere in the text. Other symbols will be handled explicitly.
    final theme = pw.ThemeData.withFont(
      base: font,
      bold: boldFont,
      italic: italicFont,
      boldItalic: boldItalicFont,
      fontFallback: [emojiFont],
    );

    // --- 2. Load Assets ---
    final appIconSvg = await rootBundle.loadString('assets/app_icon.svg');
    String? moodSvg;
    if (entry.moodIndex != null) {
      moodSvg =
      await rootBundle.loadString('assets/${entry.moodIndex! + 1}.svg');
    }

    // --- 3. Load and Process Media Assets ---
    final List<_VisualMedia> visualMedia = [];

    // Helper to check if a file path represents a video.
    bool isVideoFile(String path) {
      final lowercasedPath = path.toLowerCase();
      return lowercasedPath.endsWith('.mp4') ||
          lowercasedPath.endsWith('.mov') ||
          lowercasedPath.endsWith('.avi') ||
          lowercasedPath.endsWith('.wmv') ||
          lowercasedPath.endsWith('.mkv');
    }

    // Process gallery assets (images and videos)
    for (var asset in entry.galleryImages) {
      final file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.video) {
          final thumbnail = await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 300,
            quality: 50,
          );
          if (thumbnail != null) {
            visualMedia.add(_VisualMedia(thumbnail, true));
          }
        } else {
          visualMedia.add(_VisualMedia(await file.readAsBytes(), false));
        }
      }
    }

    // Process camera photos (which can also be videos)
    for (var photo in entry.cameraPhotos) {
      final file = photo.file;
      if (isVideoFile(file.path)) {
        final thumbnail = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 300,
          quality: 50,
        );
        if (thumbnail != null) {
          visualMedia.add(_VisualMedia(thumbnail, true));
        }
      } else {
        visualMedia.add(_VisualMedia(await file.readAsBytes(), false));
      }
    }

    // --- 4. Build the PDF page ---
    pdf.addPage(
      pw.MultiPage(
        // Apply the theme to the entire page.
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (context) => _buildFooter(appIconSvg, boldFont),
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // --- Header: Date and Time ---
                _buildDateHeader(entry, mediumFont),
                pw.SizedBox(height: 24),

                // --- Attached Images & Video Thumbnails ---
                if (visualMedia.isNotEmpty) ...[
                  _buildMediaGrid(visualMedia),
                  pw.SizedBox(height: 20),
                ],

                // --- Attached Audio Files ---
                if (entry.recordings.isNotEmpty ||
                    entry.galleryAudios.isNotEmpty) ...[
                  // ** UPDATED: Pass the specific symbol font. **
                  _buildAudioList(entry, symbolFont),
                  pw.SizedBox(height: 20),
                ],

                // --- Journal Text (from Quill Delta) ---
                if (entry.content.toPlainText().trim().isNotEmpty)
                  _buildJournalTextFromDelta(entry),
                pw.SizedBox(height: 20),

                // --- Location and Mood ---
                _buildLocationAndMood(entry, moodSvg),
              ],
            )
          ];
        },
      ),
    );

    // --- 5. Save and share ---
    final fileName =
        'Journal_Entry_${intl.DateFormat('yyyy-MM-dd_HH-mm').format(entry.createdAt)}.pdf';
    await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
  }

  // --- PDF Component Builders ---

  /// Builds the header section with the formatted date.
  static pw.Widget _buildDateHeader(JournalEntry entry, pw.Font mediumFont) {
    final formattedDate =
    intl.DateFormat('EEEE, MMM d').format(entry.createdAt);
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        formattedDate,
        style: pw.TextStyle(
          font: mediumFont, // Keep specific font for styling
          fontSize: 16,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  /// Builds the main text block by parsing the Quill editor's delta format.
  static pw.Widget _buildJournalTextFromDelta(JournalEntry entry) {
    final delta = entry.content.toDelta().toJson();
    final List<_PdfLine> lines = [];
    List<pw.InlineSpan> currentSpans = [];

    for (final op in delta) {
      if (!op.containsKey('insert')) continue;

      final text = op['insert'] as String;
      final attributes = op['attributes'] as Map<String, dynamic>?;
      final textLines = text.split('\n');

      for (int i = 0; i < textLines.length; i++) {
        final lineText = textLines[i];
        if (lineText.isNotEmpty) {
          pw.TextStyle style = const pw.TextStyle(
            fontSize: 16,
            color: PdfColors.black,
            height: 1.5,
          );
          final List<pw.TextDecoration> decorations = [];

          if (attributes != null) {
            final isBold = attributes['bold'] == true;
            final isItalic = attributes['italic'] == true;

            if (isBold && isItalic) {
              style = style.copyWith(fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic);
            } else if (isBold) {
              style = style.copyWith(fontWeight: pw.FontWeight.bold);
            } else if (isItalic) {
              style = style.copyWith(fontStyle: pw.FontStyle.italic);
            }

            if (attributes['underline'] == true) {
              decorations.add(pw.TextDecoration.underline);
            }
            if (attributes['strike'] == true) {
              decorations.add(pw.TextDecoration.lineThrough);
            }

            if (attributes.containsKey('header')) {
              final level = attributes['header'];
              if (level == 1) style = style.copyWith(fontSize: 24, fontWeight: pw.FontWeight.bold);
              if (level == 2) style = style.copyWith(fontSize: 20, fontWeight: pw.FontWeight.bold);
            }
          }
          currentSpans.add(pw.TextSpan(
            text: lineText,
            style: style.copyWith(decoration: pw.TextDecoration.combine(decorations)),
          ));
        }

        if (i < textLines.length - 1) {
          lines.add(_PdfLine(List.from(currentSpans), attributes));
          currentSpans.clear();
        }
      }
    }

    if (currentSpans.isNotEmpty) {
      final lastOp =
      delta.lastWhere((op) => op.containsKey('insert'), orElse: () => {});
      lines.add(_PdfLine(List.from(currentSpans), lastOp['attributes']));
    }

    final List<pw.Widget> contentWidgets = [];
    int orderedListCounter = 1;
    String? lastListType;

    for (final line in lines) {
      if (line.spans.isEmpty) {
        contentWidgets.add(pw.SizedBox(height: 16));
        continue;
      }

      pw.Widget lineWidget =
      pw.RichText(text: pw.TextSpan(children: line.spans));

      final attributes = line.attributes;
      String? currentListType = attributes?['list'];

      if (currentListType != lastListType) {
        orderedListCounter = 1;
      }
      lastListType = currentListType;

      if (attributes != null) {
        if (attributes['blockquote'] == true) {
          lineWidget = pw.Container(
            padding: const pw.EdgeInsets.only(left: 10, top: 4, bottom: 4),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                  left: pw.BorderSide(color: PdfColors.grey300, width: 2)),
            ),
            child: lineWidget,
          );
        }

        if (attributes['list'] == 'bullet') {
          lineWidget = pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 20,
                child: pw.Text('•', style: const pw.TextStyle(fontSize: 16, height: 1.5)),
              ),
              pw.Expanded(child: lineWidget),
            ],
          );
        }

        if (attributes['list'] == 'ordered') {
          lineWidget = pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(
                width: 20,
                child: pw.Text('${orderedListCounter++}.',
                    style: const pw.TextStyle(fontSize: 16, height: 1.5)),
              ),
              pw.Expanded(child: lineWidget),
            ],
          );
        }
      }
      contentWidgets.add(lineWidget);
      if (attributes != null && attributes.containsKey('header')) {
        contentWidgets.add(pw.SizedBox(height: 8));
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  /// Builds a responsive grid for attached images and video thumbnails.
  /// The '►' symbol will use the default theme font, which is Inter.
  static pw.Widget _buildMediaGrid(List<_VisualMedia> media) {
    return pw.Wrap(
      spacing: 12,
      runSpacing: 12,
      children: media.take(6).map((item) {
        return pw.Container(
          width: 150,
          height: 150,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300, width: 1.5),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
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
                    '►', // This will use Inter font from the theme.
                    style: const pw.TextStyle(
                      color: PdfColor(1, 1, 1, 0.78),
                      fontSize: 48,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds a list to display audio files.
  /// ** UPDATED: Accepts a specific font for the '♫' symbol. **
  static pw.Widget _buildAudioList(JournalEntry entry, pw.Font symbolFont) {
    String formatDuration(Duration duration) {
      if (duration == Duration.zero) return "--:--";
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final seconds = twoDigits(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }

    final List<pw.Widget> audioWidgets = [];

    pw.Widget buildAudioItem(String title, String durationStr) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#EFEFEF'),
          borderRadius: pw.BorderRadius.circular(20),
        ),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text('♫',
                // ** UPDATED: Use the specific symbol font for this character. **
                style: pw.TextStyle(font: symbolFont, fontSize: 16, color: PdfColors.grey800)),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Text(title, style: const pw.TextStyle(fontSize: 14)),
            ),
            pw.SizedBox(width: 8),
            pw.Text(durationStr,
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey600)),
          ],
        ),
      );
    }

    for (final recording in entry.recordings) {
      audioWidgets.add(
          buildAudioItem(recording.name, formatDuration(recording.duration)));
      audioWidgets.add(pw.SizedBox(height: 8));
    }

    for (final audio in entry.galleryAudios) {
      audioWidgets.add(buildAudioItem(audio.title ?? "Audio Track",
          formatDuration(Duration(seconds: audio.duration))));
      audioWidgets.add(pw.SizedBox(height: 8));
    }

    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: audioWidgets,
    );
  }

  /// Builds the row containing location and mood information.
  static pw.Widget _buildLocationAndMood(JournalEntry entry, String? moodSvg) {
    if (entry.location == null && moodSvg == null) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (entry.location != null)
            pw.Row(children: [
              pw.SizedBox(width: 6),
              pw.Text(
                '${entry.location!.coordinates.latitude.toStringAsFixed(4)}, ${entry.location!.coordinates.longitude.toStringAsFixed(4)}',
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
            ]),
          if (entry.location != null && moodSvg != null) pw.SizedBox(width: 12),
          if (moodSvg != null) pw.SvgImage(svg: moodSvg, width: 28, height: 28),
        ],
      ),
    );
  }

  /// Builds the footer with the app icon and name.
  static pw.Widget _buildFooter(String appIconSvg, pw.Font boldFont) {
    return pw.Center(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('#EFEFEF'),
          borderRadius: pw.BorderRadius.circular(20),
        ),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SvgImage(svg: appIconSvg, width: 20, height: 20),
            pw.SizedBox(width: 8),
            pw.Text(
              'OpenJot',
              style: pw.TextStyle(
                font: boldFont, // Keep specific font for branding
                fontSize: 16,
                color: PdfColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
