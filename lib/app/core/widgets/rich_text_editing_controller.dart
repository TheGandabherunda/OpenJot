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
  bool _quoteMode = false; // Track persistent quote mode

  late final Map<String, TextStyle> _styleMap;

  RichTextEditingController({required this.appThemeColors, String? text})
      : super(text: text) {
    _styleMap = {
      'bold': const TextStyle(fontWeight: FontWeight.bold),
      'italic': const TextStyle(fontStyle: FontStyle.italic),
      'underline': const TextStyle(decoration: TextDecoration.underline),
      'strikethrough': const TextStyle(decoration: TextDecoration.lineThrough),
      'title': const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      'quote': TextStyle(
        color: appThemeColors.grey2,
        backgroundColor: appThemeColors.grey5,
        fontStyle: FontStyle.italic,
      ),
    };
    if (this.text.isEmpty) {
      _activeStyles.add('title');
    }
  }

  TextStyle? _getStyle(String style) => _styleMap[style];

  @override
  set value(TextEditingValue newValue) {
    final selectionChanged = newValue.selection != selection;

    if (newValue.text == text && !selectionChanged) {
      super.value = newValue;
      return;
    }

    if (newValue.text.isEmpty) {
      clearStyles();
    }

    final oldValue = value;
    if (newValue.text != text) {
      if (_onTextChanged(oldValue, newValue)) {
        return;
      }
    }

    super.value = newValue;

    if (selectionChanged) {
      _updateActiveStylesAtSelection();
    }
  }

  bool _onTextChanged(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.start == -1 || newValue.selection.end == -1) {
      return false;
    }

    // Handle bullet points on Enter key press
    final diff = newValue.text.length - oldValue.text.length;
    if (diff > 0 && newValue.selection.isCollapsed) {
      final changeStart = newValue.selection.start - diff;
      final addedText = newValue.text.substring(
        changeStart,
        newValue.selection.start,
      );

      if (addedText == '\n') {
        if (_activeStyles.contains('title')) {
          _activeStyles.remove('title');
        }

        // Handle quote mode persistence on new lines - quote mode stays active
        if (_quoteMode) {
          _activeStyles.add('quote');
        }

        final lineStart = getLineStart(changeStart);
        final line = oldValue.text.substring(lineStart, changeStart);

        if (line.trim().startsWith('• ')) {
          if (line.trim() == '•' || line.trim() == '• ') {
            // Empty bullet line, remove bullet and insert a newline
            final newText =
                oldValue.text.substring(0, lineStart) +
                    oldValue.text.substring(changeStart);
            super.value = TextEditingValue(
              text: newText,
              selection: TextSelection.fromPosition(
                TextPosition(offset: lineStart),
              ),
            );
            return true;
          } else {
            // Non-empty bullet line, add a new bullet on the new line
            final textToInsert = '• ';
            final newTextValue =
                newValue.text.substring(0, newValue.selection.start) +
                    textToInsert +
                    newValue.text.substring(newValue.selection.start);
            final newSelection = TextSelection.fromPosition(
              TextPosition(
                offset: newValue.selection.start + textToInsert.length,
              ),
            );

            super.value = TextEditingValue(
              text: newTextValue,
              selection: newSelection,
            );
            return true;
          }
        }
      }
    }

    _updateStyleRangesOnTextChange(oldValue, newValue);
    _applyActiveStylesOnCharacterInsertion(oldValue, newValue);
    return false;
  }

  void _updateActiveStylesAtSelection() {
    _activeStyles.clear();

    if (text.isEmpty) {
      _activeStyles.add('title');
    }

    // Add quote to active styles if quote mode is enabled
    if (_quoteMode) {
      _activeStyles.add('quote');
    }

    if (selection.isCollapsed) {
      // For collapsed selection, check styles at cursor position
      if (selection.start > 0) {
        final position = selection.start - 1;
        final activeRanges = _styleRanges.where(
              (range) =>
          range.range.start <= position && range.range.end > position,
        );
        for (final range in activeRanges) {
          if ([
            'bold',
            'italic',
            'underline',
            'strikethrough',
            'title',
          ].contains(range.style)) {
            _activeStyles.add(range.style);
          }
        }
      }
    } else {
      // For text selection, only mark styles as active if they cover the entire selection
      for (final style in [
        'bold',
        'italic',
        'underline',
        'strikethrough',
        'title',
      ]) {
        if (_isEntireSelectionStyled(style, selection)) {
          _activeStyles.add(style);
        }
      }
    }
  }

  bool _isEntireSelectionStyled(String style, TextRange selection) {
    if (selection.isCollapsed) return false;

    final relevantRanges = _styleRanges
        .where(
          (range) => range.style == style && range.range.overlaps(selection),
    )
        .toList();

    if (relevantRanges.isEmpty) return false;

    // Sort ranges by start position
    relevantRanges.sort((a, b) => a.range.start.compareTo(b.range.start));

    // Check if ranges cover the entire selection without gaps
    int covered = selection.start;
    for (final range in relevantRanges) {
      final rangeStart = range.range.start.clamp(
        selection.start,
        selection.end,
      );
      final rangeEnd = range.range.end.clamp(selection.start, selection.end);

      if (rangeStart > covered) {
        return false; // Gap in coverage
      }
      covered = rangeEnd;
    }

    return covered >= selection.end;
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
      // Change is after this range - no adjustment needed
      return range;
    } else if (changeEnd <= start) {
      // Change is before this range - shift the entire range
      newStart += delta;
      newEnd += delta;
    } else {
      // Change overlaps with this range
      if (start >= changeStart && end <= changeEnd) {
        // Range is completely within the changed area - remove it
        return null;
      }

      if (start < changeStart) {
        // Range starts before the change
        if (end <= changeEnd) {
          // Range ends within the change - truncate at changeStart
          newEnd = changeStart;
        } else {
          // Range extends beyond the change - adjust end
          newEnd += delta;
        }
      } else {
        // Range starts within the change
        newStart = changeStart + addedLength;
        if (end <= changeEnd) {
          // Range ends within the change - collapse to changeStart
          newEnd = newStart;
        } else {
          // Range extends beyond the change - adjust end
          newEnd += delta;
        }
      }
    }

    if (newStart >= newEnd || newStart < 0 || newEnd > newTextLength) {
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

        // Apply active styles to newly typed characters
        for (final style in _activeStyles) {
          final textStyle = _getStyle(style);
          if (textStyle != null) {
            _addStyleInternal(style, textStyle, range);
          }
        }
      }
    }
  }

  bool isStyleActive(String style) {
    if (style == 'quote') {
      return _quoteMode || _hasQuoteStyleInSelection();
    }

    if (style == 'bullet') {
      return _isBulletListActive();
    }

    if (selection.isCollapsed) {
      return _activeStyles.contains(style);
    } else {
      return _isEntireSelectionStyled(style, selection);
    }
  }

  bool _hasQuoteStyleInSelection() {
    final start = getLineStart(selection.start);
    final end = getLineEnd(selection.end);
    return _isRangeStyleActive('quote', TextRange(start: start, end: end));
  }

  bool _isRangeStyleActive(String style, TextRange range) {
    if (range.isCollapsed) {
      return _styleRanges.any(
            (r) =>
        r.style == style &&
            r.range.start <= range.start &&
            r.range.end > range.start,
      );
    }
    return _isEntireSelectionStyled(style, range);
  }

  bool _isBulletListActive() {
    if (selection.start == -1 || selection.end == -1) return false;

    final lineStart = getLineStart(selection.start);
    final lineEnd = getLineEnd(selection.start);
    final currentLine = text.substring(lineStart, lineEnd);

    return currentLine.trimLeft().startsWith('• ');
  }

  void _addStyleInternal(String style, TextStyle textStyle, TextRange range) {
    if (range.isCollapsed) return;

    // Remove any existing overlapping ranges of the same style and merge
    final overlappingRanges = _styleRanges
        .where(
          (r) =>
      r.style == style &&
          (r.range.overlaps(range) ||
              r.range.start == range.end ||
              r.range.end == range.start),
    )
        .toList();

    TextRange mergedRange = range;
    for (final overlapping in overlappingRanges) {
      mergedRange = TextRange(
        start: [
          mergedRange.start,
          overlapping.range.start,
        ].reduce((a, b) => a < b ? a : b),
        end: [
          mergedRange.end,
          overlapping.range.end,
        ].reduce((a, b) => a > b ? a : b),
      );
      _styleRanges.remove(overlapping);
    }

    _styleRanges.add(
      StyleRange(style: style, range: mergedRange, textStyle: textStyle),
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

    for (final overlappingRange in overlappingRanges) {
      _styleRanges.remove(overlappingRange);
      final oldRange = overlappingRange.range;

      // Add the part before the removal range
      if (oldRange.start < rangeToRemove.start) {
        _styleRanges.add(
          overlappingRange.copyWith(
            range: TextRange(start: oldRange.start, end: rangeToRemove.start),
          ),
        );
      }

      // Add the part after the removal range
      if (oldRange.end > rangeToRemove.end) {
        _styleRanges.add(
          overlappingRange.copyWith(
            range: TextRange(start: rangeToRemove.end, end: oldRange.end),
          ),
        );
      }
    }
    notifyListeners();
  }

  void clearStyles() {
    _styleRanges.clear();
    _activeStyles.clear();
    _quoteMode = false; // Reset quote mode when clearing styles
    if (text.isEmpty) {
      _activeStyles.add('title');
    }
    notifyListeners();
  }

  void toggleStyle(String style) {
    final textStyle = _getStyle(style);
    if (textStyle == null) return;

    if (style == 'quote') {
      _toggleQuoteMode();
      return;
    }

    if (style == 'bullet') {
      toggleBulletPoints();
      return;
    }

    final currentSelection = selection;
    if (currentSelection.isCollapsed) {
      // Toggle active style for future typing
      if (_activeStyles.contains(style)) {
        _activeStyles.remove(style);
      } else {
        _activeStyles.add(style);
      }
    } else {
      // Toggle style on selected text
      final bool isActive = _isEntireSelectionStyled(style, currentSelection);
      if (isActive) {
        removeStyle(style, currentSelection);
        // Update active styles after removal
        _updateActiveStylesAtSelection();
      } else {
        addStyle(style, textStyle, currentSelection);
        // Update active styles after addition
        _updateActiveStylesAtSelection();
      }
    }
    notifyListeners();
  }

  void _toggleQuoteMode() {
    final textStyle = _getStyle('quote');
    if (textStyle == null) return;

    if (selection.isCollapsed) {
      // Toggle quote mode for cursor position
      if (_quoteMode) {
        // Turn off quote mode
        _quoteMode = false;
        _activeStyles.remove('quote');
      } else {
        // Turn on quote mode immediately - persistent across new lines
        _quoteMode = true;
        _activeStyles.add('quote');

        // If there's existing text at cursor, apply quote style to current line
        if (text.isNotEmpty) {
          final start = getLineStart(selection.start);
          final end = getLineEnd(selection.start);
          if (start < end) {
            final lineRange = TextRange(start: start, end: end);
            addStyle('quote', textStyle, lineRange);
          }
        }
      }
    } else {
      // Handle text selection - check if entire selection is quoted
      final start = getLineStart(selection.start);
      final end = getLineEnd(selection.end);
      final linesRange = TextRange(start: start, end: end);

      if (text.substring(start, end).trim().isEmpty) {
        return;
      }

      final isEntireSelectionQuoted = _isEntireSelectionStyled(
        'quote',
        linesRange,
      );

      if (isEntireSelectionQuoted) {
        // Remove quote from selected lines and disable quote mode
        removeStyle('quote', linesRange);
        _quoteMode = false;
        _activeStyles.remove('quote');
      } else {
        // Add quote to selected lines and enable persistent quote mode
        addStyle('quote', textStyle, linesRange);
        _quoteMode = true;
        _activeStyles.add('quote');
      }
    }

    // Update active styles after toggle
    _updateActiveStylesAtSelection();
    notifyListeners();
  }

  void toggleBulletPoints() {
    if (selection.isCollapsed &&
        getLineAtCursor(selection.start).trim().isEmpty) {
      // Add bullet to empty line
      final currentLineStart = getLineStart(selection.start);
      final newText = text.replaceRange(
        currentLineStart,
        currentLineStart,
        '• ',
      );
      value = TextEditingValue(
        text: newText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: selection.start + 2),
        ),
      );
      return;
    }

    final selectedLinesRange = TextRange(
      start: getLineStart(selection.start),
      end: getLineEnd(selection.end),
    );
    final selectedText = text.substring(
      selectedLinesRange.start,
      selectedLinesRange.end,
    );
    final selectedLines = selectedText.split('\n');

    final bool areAllLinesBulleted = selectedLines.every(
          (line) => line.trimLeft().startsWith('• '),
    );

    String newText;
    int charDelta = 0;

    if (areAllLinesBulleted) {
      // Remove bullets
      newText = selectedLines
          .map((line) {
        final originalLength = line.length;
        final newLine = line.replaceFirst(RegExp(r'^\s*•\s?'), '');
        charDelta += newLine.length - originalLength;
        return newLine;
      })
          .join('\n');
    } else {
      // Add bullets
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

    final newTextValue = text.replaceRange(
      selectedLinesRange.start,
      selectedLinesRange.end,
      newText,
    );

    value = TextEditingValue(
      text: newTextValue,
      selection: TextSelection(
        baseOffset: selection.start,
        extentOffset: (selection.end + charDelta).clamp(0, newTextValue.length),
      ),
    );
  }

  @override
  void clear() {
    _styleRanges.clear();
    _activeStyles.clear();
    _quoteMode = false; // Reset quote mode when clearing
    _activeStyles.add('title');
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

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      final end = start + line.length;
      final lineRange = TextRange(start: start, end: end);

      final isQuote =
          _styleRanges.any(
                (r) => r.style == 'quote' && r.range.overlaps(lineRange),
          ) ||
              (_quoteMode && selection.start >= start && selection.start <= end);

      if (isQuote) {
        children.add(
          WidgetSpan(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: appThemeColors.grey5, width: 2.0),
                ),
              ),
              padding: const EdgeInsets.only(left: 8.0),
              child: Text.rich(
                _buildTextSpanForRange(
                  TextRange(start: start, end: end),
                  style,
                  plainText,
                ),
                style: style,
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

      // Add newline except for the last line
      if (lineIndex < lines.length - 1) {
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
        combinedStyle = combinedStyle.merge(range.textStyle);
      }

      // Apply quote style if in quote mode and cursor is in this range
      if (_quoteMode && selection.start >= start && selection.start <= end) {
        final quoteStyle = _styleMap['quote'];
        if (quoteStyle != null) {
          combinedStyle = combinedStyle.merge(quoteStyle);
        }
      }

      if (text.isEmpty && _activeStyles.contains('title')) {
        combinedStyle = combinedStyle.merge(_styleMap['title']);
      }

      spans.add(
        TextSpan(text: plainText.substring(start, end), style: combinedStyle),
      );
    }
    if (spans.isEmpty && range.start == range.end) {
      TextStyle combinedStyle = style ?? const TextStyle();
      if (text.isEmpty && _activeStyles.contains('title')) {
        combinedStyle = combinedStyle.merge(_styleMap['title']);
      }
      // Apply quote style if in quote mode
      if (_quoteMode) {
        final quoteStyle = _styleMap['quote'];
        if (quoteStyle != null) {
          combinedStyle = combinedStyle.merge(quoteStyle);
        }
      }
      return TextSpan(text: '', style: combinedStyle);
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