import '../constants.dart';

/// Complete Serbian (Српски) translations for OpenJot.
final Map<String, String> srTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Мој дневник",
  AppConstants.noEntriesMessage:
      "Још нема уноса у дневнику. Почните да пишете!",
  AppConstants.noBookmarksYet: "Још нема обележивача.",
  AppConstants.noDraftsYet: "Још нема нацрта.",
  AppConstants.addEntryButton: "Додај нови унос",
  AppConstants.jotYourThoughts: "Запишите своје мисли",
  AppConstants.tapToCreateJournal:
      "Додирните + да направите свој лични дневник.",
  AppConstants.entriesThisYear: "Уноса ове године",
  AppConstants.wordsWritten: "Написаних речи",
  AppConstants.daysJournaled: "Дана са уносима",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Нови унос у дневнику",
  AppConstants.editEntryAppBarTitle: "Уреди унос",
  AppConstants.titleHintText: "Наслов (нпр. 'Мој дан', 'Мисли о...')",
  AppConstants.contentHintText: "Запишите своје мисли овде...",
  AppConstants.saveButton: "Сачувај унос",
  AppConstants.updateButton: "Ажурирај",
  AppConstants.deleteButton: "Обриши унос",
  AppConstants.requiredFieldMessage: "Ово поље не може бити празно.",
  AppConstants.newEntry: "Нови унос",
  AppConstants.todayDate: "Данашњи датум",
  AppConstants.customDate: "Прилагођени датум",
  AppConstants.done: "Готово",
  AppConstants.startWriting: " Почните да пишете...",
  AppConstants.tags: "Ознаке",
  AppConstants.addTags: "Додај ознаке",
  AppConstants.openInMaps: "Отвори у Мапама",
  AppConstants.changeLocation: "Промени локацију",
  AppConstants.remove: "Уклони",
  AppConstants.discardSelectionsTitle: "Одбацити изабрано?",
  AppConstants.discardSelectionsMessage:
      "Изабрали сте медије или активан снимак. Да ли сте сигурни да желите да их одбаците?",
  AppConstants.journalEntryEmpty: "Унос у дневнику не може бити празан",
  AppConstants.discardDateConfirm:
      "Одбацити изабрани датум/време за овај унос?",
  AppConstants.addMediaLocationMoodFirst:
      "Прво додајте медије, локацију или расположење",
  AppConstants.location: "Локација",
  AppConstants.record: "Сними",
  AppConstants.selectMomentsToJournal: "Изаберите тренутке за дневник",
  AppConstants.addMomentsFromMenu:
      "Додајте медије, локацију, снимак или расположење из менија",
  AppConstants.writeSomething: "Напишите нешто",
  AppConstants.saveWithoutWriting: "Сачувај без писања",
  AppConstants.oneLocation: "1 локација",
  AppConstants.mediaCount: "%d медија",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Потврди брисање",
  AppConstants.confirmDeleteMessage:
      "Да ли сте сигурни да желите да обришете овај унос?",
  AppConstants.pleaseConfirm: "Молимо потврдите",
  AppConstants.confirmDeleteJournalEntry:
      "Да ли сте сигурни да желите да обришете овај унос из дневника? Ова радња је неповратна.",
  AppConstants.yes: "Да",
  AppConstants.no: "Не",
  AppConstants.cancel: "Откажи",
  AppConstants.delete: "Обриши",
  AppConstants.save: "Сачувај",
  AppConstants.entrySavedSuccess: "Унос је успешно сачуван!",
  AppConstants.entryUpdatedSuccess: "Унос је успешно ажуриран!",
  AppConstants.entryDeletedSuccess: "Унос је обрисан.",
  AppConstants.errorSavingEntry: "Грешка при чувању уноса.",
  AppConstants.errorDeletingEntry: "Грешка при брисању уноса.",
  AppConstants.errorLoadingEntries: "Грешка при учитавању уноса.",
  AppConstants.noEntriesForDate: "Нема уноса за овај датум.",
  AppConstants.noEntriesForMonth: "Нису пронађени уноси за овај месец.",
  AppConstants.selectMonthAndYear: "Изаберите месец и годину",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Веома непријатно",
  AppConstants.unpleasant: "Непријатно",
  AppConstants.slightlyUnpleasant: "Благо непријатно",
  AppConstants.neutral: "Неутрално",
  AppConstants.slightlyPleasant: "Благо пријатно",
  AppConstants.pleasant: "Пријатно",
  AppConstants.veryPleasant: "Веома пријатно",
  AppConstants.reflection: "Размишљање",
  AppConstants.edit: "Уреди",
  AppConstants.removeBookmark: "Уклони обележивач",
  AppConstants.bookmark: "Обележи",
  AppConstants.share: "Подели",
  AppConstants.saveAsPdf: "Сачувај као PDF",
  AppConstants.audioTrack: "Аудио запис",
  AppConstants.generatingPdf: "Генерисање PDF-а...",
  AppConstants.voiceRecording: "Гласовни снимак",
  AppConstants.audioRecording: "Аудио снимак",
  AppConstants.couldNotLoadAudio: "Није могуће учитати аудио датотеку.",
  AppConstants.stateOfMind: "Стање ума",

  // Mood Colors
  AppConstants.moodColors: "Боје расположења",
  AppConstants.customizeMoodColors: "Прилагоди боје расположења",
  AppConstants.reset: "Ресетуј",
  AppConstants.resetMoodColors: "Врати на подразумевано",
  AppConstants.resetMoodColorsConfirm:
      "Вратити све боје расположења на подразумеване вредности?",
  AppConstants.paletteThemes: "Теме палете",
  AppConstants.customColor: "Прилагођена боја",
  AppConstants.moodUnsavedChangesMessage:
      "Имате несачуване промене боја расположења. Желите ли да их сачувате пре затварања?",

  // Drafts & Auto-save
  AppConstants.drafts: "Нацрти",
  AppConstants.draft: "Нацрт",
  AppConstants.draftSaved: "Сачувано у нацрте",
  AppConstants.unsavedChanges: "Несачуване промене",
  AppConstants.unsavedChangesMessage:
      "Имате несачуване промене. Да ли желите да их сачувате као нацрт или одбаците?",
  AppConstants.saveAsDraft: "Сачувај као нацрт",
  AppConstants.discardChanges: "Одбаци",
  AppConstants.autoDeleteDrafts: "Аутоматско брисање нацрта",
  AppConstants.days7: "7 дана",
  AppConstants.never: "Никада",
  AppConstants.custom: "Прилагођено...",
  AppConstants.enterCustomDays: "Унесите број дана",
  AppConstants.customDaysExample: "Нпр. 14",
  AppConstants.days: "дана",
  AppConstants.draftsNeverDeleted: "Нацрти никада неће бити обрисани",
  AppConstants.draftsDeletedAfterDays: "Нацрти ће бити обрисани након %d дана",

  // Home Menu & Sorting
  AppConstants.sortBy: "Сортирај по",
  AppConstants.insights: "Статистика",
  AppConstants.reflections: "Размишљања",
  AppConstants.settings: "Подешавања",
  AppConstants.entryTime: "Време уноса",
  AppConstants.bookmarkFirst: "Прво обележени",
  AppConstants.reflectionFirst: "Прво размишљања",
  AppConstants.withMediaFirst: "Прво са медијима",
  AppConstants.textOnlyFirst: "Прво само текст",
  AppConstants.withLocationFirst: "Прво са локацијом",
  AppConstants.withMoodFirst: "Прво са расположењем",
  AppConstants.withTagsFirst: "Прво са ознакама",

  // Insights
  AppConstants.stats: "Статистика",
  AppConstants.calendar: "Календар",
  AppConstants.entriesSuffix: " уноса",
  AppConstants.memoriesFromThisDay: "Успомене од овог дана",
  AppConstants.standard: "Стандардно",
  AppConstants.media: "Медији",
  AppConstants.mood: "Расположење",
  AppConstants.mostly: "Углавном",
  AppConstants.averageForThisDay: "Просек за овај дан",
  AppConstants.averageForThisYear: "Просек за ову годину",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Добродошли у OpenJot",
  AppConstants.feature1:
      "Пишите слободно, додајте фотографије и локације и чувајте све безбедно на свом уређају.",
  AppConstants.feature2:
      "Разумите своје емоције током времена уз уграђено праћење расположења.",
  AppConstants.feature3:
      "Ваши подаци остају на вашем телефону – без облака, само локално складиште и потпуна приватност.",
  AppConstants.continueButton: "Настави",

  // Notifications
  AppConstants.notificationTitle: "Време је за дневник!",
  AppConstants.notificationBody:
      "Не заборавите да запишете своје данашње мисли.",
  AppConstants.notificationChannelName: "Дневни подсетници",
  AppConstants.notificationChannelDescription:
      "Канал за обавештења дневних подсетника за дневник",
  AppConstants.onThisDayChannelName: "Успомене На данашњи дан",
  AppConstants.onThisDayChannelDescription:
      "Обавештења о успоменама из прошлих година.",
  AppConstants.onThisDayNotificationTitle: "Успомена из вашег дневника",
  AppConstants.onThisDaySingleEntry:
      "Пре годину дана на данашњи дан написали сте нешто посебно. Додирните да поново погледате своје мисли.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "На данашњи дан прошле године поделили сте ову успомену. Додирните да је поново проживите.",
  AppConstants.onThisDayMultipleEntries:
      "Имате успомене од овог дана из прошлих година. Додирните да их погледате.",
  AppConstants.onThisDayGroupedNotification:
      "Имате %d успомена од овог дана",

  // Exclude Entries
  AppConstants.excludeEntries: "Изузми уносе",
  AppConstants.saveExclusions: "Сачувај изузећа",
  AppConstants.excludeUnsavedChangesMessage:
      "Имате несачуване промене. Да ли сте сигурни да желите да их одбаците и изађете?",
  AppConstants.sortDefault: "Подразумевано",
  AppConstants.sortMutedFirst: "Прво скривени",
  AppConstants.sortUnmutedFirst: "Прво видљиви",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Данас",
  AppConstants.yesterday: "Јуче",
  AppConstants.contentForQuote: "Садржај за цитат",
  AppConstants.noContentSelected: "Није изабран садржај.",
  AppConstants.photos: "Фотографије",
  AppConstants.video: "Видео",
  AppConstants.audio: "Аудио",
  AppConstants.add: "Додај",
  AppConstants.noMediaFound: "Није пронађено: %s.",
  AppConstants.permissionRequired:
      "Потребна је дозвола за приступ %s да би се приказали.",
  AppConstants.openSettings: "Отвори подешавања",
  AppConstants.videos: "Видео снимци",
  AppConstants.audios: "Аудио записи",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Обрисати снимак?",
  AppConstants.deleteRecordingMessage:
      "Да ли сте сигурни да желите да обришете овај снимак?",
  AppConstants.listen: "Слушај",
  AppConstants.tapAndHold: "додирните и држите",
  AppConstants.clear: "Очисти",
  AppConstants.all: "Све",
  AppConstants.folder: "Фасцикла",
  AppConstants.browse: "Прегледај",
  AppConstants.tiles: "Плочице",
  AppConstants.graph: "Графикон",
  AppConstants.recording: "Снимање...",
  AppConstants.recordingLabel: "Снимак",
  AppConstants.startAudioRecording: "Започни аудио снимање",
  AppConstants.howAreYouFeeling: "Како се осећате?",
  AppConstants.paused: "Паузирано",
  AppConstants.stop: "Заустави",
  AppConstants.tapOrHoldToResume: "Додирните или држите за наставак",
  AppConstants.tapOrReleaseToPause: "Додирните или пустите за паузу",
  AppConstants.unsupportedImageType: "Неподржан тип слике",
  AppConstants.couldNotLoadVideo: "Није могуће учитати видео",
  AppConstants.couldNotOpenMap: "Није могуће отворити везу ка мапи.",
  AppConstants.dismiss: "Затвори",
  AppConstants.selectTime: "Изаберите време",
  AppConstants.now: "Сада",
  AppConstants.searchPlacesHint: "Претражите места, продавнице...",
  AppConstants.locationPermissionDenied: "Дозвола за локацију је одбијена.",
  AppConstants.failedGetCurrentLocation:
      "Није успело преузимање тренутне локације.",

  // Search
  AppConstants.searchJournalsHint: "Претражи дневнике...",
  AppConstants.textOnly: "Само текст",
  AppConstants.withMedia: "Са медијима",
  AppConstants.withMood: "Са расположењем",
  AppConstants.withLocation: "Са локацијом",
  AppConstants.withTags: "Са ознакама",
  AppConstants.noResultsFound: "Нема пронађених резултата",
  AppConstants.searchHintText: "Претражи уносе...",

  // Settings
  AppConstants.language: "Језик",
  AppConstants.selectLanguage: "Изаберите језик",
  AppConstants.systemDefault: "Подразумевано система",
  AppConstants.searchLanguagesHint: "Претражи језике...",
  AppConstants.languageChanged: "Језик је промењен у %s.",
  AppConstants.dailyReminder: "Подсетници",
  AppConstants.addReminder: "Додај подсетник",
  AppConstants.deleteReminder: "Обриши подсетник",
  AppConstants.noRemindersSet: "Нема постављених подсетника.",
  AppConstants.onThisDay: "На данашњи дан",
  AppConstants.appLock: "Закључавање апликације",
  AppConstants.backup: "Резервна копија",
  AppConstants.restore: "Врати",
  AppConstants.importFromAnotherApp: "Увези из друге апликације",
  AppConstants.importFromDailyYou: "Увези из Daily You",
  AppConstants.selectDailyYouBackup:
      "Изаберите Daily You zip датотеку резервне копије",
  AppConstants.importingEntries: "Увоз уноса...",
  AppConstants.importSuccess: "Успешно увезено %d уноса из Daily You!",
  AppConstants.importFailed: "Увоз није успео: %s",
  AppConstants.noEntriesToImport: "Нису пронађени нови уноси за увоз.",
  AppConstants.askSupport: "Затражи подршку",
  AppConstants.importSupportNote:
      "Формати других апликација можда не подржавају све функције. Ако наиђете на проблеме или се формати промене, пријавите проблем.",
  AppConstants.extractingBackup: "Распакивање резервне копије...",
  AppConstants.parsingDatabase: "Анализирање базе података...",
  AppConstants.dailyYouDbNotFound:
      "Daily You база података није пронађена у резервној копији.",
  AppConstants.privacyPolicy: "Политика приватности",
  AppConstants.termsNConditions: "Услови коришћења",
  AppConstants.about: "О апликацији",
  AppConstants.changeTheme: "Промени тему",
  AppConstants.theme: "Тема",
  AppConstants.pitchBlack: "Потпуно црна",
  AppConstants.themeLight: "Светла",
  AppConstants.themeDark: "Тамна",
  AppConstants.themeSystem: "Систем",
  AppConstants.changePin: "Промени PIN",
  AppConstants.loading: "Учитавање...",
  AppConstants.confirmRestoreTitle: "Потврди враћање",
  AppConstants.confirmRestoreMessage:
      "Враћање из резервне копије ће преписати све тренутне податке. Ова радња се не може опозвати. Да ли сте сигурни да желите да наставите?",
  AppConstants.notificationScheduled: "Обавештење заказано за %s",
  AppConstants.notificationCanceled: "Обавештење отказано",
  AppConstants.notificationRescheduled: "Обавештење поново заказано за %s",
  AppConstants.notificationPermissionRequired:
      "Дозвола за обавештења је потребна за постављање подсетника.",
  AppConstants.pinChangedSuccess: "PIN је успешно промењен",
  AppConstants.onThisDayOn: "Сада ћете добијати успомене од овог дана.",
  AppConstants.onThisDayOff: "Подсетници 'На данашњи дан' су искључени.",
  AppConstants.themeChanged: "Изабрана је тема %s.",
  AppConstants.hideStats: "Сакриј статистику",
  AppConstants.hideHomeStats: "Сакриј статистику на почетној",
  AppConstants.hideInsightsStats: "Сакриј статистику у Увидима",

  // Reflection Sheet
  AppConstants.reflectionTitle: "РАЗМИШЉАЊЕ",
  AppConstants.reflectButton: "Размисли",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Нетачан PIN",
  AppConstants.verifyYourPin: "Потврдите свој PIN",
  AppConstants.setAPin: "Постави PIN",
  AppConstants.confirmPin: "Потврди PIN",
  AppConstants.pinsDoNotMatch: "PIN кодови се не поклапају",
  AppConstants.setPin: "Постави PIN",
  AppConstants.hello: "Здраво!",
  AppConstants.enterYourPin: "Унесите свој PIN",
  AppConstants.useBiometrics: "Користи биометрију",
  AppConstants.authenticateToUnlock:
      "Молимо потврдите идентитет да откључате апликацију",
  AppConstants.databaseEncryption: "Шифровање базе података",
  AppConstants.databaseEncryptionDesc: "Локално шифровање AES-256-GCM",
  AppConstants.changeMasterPassword: "Промени главну лозинку",
  AppConstants.biometricUnlock: "Биометријско откључавање",
  AppConstants.enterMasterPassword: "Унесите главну лозинку",
  AppConstants.enterMasterPasswordHint:
      "Унесите своју главну лозинку да дешифрујете дневник.",
  AppConstants.unlockButton: "Откључај",
  AppConstants.unlockWithBiometrics: "Откључај биометријом",
  AppConstants.incorrectMasterPassword:
      "Нетачна главна лозинка. Покушајте поново.",
  AppConstants.databaseEncryptedSuccess:
      "База података дневника је шифрована помоћу AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "База података је дешифрована и закључавање апликације је искључено.",
  AppConstants.masterPasswordChangedSuccess:
      "Главна лозинка је успешно ажурирана.",
  AppConstants.encryptedBackupPasswordRequired:
      "Лозинка је потребна за отварање шифроване резервне копије.",
  AppConstants.incorrectBackupPassword: "Нетачна лозинка резервне копије.",
  AppConstants.invalidBackupFile:
      "Изабрана датотека није важећа OpenJot резервна копија.",
  AppConstants.encryptedBackup: "Шифрована копија (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Заштићено са AES-256-GCM и лозинком резервне копије",
  AppConstants.standardBackup: "Стандардна копија (.zip)",
  AppConstants.standardBackupDesc:
      "Нешифрована архива компатибилна са свим верзијама",
  AppConstants.takingBackup: "Прављење резервне копије...",
  AppConstants.encryptingBackup: "Шифровање резервне копије...",
  AppConstants.savingBackup: "Чување резервне копије...",
  AppConstants.preparingBackup: "Припрема резервне копије...",
  AppConstants.decryptingBackup: "Дешифровање резервне копије...",
  AppConstants.restoringBackup: "Враћање резервне копије...",
  AppConstants.backupEncodingFailed:
      "Кодирање датотеке резервне копије није успело.",
  AppConstants.backupCreatedSuccess: "Резервна копија је успешно направљена!",
  AppConstants.backupFailed: "Прављење резервне копије није успело: %s",
  AppConstants.restorePermissionsRequired:
      "Дозволе за складиште и медије су потребне за враћање података.",
  AppConstants.databaseRestoredNoMedia:
      "База података је враћена. У копији нису пронађени медији.",
  AppConstants.restoreSuccess: "Враћање је успешно!",
  AppConstants.restoreSuccessRestartRecommended:
      "Враћање је успешно. Препоручује се поновно покретање ради примене свих промена.",
  AppConstants.restoreFailed: "Враћање података није успело: %s",
  AppConstants.storagePermissionsRequired:
      "Дозволе за складиште и медије су потребне за прављење резервне копије.",
  AppConstants.selectBackupFolder:
      "Изаберите фасциклу за чување резервне копије",
  AppConstants.encryptDatabase: "Шифруј базу података",
  AppConstants.disableEncryption: "Искључи шифровање",
  AppConstants.backupPasswordTitle: "Лозинка резервне копије",
  AppConstants.changeMasterPasswordDesc:
      "Унесите тренутну главну лозинку и изаберите нову лозинку (најмање 6 карактера).",
  AppConstants.disableEncryptionDesc:
      "Унесите своју главну лозинку да дешифрујете базу података на диску и искључите шифровање.",
  AppConstants.enableEncryptionDesc:
      "Заштитите све белешке дневника локално шифровањем AES-256-GCM. Ако заборавите главну лозинку, шифровани подаци се не могу повратити.",
  AppConstants.verifyForBiometricsDesc:
      "Унесите своју главну лозинку једном да сачувате кључ за откључавање у сигурном хардверском складишту за брзо биометријско откључавање.",
  AppConstants.createBackupPasswordDesc:
      "Поставите јаку лозинку за шифровање ове .openjot копије. Ова лозинка ће вам требати за враћање на било ком уређају.",
  AppConstants.enterBackupPasswordDesc:
      "Унесите лозинку коришћену при прављењу ове .openjot резервне копије.",
  AppConstants.updatePasswordAction: "Ажурирај лозинку",
  AppConstants.decryptAndDisable: "Дешифруј и искључи",
  AppConstants.enableBiometricsAction: "Омогући биометрију",
  AppConstants.createBackupAction: "Направи копију",
  AppConstants.decryptBackupAction: "Дешифруј копију",
  AppConstants.newMasterPasswordHint: "Нова главна лозинка",
  AppConstants.backupPasswordHint: "Лозинка резервне копије",
  AppConstants.masterPasswordHint: "Главна лозинка",
  AppConstants.enterCurrentMasterPasswordError:
      "Молимо унесите тренутну главну лозинку.",
  AppConstants.passwordEmptyError: "Лозинка не може бити празна.",
  AppConstants.passwordMinLengthError:
      "Лозинка мора имати најмање 6 карактера.",
  AppConstants.passwordsDoNotMatchError: "Лозинке се не поклапају.",
  AppConstants.currentMasterPasswordHint: "Тренутна главна лозинка",
  AppConstants.confirmPasswordHint: "Потврди лозинку",

  // About & Terms
  AppConstants.aboutApp: "О апликацији OpenJot",
  AppConstants.versionPrefix: "Верзија: %s",
  AppConstants.aboutSubtitle:
      "Минималистички дневник отвореног кода за бележење ваших мисли, расположења и успомена. Сви ваши подаци остају на вашем уређају.",
  AppConstants.keyFeatures: "Кључне функције",
  AppConstants.aboutFeature1: "• Чисто искуство писања без ометања.",
  AppConstants.aboutFeature2:
      "• Додајте фотографије, гласовне белешке и музику у своје уносе.",
  AppConstants.aboutFeature3: "• Бележите своје расположење уз дневнике.",
  AppConstants.aboutFeature4: "• Персонализујте различитим стиловима текста.",
  AppConstants.aboutFeature5:
      "• Ради потпуно офлајн, подаци остају на вашем уређају.",
  AppConstants.openSource: "Отворени код",
  AppConstants.openSourceDesc:
      "OpenJot је апликација отвореног кода. Изворни код је јавно доступан свима на увид, измену и допринос. Верујемо у транспарентност и сарадњу заједнице.",
  AppConstants.dataPrivacy: "Приватност података",
  AppConstants.dataPrivacyDesc:
      "Ценимо вашу приватност. OpenJot не прикупља, не чува нити преноси ваше личне податке. Сви ваши уноси, укључујући текст, слике и аудио датотеке, чувају се искључиво на вашем уређају.",
  AppConstants.linksTitle: "Везе",
  AppConstants.sourceCodeOnGithub: "Изворни код на GitHub-у",
  AppConstants.sendFeedback: "Пошаљи повратне информације",
  AppConstants.couldNotLaunchUrl: "Није могуће отворити URL",
  AppConstants.termsIntro:
      "Добродошли у OpenJot! Овај документ описује услове коришћења наше апликације. Коришћењем апликације OpenJot прихватате ове услове.",
  AppConstants.termsSectionDataPrivacy: "Чување података и приватност",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot је осмишљен као приватни простор за ваше мисли. Сви уноси дневника, укључујући текст, слике, аудио датотеке и друге медије, чувају се искључиво локално на вашем уређају. Апликација не прикупља, не чува нити шаље личне податке спољним серверима. Немамо приступ вашем садржају.",
  AppConstants.termsSectionUserContent: "Садржај који генерише корисник",
  AppConstants.termsSectionUserContentBody:
      "Ви сте искључиво одговорни за садржај који креирате и чувате у апликацији OpenJot, укључујући текст, слике, аудио снимке и друге датотеке. Ваша је одговорност да обезбедите потребна права за коришћење сваког садржаја који увозите у апликацију.",
  AppConstants.termsSectionDisclaimer: "Одрицање од гаранције",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot је обезбеђен \"какав јесте\" без икаквих изричитих или подразумеваних гаранција. Не гарантујемо да ће апликација бити без грешака или прекида. Користите апликацију на сопствени ризик.",
  AppConstants.termsSectionLiability: "Ограничење одговорности",
  AppConstants.termsSectionLiabilityBody:
      "Ни у ком случају програмери апликације OpenJot неће бити одговорни за било какву директну, индиректну, случајну, посебну или последичну штету, укључујући губитак података, насталу услед коришћења или немогућности коришћења ове апликације.",
  AppConstants.termsSectionThirdParty: "Библиотеке трећих страна",
  AppConstants.termsSectionThirdPartyBody:
      "Ова апликација користи следеће библиотеке трећих страна, од којих свака подлеже сопственој лиценци:",

  // Months
  'January': 'Јануар',
  'February': 'Фебруар',
  'March': 'Март',
  'April': 'Април',
  'May': 'Мај',
  'June': 'Јун',
  'July': 'Јул',
  'August': 'Август',
  'September': 'Септембар',
  'October': 'Октобар',
  'November': 'Новембар',
  'December': 'Децембар',

  // Reflection Prompts (62)
  "What made you smile today?": "Шта вас је данас насмејало?",
  "Who are you thankful for this week, and why?":
      "Коме сте захвални ове недеље и зашто?",
  "What is something small that brought you joy today?":
      "Која вам је ситница данас донела радост?",
  "Which part of your day felt most comforting?":
      "Који део дана вам је био најпријатнији?",
  "What’s something you often take for granted but appreciate now?":
      "Шта често узимате здраво за готово, а сада цените?",
  "What’s the best thing that happened today?":
      "Шта је најбоље што се данас догодило?",
  "Did someone make your day easier today?":
      "Да ли вам је неко данас олакшао дан?",
  "Who made a positive impact on you recently?":
      "Ко је недавно позитивно утицао на вас?",
  "What’s a quality you admire in someone close to you?":
      "Којој се особини дивите код неког блиског?",
  "When did you last feel truly connected with someone?":
      "Када сте се последњи пут осећали истински повезани са неким?",
  "Who do you want to reach out to soon?":
      "Коме желите ускоро да се јавите?",
  "Did someone’s kindness stand out today?":
      "Да ли се данас истакла нечија љубазност?",
  "How did you support someone else recently?":
      "Како сте недавно подржали неког другог?",
  "Who do you miss the most right now?":
      "Ко вам тренутно највише недостаје?",
  "What’s a moment from today you want to remember?":
      "Који тренутак од данас желите да запамтите?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Који детаљ о данашњем дану бисте могли заборавити ако га не запишете?",
  "What’s the most peaceful moment you had today?":
      "Који вам је био најмирнији тренутак данас?",
  "Did you see something beautiful today?":
      "Да ли сте данас видели нешто лепо?",
  "Which memory from this week stands out?":
      "Која се успомена из ове недеље посебно истиче?",
  "What song, photo, or place will always remind you of today?":
      "Која ће вас песма, фотографија или место увек подсећати на данашњи дан?",
  "What surprised you today?": "Шта вас је данас изненадило?",
  "What challenge did you overcome today?":
      "Који сте изазов данас савладали?",
  "What’s a small win you had today?": "Коју сте малу победу данас остварили?",
  "What new thing did you learn about yourself recently?":
      "Шта сте ново недавно сазнали о себи?",
  "What are you proud of yourself for?": "На шта сте поносни код себе?",
  "What habit do you feel good about keeping?":
      "Због које навике коју одржавате се осећате добро?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Који сте напредак приметили код себе ове године?",
  "How did you push yourself out of your comfort zone?":
      "Како сте изашли из своје зоне комфора?",
  "How are you truly feeling right now?":
      "Како се заиста осећате управо сада?",
  "Which emotion stood out the most today?":
      "Која се емоција данас највише истакла?",
  "Did you feel present in any moment today?":
      "Да ли сте се у неком тренутку данас осећали потпуно присутно?",
  "When did you feel the most at peace today?":
      "Када сте се данас осећали најмирније?",
  "What gave you energy today?": "Шта вам је данас дало енергију?",
  "What drained your energy today?": "Шта вам је данас исцрпело енергију?",
  "If your mood had a color today, what would it be?":
      "Да ваше данашње расположење има боју, која би то била?",
  "What’s something you’re excited about tomorrow?":
      "Чему се радујете сутра?",
  "What’s one thing you want to improve tomorrow?":
      "Шта је једна ствар коју желите да побољшате сутра?",
  "What would make tomorrow feel successful?":
      "Шта би сутрашњи дан учинило успешним?",
  "What do you hope to achieve this week?":
      "Шта се надате да ћете постићи ове недеље?",
  "What’s a habit you’d like to start tomorrow?":
      "Коју бисте навику желели да започнете сутра?",
  "What’s something you want to look forward to in the next month?":
      "Чему желите да се радујете у наредном месецу?",
  "What would your ideal tomorrow look like?":
      "Како би изгледао ваш идеалан сутрашњи дан?",
  "What’s one lesson you learned recently?":
      "Која је једна лекција коју сте недавно научили?",
  "If you could freeze one moment today, which would it be?":
      "Када бисте данас могли да замрзнете један тренутак, који би то био?",
  "What makes your life feel meaningful right now?":
      "Шта ваш живот тренутно чини смисленим?",
  "If you described today in one word, what would it be?":
      "Када бисте данашњи дан описали једном речју, која би то била?",
  "What inspired you today?": "Шта вас је данас инспирисало?",
  "What did you notice today that you usually overlook?":
      "Шта сте данас приметили, а иначе превидите?",
  "How has today changed your perspective?":
      "Како је данашњи дан променио вашу перспективу?",
  "What’s something you’ve been overthinking?":
      "О чему сте у последње време превише размишљали?",
  "What do you need to let go of?": "Чега треба да се ослободите?",
  "What part of nature did you notice today?":
      "Који сте део природе данас приметили?",
  "Did the weather affect your mood today?":
      "Да ли је време данас утицало на ваше расположење?",
  "What place felt most comforting today?":
      "Које вам се место данас чинило најпријатнијим?",
  "Where did you feel most at home today?":
      "Где сте се данас осећали највише као код куће?",
  "What sound or smell reminded you of something important?":
      "Који вас је звук или мирис подсетио на нешто важно?",
  "How did you take care of yourself today?":
      "Како сте се данас бринули о себи?",
  "When did you feel most like yourself today?":
      "Када сте се данас осећали највише као ви сами?",
  "What’s something kind you can say to yourself right now?":
      "Шта лепо можете да кажете себи управо сада?",
  "What do you want to forgive yourself for?":
      "Шта желите да опростите себи?",
  "What do you deserve more of in your life?":
      "Чега заслужујете више у свом животу?",
};

/// Complete Swahili (Kiswahili) translations for OpenJot.
final Map<String, String> swTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Shajara Yangu",
  AppConstants.noEntriesMessage:
      "Hakuna maingizo ya shajara bado. Anza kuandika!",
  AppConstants.noBookmarksYet: "Hakuna alamisho bado.",
  AppConstants.noDraftsYet: "Hakuna rasimu bado.",
  AppConstants.addEntryButton: "Ongeza Ingizo Jipya",
  AppConstants.jotYourThoughts: "Andika Mawazo Yako",
  AppConstants.tapToCreateJournal:
      "Gusa + ili kuunda shajara yako ya kibinafsi.",
  AppConstants.entriesThisYear: "Maingizo Mwaka Huu",
  AppConstants.wordsWritten: "Maneno Yaliyoandikwa",
  AppConstants.daysJournaled: "Siku za Kuandika",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Ingizo Jipya la Shajara",
  AppConstants.editEntryAppBarTitle: "Hariri Ingizo la Shajara",
  AppConstants.titleHintText: "Kichwa (mf. 'Siku Yangu', 'Mawazo juu ya...')",
  AppConstants.contentHintText: "Andika mawazo yako hapa...",
  AppConstants.saveButton: "Hifadhi Ingizo",
  AppConstants.updateButton: "Sasisha",
  AppConstants.deleteButton: "Futa Ingizo",
  AppConstants.requiredFieldMessage: "Sehemu hii haiwezi kuwa tupu.",
  AppConstants.newEntry: "Ingizo Jipya",
  AppConstants.todayDate: "Tarehe ya leo",
  AppConstants.customDate: "Tarehe Maalum",
  AppConstants.done: "Imekamilika",
  AppConstants.startWriting: " Anza kuandika...",
  AppConstants.tags: "Lebo",
  AppConstants.addTags: "Ongeza lebo",
  AppConstants.openInMaps: "Fungua kwenye Ramani",
  AppConstants.changeLocation: "Badilisha Eneo",
  AppConstants.remove: "Ondoa",
  AppConstants.discardSelectionsTitle: "Tupa Chaguo?",
  AppConstants.discardSelectionsMessage:
      "Umechagua midia au rekodi inayoendelea. Una uhakika unataka kuzitupa?",
  AppConstants.journalEntryEmpty: "Ingizo la shajara haliwezi kuwa tupu",
  AppConstants.discardDateConfirm:
      "Tupa tarehe/muda uliouchagua kwa ingizo hili?",
  AppConstants.addMediaLocationMoodFirst:
      "Ongeza midia, eneo, au hisia kwanza",
  AppConstants.location: "Eneo",
  AppConstants.record: "Rekodi",
  AppConstants.selectMomentsToJournal: "Chagua matukio ya kuandika",
  AppConstants.addMomentsFromMenu:
      "Ongeza midia, eneo, rekodi, au hisia kutoka kwenye menyu",
  AppConstants.writeSomething: "Andika Kitu",
  AppConstants.saveWithoutWriting: "Hifadhi Bila Kuandika",
  AppConstants.oneLocation: "Eneo 1",
  AppConstants.mediaCount: "Midia %d",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Thibitisha Kufuta",
  AppConstants.confirmDeleteMessage:
      "Una uhakika unataka kufuta ingizo hili?",
  AppConstants.pleaseConfirm: "Tafadhali Thibitisha",
  AppConstants.confirmDeleteJournalEntry:
      "Una uhakika unataka kufuta ingizo hili la shajara? Kitendo hiki hakiwezi kutenduliwa.",
  AppConstants.yes: "Ndiyo",
  AppConstants.no: "Hapana",
  AppConstants.cancel: "Ghairi",
  AppConstants.delete: "Futa",
  AppConstants.save: "Hifadhi",
  AppConstants.entrySavedSuccess: "Ingizo la shajara limehifadhiwa!",
  AppConstants.entryUpdatedSuccess: "Ingizo la shajara limesasishwa!",
  AppConstants.entryDeletedSuccess: "Ingizo la shajara limefutwa.",
  AppConstants.errorSavingEntry: "Hitilafu wakati wa kuhifadhi ingizo.",
  AppConstants.errorDeletingEntry: "Hitilafu wakati wa kufuta ingizo.",
  AppConstants.errorLoadingEntries:
      "Hitilafu wakati wa kupakia maingizo ya shajara.",
  AppConstants.noEntriesForDate: "Hakuna maingizo kwa tarehe hii.",
  AppConstants.noEntriesForMonth: "Hakuna maingizo yaliyopatikana kwa mwezi huu.",
  AppConstants.selectMonthAndYear: "Chagua Mwezi & Mwaka",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Haipendezi Sana",
  AppConstants.unpleasant: "Haipendezi",
  AppConstants.slightlyUnpleasant: "Haipendezi Kidogo",
  AppConstants.neutral: "Wastani",
  AppConstants.slightlyPleasant: "Nzuri Kidogo",
  AppConstants.pleasant: "Nzuri",
  AppConstants.veryPleasant: "Nzuri Sana",
  AppConstants.reflection: "Tafakari",
  AppConstants.edit: "Hariri",
  AppConstants.removeBookmark: "Ondoa Alamisho",
  AppConstants.bookmark: "Alamisho",
  AppConstants.share: "Shiriki",
  AppConstants.saveAsPdf: "Hifadhi kama PDF",
  AppConstants.audioTrack: "Wimbo wa sauti",
  AppConstants.generatingPdf: "Inatengeneza PDF...",
  AppConstants.voiceRecording: "Rekodi ya Sauti",
  AppConstants.audioRecording: "Rekodi ya Sauti",
  AppConstants.couldNotLoadAudio: "Imeshindwa kupakia faili ya sauti.",
  AppConstants.stateOfMind: "Hali ya Akili",

  // Mood Colors
  AppConstants.moodColors: "Rangi za Hisia",
  AppConstants.customizeMoodColors: "Geuza Rangi za Hisia",
  AppConstants.reset: "Weka Upya",
  AppConstants.resetMoodColors: "Rejesha Chaguo-msingi",
  AppConstants.resetMoodColorsConfirm:
      "Rejesha rangi zote za hisia kuwa za msingi?",
  AppConstants.paletteThemes: "Mandhari ya Rangi",
  AppConstants.customColor: "Rangi Maalum",
  AppConstants.moodUnsavedChangesMessage:
      "Una mabadiliko ya rangi za hisia ambayo hayajahifadhiwa. Je, ungependa kuyahifadhi kabla ya kufunga?",

  // Drafts & Auto-save
  AppConstants.drafts: "Rasimu",
  AppConstants.draft: "Rasimu",
  AppConstants.draftSaved: "Imehifadhiwa kwenye Rasimu",
  AppConstants.unsavedChanges: "Mabadiliko Yasiyohifadhiwa",
  AppConstants.unsavedChangesMessage:
      "Una mabadiliko ambayo hayajahifadhiwa. Je, unataka kuyahifadhi kama rasimu au kuyatupa?",
  AppConstants.saveAsDraft: "Hifadhi kama Rasimu",
  AppConstants.discardChanges: "Tupa",
  AppConstants.autoDeleteDrafts: "Futa Rasimu Kiotomatiki",
  AppConstants.days7: "Siku 7",
  AppConstants.never: "Kamwe",
  AppConstants.custom: "Maalum...",
  AppConstants.enterCustomDays: "Weka Siku Maalum",
  AppConstants.customDaysExample: "Mf. 14",
  AppConstants.days: "Siku",
  AppConstants.draftsNeverDeleted: "Rasimu hazitafutwa kamwe",
  AppConstants.draftsDeletedAfterDays: "Rasimu zitafutwa baada ya siku %d",

  // Home Menu & Sorting
  AppConstants.sortBy: "Panga kwa",
  AppConstants.insights: "Takwimu",
  AppConstants.reflections: "Tafakari",
  AppConstants.settings: "Mipangilio",
  AppConstants.entryTime: "Muda wa ingizo",
  AppConstants.bookmarkFirst: "Alamisho kwanza",
  AppConstants.reflectionFirst: "Tafakari kwanza",
  AppConstants.withMediaFirst: "Zenye midia kwanza",
  AppConstants.textOnlyFirst: "Maandishi pekee kwanza",
  AppConstants.withLocationFirst: "Zenye eneo kwanza",
  AppConstants.withMoodFirst: "Zenye hisia kwanza",
  AppConstants.withTagsFirst: "Zenye lebo kwanza",

  // Insights
  AppConstants.stats: "Takwimu",
  AppConstants.calendar: "Kalenda",
  AppConstants.entriesSuffix: " maingizo",
  AppConstants.memoriesFromThisDay: "Kumbukumbu za siku hii",
  AppConstants.standard: "Kawaida",
  AppConstants.media: "Midia",
  AppConstants.mood: "Hisia",
  AppConstants.mostly: "Zaidi",
  AppConstants.averageForThisDay: "Wastani wa siku hii",
  AppConstants.averageForThisYear: "Wastani wa mwaka huu",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Karibu OpenJot",
  AppConstants.feature1:
      "Andika kwa uhuru, ongeza picha na maeneo, na uweke kila kitu salama kwenye kifaa chako.",
  AppConstants.feature2:
      "Elewa hisia zako baada ya muda kwa ufuatiliaji wa hisia uliojumuishwa.",
  AppConstants.feature3:
      "Data yako hubaki kwenye simu yako – hakuna wingu, hifadhi ya ndani tu na faragha kamili.",
  AppConstants.continueButton: "Endelea",

  // Notifications
  AppConstants.notificationTitle: "Muda wa Kuandika Shajara!",
  AppConstants.notificationBody: "Usisahau kuandika mawazo yako ya leo.",
  AppConstants.notificationChannelName: "Vikumbusho vya Shajara vya Kila Siku",
  AppConstants.notificationChannelDescription:
      "Kituo cha arifa za vikumbusho vya shajara kila siku",
  AppConstants.onThisDayChannelName: "Kumbukumbu za Siku Kama Hii",
  AppConstants.onThisDayChannelDescription:
      "Arifa za kumbukumbu kutoka miaka iliyopita.",
  AppConstants.onThisDayNotificationTitle: "Kumbukumbu kutoka shajara yako",
  AppConstants.onThisDaySingleEntry:
      "Mwaka mmoja uliopita leo, uliandika kitu maalum. Gusa ili kurejelea mawazo yako.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Siku kama hii mwaka jana, ulishiriki kumbukumbu hii. Gusa ili kuikumbuka tena.",
  AppConstants.onThisDayMultipleEntries:
      "Una kumbukumbu kutoka siku hii katika miaka iliyopita. Gusa ili kuziona.",
  AppConstants.onThisDayGroupedNotification:
      "Una kumbukumbu %d kutoka siku hii",

  // Exclude Entries
  AppConstants.excludeEntries: "Ondoa Maingizo",
  AppConstants.saveExclusions: "Hifadhi Viondolewa",
  AppConstants.excludeUnsavedChangesMessage:
      "Una mabadiliko ambayo hayajahifadhiwa. Una uhakika unataka kuyatupa na kuondoka?",
  AppConstants.sortDefault: "Chaguo-msingi",
  AppConstants.sortMutedFirst: "Zilizonyamazishwa kwanza",
  AppConstants.sortUnmutedFirst: "Zisizonyamazishwa kwanza",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Leo",
  AppConstants.yesterday: "Jana",
  AppConstants.contentForQuote: "Maudhui ya Nukuu",
  AppConstants.noContentSelected: "Hakuna maudhui yaliyochaguliwa.",
  AppConstants.photos: "Picha",
  AppConstants.video: "Video",
  AppConstants.audio: "Sauti",
  AppConstants.add: "Ongeza",
  AppConstants.noMediaFound: "Hakuna %s zilizopatikana.",
  AppConstants.permissionRequired:
      "Ruhusa ya kufikia %s inahitajika ili kuzionyesha.",
  AppConstants.openSettings: "Fungua Mipangilio",
  AppConstants.videos: "Video",
  AppConstants.audios: "Sauti",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Futa Rekodi?",
  AppConstants.deleteRecordingMessage:
      "Una uhakika unataka kufuta rekodi hii?",
  AppConstants.listen: "Sikiliza",
  AppConstants.tapAndHold: "gusa na ushikilie",
  AppConstants.clear: "Futa",
  AppConstants.all: "Zote",
  AppConstants.folder: "Folda",
  AppConstants.browse: "Vinjari",
  AppConstants.tiles: "Vigae",
  AppConstants.graph: "Grafu",
  AppConstants.recording: "Inarekodi...",
  AppConstants.recordingLabel: "Inarekodi",
  AppConstants.startAudioRecording: "Anza Kurekodi Sauti",
  AppConstants.howAreYouFeeling: "Unajisikiaje?",
  AppConstants.paused: "Imesitishwa",
  AppConstants.stop: "Simamisha",
  AppConstants.tapOrHoldToResume: "Gusa au ushikilie ili kuendelea",
  AppConstants.tapOrReleaseToPause: "Gusa au achilia ili kusitisha",
  AppConstants.unsupportedImageType: "Aina ya Picha Haiungwi Mkono",
  AppConstants.couldNotLoadVideo: "Imeshindwa kupakia video",
  AppConstants.couldNotOpenMap: "Imeshindwa kufungua kiungo cha ramani.",
  AppConstants.dismiss: "Ondoa",
  AppConstants.selectTime: "Chagua Muda",
  AppConstants.now: "Sasa",
  AppConstants.searchPlacesHint: "Tafuta maeneo, maduka...",
  AppConstants.locationPermissionDenied: "Ruhusa ya eneo imekataliwa.",
  AppConstants.failedGetCurrentLocation: "Imeshindwa kupata eneo la sasa.",

  // Search
  AppConstants.searchJournalsHint: "Tafuta shajara...",
  AppConstants.textOnly: "Maandishi Pekee",
  AppConstants.withMedia: "Yenye Midia",
  AppConstants.withMood: "Yenye Hisia",
  AppConstants.withLocation: "Yenye Eneo",
  AppConstants.withTags: "Yenye Lebo",
  AppConstants.noResultsFound: "Hakuna matokeo yaliyopatikana",
  AppConstants.searchHintText: "Tafuta maingizo...",

  // Settings
  AppConstants.language: "Lugha",
  AppConstants.selectLanguage: "Chagua Lugha",
  AppConstants.systemDefault: "Chaguo-msingi la Mfumo",
  AppConstants.searchLanguagesHint: "Tafuta lugha...",
  AppConstants.languageChanged: "Lugha imebadilishwa kuwa %s.",
  AppConstants.dailyReminder: "Vikumbusho",
  AppConstants.addReminder: "Ongeza Kikumbusho",
  AppConstants.deleteReminder: "Futa Kikumbusho",
  AppConstants.noRemindersSet: "Hakuna vikumbusho vilivyowekwa.",
  AppConstants.onThisDay: "Siku Kama Hii",
  AppConstants.appLock: "Kufuli ya Programu",
  AppConstants.backup: "Hifadhi Nakala",
  AppConstants.restore: "Rejesha",
  AppConstants.importFromAnotherApp: "Leta kutoka programu nyingine",
  AppConstants.importFromDailyYou: "Leta kutoka Daily You",
  AppConstants.selectDailyYouBackup:
      "Chagua faili ya zip ya nakala ya Daily You",
  AppConstants.importingEntries: "Inaleta maingizo...",
  AppConstants.importSuccess:
      "Maingizo %d yameletwa kwa mafanikio kutoka Daily You!",
  AppConstants.importFailed: "Kuleta kumeshindwa: %s",
  AppConstants.noEntriesToImport: "Hakuna maingizo mapya ya kuleta.",
  AppConstants.askSupport: "Omba Msaada",
  AppConstants.importSupportNote:
      "Miundo ya programu nyingine huenda isiauni vipengele vyote. Ukipata matatizo au miundo ikibadilika, tafadhali tuma ripoti ya tatizo.",
  AppConstants.extractingBackup: "Inatoa nakala...",
  AppConstants.parsingDatabase: "Inachambua hifadhidata...",
  AppConstants.dailyYouDbNotFound:
      "Hifadhidata ya Daily You haikupatikana kwenye nakala.",
  AppConstants.privacyPolicy: "Sera ya Faragha",
  AppConstants.termsNConditions: "Sheria na Masharti",
  AppConstants.about: "Kuhusu Programu",
  AppConstants.changeTheme: "Badilisha mandhari",
  AppConstants.theme: "Mandhari",
  AppConstants.pitchBlack: "Nyeusi Tii",
  AppConstants.themeLight: "Nuru",
  AppConstants.themeDark: "Giza",
  AppConstants.themeSystem: "Mfumo",
  AppConstants.changePin: "Badilisha PIN",
  AppConstants.loading: "Inapakia...",
  AppConstants.confirmRestoreTitle: "Thibitisha Kurejesha",
  AppConstants.confirmRestoreMessage:
      "Kurejesha kutoka kwa nakala kutafuta na kuandika upya data zote za sasa. Kitendo hiki hakiwezi kutenduliwa. Una uhakika unataka kuendelea?",
  AppConstants.notificationScheduled: "Arifa imepangwa kwa %s",
  AppConstants.notificationCanceled: "Arifa imeghairiwa",
  AppConstants.notificationRescheduled: "Arifa imepangwa upya kwa %s",
  AppConstants.notificationPermissionRequired:
      "Ruhusa ya arifa inahitajika ili kuweka vikumbusho.",
  AppConstants.pinChangedSuccess: "PIN imebadilishwa kwa mafanikio",
  AppConstants.onThisDayOn: "Sasa utapokea kumbukumbu kutoka siku hii.",
  AppConstants.onThisDayOff: "Vikumbusho vya 'Siku Kama Hii' vimezimwa.",
  AppConstants.themeChanged: "Mandhari ya %s yamechaguliwa.",
  AppConstants.hideStats: "Ficha Takwimu",
  AppConstants.hideHomeStats: "Ficha Takwimu za Nyumbani",
  AppConstants.hideInsightsStats: "Ficha Takwimu za Uchambuzi",

  // Reflection Sheet
  AppConstants.reflectionTitle: "TAFAKARI",
  AppConstants.reflectButton: "Tafakari",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "PIN si sahihi",
  AppConstants.verifyYourPin: "Thibitisha PIN yako",
  AppConstants.setAPin: "Weka PIN",
  AppConstants.confirmPin: "Thibitisha PIN",
  AppConstants.pinsDoNotMatch: "PIN hazilingani",
  AppConstants.setPin: "Weka PIN",
  AppConstants.hello: "Hujambo!",
  AppConstants.enterYourPin: "Weka PIN yako",
  AppConstants.useBiometrics: "Tumia Bayometriki",
  AppConstants.authenticateToUnlock:
      "Tafadhali thibitisha ili kufungua programu",
  AppConstants.databaseEncryption: "Usimbaji Fiche wa Hifadhidata",
  AppConstants.databaseEncryptionDesc: "Usimbaji fiche wa ndani wa AES-256-GCM",
  AppConstants.changeMasterPassword: "Badilisha Nenosiri Kuu",
  AppConstants.biometricUnlock: "Kufungua kwa Bayometriki",
  AppConstants.enterMasterPassword: "Weka Nenosiri Kuu",
  AppConstants.enterMasterPasswordHint:
      "Weka nenosiri lako kuu ili kufungua shajara yako.",
  AppConstants.unlockButton: "Fungua",
  AppConstants.unlockWithBiometrics: "Fungua kwa Bayometriki",
  AppConstants.incorrectMasterPassword:
      "Nenosiri kuu si sahihi. Tafadhali jaribu tena.",
  AppConstants.databaseEncryptedSuccess:
      "Hifadhidata ya shajara imesimbwa kwa AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Hifadhidata ya shajara imefunguliwa na kufuli ya programu imezimwa.",
  AppConstants.masterPasswordChangedSuccess:
      "Nenosiri kuu limesasishwa kwa mafanikio.",
  AppConstants.encryptedBackupPasswordRequired:
      "Nenosiri linahitajika ili kufungua nakala iliyosimbwa.",
  AppConstants.incorrectBackupPassword: "Nenosiri la nakala si sahihi.",
  AppConstants.invalidBackupFile:
      "Faili iliyochaguliwa si nakala halali ya OpenJot.",
  AppConstants.encryptedBackup: "Nakala Iliyosimbwa (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Imelindwa kwa AES-256-GCM na nenosiri la nakala",
  AppConstants.standardBackup: "Nakala ya Kawaida (.zip)",
  AppConstants.standardBackupDesc:
      "Kumbukumbu isiyosimbwa inayooana na matoleo yote",
  AppConstants.takingBackup: "Inatengeneza nakala...",
  AppConstants.encryptingBackup: "Inasimba nakala...",
  AppConstants.savingBackup: "Inahifadhi nakala...",
  AppConstants.preparingBackup: "Inaandaa nakala...",
  AppConstants.decryptingBackup: "Inafungua usimbaji wa nakala...",
  AppConstants.restoringBackup: "Inarejesha nakala...",
  AppConstants.backupEncodingFailed: "Imeshindwa kusimba faili ya nakala.",
  AppConstants.backupCreatedSuccess: "Nakala imeundwa kwa mafanikio!",
  AppConstants.backupFailed: "Imeshindwa kuunda nakala: %s",
  AppConstants.restorePermissionsRequired:
      "Ruhusa za hifadhi na midia zinahitajika ili kurejesha data.",
  AppConstants.databaseRestoredNoMedia:
      "Hifadhidata imerejeshwa. Hakuna midia iliyopatikana kwenye nakala.",
  AppConstants.restoreSuccess: "Urejeshaji umefanikiwa!",
  AppConstants.restoreSuccessRestartRecommended:
      "Urejeshaji umefanikiwa. Kuanzisha upya kunapendekezwa ili kutumia mabadiliko yote.",
  AppConstants.restoreFailed: "Imeshindwa kurejesha data: %s",
  AppConstants.storagePermissionsRequired:
      "Ruhusa za hifadhi na midia zinahitajika ili kuunda nakala.",
  AppConstants.selectBackupFolder: "Chagua folda ya kuhifadhi nakala",
  AppConstants.encryptDatabase: "Simba Hifadhidata",
  AppConstants.disableEncryption: "Zima Usimbaji Fiche",
  AppConstants.backupPasswordTitle: "Nenosiri la Nakala",
  AppConstants.changeMasterPasswordDesc:
      "Weka nenosiri lako kuu la sasa kisha uchague nenosiri jipya (angalau herufi 6).",
  AppConstants.disableEncryptionDesc:
      "Weka nenosiri lako kuu ili kufungua usimbaji wa hifadhidata kwenye diski na kuzima usimbaji fiche.",
  AppConstants.enableEncryptionDesc:
      "Linda maelezo yote ya shajara ndani ya kifaa kwa usimbaji fiche wa AES-256-GCM. Ukisahau nenosiri lako kuu, data iliyosimbwa haiwezi kurejeshwa.",
  AppConstants.verifyForBiometricsDesc:
      "Weka nenosiri lako kuu mara moja ili kuhifadhi ufunguo wa kufungua kwenye hifadhi salama ya maunzi kwa ufunguaji wa haraka wa bayometriki.",
  AppConstants.createBackupPasswordDesc:
      "Weka nenosiri imara la kusimba nakala hii ya .openjot. Utahitaji nenosiri hili ili kuirejesha kwenye kifaa chochote.",
  AppConstants.enterBackupPasswordDesc:
      "Weka nenosiri lililotumika wakati nakala hii ya .openjot ilipoundwa.",
  AppConstants.updatePasswordAction: "Sasisha Nenosiri",
  AppConstants.decryptAndDisable: "Fungua & Zima",
  AppConstants.enableBiometricsAction: "Washa Bayometriki",
  AppConstants.createBackupAction: "Unda Nakala",
  AppConstants.decryptBackupAction: "Fungua Nakala",
  AppConstants.newMasterPasswordHint: "Nenosiri kuu jipya",
  AppConstants.backupPasswordHint: "Nenosiri la nakala",
  AppConstants.masterPasswordHint: "Nenosiri kuu",
  AppConstants.enterCurrentMasterPasswordError:
      "Tafadhali weka nenosiri lako kuu la sasa.",
  AppConstants.passwordEmptyError: "Nenosiri haliwezi kuwa tupu.",
  AppConstants.passwordMinLengthError:
      "Nenosiri lazima liwe na angalau herufi 6.",
  AppConstants.passwordsDoNotMatchError: "Manenosiri hayalingani.",
  AppConstants.currentMasterPasswordHint: "Nenosiri kuu la sasa",
  AppConstants.confirmPasswordHint: "Thibitisha nenosiri",

  // About & Terms
  AppConstants.aboutApp: "Kuhusu OpenJot",
  AppConstants.versionPrefix: "Toleo: %s",
  AppConstants.aboutSubtitle:
      "Shajara rahisi ya chanzo huria ya kurekodi mawazo, hisia, na kumbukumbu zako. Data yako yote hubaki kwenye kifaa chako.",
  AppConstants.keyFeatures: "Vipengele Muhimu",
  AppConstants.aboutFeature1: "• Uzoefu safi wa uandishi usio na usumbufu.",
  AppConstants.aboutFeature2:
      "• Ongeza picha, maelezo ya sauti, na muziki kwenye maingizo yako.",
  AppConstants.aboutFeature3: "• Rekodi hisia zako pamoja na shajara yako.",
  AppConstants.aboutFeature4: "• Binafsisha kwa mitindo mbalimbali ya maandishi.",
  AppConstants.aboutFeature5:
      "• Inafanya kazi nje ya mtandao kabisa, data yako hubaki kwenye kifaa chako.",
  AppConstants.openSource: "Chanzo Huria",
  AppConstants.openSourceDesc:
      "OpenJot ni programu ya chanzo huria. Msimbo chanzo unapatikana hadharani kwa yeyote kukagua, kubadilisha, na kuchangia. Tunaamini katika uwazi na ushirikiano wa jamii.",
  AppConstants.dataPrivacy: "Faragha ya Data",
  AppConstants.dataPrivacyDesc:
      "Tunathamini faragha yako. OpenJot haikusanyi, haihifadhi, wala haisambazi data yako yoyote ya kibinafsi. Maingizo yako yote ya shajara, ikiwa ni pamoja na maandishi, picha, na sauti, huhifadhiwa pekee kwenye kifaa chako.",
  AppConstants.linksTitle: "Viungo",
  AppConstants.sourceCodeOnGithub: "Msimbo Chanzo kwenye GitHub",
  AppConstants.sendFeedback: "Tuma Maoni",
  AppConstants.couldNotLaunchUrl: "Imeshindwa kufungua URL",
  AppConstants.termsIntro:
      "Karibu OpenJot! Hati hii inaelezea sheria na masharti ya kutumia programu yetu. Kwa kutumia OpenJot, unakubali masharti haya.",
  AppConstants.termsSectionDataPrivacy: "Uhifadhi wa Data na Faragha",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot imeundwa kuwa nafasi ya faragha kwa mawazo yako. Maingizo yote ya shajara, ikiwa ni pamoja na maandishi, picha, faili za sauti, na midia nyingine, huhifadhiwa pekee ndani ya kifaa chako. Programu haikusanyi, haihifadhi, wala haitumi data yoyote ya kibinafsi kwa seva za nje. Hatuna ufikiaji wa maudhui yako.",
  AppConstants.termsSectionUserContent: "Maudhui Yanayotengenezwa na Mtumiaji",
  AppConstants.termsSectionUserContentBody:
      "Unawajibika kikamilifu kwa maudhui unayounda na kuhifadhi ndani ya OpenJot, ikiwa ni pamoja na maandishi, picha, rekodi za sauti, na faili nyingine. Ni jukumu lako kuhakikisha una haki zinazohitajika kutumia maudhui yoyote unayoingiza kwenye programu.",
  AppConstants.termsSectionDisclaimer: "Kanusho la Udhamini",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot inatolewa \"kama ilivyo\" bila dhamana yoyote, ya wazi au ya kudokezwa. Hatuhakikishi kuwa programu itakuwa bila hitilafu au bila kukatizwa. Unatumia programu kwa hatari yako mwenyewe.",
  AppConstants.termsSectionLiability: "Ukomo wa Dhima",
  AppConstants.termsSectionLiabilityBody:
      "Kwa vyovyote vile watengenezaji wa OpenJot hawatawajibika kwa uharibifu wowote wa moja kwa moja, usio wa moja kwa moja, wa bahati mbaya, maalum, au wa matokeo, ikiwa ni pamoja na upotevu wa data, unaotokana na matumizi au kushindwa kutumia programu hii.",
  AppConstants.termsSectionThirdParty: "Maktaba za Wahusika Wengine",
  AppConstants.termsSectionThirdPartyBody:
      "Programu hii inatumia maktaba zifuatazo za wahusika wengine, kila moja ikiongozwa na leseni yake yenyewe:",

  // Months
  'January': 'Januari',
  'February': 'Februari',
  'March': 'Machi',
  'April': 'Aprili',
  'May': 'Mei',
  'June': 'Juni',
  'July': 'Julai',
  'August': 'Agosti',
  'September': 'Septemba',
  'October': 'Oktoba',
  'November': 'Novemba',
  'December': 'Desemba',

  // Reflection Prompts (62)
  "What made you smile today?": "Nini kilikufanya utabasamu leo?",
  "Who are you thankful for this week, and why?":
      "Unamshukuru nani wiki hii, na kwa nini?",
  "What is something small that brought you joy today?":
      "Ni kitu gani kidogo kilichokuletea furaha leo?",
  "Which part of your day felt most comforting?":
      "Ni sehemu gani ya siku yako iliyohisi yenye faraja zaidi?",
  "What’s something you often take for granted but appreciate now?":
      "Ni kitu gani ambacho mara nyingi hukichukulia poa lakini sasa unakithamini?",
  "What’s the best thing that happened today?":
      "Ni jambo gani bora lililotokea leo?",
  "Did someone make your day easier today?":
      "Je, kuna mtu aliyefanya siku yako kuwa rahisi leo?",
  "Who made a positive impact on you recently?":
      "Nani aliyekuwa na athari chanya kwako hivi karibuni?",
  "What’s a quality you admire in someone close to you?":
      "Ni sifa gani unayoipenda kwa mtu aliye karibu nawe?",
  "When did you last feel truly connected with someone?":
      "Ni lini mara ya mwisho ulipohisi umeunganika kweli na mtu?",
  "Who do you want to reach out to soon?":
      "Unataka kuwasiliana na nani hivi karibuni?",
  "Did someone’s kindness stand out today?":
      "Je, wema wa mtu ulionekana wazi leo?",
  "How did you support someone else recently?":
      "Ulimsaidiaje mtu mwingine hivi karibuni?",
  "Who do you miss the most right now?":
      "Unamkosa nani zaidi kwa sasa?",
  "What’s a moment from today you want to remember?":
      "Ni tukio gani la leo unalotaka kulikumbuka?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Ni maelezo gani kuhusu leo unayoweza kusahau usipoyaandika?",
  "What’s the most peaceful moment you had today?":
      "Ni wakati gani wa amani zaidi uliokuwa nao leo?",
  "Did you see something beautiful today?": "Je, uliona kitu kizuri leo?",
  "Which memory from this week stands out?":
      "Ni kumbukumbu ipi ya wiki hii inayojitokeza zaidi?",
  "What song, photo, or place will always remind you of today?":
      "Ni wimbo, picha, au mahali gani ambapo siku zote patakukumbusha siku ya leo?",
  "What surprised you today?": "Nini kilikushangaza leo?",
  "What challenge did you overcome today?":
      "Ni changamoto gani uliyoishinda leo?",
  "What’s a small win you had today?":
      "Ni ushindi gani mdogo uliopata leo?",
  "What new thing did you learn about yourself recently?":
      "Ni jambo gani jipya ulilojifunza kujihusu hivi karibuni?",
  "What are you proud of yourself for?": "Unajivunia nini kuhusu wewe?",
  "What habit do you feel good about keeping?":
      "Ni tabia gani unayojisikia vizuri kuiendeleza?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Ni uboreshaji gani mmoja uliouona kwako mwaka huu?",
  "How did you push yourself out of your comfort zone?":
      "Ulijisukumaje kutoka nje ya eneo lako la faraja?",
  "How are you truly feeling right now?":
      "Unajisikiaje kweli kwa sasa?",
  "Which emotion stood out the most today?":
      "Ni hisia ipi iliyojitokeza zaidi leo?",
  "Did you feel present in any moment today?":
      "Je, ulihisi upo kikamilifu katika wakati wowote leo?",
  "When did you feel the most at peace today?":
      "Ni lini ulihisi amani zaidi leo?",
  "What gave you energy today?": "Nini kilikupa nguvu leo?",
  "What drained your energy today?": "Nini kilikumalizia nguvu leo?",
  "If your mood had a color today, what would it be?":
      "Kama hisia zako zingekuwa na rangi leo, ingekuwa rangi gani?",
  "What’s something you’re excited about tomorrow?":
      "Ni kitu gani unachokifurahia kuhusu kesho?",
  "What’s one thing you want to improve tomorrow?":
      "Ni jambo gani moja unalotaka kuboresha kesho?",
  "What would make tomorrow feel successful?":
      "Nini kingefanya kesho ihisi kuwa ya mafanikio?",
  "What do you hope to achieve this week?":
      "Unatarajia kufanikisha nini wiki hii?",
  "What’s a habit you’d like to start tomorrow?":
      "Ni tabia gani ungependa kuanza kesho?",
  "What’s something you want to look forward to in the next month?":
      "Ni kitu gani unachotaka kukitarajia mwezi ujao?",
  "What would your ideal tomorrow look like?":
      "Kesho yako bora ingekuwaje?",
  "What’s one lesson you learned recently?":
      "Ni somo gani moja ulilojifunza hivi karibuni?",
  "If you could freeze one moment today, which would it be?":
      "Kama ungeweza kugandisha wakati mmoja leo, ungekuwa upi?",
  "What makes your life feel meaningful right now?":
      "Nini kinafanya maisha yako yahisi yenye maana sasa hivi?",
  "If you described today in one word, what would it be?":
      "Kama ungeelezea siku ya leo kwa neno moja, lingekuwa neno gani?",
  "What inspired you today?": "Nini kilikupa hamasa leo?",
  "What did you notice today that you usually overlook?":
      "Uligundua nini leo ambacho kwa kawaida hukipuuzia?",
  "How has today changed your perspective?":
      "Siku ya leo imebadilishaje mtazamo wako?",
  "What’s something you’ve been overthinking?":
      "Ni jambo gani umekuwa ukiliwaza kupita kiasi?",
  "What do you need to let go of?": "Unahitaji kuachilia nini?",
  "What part of nature did you notice today?":
      "Ni sehemu gani ya asili uliyoiona leo?",
  "Did the weather affect your mood today?":
      "Je, hali ya hewa iliathiri hisia zako leo?",
  "What place felt most comforting today?":
      "Ni mahali gani palipohisi penye faraja zaidi leo?",
  "Where did you feel most at home today?":
      "Ni wapi ulihisi upo nyumbani zaidi leo?",
  "What sound or smell reminded you of something important?":
      "Ni sauti au harufu gani iliyokukumbusha kitu muhimu?",
  "How did you take care of yourself today?":
      "Ulijitunzaje leo?",
  "When did you feel most like yourself today?":
      "Ni lini ulihisi kuwa wewe mwenyewe zaidi leo?",
  "What’s something kind you can say to yourself right now?":
      "Ni maneno gani ya fadhili unayoweza kujiambia sasa hivi?",
  "What do you want to forgive yourself for?":
      "Unataka kujisamehe kwa ajili ya nini?",
  "What do you deserve more of in your life?":
      "Unastahili zaidi nini katika maisha yako?",
};

/// Complete Amharic (አማርኛ) translations for OpenJot.
final Map<String, String> amTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "የእኔ ማስታወሻ",
  AppConstants.noEntriesMessage: "እስካሁን ምንም ማስታወሻ የለም። መጻፍ ይጀምሩ!",
  AppConstants.noBookmarksYet: "እስካሁን ምንም ዕልባቶች የሉም።",
  AppConstants.noDraftsYet: "እስካሁን ምንም ረቂቆች የሉም።",
  AppConstants.addEntryButton: "አዲስ ማስታወሻ ጨምር",
  AppConstants.jotYourThoughts: "ሃሳብዎን ይጻፉ",
  AppConstants.tapToCreateJournal: "የግል ማስታወሻዎን ለመፍጠር + ይንኩ።",
  AppConstants.entriesThisYear: "የዘንድሮ ማስታወሻዎች",
  AppConstants.wordsWritten: "የተጻፉ ቃላት",
  AppConstants.daysJournaled: "ማስታወሻ የተጻፈባቸው ቀናት",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "አዲስ የማስታወሻ ግቤት",
  AppConstants.editEntryAppBarTitle: "ማስታወሻን አርትዕ",
  AppConstants.titleHintText: "ርዕስ (ለምሳሌ 'የእኔ ቀን'፣ 'ሃሳቦች...')",
  AppConstants.contentHintText: "ሃሳብዎን እዚህ ይጻፉ...",
  AppConstants.saveButton: "ማስታወሻውን አስቀምጥ",
  AppConstants.updateButton: "አዘምን",
  AppConstants.deleteButton: "ማስታወሻውን ሰርዝ",
  AppConstants.requiredFieldMessage: "ይህ ቦታ ባዶ መሆን አይችልም።",
  AppConstants.newEntry: "አዲስ ማስታወሻ",
  AppConstants.todayDate: "የዛሬ ቀን",
  AppConstants.customDate: "ብጁ ቀን",
  AppConstants.done: "ተከናውኗል",
  AppConstants.startWriting: " መጻፍ ይጀምሩ...",
  AppConstants.tags: "መለያዎች",
  AppConstants.addTags: "መለያዎችን ጨምር",
  AppConstants.openInMaps: "በካርታ ላይ ክፈት",
  AppConstants.changeLocation: "ቦታ ቀይር",
  AppConstants.remove: "አስወግድ",
  AppConstants.discardSelectionsTitle: "ምርጫዎች ይተዉ?",
  AppConstants.discardSelectionsMessage:
      "ሚዲያ ወይም ንቁ የድምጽ ቀረጻ መርጠዋል። እነሱን ለመተው እርግጠኛ ነዎት?",
  AppConstants.journalEntryEmpty: "የማስታወሻ ግቤት ባዶ መሆን አይችልም",
  AppConstants.discardDateConfirm: "ለዚህ ማስታወሻ የተመረጠው ቀን/ሰዓት ይተው?",
  AppConstants.addMediaLocationMoodFirst:
      "መጀመሪያ ሚዲያ፣ ቦታ ወይም ስሜት ያክሉ",
  AppConstants.location: "ቦታ",
  AppConstants.record: "ቀረጻ",
  AppConstants.selectMomentsToJournal: "ለመጻፍ ጊዜያትን ይምረጡ",
  AppConstants.addMomentsFromMenu:
      "ከምናሌው ሚዲያ፣ ቦታ፣ ቀረጻ ወይም ስሜት ያክሉ",
  AppConstants.writeSomething: "አንድ ነገር ይጻፉ",
  AppConstants.saveWithoutWriting: "ሳይጽፉ ያስቀምጡ",
  AppConstants.oneLocation: "1 ቦታ",
  AppConstants.mediaCount: "%d ሚዲያ",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "መሰረዝን ያረጋግጡ",
  AppConstants.confirmDeleteMessage: "ይህን ማስታወሻ መሰረዝ እንደሚፈልጉ እርግጠኛ ነዎት?",
  AppConstants.pleaseConfirm: "እባክዎ ያረጋግጡ",
  AppConstants.confirmDeleteJournalEntry:
      "ይህን የማስታወሻ ግቤት መሰረዝ እንደሚፈልጉ እርግጠኛ ነዎት? ይህ እርምጃ ሊመለስ አይችልም።",
  AppConstants.yes: "አዎ",
  AppConstants.no: "አይ",
  AppConstants.cancel: "ሰርዝ",
  AppConstants.delete: "ሰርዝ",
  AppConstants.save: "አስቀምጥ",
  AppConstants.entrySavedSuccess: "ማስታወሻው በተሳካ ሁኔታ ተቀምጧል!",
  AppConstants.entryUpdatedSuccess: "ማስታወሻው በተሳካ ሁኔታ ዘምኗል!",
  AppConstants.entryDeletedSuccess: "ማስታወሻው ተሰርዟል።",
  AppConstants.errorSavingEntry: "ማስታወሻውን በማስቀመጥ ላይ ስህተት ተፈጥሯል።",
  AppConstants.errorDeletingEntry: "ማስታወሻውን በመሰረዝ ላይ ስህተት ተፈጥሯል።",
  AppConstants.errorLoadingEntries: "ማስታወሻዎችን በመጫን ላይ ስህተት ተፈጥሯል።",
  AppConstants.noEntriesForDate: "ለዚህ ቀን ምንም ማስታወሻ የለም።",
  AppConstants.noEntriesForMonth: "ለዚህ ወር ምንም ማስታወሻ አልተገኘም።",
  AppConstants.selectMonthAndYear: "ወር እና ዓመት ይምረጡ",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "በጣም ደስ የማይል",
  AppConstants.unpleasant: "ደስ የማይል",
  AppConstants.slightlyUnpleasant: "በመጠኑ ደስ የማይል",
  AppConstants.neutral: "ገለልተኛ",
  AppConstants.slightlyPleasant: "በመጠኑ ደስ የሚል",
  AppConstants.pleasant: "ደስ የሚል",
  AppConstants.veryPleasant: "በጣም ደስ የሚል",
  AppConstants.reflection: "ማሰላሰል",
  AppConstants.edit: "አርትዕ",
  AppConstants.removeBookmark: "ዕልባት አስወግድ",
  AppConstants.bookmark: "ዕልባት",
  AppConstants.share: "አጋራ",
  AppConstants.saveAsPdf: "እንደ PDF አስቀምጥ",
  AppConstants.audioTrack: "የድምጽ ትራክ",
  AppConstants.generatingPdf: "PDF በመፍጠር ላይ...",
  AppConstants.voiceRecording: "የድምጽ ቀረጻ",
  AppConstants.audioRecording: "የድምጽ ቀረጻ",
  AppConstants.couldNotLoadAudio: "የድምጽ ፋይሉን መጫን አልተቻለም።",
  AppConstants.stateOfMind: "የአእምሮ ሁኔታ",

  // Mood Colors
  AppConstants.moodColors: "የስሜት ቀለሞች",
  AppConstants.customizeMoodColors: "የስሜት ቀለሞችን አብጅ",
  AppConstants.reset: "ዳግም አስጀምር",
  AppConstants.resetMoodColors: "ወደ ነባሪ ዳግም አስጀምር",
  AppConstants.resetMoodColorsConfirm:
      "ሁሉንም የስሜት ቀለሞች ወደ ነባሪ ዳግም ይመለሱ?",
  AppConstants.paletteThemes: "የቀለም ገጽታዎች",
  AppConstants.customColor: "ብጁ ቀለም",
  AppConstants.moodUnsavedChangesMessage:
      "ያልተቀመጡ የስሜት ቀለም ለውጦች አሉዎት። ከመዝጋትዎ በፊት ማስቀመጥ ይፈልጋሉ?",

  // Drafts & Auto-save
  AppConstants.drafts: "ረቂቆች",
  AppConstants.draft: "ረቂቅ",
  AppConstants.draftSaved: "ወደ ረቂቆች ተቀምጧል",
  AppConstants.unsavedChanges: "ያልተቀመጡ ለውጦች",
  AppConstants.unsavedChangesMessage:
      "ያልተቀመጡ ለውጦች አሉዎት። እንደ ረቂቅ ማስቀመጥ ወይስ መተው ይፈልጋሉ?",
  AppConstants.saveAsDraft: "እንደ ረቂቅ አስቀምጥ",
  AppConstants.discardChanges: "ተው",
  AppConstants.autoDeleteDrafts: "ረቂቆችን በራስ-ሰር ሰርዝ",
  AppConstants.days7: "7 ቀናት",
  AppConstants.never: "በጭራሽ",
  AppConstants.custom: "ብጁ...",
  AppConstants.enterCustomDays: "ብጁ ቀናትን ያስገቡ",
  AppConstants.customDaysExample: "ለምሳሌ 14",
  AppConstants.days: "ቀናት",
  AppConstants.draftsNeverDeleted: "ረቂቆች በጭራሽ አይሰረዙም",
  AppConstants.draftsDeletedAfterDays: "ረቂቆች ከ%d ቀናት በኋላ ይሰረዛሉ",

  // Home Menu & Sorting
  AppConstants.sortBy: "ደርድር በ",
  AppConstants.insights: "ግንዛቤዎች",
  AppConstants.reflections: "ማሰላሰሎች",
  AppConstants.settings: "ቅንብሮች",
  AppConstants.entryTime: "የግቤት ጊዜ",
  AppConstants.bookmarkFirst: "መጀመሪያ ዕልባቶች",
  AppConstants.reflectionFirst: "መጀመሪያ ማሰላሰሎች",
  AppConstants.withMediaFirst: "መጀመሪያ ሚዲያ ያላቸው",
  AppConstants.textOnlyFirst: "መጀመሪያ ጽሑፍ ብቻ",
  AppConstants.withLocationFirst: "መጀመሪያ ቦታ ያላቸው",
  AppConstants.withMoodFirst: "መጀመሪያ ስሜት ያላቸው",
  AppConstants.withTagsFirst: "መጀመሪያ መለያ ያላቸው",

  // Insights
  AppConstants.stats: "ስታቲስቲክስ",
  AppConstants.calendar: "የቀን መቁጠሪያ",
  AppConstants.entriesSuffix: " ግቤቶች",
  AppConstants.memoriesFromThisDay: "ከዚህ ቀን ትዝታዎች",
  AppConstants.standard: "መደበኛ",
  AppConstants.media: "ሚዲያ",
  AppConstants.mood: "ስሜት",
  AppConstants.mostly: "በአብዛኛው",
  AppConstants.averageForThisDay: "ለዚህ ቀን አማካይ",
  AppConstants.averageForThisYear: "ለዚህ ዓመት አማካይ",

  // Onboarding
  AppConstants.welcomeToOpenJot: "ወደ OpenJot እንኳን በደህና መጡ",
  AppConstants.feature1:
      "በነጻነት ይጻፉ፣ ፎቶዎችንና ቦታዎችን ያክሉ እና ሁሉንም ነገር በመሣሪያዎ ላይ በደህንነት ያቆዩ።",
  AppConstants.feature2:
      "በተካተተ የስሜት ክትትል ስሜትዎን በጊዜ ሂደት ይረዱ።",
  AppConstants.feature3:
      "ውሂብዎ በስልክዎ ላይ ይቆያል – ምንም ደመና የለም፣ የአካባቢ ማከማቻ እና ሙሉ ግላዊነት ብቻ።",
  AppConstants.continueButton: "ቀጥል",

  // Notifications
  AppConstants.notificationTitle: "ማስታወሻ የመጻፊያ ሰዓት!",
  AppConstants.notificationBody: "የዛሬ ሃሳብዎን መጻፍ አይርሱ።",
  AppConstants.notificationChannelName: "ዕለታዊ የማስታወሻ አስታዋሾች",
  AppConstants.notificationChannelDescription:
      "ለዕለታዊ የማስታወሻ አስታዋሽ ማሳወቂያዎች መስመር",
  AppConstants.onThisDayChannelName: "በዚህ ቀን ትዝታዎች",
  AppConstants.onThisDayChannelDescription: "ካለፉት ዓመታት ትዝታዎች ማሳወቂያዎች።",
  AppConstants.onThisDayNotificationTitle: "ከማስታወሻዎ አንድ ትዝታ",
  AppConstants.onThisDaySingleEntry:
      "ዛሬ ከአንድ ዓመት በፊት ልዩ ነገር ጽፈው ነበር። ሃሳብዎን ለማየት ይንኩ።",
  AppConstants.onThisDaySingleEntryWithMedia:
      "ባለፈው ዓመት በዚህ ቀን ይህን ትዝታ አጋርተዋል። እንደገና ለማየት ይንኩ።",
  AppConstants.onThisDayMultipleEntries:
      "ባለፉት ዓመታት ከዚህ ቀን ትዝታዎች አሉዎት። እነሱን ለማየት ይንኩ።",
  AppConstants.onThisDayGroupedNotification:
      "ከዚህ ቀን %d ትዝታዎች አሉዎት",

  // Exclude Entries
  AppConstants.excludeEntries: "ግቤቶችን አግልል",
  AppConstants.saveExclusions: "ማግለያዎችን አስቀምጥ",
  AppConstants.excludeUnsavedChangesMessage:
      "ያልተቀመጡ ለውጦች አሉዎት። እነሱን ትተው መውጣት እንደሚፈልጉ እርግጠኛ ነዎት?",
  AppConstants.sortDefault: "ነባሪ",
  AppConstants.sortMutedFirst: "መጀመሪያ የተደበቁ",
  AppConstants.sortUnmutedFirst: "መጀመሪያ ያልተደበቁ",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "ዛሬ",
  AppConstants.yesterday: "ትናንት",
  AppConstants.contentForQuote: "ለጥቅስ ይዘት",
  AppConstants.noContentSelected: "ምንም ይዘት አልተመረጠም።",
  AppConstants.photos: "ፎቶዎች",
  AppConstants.video: "ቪዲዮ",
  AppConstants.audio: "ድምጽ",
  AppConstants.add: "ጨምር",
  AppConstants.noMediaFound: "ምንም %s አልተገኘም።",
  AppConstants.permissionRequired:
      "እነሱን ለማሳየት የ%s መዳረሻ ፈቃድ ያስፈልጋል።",
  AppConstants.openSettings: "ቅንብሮችን ክፈት",
  AppConstants.videos: "ቪዲዮዎች",
  AppConstants.audios: "ድምጾች",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "ቀረጻ ይሰረዝ?",
  AppConstants.deleteRecordingMessage: "ይህን ቀረጻ መሰረዝ እንደሚፈልጉ እርግጠኛ ነዎት?",
  AppConstants.listen: "አዳምጥ",
  AppConstants.tapAndHold: "ነካ አድርገው ይያዙ",
  AppConstants.clear: "አጽዳ",
  AppConstants.all: "ሁሉም",
  AppConstants.folder: "አቃፊ",
  AppConstants.browse: "አስስ",
  AppConstants.tiles: "ንጣፎች",
  AppConstants.graph: "ግራፍ",
  AppConstants.recording: "በመቅዳት ላይ...",
  AppConstants.recordingLabel: "ቀረጻ",
  AppConstants.startAudioRecording: "የድምጽ ቀረጻ ጀምር",
  AppConstants.howAreYouFeeling: "ምን እየተሰማዎት ነው?",
  AppConstants.paused: "ቆሟል",
  AppConstants.stop: "አቁም",
  AppConstants.tapOrHoldToResume: "ለመቀጠል ይንኩ ወይም ይያዙ",
  AppConstants.tapOrReleaseToPause: "ለማቆም ይንኩ ወይም ይልቀቁ",
  AppConstants.unsupportedImageType: "የማይደገፍ የምስል ዓይነት",
  AppConstants.couldNotLoadVideo: "ቪዲዮውን መጫን አልተቻለም",
  AppConstants.couldNotOpenMap: "የካርታ ማገናኛን መክፈት አልተቻለም።",
  AppConstants.dismiss: "ዝጋ",
  AppConstants.selectTime: "ሰዓት ይምረጡ",
  AppConstants.now: "አሁን",
  AppConstants.searchPlacesHint: "ቦታዎችን፣ ሱቆችን ይፈልጉ...",
  AppConstants.locationPermissionDenied: "የቦታ ፈቃድ ተከልክሏል።",
  AppConstants.failedGetCurrentLocation: "የአሁኑን ቦታ ማግኘት አልተቻለም።",

  // Search
  AppConstants.searchJournalsHint: "ማስታወሻዎችን ይፈልጉ...",
  AppConstants.textOnly: "ጽሑፍ ብቻ",
  AppConstants.withMedia: "ከሚዲያ ጋር",
  AppConstants.withMood: "ከስሜት ጋር",
  AppConstants.withLocation: "ከቦታ ጋር",
  AppConstants.withTags: "ከመለያዎች ጋር",
  AppConstants.noResultsFound: "ምንም ውጤት አልተገኘም",
  AppConstants.searchHintText: "ግቤቶችን ይፈልጉ...",

  // Settings
  AppConstants.language: "ቋንቋ",
  AppConstants.selectLanguage: "ቋንቋ ይምረጡ",
  AppConstants.systemDefault: "የስርዓት ነባሪ",
  AppConstants.searchLanguagesHint: "ቋንቋዎችን ይፈልጉ...",
  AppConstants.languageChanged: "ቋንቋ ወደ %s ተቀይሯል።",
  AppConstants.dailyReminder: "አስታዋሾች",
  AppConstants.addReminder: "አስታዋሽ ጨምር",
  AppConstants.deleteReminder: "አስታዋሽ ሰርዝ",
  AppConstants.noRemindersSet: "ምንም አስታዋሾች አልተዘጋጁም።",
  AppConstants.onThisDay: "በዚህ ቀን",
  AppConstants.appLock: "የመተግበሪያ ቁልፍ",
  AppConstants.backup: "ምትኬ",
  AppConstants.restore: "እነበረበት መልስ",
  AppConstants.importFromAnotherApp: "ከሌላ መተግበሪያ አስመጣ",
  AppConstants.importFromDailyYou: "ከ Daily You አስመጣ",
  AppConstants.selectDailyYouBackup: "የ Daily You ምትኬ zip ፋይል ይምረጡ",
  AppConstants.importingEntries: "ግቤቶችን በማስመጣት ላይ...",
  AppConstants.importSuccess: "ከ Daily You %d ግቤቶች በተሳካ ሁኔታ ገብተዋል!",
  AppConstants.importFailed: "ማስመጣት አልተሳካም፦ %s",
  AppConstants.noEntriesToImport: "ለማስመጣት አዲስ ግቤቶች አልተገኙም።",
  AppConstants.askSupport: "ድጋፍ ጠይቅ",
  AppConstants.importSupportNote:
      "የሌሎች መተግበሪያዎች ቅርጸቶች ሁሉንም ባህሪያት ላይደግፉ ይችላሉ። ችግሮች ካጋጠሙዎት ወይም ቅርጸቶች ከተቀየሩ እባክዎ የችግር ሪፖርት ያቅርቡ።",
  AppConstants.extractingBackup: "ምትኬን በማውጣት ላይ...",
  AppConstants.parsingDatabase: "ዳታቤዝን በመተንተን ላይ...",
  AppConstants.dailyYouDbNotFound: "በምትኬው ውስጥ የ Daily You ዳታቤዝ አልተገኘም።",
  AppConstants.privacyPolicy: "የግላዊነት ፖሊሲ",
  AppConstants.termsNConditions: "ውሎች እና ሁኔታዎች",
  AppConstants.about: "ስለ መተግበሪያው",
  AppConstants.changeTheme: "ገጽታ ቀይር",
  AppConstants.theme: "ገጽታ",
  AppConstants.pitchBlack: "ጥቁር ድቅድቅ",
  AppConstants.themeLight: "ብሩህ",
  AppConstants.themeDark: "ጨለማ",
  AppConstants.themeSystem: "ስርዓት",
  AppConstants.changePin: "PIN ቀይር",
  AppConstants.loading: "በመጫን ላይ...",
  AppConstants.confirmRestoreTitle: "መመለስን ያረጋግጡ",
  AppConstants.confirmRestoreMessage:
      "ከምትኬ መመለስ ሁሉንም የአሁኑን ውሂብ ይተካል። ይህ እርምጃ ሊመለስ አይችልም። መቀጠል እንደሚፈልጉ እርግጠኛ ነዎት?",
  AppConstants.notificationScheduled: "ማሳወቂያ ለ%s ተይዟል",
  AppConstants.notificationCanceled: "ማሳወቂያ ተሰርዟል",
  AppConstants.notificationRescheduled: "ማሳወቂያ ወደ %s ተቀይሯል",
  AppConstants.notificationPermissionRequired:
      "አስታዋሾችን ለማዘጋጀት የማሳወቂያ ፈቃድ ያስፈልጋል።",
  AppConstants.pinChangedSuccess: "PIN በተሳካ ሁኔታ ተቀይሯል",
  AppConstants.onThisDayOn: "አሁን ከዚህ ቀን ትዝታዎችን ያገኛሉ።",
  AppConstants.onThisDayOff: "የ'በዚህ ቀን' አስታዋሾች ጠፍተዋል።",
  AppConstants.themeChanged: "የ%s ገጽታ ተመርጧል።",
  AppConstants.hideStats: "ስታቲስቲክስን ደብቅ",
  AppConstants.hideHomeStats: "የመነሻ ስታቲስቲክስን ደብቅ",
  AppConstants.hideInsightsStats: "የግንዛቤዎች ስታቲስቲክስን ደብቅ",

  // Reflection Sheet
  AppConstants.reflectionTitle: "ማሰላሰል",
  AppConstants.reflectButton: "አሰላስል",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "የተሳሳተ PIN",
  AppConstants.verifyYourPin: "የእርስዎን PIN ያረጋግጡ",
  AppConstants.setAPin: "PIN ያዘጋጁ",
  AppConstants.confirmPin: "PIN ያረጋግጡ",
  AppConstants.pinsDoNotMatch: "PINዎች አይዛመዱም",
  AppConstants.setPin: "PIN አዘጋጅ",
  AppConstants.hello: "ሰላም!",
  AppConstants.enterYourPin: "የእርስዎን PIN ያስገቡ",
  AppConstants.useBiometrics: "ባዮሜትሪክስ ተጠቀም",
  AppConstants.authenticateToUnlock: "መተግበሪያውን ለመክፈት እባክዎ ማንነትዎን ያረጋግጡ",
  AppConstants.databaseEncryption: "የዳታቤዝ ምስጠራ",
  AppConstants.databaseEncryptionDesc: "AES-256-GCM የአካባቢ ምስጠራ",
  AppConstants.changeMasterPassword: "ዋና የይለፍ ቃል ቀይር",
  AppConstants.biometricUnlock: "የባዮሜትሪክ መክፈቻ",
  AppConstants.enterMasterPassword: "ዋና የይለፍ ቃል ያስገቡ",
  AppConstants.enterMasterPasswordHint:
      "ማስታወሻዎን ለመክፈት ዋና የይለፍ ቃልዎን ያስገቡ።",
  AppConstants.unlockButton: "ክፈት",
  AppConstants.unlockWithBiometrics: "በባዮሜትሪክስ ክፈት",
  AppConstants.incorrectMasterPassword:
      "የተሳሳተ ዋና የይለፍ ቃል። እባክዎ እንደገና ይሞክሩ።",
  AppConstants.databaseEncryptedSuccess:
      "የማስታወሻ ዳታቤዙ በ AES-256-GCM ተመስጥሯል።",
  AppConstants.databaseDecryptedSuccess:
      "የማስታወሻ ዳታቤዙ ተፈቷል እና የመተግበሪያ ቁልፉ ጠፍቷል።",
  AppConstants.masterPasswordChangedSuccess:
      "ዋናው የይለፍ ቃል በተሳካ ሁኔታ ዘምኗል።",
  AppConstants.encryptedBackupPasswordRequired:
      "የተመሰጠረ ምትኬን ለመክፈት የይለፍ ቃል ያስፈልጋል።",
  AppConstants.incorrectBackupPassword: "የተሳሳተ የምትኬ የይለፍ ቃል።",
  AppConstants.invalidBackupFile: "የተመረጠው ፋይል ትክክለኛ የ OpenJot ምትኬ አይደለም።",
  AppConstants.encryptedBackup: "የተመሰጠረ ምትኬ (.openjot)",
  AppConstants.encryptedBackupDesc:
      "በ AES-256-GCM እና በምትኬ የይለፍ ቃል የተጠበቀ",
  AppConstants.standardBackup: "መደበኛ ምትኬ (.zip)",
  AppConstants.standardBackupDesc: "ከሁሉም ስሪቶች ጋር የሚስማማ ያልተመሰጠረ ማህደር",
  AppConstants.takingBackup: "ምትኬ በመውሰድ ላይ...",
  AppConstants.encryptingBackup: "ምትኬን በመመስጠር ላይ...",
  AppConstants.savingBackup: "ምትኬን በማስቀመጥ ላይ...",
  AppConstants.preparingBackup: "ምትኬን በማዘጋጀት ላይ...",
  AppConstants.decryptingBackup: "ምትኬን በመፍታት ላይ...",
  AppConstants.restoringBackup: "ምትኬን በመመለስ ላይ...",
  AppConstants.backupEncodingFailed: "የምትኬ ፋይሉን መቀየር አልተሳካም።",
  AppConstants.backupCreatedSuccess: "ምትኬው በተሳካ ሁኔታ ተፈጥሯል!",
  AppConstants.backupFailed: "ምትኬ መፍጠር አልተሳካም፦ %s",
  AppConstants.restorePermissionsRequired:
      "ውሂብን ለመመለስ የማከማቻ እና የሚዲያ ፈቃዶች ያስፈልጋሉ።",
  AppConstants.databaseRestoredNoMedia:
      "ዳታቤዙ ተመልሷል። በምትኬው ውስጥ ምንም ሚዲያ አልተገኘም።",
  AppConstants.restoreSuccess: "መመለስ ተሳክቷል!",
  AppConstants.restoreSuccessRestartRecommended:
      "መመለስ ተሳክቷል። ሁሉንም ለውጦች ተግባራዊ ለማድረግ እንደገና ማስጀመር ይመከራል።",
  AppConstants.restoreFailed: "ውሂብን መመለስ አልተሳካም፦ %s",
  AppConstants.storagePermissionsRequired:
      "ምትኬ ለመፍጠር የማከማቻ እና የሚዲያ ፈቃዶች ያስፈልጋሉ።",
  AppConstants.selectBackupFolder: "ምትኬውን ለማስቀመጥ አቃፊ ይምረጡ",
  AppConstants.encryptDatabase: "ዳታቤዙን መስጥር",
  AppConstants.disableEncryption: "ምስጠራን አሰናክል",
  AppConstants.backupPasswordTitle: "የምትኬ የይለፍ ቃል",
  AppConstants.changeMasterPasswordDesc:
      "የአሁኑን ዋና የይለፍ ቃል ያስገቡ እና አዲስ የይለፍ ቃል ይምረጡ (ቢያንስ 6 ቁምፊዎች)።",
  AppConstants.disableEncryptionDesc:
      "በዲስክ ላይ ያለውን ዳታቤዝዎን ለመፍታት እና ምስጠራን ለማጥፋት ዋና የይለፍ ቃልዎን ያስገቡ።",
  AppConstants.enableEncryptionDesc:
      "ሁሉንም የማስታወሻ ጽሑፎች በአካባቢዎ በ AES-256-GCM ምስጠራ ይጠብቁ። ዋና የይለፍ ቃልዎን ከረሱ የተመሰጠረውን ውሂብ መመለስ አይቻልም።",
  AppConstants.verifyForBiometricsDesc:
      "ለፈጣን የባዮሜትሪክ መክፈቻ በደህንነቱ የተጠበቀ የሃርድዌር ማከማቻ ውስጥ የመክፈቻ ቁልፍ ለማስቀመጥ ዋና የይለፍ ቃልዎን አንድ ጊዜ ያስገቡ።",
  AppConstants.createBackupPasswordDesc:
      "ይህን .openjot ምትኬ ለመመስጠር ጠንካራ የይለፍ ቃል ያዘጋጁ። በማንኛውም መሣሪያ ላይ ለመመለስ ይህ የይለፍ ቃል ያስፈልግዎታል።",
  AppConstants.enterBackupPasswordDesc:
      "ይህ .openjot ምትኬ ሲፈጠር ጥቅም ላይ የዋለውን የይለፍ ቃል ያስገቡ።",
  AppConstants.updatePasswordAction: "የይለፍ ቃል አዘምን",
  AppConstants.decryptAndDisable: "ፍታ እና አሰናክል",
  AppConstants.enableBiometricsAction: "ባዮሜትሪክስን አንቃ",
  AppConstants.createBackupAction: "ምትኬ ፍጠር",
  AppConstants.decryptBackupAction: "ምትኬን ፍታ",
  AppConstants.newMasterPasswordHint: "አዲስ ዋና የይለፍ ቃል",
  AppConstants.backupPasswordHint: "የምትኬ የይለፍ ቃል",
  AppConstants.masterPasswordHint: "ዋና የይለፍ ቃል",
  AppConstants.enterCurrentMasterPasswordError:
      "እባክዎ የአሁኑን ዋና የይለፍ ቃልዎን ያስገቡ።",
  AppConstants.passwordEmptyError: "የይለፍ ቃል ባዶ መሆን አይችልም።",
  AppConstants.passwordMinLengthError: "የይለፍ ቃል ቢያንስ 6 ቁምፊዎች ርዝመት ሊኖረው ይገባል።",
  AppConstants.passwordsDoNotMatchError: "የይለፍ ቃሎቹ አይዛመዱም።",
  AppConstants.currentMasterPasswordHint: "የአሁኑ ዋና የይለፍ ቃል",
  AppConstants.confirmPasswordHint: "የይለፍ ቃል ያረጋግጡ",

  // About & Terms
  AppConstants.aboutApp: "ስለ OpenJot",
  AppConstants.versionPrefix: "ስሪት፦ %s",
  AppConstants.aboutSubtitle:
      "ሃሳቦችዎን፣ ስሜቶችዎን እና ትዝታዎችዎን ለመመዝገብ ቀላል እና ክፍት-ምንጭ ማስታወሻ። ሁሉም ውሂብዎ በመሣሪያዎ ላይ ይቆያል።",
  AppConstants.keyFeatures: "ዋና ዋና ባህሪያት",
  AppConstants.aboutFeature1: "• ንጹህ፣ ከማዘናጋት የጸዳ የመጻፊያ ተሞክሮ።",
  AppConstants.aboutFeature2:
      "• በማስታወሻዎችዎ ላይ ፎቶዎችን፣ የድምጽ ማስታወሻዎችን እና ሙዚቃን ያክሉ።",
  AppConstants.aboutFeature3: "• ከማስታወሻዎችዎ ጎን ለጎን ስሜትዎን ይመዝግቡ።",
  AppConstants.aboutFeature4: "• በተለያዩ የጽሑፍ ቅጦች ለግል ያብጁ።",
  AppConstants.aboutFeature5:
      "• ሙሉ በሙሉ ከመስመር ውጭ ይሰራል፣ ውሂብዎ በመሣሪያዎ ላይ ይቆያል።",
  AppConstants.openSource: "ክፍት ምንጭ (Open Source)",
  AppConstants.openSourceDesc:
      "OpenJot ክፍት-ምንጭ መተግበሪያ ነው። ማንኛውም ሰው እንዲመለከተው፣ እንዲያሻሽለው እና አስተዋጽኦ እንዲያደርግበት የምንጭ ኮዱ በይፋ ይገኛል። በግልጽነት እና በማህበረሰብ ትብብር እናምናለን።",
  AppConstants.dataPrivacy: "የውሂብ ግላዊነት",
  AppConstants.dataPrivacyDesc:
      "ግላዊነትዎን እናከብራለን። OpenJot ማንኛውንም የግል ውሂብዎን አይሰበስብም፣ አያከማችም ወይም አያስተላልፍም። ጽሑፍን፣ ምስሎችን እና የድምጽ ፋይሎችን ጨምሮ ሁሉም የማስታወሻ ግቤቶችዎ በመሣሪያዎ ላይ ብቻ ይቀመጣሉ።",
  AppConstants.linksTitle: "አገናኞች",
  AppConstants.sourceCodeOnGithub: "የምንጭ ኮድ በ GitHub ላይ",
  AppConstants.sendFeedback: "አስተያየት ይላኩ",
  AppConstants.couldNotLaunchUrl: "URL መክፈት አልተቻለም",
  AppConstants.termsIntro:
      "ወደ OpenJot እንኳን በደህና መጡ! ይህ ሰነድ መተግበሪያችንን ለመጠቀም የሚያስፈልጉ ውሎችን እና ሁኔታዎችን ይዘረዝራል። OpenJot ን በመጠቀም በእነዚህ ውሎች ይስማማሉ።",
  AppConstants.termsSectionDataPrivacy: "የውሂብ ማከማቻ እና ግላዊነት",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot ለሃሳቦችዎ የግል ቦታ እንዲሆን ተደርጎ የተነደፈ ነው። ጽሑፍ፣ ምስሎች፣ የድምጽ ፋይሎች እና ሌሎች ሚዲያዎችን ጨምሮ ሁሉም የማስታወሻ ግቤቶች በአካባቢያዊ መሣሪያዎ ላይ ብቻ ይቀመጣሉ። መተግበሪያው የግል ውሂብዎን ወደ ውጫዊ አገልጋዮች አይሰበስብም፣ አያከማችም ወይም አይልክም። ወደ ይዘትዎ ምንም መዳረሻ የለንም።",
  AppConstants.termsSectionUserContent: "በተጠቃሚ የመነጨ ይዘት",
  AppConstants.termsSectionUserContentBody:
      "በ OpenJot ውስጥ ለሚፈጥሩት እና ለሚያከማቹት ይዘት፣ ጽሑፍን፣ ምስሎችን፣ የድምጽ ቀረጻዎችን እና ሌሎች ፋይሎችን ጨምሮ እርስዎ ብቻ ኃላፊነት አለብዎት። ወደ መተግበሪያው የሚያስገቡትን ማንኛውንም ይዘት ለመጠቀም አስፈላጊ መብቶች እንዳሉዎት ማረጋገጥ የእርስዎ ኃላፊነት ነው።",
  AppConstants.termsSectionDisclaimer: "የዋስትና ማስተባበያ",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot ምንም ዓይነት ግልጽ ወይም በተዘዋዋሪ ዋስትና ሳይኖር \"እንዳለ\" ይቀርባል። መተግበሪያው ከስህተት የጸዳ ወይም ያልተቋረጠ መሆኑን ዋስትና አንሰጥም። መተግበሪያውን በራስዎ ኃላፊነት ይጠቀማሉ።",
  AppConstants.termsSectionLiability: "የተጠያቂነት ገደብ",
  AppConstants.termsSectionLiabilityBody:
      "በምንም አጋጣሚ የ OpenJot ገንቢዎች ይህን መተግበሪያ ከመጠቀም ወይም መጠቀም ካለመቻል የተነሳ ለሚደርስ የውሂብ መጥፋትን ጨምሮ ለማንኛውም ቀጥተኛ፣ ቀጥተኛ ያልሆነ፣ ድንገተኛ፣ ልዩ ወይም ተከታይ ጉዳት ተጠያቂ አይሆኑም።",
  AppConstants.termsSectionThirdParty: "የሶስተኛ ወገን ቤተ-መጻሕፍት",
  AppConstants.termsSectionThirdPartyBody:
      "ይህ መተግበሪያ የሚከተሉትን የሶስተኛ ወገን ቤተ-መጻሕፍት ይጠቀማል፣ እያንዳንዱም በራሱ ፈቃድ ይተዳደራል፦",

  // Months
  'January': 'ጃንዋሪ',
  'February': 'ፌብሩዋሪ',
  'March': 'ማርች',
  'April': 'ኤፕሪል',
  'May': 'ሜይ',
  'June': 'ጁን',
  'July': 'ጁላይ',
  'August': 'ኦገስት',
  'September': 'ሴፕቴምበር',
  'October': 'ኦክቶበር',
  'November': 'ኖቬምበር',
  'December': 'ዲሴምበር',

  // Reflection Prompts (62)
  "What made you smile today?": "ዛሬ ፈገግ እንዲሉ ያደረገው ምንድን ነው?",
  "Who are you thankful for this week, and why?":
      "በዚህ ሳምንት ለማን አመስጋኝ ነዎት፣ እና ለምን?",
  "What is something small that brought you joy today?":
      "ዛሬ ደስታ ያመጣልዎት ትንሽ ነገር ምንድን ነው?",
  "Which part of your day felt most comforting?":
      "የቀንዎ የትኛው ክፍል በጣም አጽናኝ ነበር?",
  "What’s something you often take for granted but appreciate now?":
      "ብዙ ጊዜ እንደ ተራ የሚቆጥሩት ግን አሁን የሚያደንቁት ነገር ምንድን ነው?",
  "What’s the best thing that happened today?":
      "ዛሬ የተከሰተው በጣም ጥሩ ነገር ምንድን ነው?",
  "Did someone make your day easier today?":
      "ዛሬ አንድ ሰው ቀንዎን ቀላል አድርጎልዎታል?",
  "Who made a positive impact on you recently?":
      "በቅርቡ በእርስዎ ላይ አዎንታዊ ተጽእኖ ያሳደረው ማን ነው?",
  "What’s a quality you admire in someone close to you?":
      "በቅርብ ሰውዎ ውስጥ የሚያደንቁት ባህሪ ምንድን ነው?",
  "When did you last feel truly connected with someone?":
      "ለመጨረሻ ጊዜ ከአንድ ሰው ጋር በእውነት እንደተገናኙ የተሰማዎት መቼ ነው?",
  "Who do you want to reach out to soon?":
      "በቅርቡ ማንን ማግኘት ይፈልጋሉ?",
  "Did someone’s kindness stand out today?":
      "ዛሬ የአንድ ሰው ደግነት ጎልቶ ታይቷል?",
  "How did you support someone else recently?":
      "በቅርቡ ሌላ ሰውን እንዴት ደገፉ?",
  "Who do you miss the most right now?": "አሁን በጣም የሚናፍቁት ማንን ነው?",
  "What’s a moment from today you want to remember?":
      "ከዛሬ ማስታወስ የሚፈልጉት ቅጽበት የትኛው ነው?",
  "What’s a detail about today you might forget if you don’t note it?":
      "ካልጻፉት ሊረሱት የሚችሉት የዛሬ ዝርዝር ምንድን ነው?",
  "What’s the most peaceful moment you had today?":
      "ዛሬ ያሳለፉት በጣም ሰላማዊ ጊዜ የትኛው ነበር?",
  "Did you see something beautiful today?": "ዛሬ ቆንጆ ነገር አይተዋል?",
  "Which memory from this week stands out?":
      "ከዚህ ሳምንት ጎልቶ የሚታየው ትዝታ የትኛው ነው?",
  "What song, photo, or place will always remind you of today?":
      "የትኛው ዘፈን፣ ፎቶ ወይም ቦታ ሁልጊዜ ዛሬን ያስታውስዎታል?",
  "What surprised you today?": "ዛሬ ምን አስገረመዎት?",
  "What challenge did you overcome today?":
      "ዛሬ የትኛውን ፈተና አሸነፉ?",
  "What’s a small win you had today?": "ዛሬ ያገኙት ትንሽ ድል ምንድን ነው?",
  "What new thing did you learn about yourself recently?":
      "በቅርቡ ስለ ራስዎ የተማሩት አዲስ ነገር ምንድን ነው?",
  "What are you proud of yourself for?": "በራስዎ የሚኮሩበት ነገር ምንድን ነው?",
  "What habit do you feel good about keeping?":
      "በመጠበቅዎ ጥሩ ስሜት የሚሰማዎት ልማድ የትኛው ነው?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "በዚህ ዓመት በራስዎ ላይ ያስተዋሉት አንድ መሻሻል ምንድን ነው?",
  "How did you push yourself out of your comfort zone?":
      "ራስዎን ከምቾት ዞንዎ እንዴት አወጡ?",
  "How are you truly feeling right now?":
      "አሁን በእውነት ምን እየተሰማዎት ነው?",
  "Which emotion stood out the most today?":
      "ዛሬ በጣም ጎልቶ የታየው ስሜት የትኛው ነው?",
  "Did you feel present in any moment today?":
      "ዛሬ በማንኛውም ቅጽበት ሙሉ በሙሉ በቦታው እንዳሉ ተሰምቶዎታል?",
  "When did you feel the most at peace today?":
      "ዛሬ በጣም ሰላም የተሰማዎት መቼ ነው?",
  "What gave you energy today?": "ዛሬ ጉልበት የሰጠዎት ምንድን ነው?",
  "What drained your energy today?": "ዛሬ ጉልበትዎን የወሰደው ምንድን ነው?",
  "If your mood had a color today, what would it be?":
      "ዛሬ ስሜትዎ ቀለም ቢኖረው ምን ዓይነት ቀለም ይሆን ነበር?",
  "What’s something you’re excited about tomorrow?":
      "ስለ ነገ የሚጓጉለት ነገር ምንድን ነው?",
  "What’s one thing you want to improve tomorrow?":
      "ነገ ማሻሻል የሚፈልጉት አንድ ነገር ምንድን ነው?",
  "What would make tomorrow feel successful?":
      "ነገን ስኬታማ እንዲሰማ የሚያደርገው ምንድን ነው?",
  "What do you hope to achieve this week?":
      "በዚህ ሳምንት ምን ለማሳካት ተስፋ ያደርጋሉ?",
  "What’s a habit you’d like to start tomorrow?":
      "ነገ መጀመር የሚፈልጉት ልማድ ምንድን ነው?",
  "What’s something you want to look forward to in the next month?":
      "በሚቀጥለው ወር በጉጉት መጠበቅ የሚፈልጉት ነገር ምንድን ነው?",
  "What would your ideal tomorrow look like?":
      "ተስማሚው ነገዎ ምን ይመስላል?",
  "What’s one lesson you learned recently?":
      "በቅርቡ የተማሩት አንድ ትምህርት ምንድን ነው?",
  "If you could freeze one moment today, which would it be?":
      "ዛሬ አንድ ቅጽበትን ማቆም ቢችሉ የትኛውን ይሆን ነበር?",
  "What makes your life feel meaningful right now?":
      "አሁን ሕይወትዎ ትርጉም ያለው እንዲሰማ የሚያደርገው ምንድን ነው?",
  "If you described today in one word, what would it be?":
      "ዛሬን በአንድ ቃል ቢገልጹት ምን ይሆን ነበር?",
  "What inspired you today?": "ዛሬ ምን አነሳሳዎት?",
  "What did you notice today that you usually overlook?":
      "ብዙ ጊዜ ችላ የሚሉትን ዛሬ ያስተዋሉት ምንድን ነው?",
  "How has today changed your perspective?":
      "ዛሬ አመለካከትዎን እንዴት ለወጠው?",
  "What’s something you’ve been overthinking?":
      "ከመጠን በላይ ሲያስቡበት የቆዩት ነገር ምንድን ነው?",
  "What do you need to let go of?": "መተው ያለብዎት ነገር ምንድን ነው?",
  "What part of nature did you notice today?":
      "ዛሬ የትኛውን የተፈጥሮ ክፍል አስተዋሉ?",
  "Did the weather affect your mood today?":
      "የአየር ሁኔታው ዛሬ በስሜትዎ ላይ ተጽዕኖ አሳድሯል?",
  "What place felt most comforting today?":
      "ዛሬ በጣም ምቹ የሆነልዎት ቦታ የትኛው ነው?",
  "Where did you feel most at home today?":
      "ዛሬ በጣም እንደ ቤትዎ የተሰማዎት የት ነው?",
  "What sound or smell reminded you of something important?":
      "የትኛው ድምጽ ወይም ሽታ አስፈላጊ ነገርን አስታወሰዎት?",
  "How did you take care of yourself today?":
      "ዛሬ ራስዎን እንዴት ተንከባከቡ?",
  "When did you feel most like yourself today?":
      "ዛሬ በጣም ራስዎን የሆኑ መስሎ የተሰማዎት መቼ ነው?",
  "What’s something kind you can say to yourself right now?":
      "አሁን ለራስዎ መናገር የሚችሉት ደግ ነገር ምንድን ነው?",
  "What do you want to forgive yourself for?":
      "ራስዎን ይቅር ማለት የሚፈልጉት ለምንድን ነው?",
  "What do you deserve more of in your life?":
      "በሕይወትዎ ውስጥ በይበልጥ የሚገባዎት ነገር ምንድን ነው?",
};

/// Complete Afrikaans (Afrikaans) translations for OpenJot.
final Map<String, String> afTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "My Joernaal",
  AppConstants.noEntriesMessage:
      "Nog geen joernaalinskrywings nie. Begin skryf!",
  AppConstants.noBookmarksYet: "Nog geen boekmerke nie.",
  AppConstants.noDraftsYet: "Nog geen konsepte nie.",
  AppConstants.addEntryButton: "Voeg Nuwe Inskrywing By",
  AppConstants.jotYourThoughts: "Skryf Jou Gedagtes Neer",
  AppConstants.tapToCreateJournal:
      "Tik + om jou persoonlike joernaal te skep.",
  AppConstants.entriesThisYear: "Inskrywings Hierdie Jaar",
  AppConstants.wordsWritten: "Woorde Geskryf",
  AppConstants.daysJournaled: "Dae Gejoernaal",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Nuwe Joernaalinskrywing",
  AppConstants.editEntryAppBarTitle: "Wysig Joernaalinskrywing",
  AppConstants.titleHintText: "Titel (bv. 'My Dag', 'Gedagtes oor...')",
  AppConstants.contentHintText: "Skryf jou gedagtes hier...",
  AppConstants.saveButton: "Stoor Inskrywing",
  AppConstants.updateButton: "Dateer Op",
  AppConstants.deleteButton: "Skrap Inskrywing",
  AppConstants.requiredFieldMessage: "Hierdie veld kan nie leeg wees nie.",
  AppConstants.newEntry: "Nuwe Inskrywing",
  AppConstants.todayDate: "Vandag se datum",
  AppConstants.customDate: "Pasgemaakte Datum",
  AppConstants.done: "Klaar",
  AppConstants.startWriting: " Begin skryf...",
  AppConstants.tags: "Etikette",
  AppConstants.addTags: "Voeg etikette by",
  AppConstants.openInMaps: "Maak oop in Kaarte",
  AppConstants.changeLocation: "Verander Ligging",
  AppConstants.remove: "Verwyder",
  AppConstants.discardSelectionsTitle: "Gooi Keuses Weg?",
  AppConstants.discardSelectionsMessage:
      "Jy het media of 'n aktiewe opname gekies. Is jy seker jy wil dit weggooi?",
  AppConstants.journalEntryEmpty: "Joernaalinskrywing kan nie leeg wees nie",
  AppConstants.discardDateConfirm:
      "Gooi die gekose datum/tyd vir hierdie inskrywing weg?",
  AppConstants.addMediaLocationMoodFirst:
      "Voeg eers media, ligging of gemoedstoestand by",
  AppConstants.location: "Ligging",
  AppConstants.record: "Neem Op",
  AppConstants.selectMomentsToJournal: "Kies oomblikke om te joernaal",
  AppConstants.addMomentsFromMenu:
      "Voeg media, ligging, opname of gemoedstoestand uit die kieslys by",
  AppConstants.writeSomething: "Skryf Iets",
  AppConstants.saveWithoutWriting: "Stoor Sonder om te Skryf",
  AppConstants.oneLocation: "1 Ligging",
  AppConstants.mediaCount: "%d Media",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Bevestig Skrapping",
  AppConstants.confirmDeleteMessage:
      "Is jy seker jy wil hierdie inskrywing skrap?",
  AppConstants.pleaseConfirm: "Bevestig Asseblief",
  AppConstants.confirmDeleteJournalEntry:
      "Is jy seker jy wil hierdie joernaalinskrywing skrap? Hierdie aksie is onomkeerbaar.",
  AppConstants.yes: "Ja",
  AppConstants.no: "Nee",
  AppConstants.cancel: "Kanselleer",
  AppConstants.delete: "Skrap",
  AppConstants.save: "Stoor",
  AppConstants.entrySavedSuccess: "Joernaalinskrywing suksesvol gestoor!",
  AppConstants.entryUpdatedSuccess: "Joernaalinskrywing suksesvol opgedateer!",
  AppConstants.entryDeletedSuccess: "Joernaalinskrywing geskrap.",
  AppConstants.errorSavingEntry: "Fout tydens stoor van inskrywing.",
  AppConstants.errorDeletingEntry: "Fout tydens skrapping van inskrywing.",
  AppConstants.errorLoadingEntries: "Fout tydens laai van joernaalinskrywings.",
  AppConstants.noEntriesForDate: "Geen inskrywings vir hierdie datum nie.",
  AppConstants.noEntriesForMonth: "Geen inskrywings vir hierdie maand gevind nie.",
  AppConstants.selectMonthAndYear: "Kies Maand & Jaar",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Baie Onaangenaam",
  AppConstants.unpleasant: "Onaangenaam",
  AppConstants.slightlyUnpleasant: "Effens Onaangenaam",
  AppConstants.neutral: "Neutraal",
  AppConstants.slightlyPleasant: "Effens Aangenaam",
  AppConstants.pleasant: "Aangenaam",
  AppConstants.veryPleasant: "Baie Aangenaam",
  AppConstants.reflection: "Refleksie",
  AppConstants.edit: "Wysig",
  AppConstants.removeBookmark: "Verwyder Boekmerk",
  AppConstants.bookmark: "Boekmerk",
  AppConstants.share: "Deel",
  AppConstants.saveAsPdf: "Stoor as PDF",
  AppConstants.audioTrack: "Oudiosnit",
  AppConstants.generatingPdf: "Genereer PDF...",
  AppConstants.voiceRecording: "Stemopname",
  AppConstants.audioRecording: "Oudio-opname",
  AppConstants.couldNotLoadAudio: "Kon nie oudiolêer laai nie.",
  AppConstants.stateOfMind: "Gemoedstoestand",

  // Mood Colors
  AppConstants.moodColors: "Gemoedskleure",
  AppConstants.customizeMoodColors: "Pas Gemoedskleure Aan",
  AppConstants.reset: "Herstel",
  AppConstants.resetMoodColors: "Herstel na Verstek",
  AppConstants.resetMoodColorsConfirm:
      "Herstel alle gemoedskleure na verstek?",
  AppConstants.paletteThemes: "Palettemas",
  AppConstants.customColor: "Pasgemaakte Kleur",
  AppConstants.moodUnsavedChangesMessage:
      "Jy het ongestoorde veranderinge aan gemoedskleure. Wil jy dit stoor voordat jy toemaak?",

  // Drafts & Auto-save
  AppConstants.drafts: "Konsepte",
  AppConstants.draft: "Konsep",
  AppConstants.draftSaved: "In Konsepte gestoor",
  AppConstants.unsavedChanges: "Ongestoorde Veranderinge",
  AppConstants.unsavedChangesMessage:
      "Jy het ongestoorde veranderinge. Wil jy dit as 'n konsep stoor of weggooi?",
  AppConstants.saveAsDraft: "Stoor as Konsep",
  AppConstants.discardChanges: "Gooi Weg",
  AppConstants.autoDeleteDrafts: "Skrap Konsepte Outomaties",
  AppConstants.days7: "7 Dae",
  AppConstants.never: "Nooit",
  AppConstants.custom: "Pasgemaak...",
  AppConstants.enterCustomDays: "Voer Pasgemaakte Dae In",
  AppConstants.customDaysExample: "Bv. 14",
  AppConstants.days: "Dae",
  AppConstants.draftsNeverDeleted: "Konsepte sal nooit geskrap word nie",
  AppConstants.draftsDeletedAfterDays: "Konsepte sal na %d dae geskrap word",

  // Home Menu & Sorting
  AppConstants.sortBy: "Sorteer volgens",
  AppConstants.insights: "Insigte",
  AppConstants.reflections: "Refleksies",
  AppConstants.settings: "Instellings",
  AppConstants.entryTime: "Inskrywingstyd",
  AppConstants.bookmarkFirst: "Boekmerke eerste",
  AppConstants.reflectionFirst: "Refleksies eerste",
  AppConstants.withMediaFirst: "Met media eerste",
  AppConstants.textOnlyFirst: "Slegs teks eerste",
  AppConstants.withLocationFirst: "Met ligging eerste",
  AppConstants.withMoodFirst: "Met gemoed eerste",
  AppConstants.withTagsFirst: "Met etikette eerste",

  // Insights
  AppConstants.stats: "Statistiek",
  AppConstants.calendar: "Kalender",
  AppConstants.entriesSuffix: " inskrywings",
  AppConstants.memoriesFromThisDay: "Herinneringe van hierdie dag",
  AppConstants.standard: "Standaard",
  AppConstants.media: "Media",
  AppConstants.mood: "Gemoed",
  AppConstants.mostly: "Meestal",
  AppConstants.averageForThisDay: "Gemiddeld vir hierdie dag",
  AppConstants.averageForThisYear: "Gemiddeld vir hierdie jaar",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Welkom by OpenJot",
  AppConstants.feature1:
      "Skryf vrylik, voeg foto's en liggings by, en hou alles veilig op jou toestel.",
  AppConstants.feature2:
      "Verstaan jou emosies oor tyd met geïntegreerde gemoedsopsporing.",
  AppConstants.feature3:
      "Jou data bly op jou foon – geen wolk nie, net plaaslike berging en volledige privaatheid.",
  AppConstants.continueButton: "Gaan Voort",

  // Notifications
  AppConstants.notificationTitle: "Tyd om te Joernaal!",
  AppConstants.notificationBody:
      "Moenie vergeet om jou gedagtes vir die dag neer te skryf nie.",
  AppConstants.notificationChannelName: "Daaglikse Joernaalherinneringe",
  AppConstants.notificationChannelDescription:
      "Kanaal vir daaglikse joernaalherinneringkennisgewings",
  AppConstants.onThisDayChannelName: "Op Hierdie Dag Herinneringe",
  AppConstants.onThisDayChannelDescription:
      "Kennisgewings vir herinneringe uit vorige jare.",
  AppConstants.onThisDayNotificationTitle: "'n Herinnering uit jou joernaal",
  AppConstants.onThisDaySingleEntry:
      "'n Jaar gelede vandag het jy iets spesiaals geskryf. Tik om jou gedagtes weer te besoek.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Op hierdie dag verlede jaar het jy hierdie herinnering gedeel. Tik om dit weer te beleef.",
  AppConstants.onThisDayMultipleEntries:
      "Jy het herinneringe van hierdie dag uit vorige jare. Tik om dit te herbesoek.",
  AppConstants.onThisDayGroupedNotification:
      "Jy het %d herinneringe van hierdie dag",

  // Exclude Entries
  AppConstants.excludeEntries: "Sluit Inskrywings Uit",
  AppConstants.saveExclusions: "Stoor Uitsluitings",
  AppConstants.excludeUnsavedChangesMessage:
      "Jy het ongestoorde veranderinge. Is jy seker jy wil dit weggooi en uitgaan?",
  AppConstants.sortDefault: "Verstek",
  AppConstants.sortMutedFirst: "Gedemp eerste",
  AppConstants.sortUnmutedFirst: "Ongedemp eerste",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Vandag",
  AppConstants.yesterday: "Gister",
  AppConstants.contentForQuote: "Inhoud vir Aanhaling",
  AppConstants.noContentSelected: "Geen inhoud gekies nie.",
  AppConstants.photos: "Foto's",
  AppConstants.video: "Video",
  AppConstants.audio: "Oudio",
  AppConstants.add: "Voeg By",
  AppConstants.noMediaFound: "Geen %s gevind nie.",
  AppConstants.permissionRequired:
      "Toestemming tot %s word vereis om dit te vertoon.",
  AppConstants.openSettings: "Maak Instellings Oop",
  AppConstants.videos: "Video's",
  AppConstants.audios: "Oudio's",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Skrap Opname?",
  AppConstants.deleteRecordingMessage:
      "Is jy seker jy wil hierdie opname skrap?",
  AppConstants.listen: "Luister",
  AppConstants.tapAndHold: "tik en hou",
  AppConstants.clear: "Maak Skoon",
  AppConstants.all: "Alles",
  AppConstants.folder: "Gids",
  AppConstants.browse: "Blaai",
  AppConstants.tiles: "Teëls",
  AppConstants.graph: "Grafiek",
  AppConstants.recording: "Neem op...",
  AppConstants.recordingLabel: "Opname",
  AppConstants.startAudioRecording: "Begin Oudio-opname",
  AppConstants.howAreYouFeeling: "Hoe voel jy?",
  AppConstants.paused: "Onderbreek",
  AppConstants.stop: "Stop",
  AppConstants.tapOrHoldToResume: "Tik of hou om te hervat",
  AppConstants.tapOrReleaseToPause: "Tik of los om te onderbreek",
  AppConstants.unsupportedImageType: "Onondersteunde Beeldtipe",
  AppConstants.couldNotLoadVideo: "Kon nie video laai nie",
  AppConstants.couldNotOpenMap: "Kon nie kaartskakel oopmaak nie.",
  AppConstants.dismiss: "Maak Toe",
  AppConstants.selectTime: "Kies Tyd",
  AppConstants.now: "Nou",
  AppConstants.searchPlacesHint: "Soek plekke, winkels...",
  AppConstants.locationPermissionDenied: "Liggingtoestemming geweier.",
  AppConstants.failedGetCurrentLocation: "Kon nie huidige ligging kry nie.",

  // Search
  AppConstants.searchJournalsHint: "Soek joernale...",
  AppConstants.textOnly: "Slegs Teks",
  AppConstants.withMedia: "Met Media",
  AppConstants.withMood: "Met Gemoed",
  AppConstants.withLocation: "Met Ligging",
  AppConstants.withTags: "Met Etikette",
  AppConstants.noResultsFound: "Geen resultate gevind nie",
  AppConstants.searchHintText: "Soek inskrywings...",

  // Settings
  AppConstants.language: "Taal",
  AppConstants.selectLanguage: "Kies Taal",
  AppConstants.systemDefault: "Stelselverstek",
  AppConstants.searchLanguagesHint: "Soek tale...",
  AppConstants.languageChanged: "Taal verander na %s.",
  AppConstants.dailyReminder: "Herinneringe",
  AppConstants.addReminder: "Voeg Herinnering By",
  AppConstants.deleteReminder: "Skrap Herinnering",
  AppConstants.noRemindersSet: "Geen herinneringe gestel nie.",
  AppConstants.onThisDay: "Op Hierdie Dag",
  AppConstants.appLock: "Toep-slot",
  AppConstants.backup: "Rugsteun",
  AppConstants.restore: "Herstel",
  AppConstants.importFromAnotherApp: "Voer in vanaf 'n ander toep",
  AppConstants.importFromDailyYou: "Voer in vanaf Daily You",
  AppConstants.selectDailyYouBackup:
      "Kies Daily You rugsteun-zip-lêer",
  AppConstants.importingEntries: "Voer inskrywings in...",
  AppConstants.importSuccess:
      "%d inskrywings suksesvol vanaf Daily You ingevoer!",
  AppConstants.importFailed: "Invoer het misluk: %s",
  AppConstants.noEntriesToImport:
      "Geen nuwe inskrywings gevind om in te voer nie.",
  AppConstants.askSupport: "Vra Ondersteuning",
  AppConstants.importSupportNote:
      "Ander toep-formate ondersteun moontlik nie alle kenmerke nie. As jy probleme ondervind of formate verander, dien asseblief 'n probleemverslag in.",
  AppConstants.extractingBackup: "Pak rugsteun uit...",
  AppConstants.parsingDatabase: "Ontleed databasis...",
  AppConstants.dailyYouDbNotFound:
      "Daily You-databasis nie in rugsteun gevind nie.",
  AppConstants.privacyPolicy: "Privaatheidsbeleid",
  AppConstants.termsNConditions: "Bepalings & Voorwaardes",
  AppConstants.about: "Oor Toep",
  AppConstants.changeTheme: "Verander tema",
  AppConstants.theme: "Tema",
  AppConstants.pitchBlack: "Pikswart",
  AppConstants.themeLight: "Lig",
  AppConstants.themeDark: "Donker",
  AppConstants.themeSystem: "Stelsel",
  AppConstants.changePin: "Verander PIN",
  AppConstants.loading: "Laai...",
  AppConstants.confirmRestoreTitle: "Bevestig Herstel",
  AppConstants.confirmRestoreMessage:
      "Herstel vanaf 'n rugsteun sal alle huidige data oorskryf. Hierdie aksie kan nie ongedaan gemaak word nie. Is jy seker jy wil voortgaan?",
  AppConstants.notificationScheduled: "Kennisgewing geskeduleer vir %s",
  AppConstants.notificationCanceled: "Kennisgewing gekanselleer",
  AppConstants.notificationRescheduled: "Kennisgewing herskeduleer vir %s",
  AppConstants.notificationPermissionRequired:
      "Kennisgewingtoestemming word vereis om herinneringe te stel.",
  AppConstants.pinChangedSuccess: "PIN suksesvol verander",
  AppConstants.onThisDayOn: "Jy sal nou herinneringe van hierdie dag kry.",
  AppConstants.onThisDayOff: "'Op Hierdie Dag'-herinneringe is afgeskakel.",
  AppConstants.themeChanged: "%s tema gekies.",
  AppConstants.hideStats: "Versteek Statistiek",
  AppConstants.hideHomeStats: "Versteek Tuisstatistiek",
  AppConstants.hideInsightsStats: "Versteek Insigte-statistiek",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLEKSIE",
  AppConstants.reflectButton: "Reflekteer",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Verkeerde PIN",
  AppConstants.verifyYourPin: "Verifieer jou PIN",
  AppConstants.setAPin: "Stel 'n PIN",
  AppConstants.confirmPin: "Bevestig PIN",
  AppConstants.pinsDoNotMatch: "PIN's stem nie ooreen nie",
  AppConstants.setPin: "Stel PIN",
  AppConstants.hello: "Hallo!",
  AppConstants.enterYourPin: "Voer jou PIN in",
  AppConstants.useBiometrics: "Gebruik Biometrie",
  AppConstants.authenticateToUnlock:
      "Verifieer asseblief om die toep te ontsluit",
  AppConstants.databaseEncryption: "Databasis-enkripsie",
  AppConstants.databaseEncryptionDesc: "AES-256-GCM plaaslike enkripsie",
  AppConstants.changeMasterPassword: "Verander Meesterwagwoord",
  AppConstants.biometricUnlock: "Biometriese Ontsluiting",
  AppConstants.enterMasterPassword: "Voer Meesterwagwoord In",
  AppConstants.enterMasterPasswordHint:
      "Voer jou meesterwagwoord in om jou joernaal te dekripteer.",
  AppConstants.unlockButton: "Ontsluit",
  AppConstants.unlockWithBiometrics: "Ontsluit met Biometrie",
  AppConstants.incorrectMasterPassword:
      "Verkeerde meesterwagwoord. Probeer asseblief weer.",
  AppConstants.databaseEncryptedSuccess:
      "Joernaaldatabasis is met AES-256-GCM geënkripteer.",
  AppConstants.databaseDecryptedSuccess:
      "Joernaaldatabasis is gedekripteer en toep-slot is afgeskakel.",
  AppConstants.masterPasswordChangedSuccess:
      "Meesterwagwoord suksesvol opgedateer.",
  AppConstants.encryptedBackupPasswordRequired:
      "'n Wagwoord word vereis om 'n geënkripteerde rugsteun oop te maak.",
  AppConstants.incorrectBackupPassword: "Verkeerde rugsteunwagwoord.",
  AppConstants.invalidBackupFile:
      "Gekose lêer is nie 'n geldige OpenJot-rugsteun nie.",
  AppConstants.encryptedBackup: "Geënkripteerde Rugsteun (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Beskerm met AES-256-GCM en 'n rugsteunwagwoord",
  AppConstants.standardBackup: "Standaard Rugsteun (.zip)",
  AppConstants.standardBackupDesc:
      "Ongeënkripteerde argief versoenbaar met alle weergawes",
  AppConstants.takingBackup: "Neem rugsteun...",
  AppConstants.encryptingBackup: "Enkripteer rugsteun...",
  AppConstants.savingBackup: "Stoor rugsteun...",
  AppConstants.preparingBackup: "Berei rugsteun voor...",
  AppConstants.decryptingBackup: "Dekripteer rugsteun...",
  AppConstants.restoringBackup: "Herstel rugsteun...",
  AppConstants.backupEncodingFailed: "Kon nie die rugsteunlêer enkodeer nie.",
  AppConstants.backupCreatedSuccess: "Rugsteun suksesvol geskep!",
  AppConstants.backupFailed: "Kon nie rugsteun skep nie: %s",
  AppConstants.restorePermissionsRequired:
      "Berging- en mediatoestemmings word vereis om data te herstel.",
  AppConstants.databaseRestoredNoMedia:
      "Databasis herstel. Geen media in rugsteun gevind nie.",
  AppConstants.restoreSuccess: "Herstel suksesvol!",
  AppConstants.restoreSuccessRestartRecommended:
      "Herstel suksesvol. 'n Herbegin word aanbeveel om alle veranderinge toe te pas.",
  AppConstants.restoreFailed: "Kon nie data herstel nie: %s",
  AppConstants.storagePermissionsRequired:
      "Berging- en mediatoestemmings word vereis om 'n rugsteun te skep.",
  AppConstants.selectBackupFolder: "Kies 'n gids om die rugsteun te stoor",
  AppConstants.encryptDatabase: "Enkripteer Databasis",
  AppConstants.disableEncryption: "Deaktiveer Enkripsie",
  AppConstants.backupPasswordTitle: "Rugsteunwagwoord",
  AppConstants.changeMasterPasswordDesc:
      "Voer jou huidige meesterwagwoord in en kies 'n nuwe wagwoord (minimum 6 karakters).",
  AppConstants.disableEncryptionDesc:
      "Voer jou meesterwagwoord in om jou databasis op skyf te dekripteer en enkripsie af te skakel.",
  AppConstants.enableEncryptionDesc:
      "Beskerm alle joernaalnotas plaaslik met AES-256-GCM-enkripsie. As jy jou meesterwagwoord vergeet, kan jou geënkripteerde data nie herstel word nie.",
  AppConstants.verifyForBiometricsDesc:
      "Voer jou meesterwagwoord een keer in om 'n ontsluitsleutel in veilige hardewareberging te stoor vir vinnige biometriese ontsluiting.",
  AppConstants.createBackupPasswordDesc:
      "Stel 'n sterk wagwoord op om hierdie .openjot-rugsteun te enkripteer. Jy sal hierdie wagwoord nodig hê om dit op enige toestel te herstel.",
  AppConstants.enterBackupPasswordDesc:
      "Voer die wagwoord in wat gebruik is toe hierdie .openjot-rugsteun geskep is.",
  AppConstants.updatePasswordAction: "Dateer Wagwoord Op",
  AppConstants.decryptAndDisable: "Dekripteer & Deaktiveer",
  AppConstants.enableBiometricsAction: "Aktiveer Biometrie",
  AppConstants.createBackupAction: "Skep Rugsteun",
  AppConstants.decryptBackupAction: "Dekripteer Rugsteun",
  AppConstants.newMasterPasswordHint: "Nuwe meesterwagwoord",
  AppConstants.backupPasswordHint: "Rugsteunwagwoord",
  AppConstants.masterPasswordHint: "Meesterwagwoord",
  AppConstants.enterCurrentMasterPasswordError:
      "Voer asseblief jou huidige meesterwagwoord in.",
  AppConstants.passwordEmptyError: "Wagwoord kan nie leeg wees nie.",
  AppConstants.passwordMinLengthError:
      "Wagwoord moet minstens 6 karakters lank wees.",
  AppConstants.passwordsDoNotMatchError: "Wagwoorde stem nie ooreen nie.",
  AppConstants.currentMasterPasswordHint: "Huidige meesterwagwoord",
  AppConstants.confirmPasswordHint: "Bevestig wagwoord",

  // About & Terms
  AppConstants.aboutApp: "Oor OpenJot",
  AppConstants.versionPrefix: "Weergawe: %s",
  AppConstants.aboutSubtitle:
      "'n Minimalistiese, oopbron-joernaal om jou gedagtes, gemoedstoestande en herinneringe aan te teken. Al jou data bly op jou toestel.",
  AppConstants.keyFeatures: "Belangrikste Kenmerke",
  AppConstants.aboutFeature1: "• Skoon, afleidingsvrye skryfervaring.",
  AppConstants.aboutFeature2:
      "• Voeg foto's, stemnotas en musiek by jou inskrywings.",
  AppConstants.aboutFeature3: "• Teken jou gemoed saam met jou joernale aan.",
  AppConstants.aboutFeature4: "• Verpersoonlik met verskillende teksstyle.",
  AppConstants.aboutFeature5:
      "• Werk heeltemal vanlyn, jou data bly op jou toestel.",
  AppConstants.openSource: "Oopbron",
  AppConstants.openSourceDesc:
      "OpenJot is 'n oopbrontoepassing. Die bronkode is publiek beskikbaar vir enigiemand om te inspekteer, te wysig en by te dra. Ons glo in deursigtigheid en gemeenskapsamewerking.",
  AppConstants.dataPrivacy: "Dataprivaatheid",
  AppConstants.dataPrivacyDesc:
      "Ons waardeer jou privaatheid. OpenJot versamel, stoor of stuur geen van jou persoonlike data nie. Al jou joernaalinskrywings, insluitend teks, beelde en oudiolêers, word uitsluitlik op jou toestel gestoor.",
  AppConstants.linksTitle: "Skakels",
  AppConstants.sourceCodeOnGithub: "Bronkode op GitHub",
  AppConstants.sendFeedback: "Stuur Terugvoer",
  AppConstants.couldNotLaunchUrl: "Kon nie URL oopmaak nie",
  AppConstants.termsIntro:
      "Welkom by OpenJot! Hierdie dokument sit die bepalings en voorwaardes vir die gebruik van ons toepassing uiteen. Deur OpenJot te gebruik, stem jy in tot hierdie bepalings.",
  AppConstants.termsSectionDataPrivacy: "Databerging en Privaatheid",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot is ontwerp as 'n privaat ruimte vir jou gedagtes. Alle joernaalinskrywings, insluitend teks, beelde, oudiolêers en ander media, word uitsluitlik plaaslik op jou toestel gestoor. Die toepassing versamel, stoor of stuur geen persoonlike data na eksterne bedieners nie. Ons het geen toegang tot jou inhoud nie.",
  AppConstants.termsSectionUserContent: "Gebruikergegenereerde Inhoud",
  AppConstants.termsSectionUserContentBody:
      "Jy is alleen verantwoordelik vir die inhoud wat jy binne OpenJot skep en stoor, insluitend enige teks, beelde, oudio-opnames en ander lêers. Dit is jou verantwoordelikheid om te verseker dat jy die nodige regte het om enige inhoud wat jy in die toep invoer te gebruik.",
  AppConstants.termsSectionDisclaimer: "Vrywaring van Waarborg",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot word voorsien \"soos dit is\" sonder enige waarborge, uitdruklik of geïmpliseer. Ons waarborg nie dat die toep foutvry of ononderbroke sal wees nie. Jy gebruik die toepassing op eie risiko.",
  AppConstants.termsSectionLiability: "Beperking van Aanspreeklikheid",
  AppConstants.termsSectionLiabilityBody:
      "In geen geval sal die ontwikkelaars van OpenJot aanspreeklik wees vir enige direkte, indirekte, toevallige, spesiale of gevolglike skade, insluitend verlies van data, wat voortspruit uit die gebruik of onvermoë om hierdie toepassing te gebruik nie.",
  AppConstants.termsSectionThirdParty: "Derdeparty-biblioteke",
  AppConstants.termsSectionThirdPartyBody:
      "Hierdie toepassing gebruik die volgende derdeparty-biblioteke, elk onderhewig aan sy eie lisensie:",

  // Months
  'January': 'Januarie',
  'February': 'Februarie',
  'March': 'Maart',
  'April': 'April',
  'May': 'Mei',
  'June': 'Junie',
  'July': 'Julie',
  'August': 'Augustus',
  'September': 'September',
  'October': 'Oktober',
  'November': 'November',
  'December': 'Desember',

  // Reflection Prompts (62)
  "What made you smile today?": "Wat het jou vandag laat glimlag?",
  "Who are you thankful for this week, and why?":
      "Vir wie is jy hierdie week dankbaar, en hoekom?",
  "What is something small that brought you joy today?":
      "Wat is iets kleins wat jou vandag vreugde gebring het?",
  "Which part of your day felt most comforting?":
      "Watter deel van jou dag het die gemaklikste gevoel?",
  "What’s something you often take for granted but appreciate now?":
      "Wat is iets wat jy dikwels as vanselfsprekend aanvaar maar nou waardeer?",
  "What’s the best thing that happened today?":
      "Wat is die beste ding wat vandag gebeur het?",
  "Did someone make your day easier today?":
      "Het iemand vandag jou dag makliker gemaak?",
  "Who made a positive impact on you recently?":
      "Wie het onlangs 'n positiewe impak op jou gemaak?",
  "What’s a quality you admire in someone close to you?":
      "Watter eienskap bewonder jy in iemand na aan jou?",
  "When did you last feel truly connected with someone?":
      "Wanneer laas het jy werklik met iemand verbind gevoel?",
  "Who do you want to reach out to soon?":
      "Na wie wil jy binnekort uitreik?",
  "Did someone’s kindness stand out today?":
      "Het iemand se vriendelikheid vandag uitgestaan?",
  "How did you support someone else recently?":
      "Hoe het jy onlangs iemand anders ondersteun?",
  "Who do you miss the most right now?":
      "Wie mis jy op die oomblik die meeste?",
  "What’s a moment from today you want to remember?":
      "Watter oomblik van vandag wil jy onthou?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Watter detail van vandag kan jy vergeet as jy dit nie neerskryf nie?",
  "What’s the most peaceful moment you had today?":
      "Wat was die rustigste oomblik wat jy vandag gehad het?",
  "Did you see something beautiful today?": "Het jy vandag iets moois gesien?",
  "Which memory from this week stands out?":
      "Watter herinnering van hierdie week staan uit?",
  "What song, photo, or place will always remind you of today?":
      "Watter liedjie, foto of plek sal jou altyd aan vandag herinner?",
  "What surprised you today?": "Wat het jou vandag verras?",
  "What challenge did you overcome today?":
      "Watter uitdaging het jy vandag oorkom?",
  "What’s a small win you had today?":
      "Watter klein oorwinning het jy vandag behaal?",
  "What new thing did you learn about yourself recently?":
      "Watter nuwe ding het jy onlangs oor jouself geleer?",
  "What are you proud of yourself for?":
      "Waaroor is jy trots op jouself?",
  "What habit do you feel good about keeping?":
      "Oor watter gewoonte voel jy goed om vol te hou?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Wat is een verbetering wat jy vanjaar in jouself opgemerk het?",
  "How did you push yourself out of your comfort zone?":
      "Hoe het jy jouself uit jou gemaksone gedruk?",
  "How are you truly feeling right now?":
      "Hoe voel jy werklik op die oomblik?",
  "Which emotion stood out the most today?":
      "Watter emosie het vandag die meeste uitgestaan?",
  "Did you feel present in any moment today?":
      "Het jy vandag in enige oomblik ten volle teenwoordig gevoel?",
  "When did you feel the most at peace today?":
      "Wanneer het jy vandag die rustigste gevoel?",
  "What gave you energy today?": "Wat het jou vandag energie gegee?",
  "What drained your energy today?": "Wat het jou vandag van energie getap?",
  "If your mood had a color today, what would it be?":
      "As jou gemoed vandag 'n kleur gehad het, wat sou dit wees?",
  "What’s something you’re excited about tomorrow?":
      "Waaroor is jy opgewonde vir môre?",
  "What’s one thing you want to improve tomorrow?":
      "Wat is een ding wat jy môre wil verbeter?",
  "What would make tomorrow feel successful?":
      "Wat sou môre suksesvol laat voel?",
  "What do you hope to achieve this week?":
      "Wat hoop jy om hierdie week te bereik?",
  "What’s a habit you’d like to start tomorrow?":
      "Watter gewoonte wil jy graag môre begin?",
  "What’s something you want to look forward to in the next month?":
      "Na wat wil jy in die volgende maand uitsien?",
  "What would your ideal tomorrow look like?":
      "Hoe sou jou ideale môre lyk?",
  "What’s one lesson you learned recently?":
      "Wat is een les wat jy onlangs geleer het?",
  "If you could freeze one moment today, which would it be?":
      "As jy een oomblik vandag kon vries, watter een sou dit wees?",
  "What makes your life feel meaningful right now?":
      "Wat laat jou lewe op die oomblik betekenisvol voel?",
  "If you described today in one word, what would it be?":
      "As jy vandag in een woord moes beskryf, wat sou dit wees?",
  "What inspired you today?": "Wat het jou vandag geïnspireer?",
  "What did you notice today that you usually overlook?":
      "Wat het jy vandag opgemerk wat jy gewoonlik miskyk?",
  "How has today changed your perspective?":
      "Hoe het vandag jou perspektief verander?",
  "What’s something you’ve been overthinking?":
      "Waaroor het jy die laaste tyd te veel gedink?",
  "What do you need to let go of?": "Waarvan moet jy laat gaan?",
  "What part of nature did you notice today?":
      "Watter deel van die natuur het jy vandag opgemerk?",
  "Did the weather affect your mood today?":
      "Het die weer vandag jou gemoed beïnvloed?",
  "What place felt most comforting today?":
      "Watter plek het vandag die gemaklikste gevoel?",
  "Where did you feel most at home today?":
      "Waar het jy vandag die meeste tuis gevoel?",
  "What sound or smell reminded you of something important?":
      "Watter klank of reuk het jou aan iets belangriks herinner?",
  "How did you take care of yourself today?":
      "Hoe het jy vandag vir jouself gesorg?",
  "When did you feel most like yourself today?":
      "Wanneer het jy vandag die meeste soos jouself gevoel?",
  "What’s something kind you can say to yourself right now?":
      "Wat is iets vriendeliks wat jy nou vir jouself kan sê?",
  "What do you want to forgive yourself for?":
      "Waarvoor wil jy jouself vergewe?",
  "What do you deserve more of in your life?":
      "Waarvan verdien jy meer in jou lewe?",
};
