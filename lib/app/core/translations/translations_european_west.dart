import 'europe_west_1.dart';
import 'europe_west_2.dart';
import 'europe_west_3.dart';

/// Combined translations for Western & Northern European languages:
/// Spanish (`es`), French (`fr`), German (`de`), Italian (`it`),
/// Portuguese (`pt`), Dutch (`nl`), Catalan (`ca`), Swedish (`sv`),
/// Danish (`da`), Norwegian Bokmål (`nb`), and Finnish (`fi`).
final Map<String, Map<String, String>> europeanWestTranslations =
    <String, Map<String, String>>{
  ...europeWest1Translations,
  ...europeWest2Translations,
  ...europeWest3Translations,
};
