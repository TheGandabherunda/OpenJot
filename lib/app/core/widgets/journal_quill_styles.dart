import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_jot/app/core/theme.dart';

/// Builds shared Quill editor styles for both Write and Read journal sheets so
/// quotes, headings, paragraphs, and links render consistently.
quill.DefaultStyles buildJournalQuillStyles(
  BuildContext context,
  AppThemeColors appThemeColors, {
  bool includePlaceholder = false,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final quoteAccent =
      isDark ? const Color(0xFF7D7AFF) : const Color(0xFF5856D6);
  final linkColor = isDark ? const Color(0xFF409CFF) : const Color(0xFF007AFF);

  return quill.DefaultStyles(
    placeHolder: includePlaceholder
        ? quill.DefaultTextBlockStyle(
            TextStyle(
              fontSize: 16.sp,
              color: appThemeColors.grey2,
              height: 1.5,
            ),
            quill.HorizontalSpacing.zero,
            quill.VerticalSpacing.zero,
            quill.VerticalSpacing.zero,
            null,
          )
        : null,
    paragraph: quill.DefaultTextBlockStyle(
      TextStyle(
        fontSize: 16.sp,
        color: appThemeColors.grey10,
        height: 1.5,
      ),
      quill.HorizontalSpacing.zero,
      quill.VerticalSpacing.zero,
      quill.VerticalSpacing.zero,
      null,
    ),
    h2: quill.DefaultTextBlockStyle(
      TextStyle(
        fontSize: 26.sp,
        color: appThemeColors.grey10,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      quill.HorizontalSpacing.zero,
      quill.VerticalSpacing.zero,
      quill.VerticalSpacing.zero,
      null,
    ),
    link: TextStyle(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    ),
    quote: quill.DefaultTextBlockStyle(
      TextStyle(
        fontSize: 15.5.sp,
        color: appThemeColors.grey10.withValues(alpha: 0.88),
        height: 1.3,
      ),
      quill.HorizontalSpacing.zero,
      const quill.VerticalSpacing(6, 6),
      quill.VerticalSpacing.zero,
      BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 4.w,
            color: quoteAccent,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 0.55, 1.0],
          colors: [
            quoteAccent.withValues(alpha: isDark ? 0.34 : 0.22),
            quoteAccent.withValues(alpha: isDark ? 0.12 : 0.07),
            quoteAccent.withValues(alpha: 0.0),
          ],
        ),
      ),
    ),
  );
}
