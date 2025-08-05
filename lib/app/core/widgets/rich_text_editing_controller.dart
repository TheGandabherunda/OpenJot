import 'package:flutter/material.dart';
import 'package:open_jot/app/core/theme.dart';

extension on TextRange {
  bool overlaps(TextRange other) {
    return start < other.end && other.start < end;
  }
}

@immutable
class StyleRange {
  final String style;
  final TextRange range;
  final TextStyle textStyle;

  const StyleRange({
    required this.style,
    required this.range,
    required this.textStyle,
  });

  StyleRange copyWith({String? style, TextRange? range, TextStyle? textStyle}) {
    return StyleRange(
      style: style ?? this.style,
      range: range ?? this.range,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleRange &&
          runtimeType == other.runtimeType &&
          style == other.style &&
          range == other.range &&
          textStyle == other.textStyle;

  @override
  int get hashCode => style.hashCode ^ range.hashCode ^ textStyle.hashCode;
}

class RichTextEditingController extends TextEditingController {
  final AppThemeColors appThemeColors;
  final List<StyleRange> _styleRanges = [];
  final Set<String> _activeStyles = {};

  late final Map<String, TextStyle> _styleMap;

  RichTextEditingController({required this.appThemeColors}) {
    _styleMap = {
      'bold': const TextStyle(fontWeight: FontWeight.bold),
      'italic': const TextStyle(fontStyle: FontStyle.italic),
      'underline': const TextStyle(decoration: TextDecoration.underline),
      'strikethrough': const TextStyle(decoration: TextDecoration.lineThrough),
      'title': const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      'quote': TextStyle(
        color: appThemeColors.grey2,
        backgroundColor: appThemeColors.grey5,
        fontStyle: FontStyle.italic
      ),
    };
  }

  TextStyle? _getStyle(String style) => _styleMap[style];

  @override
  set value(TextEditingValue newValue) {
    final selectionChanged = newValue.selection != selection;

    if (newValue.text == text && !selectionChanged) {
      super.value = newValue;
      return;
    }

    if (newValue.text != text) {
      _onTextChanged(value, newValue);
    }

    if (newValue.text.isEmpty) {
      clearStyles();
    }

    super.value = newValue;

    if (selectionChanged) {
      _updateActiveStylesAtSelection();
    }
  }

  void _onTextChanged(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.start == -1 || newValue.selection.end == -1) {
      return;
    }

    _updateStyleRangesOnTextChange(oldValue, newValue);
    _applyActiveStylesOnCharacterInsertion(oldValue, newValue);
    _applyTitleStyle(newValue.text);
  }

  void _updateActiveStylesAtSelection() {
    _activeStyles.clear();
    if (selection.isCollapsed && selection.start > 0) {
      final position = selection.start;
      final activeRanges = _styleRanges.where(
        (range) =>
            range.range.start <= position - 1 && range.range.end > position - 1,
      );
      for (final range in activeRanges) {
        if (range.style == 'bold' ||
            range.style == 'italic' ||
            range.style == 'underline' ||
            range.style == 'strikethrough') {
          _activeStyles.add(range.style);
        }
      }
    }
  }

  void _updateStyleRangesOnTextChange(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    final selection = newValue.selection;

    final addedLength = newText.length - oldText.length;
    final changeStart = selection.start - (addedLength > 0 ? addedLength : 0);
    final removedLength = addedLength < 0
        ? -addedLength
        : (oldValue.selection.end - oldValue.selection.start);

    final List<StyleRange> updatedRanges = [];
    for (final range in _styleRanges) {
      final newRange = _adjustRange(
        range.range,
        changeStart,
        addedLength,
        removedLength,
        newText.length,
      );
      if (newRange != null && !newRange.isCollapsed) {
        updatedRanges.add(range.copyWith(range: newRange));
      }
    }
    _styleRanges
      ..clear()
      ..addAll(updatedRanges);
  }

  TextRange? _adjustRange(
    TextRange range,
    int changeStart,
    int addedLength,
    int removedLength,
    int newTextLength,
  ) {
    final int start = range.start;
    final int end = range.end;
    final int delta = addedLength - removedLength;
    final int changeEnd = changeStart + removedLength;

    int newStart = start;
    int newEnd = end;

    if (changeStart >= end) {
      // The change is completely after the range.
      // But if it's an insertion right at the end, the range should expand.
      if (changeStart == end && addedLength > 0) {
        newEnd += addedLength;
      }
    } else if (changeEnd <= start) {
      // The change is completely before the range.
      newStart += delta;
      newEnd += delta;
    } else {
      // The change overlaps with the range.
      if (start >= changeStart && end <= changeEnd) {
        // The range is completely inside the changed (deleted) text.
        return null; // The range is deleted.
      }

      if (start < changeStart) {
        // The change starts after the range starts.
        // The start of the range is not affected.
        // The end of the range must be adjusted.
        if (end < changeEnd) {
          // The end of the range is inside the deleted text.
          newEnd = changeStart;
        } else {
          newEnd += delta;
        }
      } else {
        // The change starts before or at the start of the range.
        newStart = changeStart + addedLength;
        if (end < changeEnd) {
          // The end of the range is inside the deleted text.
          newEnd = newStart;
        } else {
          // The end of the range is after the deleted text.
          newEnd += delta;
        }
      }
    }

    if (newStart >= newEnd) {
      return null;
    }

    return TextRange(
      start: newStart.clamp(0, newTextLength),
      end: newEnd.clamp(0, newTextLength),
    );
  }

  void _applyActiveStylesOnCharacterInsertion(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.isCollapsed && newValue.selection.start >= 0) {
      final diff = newValue.text.length - oldValue.text.length;
      if (diff > 0) {
        final start = newValue.selection.start - diff;
        final end = newValue.selection.start;
        final range = TextRange(start: start, end: end);

        for (final style in _activeStyles) {
          final textStyle = _getStyle(style);
          if (textStyle != null) {
            _addStyleInternal(style, textStyle, range);
          }
        }
      }
    }
  }

  void _applyTitleStyle(String text) {
    final firstLineEnd = text.indexOf('\n');
    final titleRange = TextRange(
      start: 0,
      end: firstLineEnd == -1 ? text.length : firstLineEnd,
    );
    _styleRanges.removeWhere((r) => r.style == 'title');
    if (titleRange.end > 0) {
      _addStyleInternal('title', _getStyle('title')!, titleRange);
    }
  }

  bool isStyleActive(String style) {
    if (style == 'quote') {
      return _isBlockStyleActive('quote');
    }
    if (style == 'bullet') {
      return _isBulletListActive();
    }
    return _isCharacterStyleActive(style);
  }

  bool _isCharacterStyleActive(String style) {
    if (selection.isCollapsed) {
      return _activeStyles.contains(style);
    } else {
      return _isRangeStyleActive(style, selection);
    }
  }

  bool _isBlockStyleActive(String style) {
    return _isRangeStyleActive(style, selection);
  }

  bool _isRangeStyleActive(String style, TextRange range) {
    if (range.isCollapsed) {
      final intersectingRanges = _styleRanges.where(
        (r) =>
            r.style == style &&
            r.range.start <= range.start &&
            r.range.end >= range.start,
      );
      return intersectingRanges.isNotEmpty;
    }

    final intersectingRanges = _styleRanges.where(
      (r) => r.style == style && r.range.overlaps(range),
    );

    if (intersectingRanges.isEmpty) return false;

    int coveredLength = 0;
    for (final r in intersectingRanges) {
      final intersectionStart = r.range.start > range.start
          ? r.range.start
          : range.start;
      final intersectionEnd = r.range.end < range.end ? r.range.end : range.end;
      coveredLength += intersectionEnd - intersectionStart;
    }

    return coveredLength >= (range.end - range.start);
  }

  bool _isBulletListActive() {
    final selectedLines = text
        .substring(selection.start, selection.end)
        .split('\n');
    return selectedLines.every((line) => line.trimLeft().startsWith('• '));
  }

  void _addStyleInternal(String style, TextStyle textStyle, TextRange range) {
    if (range.isCollapsed) return;

    _styleRanges.removeWhere(
      (r) => r.style == style && r.range.overlaps(range),
    );
    _styleRanges.add(
      StyleRange(style: style, range: range, textStyle: textStyle),
    );
  }

  void addStyle(String style, TextStyle textStyle, TextRange range) {
    _addStyleInternal(style, textStyle, range);
    notifyListeners();
  }

  void removeStyle(String style, TextRange rangeToRemove) {
    if (rangeToRemove.isCollapsed) return;

    final List<StyleRange> overlappingRanges = _styleRanges
        .where((r) => r.style == style && r.range.overlaps(rangeToRemove))
        .toList();

    _styleRanges.removeWhere((r) => overlappingRanges.contains(r));

    for (final oldRange in overlappingRanges) {
      final oldTextRange = oldRange.range;

      // Part before the removed range
      if (oldTextRange.start < rangeToRemove.start) {
        _styleRanges.add(
          oldRange.copyWith(
            range: TextRange(
              start: oldTextRange.start,
              end: rangeToRemove.start,
            ),
          ),
        );
      }

      // Part after the removed range
      if (oldTextRange.end > rangeToRemove.end) {
        _styleRanges.add(
          oldRange.copyWith(
            range: TextRange(start: rangeToRemove.end, end: oldTextRange.end),
          ),
        );
      }
    }
    notifyListeners();
  }

  void clearStyles() {
    _styleRanges.clear();
    _activeStyles.clear();
    notifyListeners();
  }

  void toggleStyle(String style, TextStyle textStyle) {
    final currentSelection = selection;
    if (currentSelection.isCollapsed) {
      if (_activeStyles.contains(style)) {
        _activeStyles.remove(style);
      } else {
        _activeStyles.add(style);
      }
    } else {
      final bool isActive = isStyleActive(style);
      if (isActive) {
        removeStyle(style, currentSelection);
      } else {
        addStyle(style, textStyle, currentSelection);
      }
    }
    notifyListeners();
  }

  void toggleQuote() {
    final currentSelection = selection;
    final start = getLineStart(currentSelection.start);
    final end = getLineEnd(currentSelection.end);
    final linesRange = TextRange(start: start, end: end);

    if (linesRange.isCollapsed && text.substring(start, end).isEmpty) {
      return; // Do nothing on empty line
    }

    final isActive = _isRangeStyleActive('quote', linesRange);
    final quoteStyle = _getStyle('quote')!;

    if (isActive) {
      removeStyle('quote', linesRange);
    } else {
      addStyle('quote', quoteStyle, linesRange);
    }
  }

  void toggleBulletPoints() {
    if (selection.isCollapsed &&
        getLineAtCursor(selection.start).trim().isEmpty) {
      final currentLineStart = getLineStart(selection.start);
      text = text.replaceRange(currentLineStart, currentLineStart, '• ');
      selection = TextSelection.fromPosition(
        TextPosition(offset: selection.start + 2),
      );
      return;
    }

    final selectionStartLine = getLineAtCursor(selection.start);
    final selectedLinesRange = TextRange(
      start: getLineStart(selection.start),
      end: getLineEnd(selection.end),
    );
    final selectedLines = text
        .substring(selectedLinesRange.start, selectedLinesRange.end)
        .split('\n');

    final bool areAllLinesBulleted = selectedLines.every(
      (line) => line.trimLeft().startsWith('• '),
    );

    String newText;
    int charDelta = 0;

    if (areAllLinesBulleted) {
      newText = selectedLines
          .map((line) {
            final originalLength = line.length;
            final newLine = line.replaceFirst(RegExp(r'^\s*•\s?'), '');
            charDelta -= originalLength - newLine.length;
            return newLine;
          })
          .join('\n');
    } else {
      newText = selectedLines
          .map((line) {
            if (line.trim().isNotEmpty && !line.trimLeft().startsWith('• ')) {
              final originalLength = line.length;
              final newLine = '• $line';
              charDelta += newLine.length - originalLength;
              return newLine;
            }
            return line;
          })
          .join('\n');
    }

    text = text.replaceRange(
      selectedLinesRange.start,
      selectedLinesRange.end,
      newText,
    );

    selection = TextSelection(
      baseOffset: selection.start,
      extentOffset: (selection.end + charDelta).clamp(0, text.length),
    );
  }

  @override
  void clear() {
    _styleRanges.clear();
    _activeStyles.clear();
    super.clear();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = [];
    final plainText = text;
    final lines = plainText.split('\n');
    int start = 0;

    for (final line in lines) {
      final end = start + line.length;
      final lineRange = TextRange(start: start, end: end);
      final isQuote = _styleRanges.any(
        (r) =>
            r.style == 'quote' &&
            (r.range.overlaps(lineRange) ||
                r.range.start == r.range.end &&
                    r.range.start >= lineRange.start &&
                    r.range.end <= lineRange.end ||
                r.range.end == lineRange.start ||
                r.range.start == lineRange.end),
      );

      if (isQuote) {
        children.add(
          WidgetSpan(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: appThemeColors.grey5, width: 2.0),
                ),
              ),
              padding: const EdgeInsets.only(left: 4.0),
              child: Text.rich(
                _buildTextSpanForRange(
                  TextRange(start: start, end: end),
                  style,
                  plainText,
                ),
              ),
            ),
          ),
        );
      } else {
        children.add(
          _buildTextSpanForRange(
            TextRange(start: start, end: end),
            style,
            plainText,
          ),
        );
      }
      if (end < plainText.length || line.isEmpty && end == plainText.length) {
        children.add(const TextSpan(text: '\n'));
      }

      start = end + 1;
    }

    return TextSpan(children: children, style: style);
  }

  TextSpan _buildTextSpanForRange(
    TextRange range,
    TextStyle? style,
    String plainText,
  ) {
    final Set<int> splitPoints = {range.start, range.end};
    for (final styleRange in _styleRanges) {
      if (styleRange.range.overlaps(range)) {
        splitPoints.add(styleRange.range.start.clamp(range.start, range.end));
        splitPoints.add(styleRange.range.end.clamp(range.start, range.end));
      }
    }

    final sortedPoints = splitPoints.toList()..sort();
    final List<TextSpan> spans = [];

    for (int i = 0; i < sortedPoints.length - 1; i++) {
      final int start = sortedPoints[i];
      final int end = sortedPoints[i + 1];

      if (start >= end) continue;

      final double midpoint = start + (end - start) / 2;
      TextStyle combinedStyle = style ?? const TextStyle();
      final activeRanges = _styleRanges.where(
        (range) => range.range.start <= midpoint && range.range.end > midpoint,
      );

      for (final range in activeRanges) {
        if (range.style != 'quote') {
          combinedStyle = combinedStyle.merge(range.textStyle);
        } else {
          combinedStyle = combinedStyle.merge(_getStyle('quote'));
        }
      }
      spans.add(
        TextSpan(text: plainText.substring(start, end), style: combinedStyle),
      );
    }
    return TextSpan(children: spans, style: style);
  }

  String getLineAtCursor(int position) {
    final start = getLineStart(position);
    final end = getLineEnd(position);
    return text.substring(start, end);
  }

  int getLineStart(int position) {
    int lineStart = 0;
    for (int i = position - 1; i >= 0; i--) {
      if (text[i] == '\n') {
        lineStart = i + 1;
        break;
      }
    }
    return lineStart;
  }

  int getLineEnd(int position) {
    int lineEnd = text.length;
    for (int i = position; i < text.length; i++) {
      if (text[i] == '\n') {
        lineEnd = i;
        break;
      }
    }
    return lineEnd;
  }
}
