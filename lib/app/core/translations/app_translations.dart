import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'translations_east_se_west_asian.dart';
import 'translations_en.dart';
import 'translations_european_east_other.dart';
import 'translations_european_west.dart';
import 'translations_kn.dart';
import 'translations_south_asian.dart';

/// Metadata describing an in-app selectable language.
class LanguageOption {
  final String code;
  final Locale locale;
  final String nativeName;
  final String englishName;
  final bool isRtl;

  const LanguageOption({
    required this.code,
    required this.locale,
    required this.nativeName,
    required this.englishName,
    this.isRtl = false,
  });
}

/// Wraps [FlutterQuillLocalizations.delegate] so locales not natively
/// translated inside `flutter_quill` (e.g. Kannada `kn`, Telugu `te`,
/// Tamil `ta`, Malayalam `ml`, Marathi `mr`) fall back cleanly to English
/// instead of throwing a missing delegate error.
class FallbackQuillLocalizationsDelegate
    extends LocalizationsDelegate<FlutterQuillLocalizations> {
  const FallbackQuillLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<FlutterQuillLocalizations> load(Locale locale) {
    if (FlutterQuillLocalizations.delegate.isSupported(locale)) {
      return FlutterQuillLocalizations.delegate.load(locale);
    }
    return FlutterQuillLocalizations.delegate.load(const Locale('en'));
  }

  @override
  bool shouldReload(FallbackQuillLocalizationsDelegate old) => false;
}

/// Central GetX translations registry and locale helpers for OpenJot.
class AppTranslations extends Translations {
  static const String systemCode = 'system';

  /// Ordered list of all 55 supported languages (Kannada featured alongside
  /// Indian/Asian, European, Middle Eastern, African, and global languages).
  static const List<LanguageOption> languages = <LanguageOption>[
    // Kannada & Indian / South Asian languages
    LanguageOption(
      code: 'kn',
      locale: Locale('kn'),
      nativeName: 'ಕನ್ನಡ',
      englishName: 'Kannada',
    ),
    LanguageOption(
      code: 'en_US',
      locale: Locale('en', 'US'),
      nativeName: 'English',
      englishName: 'English',
    ),
    LanguageOption(
      code: 'hi',
      locale: Locale('hi'),
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
    ),
    LanguageOption(
      code: 'te',
      locale: Locale('te'),
      nativeName: 'తెలుగు',
      englishName: 'Telugu',
    ),
    LanguageOption(
      code: 'ta',
      locale: Locale('ta'),
      nativeName: 'தமிழ்',
      englishName: 'Tamil',
    ),
    LanguageOption(
      code: 'ml',
      locale: Locale('ml'),
      nativeName: 'മലയാളം',
      englishName: 'Malayalam',
    ),
    LanguageOption(
      code: 'mr',
      locale: Locale('mr'),
      nativeName: 'मराठी',
      englishName: 'Marathi',
    ),
    LanguageOption(
      code: 'gu',
      locale: Locale('gu'),
      nativeName: 'ગુજરાતી',
      englishName: 'Gujarati',
    ),
    LanguageOption(
      code: 'bn',
      locale: Locale('bn'),
      nativeName: 'বাংলা',
      englishName: 'Bengali',
    ),
    LanguageOption(
      code: 'pa',
      locale: Locale('pa'),
      nativeName: 'ਪੰਜਾਬੀ',
      englishName: 'Punjabi',
    ),
    LanguageOption(
      code: 'or',
      locale: Locale('or'),
      nativeName: 'ଓଡ଼ିଆ',
      englishName: 'Odia',
    ),
    LanguageOption(
      code: 'as',
      locale: Locale('as'),
      nativeName: 'অসমীয়া',
      englishName: 'Assamese',
    ),
    LanguageOption(
      code: 'ur',
      locale: Locale('ur'),
      nativeName: 'اردو',
      englishName: 'Urdu',
      isRtl: true,
    ),
    LanguageOption(
      code: 'ne',
      locale: Locale('ne'),
      nativeName: 'नेपाली',
      englishName: 'Nepali',
    ),
    LanguageOption(
      code: 'si',
      locale: Locale('si'),
      nativeName: 'සිංහල',
      englishName: 'Sinhala',
    ),

    // East, Southeast & West Asian / Middle Eastern languages
    LanguageOption(
      code: 'ja',
      locale: Locale('ja'),
      nativeName: '日本語',
      englishName: 'Japanese',
    ),
    LanguageOption(
      code: 'ko',
      locale: Locale('ko'),
      nativeName: '한국어',
      englishName: 'Korean',
    ),
    LanguageOption(
      code: 'zh_CN',
      locale: Locale('zh', 'CN'),
      nativeName: '简体中文',
      englishName: 'Chinese (Simplified)',
    ),
    LanguageOption(
      code: 'zh_TW',
      locale: Locale('zh', 'TW'),
      nativeName: '繁體中文',
      englishName: 'Chinese (Traditional)',
    ),
    LanguageOption(
      code: 'th',
      locale: Locale('th'),
      nativeName: 'ไทย',
      englishName: 'Thai',
    ),
    LanguageOption(
      code: 'vi',
      locale: Locale('vi'),
      nativeName: 'Tiếng Việt',
      englishName: 'Vietnamese',
    ),
    LanguageOption(
      code: 'id',
      locale: Locale('id'),
      nativeName: 'Bahasa Indonesia',
      englishName: 'Indonesian',
    ),
    LanguageOption(
      code: 'ms',
      locale: Locale('ms'),
      nativeName: 'Bahasa Melayu',
      englishName: 'Malay',
    ),
    LanguageOption(
      code: 'fil',
      locale: Locale('fil'),
      nativeName: 'Filipino',
      englishName: 'Filipino',
    ),
    LanguageOption(
      code: 'my',
      locale: Locale('my'),
      nativeName: 'မြန်မာ',
      englishName: 'Burmese',
    ),
    LanguageOption(
      code: 'km',
      locale: Locale('km'),
      nativeName: 'ខ្មែរ',
      englishName: 'Khmer',
    ),
    LanguageOption(
      code: 'tr',
      locale: Locale('tr'),
      nativeName: 'Türkçe',
      englishName: 'Turkish',
    ),
    LanguageOption(
      code: 'ar',
      locale: Locale('ar'),
      nativeName: 'العربية',
      englishName: 'Arabic',
      isRtl: true,
    ),
    LanguageOption(
      code: 'fa',
      locale: Locale('fa'),
      nativeName: 'فارسی',
      englishName: 'Persian',
      isRtl: true,
    ),
    LanguageOption(
      code: 'he',
      locale: Locale('he'),
      nativeName: 'עברית',
      englishName: 'Hebrew',
      isRtl: true,
    ),

    // European languages
    LanguageOption(
      code: 'es',
      locale: Locale('es'),
      nativeName: 'Español',
      englishName: 'Spanish',
    ),
    LanguageOption(
      code: 'fr',
      locale: Locale('fr'),
      nativeName: 'Français',
      englishName: 'French',
    ),
    LanguageOption(
      code: 'de',
      locale: Locale('de'),
      nativeName: 'Deutsch',
      englishName: 'German',
    ),
    LanguageOption(
      code: 'it',
      locale: Locale('it'),
      nativeName: 'Italiano',
      englishName: 'Italian',
    ),
    LanguageOption(
      code: 'pt',
      locale: Locale('pt'),
      nativeName: 'Português',
      englishName: 'Portuguese',
    ),
    LanguageOption(
      code: 'nl',
      locale: Locale('nl'),
      nativeName: 'Nederlands',
      englishName: 'Dutch',
    ),
    LanguageOption(
      code: 'ca',
      locale: Locale('ca'),
      nativeName: 'Català',
      englishName: 'Catalan',
    ),
    LanguageOption(
      code: 'sv',
      locale: Locale('sv'),
      nativeName: 'Svenska',
      englishName: 'Swedish',
    ),
    LanguageOption(
      code: 'da',
      locale: Locale('da'),
      nativeName: 'Dansk',
      englishName: 'Danish',
    ),
    LanguageOption(
      code: 'nb',
      locale: Locale('nb'),
      nativeName: 'Norsk bokmål',
      englishName: 'Norwegian',
    ),
    LanguageOption(
      code: 'fi',
      locale: Locale('fi'),
      nativeName: 'Suomi',
      englishName: 'Finnish',
    ),
    LanguageOption(
      code: 'ru',
      locale: Locale('ru'),
      nativeName: 'Русский',
      englishName: 'Russian',
    ),
    LanguageOption(
      code: 'pl',
      locale: Locale('pl'),
      nativeName: 'Polski',
      englishName: 'Polish',
    ),
    LanguageOption(
      code: 'uk',
      locale: Locale('uk'),
      nativeName: 'Українська',
      englishName: 'Ukrainian',
    ),
    LanguageOption(
      code: 'cs',
      locale: Locale('cs'),
      nativeName: 'Čeština',
      englishName: 'Czech',
    ),
    LanguageOption(
      code: 'sk',
      locale: Locale('sk'),
      nativeName: 'Slovenčina',
      englishName: 'Slovak',
    ),
    LanguageOption(
      code: 'el',
      locale: Locale('el'),
      nativeName: 'Ελληνικά',
      englishName: 'Greek',
    ),
    LanguageOption(
      code: 'ro',
      locale: Locale('ro'),
      nativeName: 'Română',
      englishName: 'Romanian',
    ),
    LanguageOption(
      code: 'hu',
      locale: Locale('hu'),
      nativeName: 'Magyar',
      englishName: 'Hungarian',
    ),
    LanguageOption(
      code: 'bg',
      locale: Locale('bg'),
      nativeName: 'Български',
      englishName: 'Bulgarian',
    ),
    LanguageOption(
      code: 'hr',
      locale: Locale('hr'),
      nativeName: 'Hrvatski',
      englishName: 'Croatian',
    ),
    LanguageOption(
      code: 'sr',
      locale: Locale('sr'),
      nativeName: 'Српски',
      englishName: 'Serbian',
    ),

    // African & Other Global languages
    LanguageOption(
      code: 'sw',
      locale: Locale('sw'),
      nativeName: 'Kiswahili',
      englishName: 'Swahili',
    ),
    LanguageOption(
      code: 'am',
      locale: Locale('am'),
      nativeName: 'አማርኛ',
      englishName: 'Amharic',
    ),
    LanguageOption(
      code: 'af',
      locale: Locale('af'),
      nativeName: 'Afrikaans',
      englishName: 'Afrikaans',
    ),
  ];

  static final List<Locale> supportedLocales = <Locale>[
    const Locale('en'),
    const Locale('zh'),
    ...languages.map((l) => l.locale),
  ];

  static final Map<String, Map<String, String>> _allDictionaries =
      <String, Map<String, String>>{
    'en': enUSTranslations,
    'en_US': enUSTranslations,
    'kn': knTranslations,
    ...southAsianTranslations,
    ...eastSeWestAsianTranslations,
    ...europeanWestTranslations,
    ...europeanEastOtherTranslations,
  };

  @override
  Map<String, Map<String, String>> get keys => _allDictionaries;

  /// Resolves a stored preference code (`'system'`, `'kn'`, `'zh_CN'`, etc.)
  /// to a concrete supported [Locale].
  static Locale resolveLocale(String? savedCode) {
    if (savedCode == null || savedCode.isEmpty || savedCode == systemCode) {
      return matchDeviceLocale(ui.PlatformDispatcher.instance.locale);
    }
    for (final lang in languages) {
      if (lang.code == savedCode) {
        return lang.locale;
      }
    }
    return const Locale('en', 'US');
  }

  /// Matches the OS locale to the closest supported [Locale] in OpenJot.
  static Locale matchDeviceLocale(Locale? deviceLocale) {
    if (deviceLocale == null) return const Locale('en', 'US');

    if (deviceLocale.languageCode == 'zh') {
      final isHant = deviceLocale.scriptCode == 'Hant' ||
          deviceLocale.countryCode == 'TW' ||
          deviceLocale.countryCode == 'HK' ||
          deviceLocale.countryCode == 'MO';
      return isHant ? const Locale('zh', 'TW') : const Locale('zh', 'CN');
    }

    for (final lang in languages) {
      if (lang.locale.languageCode == deviceLocale.languageCode) {
        return lang.locale;
      }
    }
    return const Locale('en', 'US');
  }

  /// Finds the [LanguageOption] matching a preference code, or `null` for `'system'`.
  static LanguageOption? optionForCode(String? code) {
    if (code == null || code == systemCode) return null;
    for (final lang in languages) {
      if (lang.code == code) return lang;
    }
    return null;
  }

  /// Returns a localized label suitable for settings rows & toast feedback.
  static String displayNameForCode(String code) {
    if (code == systemCode) {
      return 'System Default'.tr;
    }
    final opt = optionForCode(code);
    return opt?.nativeName ?? 'English';
  }

  /// Returns a `intl`-safe locale string matching the currently active GetX locale.
  static String get activeIntlLocale {
    final loc = Get.locale ?? ui.PlatformDispatcher.instance.locale;
    final full = loc.countryCode != null && loc.countryCode!.isNotEmpty
        ? '${loc.languageCode}_${loc.countryCode}'
        : loc.languageCode;
    if (DateFormat.localeExists(full)) return full;
    if (DateFormat.localeExists(loc.languageCode)) return loc.languageCode;
    return 'en';
  }

  /// Formats [date] using the active locale's `intl` date symbols safely.
  static String formatDate(DateTime date, String pattern) {
    return DateFormat(pattern, activeIntlLocale).format(date);
  }

  /// Formats [date] with the locale-appropriate short time (`jm`).
  static String formatJm(DateTime date) {
    return DateFormat.jm(activeIntlLocale).format(date);
  }

  /// Returns localized Sunday..Saturday short weekday labels for the active locale.
  static List<String> weekdayShortNames() {
    final loc = activeIntlLocale;
    // 2024-01-07 is Sunday
    return List<String>.generate(7, (i) {
      final d = DateTime(2024, 1, 7 + i);
      return DateFormat.E(loc).format(d);
    });
  }

  /// Returns the localized AM or PM period label for the active locale.
  static String dayPeriodLabel(bool isPm) {
    final d = DateTime(2024, 1, 1, isPm ? 14 : 9, 0);
    return DateFormat('a', activeIntlLocale).format(d);
  }
}
