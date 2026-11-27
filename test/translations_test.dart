import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_jot/app/core/translations/app_translations.dart';
import 'package:open_jot/app/core/translations/translations_en.dart';
import 'package:open_jot/app/core/translations/translations_kn.dart';

void main() {
  group('AppTranslations coverage & integrity', () {
    final translations = AppTranslations();
    final uniqueKeys = allTranslationKeys.toSet();

    int countOccurrences(String text, String token) {
      var count = 0;
      var index = 0;
      while ((index = text.indexOf(token, index)) != -1) {
        count++;
        index += token.length;
      }
      return count;
    }

    test('Kannada (kn) has 100% non-empty key coverage and matching placeholders', () {
      expect(translations.keys.containsKey('kn'), isTrue);
      for (final key in uniqueKeys) {
        expect(
          knTranslations.containsKey(key),
          isTrue,
          reason: 'Missing Kannada translation for "$key"',
        );
        final val = knTranslations[key]!;
        expect(
          val.trim(),
          isNotEmpty,
          reason: 'Empty Kannada translation for "$key"',
        );
        expect(
          countOccurrences(val, '%s'),
          equals(countOccurrences(key, '%s')),
          reason: 'Mismatched %s count in Kannada for "$key": "$val"',
        );
        expect(
          countOccurrences(val, '%d'),
          equals(countOccurrences(key, '%d')),
          reason: 'Mismatched %d count in Kannada for "$key": "$val"',
        );
      }
    });

    test('All 55 configured languages have complete non-empty translations', () {
      expect(AppTranslations.languages.length, greaterThanOrEqualTo(50));
      for (final lang in AppTranslations.languages) {
        final dict = translations.keys[lang.code];
        expect(
          dict,
          isNotNull,
          reason: 'Missing dictionary for language ${lang.code} (${lang.englishName})',
        );
        for (final key in uniqueKeys) {
          expect(
            dict!.containsKey(key),
            isTrue,
            reason: 'Missing key "$key" in ${lang.code} (${lang.englishName})',
          );
          final val = dict[key]!;
          expect(
            val.trim(),
            isNotEmpty,
            reason: 'Empty value for "$key" in ${lang.code} (${lang.englishName})',
          );
          expect(
            countOccurrences(val, '%s'),
            equals(countOccurrences(key, '%s')),
            reason: 'Mismatched %s placeholder in ${lang.code} for "$key"',
          );
          expect(
            countOccurrences(val, '%d'),
            equals(countOccurrences(key, '%d')),
            reason: 'Mismatched %d placeholder in ${lang.code} for "$key"',
          );
        }
      }
    });

    test('resolveLocale handles explicit and device-matched locales cleanly', () {
      expect(AppTranslations.resolveLocale('kn'), equals(const Locale('kn')));
      expect(AppTranslations.resolveLocale('en_US'), equals(const Locale('en', 'US')));
      expect(AppTranslations.resolveLocale('zh_CN'), equals(const Locale('zh', 'CN')));
      expect(AppTranslations.resolveLocale('zh_TW'), equals(const Locale('zh', 'TW')));
      expect(
        AppTranslations.matchDeviceLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ),
        equals(const Locale('zh', 'TW')),
      );
      expect(
        AppTranslations.matchDeviceLocale(const Locale('kn', 'IN')),
        equals(const Locale('kn')),
      );
    });
  });
}
