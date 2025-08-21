import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../core/models/journal_entry.dart';

// A helper class to hold the parsed information for a single line of text.
class _PdfLine {
  final List<pw.InlineSpan> spans;
  final Map<String, dynamic>? attributes;

  _PdfLine(this.spans, this.attributes);
}

/// A simplified PDF generator for journal entries.
/// This version is optimized for English content and uses the 'Inter' font.
class PdfGenerator {
  /// Generates a PDF from a journal entry and initiates a share dialog.
  static Future<void> generateAndSharePdf(JournalEntry entry) async {
    final pdf = pw.Document();

    // --- 1. Load Fonts ---
    // Load all required styles of the 'Inter' font to support rich text.
    final font = await PdfGoogleFonts.interRegular();
    final boldFont = await PdfGoogleFonts.interBold();
    final italicFont = await PdfGoogleFonts.interItalic();
    final boldItalicFont = await PdfGoogleFonts.interBoldItalic();
    final mediumFont = await PdfGoogleFonts.interMedium();

    // --- 2. Load Assets ---
    // Load the app icon and mood icon from the assets folder.
    final appIconSvg = await rootBundle.loadString('assets/app_icon.svg');
    String? moodSvg;
    if (entry.moodIndex != null) {
      moodSvg =
          await rootBundle.loadString('assets/${entry.moodIndex! + 1}.svg');
    }

    // --- 3. Load Media Assets ---
    // Collect all images from the device gallery and camera photos.
    final List<Uint8List> imageBytes = [];
    for (var asset in entry.galleryImages) {
      final file = await asset.file;
      if (file != null) {
        imageBytes.add(await file.readAsBytes());
      }
    }
    for (var photo in entry.cameraPhotos) {
      imageBytes.add(await photo.file.readAsBytes());
    }

    // --- 4. Build the PDF page ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        // Use the footer callback to place the footer at the bottom of each page
        footer: (context) => _buildFooter(appIconSvg, boldFont),
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // --- Header: Date and Time ---
                _buildDateHeader(entry, mediumFont),
                pw.SizedBox(height: 24),

                // --- Attached Images ---
                if (imageBytes.isNotEmpty) ...[
                  _buildMediaGrid(imageBytes),
                  pw.SizedBox(height: 20),
                ],

                // --- Journal Text (from Quill Delta) ---
                if (entry.content.toPlainText().trim().isNotEmpty)
                  _buildJournalTextFromDelta(
                    entry,
                    font,
                    boldFont,
                    italicFont,
                    boldItalicFont,
                  ),

                pw.SizedBox(height: 20),

                // --- Location and Mood ---
                _buildLocationAndMood(entry, moodSvg, font),
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
  static pw.Widget _buildDateHeader(JournalEntry entry, pw.Font font) {
    final formattedDate =
        intl.DateFormat('EEEE, MMM d').format(entry.createdAt);

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        formattedDate,
        style: pw.TextStyle(
          font: font,
          fontSize: 16,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  /// Builds the main text block by parsing the Quill editor's delta format.
  static pw.Widget _buildJournalTextFromDelta(
    JournalEntry entry,
    pw.Font regularFont,
    pw.Font boldFont,
    pw.Font italicFont,
    pw.Font boldItalicFont,
  ) {
    final delta = entry.content.toDelta().toJson();
    final List<_PdfLine> lines = [];
    List<pw.InlineSpan> currentSpans = [];

    // First pass: Parse the delta into a list of logical lines (_PdfLine).
    for (final op in delta) {
      if (!op.containsKey('insert')) continue;

      final text = op['insert'] as String;
      final attributes = op['attributes'] as Map<String, dynamic>?;
      final textLines = text.split('\n');

      for (int i = 0; i < textLines.length; i++) {
        final lineText = textLines[i];
        if (lineText.isNotEmpty) {
          pw.Font font = regularFont;
          double fontSize = 16;
          final List<pw.TextDecoration> decorations = [];

          if (attributes != null) {
            final isBold = attributes['bold'] == true;
            final isItalic = attributes['italic'] == true;

            if (isBold && isItalic)
              font = boldItalicFont;
            else if (isBold)
              font = boldFont;
            else if (isItalic) font = italicFont;

            if (attributes['underline'] == true)
              decorations.add(pw.TextDecoration.underline);
            if (attributes['strike'] == true)
              decorations.add(pw.TextDecoration.lineThrough);

            if (attributes.containsKey('header')) {
              final level = attributes['header'];
              if (level == 1) fontSize = 24;
              if (level == 2) fontSize = 20;
              if (level == 1 || level == 2) font = boldFont;
            }
          }
          currentSpans.add(pw.TextSpan(
            text: lineText,
            style: pw.TextStyle(
              font: font,
              fontSize: fontSize,
              color: PdfColors.black,
              height: 1.5,
              decoration: pw.TextDecoration.combine(decorations),
            ),
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

    // Second pass: Build the widgets from the parsed lines.
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
        orderedListCounter = 1; // Reset counter when list type changes
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
                child: pw.Text('•',
                    style: pw.TextStyle(
                        font: regularFont, fontSize: 16, height: 1.5)),
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
                    style: pw.TextStyle(
                        font: regularFont, fontSize: 16, height: 1.5)),
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

  /// Builds a responsive grid for attached media images.
  static pw.Widget _buildMediaGrid(List<Uint8List> imageBytes) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: imageBytes.take(6).map((bytes) {
        // Limit to 6 images
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
            child: pw.Image(
              pw.MemoryImage(bytes),
              fit: pw.BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Builds the row containing location and mood information.
  static pw.Widget _buildLocationAndMood(
      JournalEntry entry, String? moodSvg, pw.Font font) {
    if (entry.location == null && moodSvg == null) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Location Text
          if (entry.location != null)
            pw.Row(children: [
              pw.SizedBox(width: 6),
              pw.Text(
                '${entry.location!.coordinates.latitude.toStringAsFixed(4)}, ${entry.location!.coordinates.longitude.toStringAsFixed(4)}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 14,
                  color: PdfColors.grey700,
                ),
              ),
            ]),

          // Spacer
          if (entry.location != null && moodSvg != null) pw.SizedBox(width: 12),

          // Mood Icon
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
                fontSize: 16,
                color: PdfColors.black, // Ensure footer text is visible
              ),
            ),
          ],
        ),
      ),
    );
  }
}
