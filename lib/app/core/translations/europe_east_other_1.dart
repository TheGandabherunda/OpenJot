import '../constants.dart';

/// Complete Russian (Русский) translations for OpenJot.
final Map<String, String> ruTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Мой дневник",
  AppConstants.noEntriesMessage: "Записей в дневнике пока нет. Начните писать!",
  AppConstants.noBookmarksYet: "Закладок пока нет.",
  AppConstants.noDraftsYet: "Черновиков пока нет.",
  AppConstants.addEntryButton: "Новая запись",
  AppConstants.jotYourThoughts: "Запишите свои мысли",
  AppConstants.tapToCreateJournal: "Нажмите +, чтобы создать личный дневник.",
  AppConstants.entriesThisYear: "Записей в этом году",
  AppConstants.wordsWritten: "Написано слов",
  AppConstants.daysJournaled: "Дней с записями",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Новая запись в дневнике",
  AppConstants.editEntryAppBarTitle: "Редактировать запись",
  AppConstants.titleHintText: "Заголовок (напр., 'Мой день', 'Мысли о...')",
  AppConstants.contentHintText: "Запишите свои мысли здесь...",
  AppConstants.saveButton: "Сохранить запись",
  AppConstants.updateButton: "Обновить",
  AppConstants.deleteButton: "Удалить запись",
  AppConstants.requiredFieldMessage: "Это поле не может быть пустым.",
  AppConstants.newEntry: "Новая запись",
  AppConstants.todayDate: "Сегодняшняя дата",
  AppConstants.customDate: "Другая дата",
  AppConstants.done: "Готово",
  AppConstants.startWriting: " Начните писать...",
  AppConstants.tags: "Теги",
  AppConstants.addTags: "Добавить теги",
  AppConstants.openInMaps: "Открыть на карте",
  AppConstants.changeLocation: "Изменить местоположение",
  AppConstants.remove: "Удалить",
  AppConstants.discardSelectionsTitle: "Отменить выбор?",
  AppConstants.discardSelectionsMessage:
      "Вы выбрали медиафайлы или активную запись звука. Вы уверены, что хотите их сбросить?",
  AppConstants.journalEntryEmpty: "Запись в дневнике не может быть пустой",
  AppConstants.discardDateConfirm:
      "Сбросить выбранную дату/время для этой записи?",
  AppConstants.addMediaLocationMoodFirst:
      "Сначала добавьте медиа, местоположение или настроение",
  AppConstants.location: "Место",
  AppConstants.record: "Запись",
  AppConstants.selectMomentsToJournal: "Выберите моменты для дневника",
  AppConstants.addMomentsFromMenu:
      "Добавьте медиа, место, аудиозапись или настроение из меню",
  AppConstants.writeSomething: "Написать текст",
  AppConstants.saveWithoutWriting: "Сохранить без текста",
  AppConstants.oneLocation: "1 место",
  AppConstants.mediaCount: "%d медиа",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Подтвердите удаление",
  AppConstants.confirmDeleteMessage:
      "Вы уверены, что хотите удалить эту запись?",
  AppConstants.pleaseConfirm: "Пожалуйста, подтвердите",
  AppConstants.confirmDeleteJournalEntry:
      "Вы уверены, что хотите удалить эту запись? Это действие необратимо.",
  AppConstants.yes: "Да",
  AppConstants.no: "Нет",
  AppConstants.cancel: "Отмена",
  AppConstants.delete: "Удалить",
  AppConstants.save: "Сохранить",
  AppConstants.entrySavedSuccess: "Запись успешно сохранена!",
  AppConstants.entryUpdatedSuccess: "Запись успешно обновлена!",
  AppConstants.entryDeletedSuccess: "Запись удалена.",
  AppConstants.errorSavingEntry: "Ошибка при сохранении записи.",
  AppConstants.errorDeletingEntry: "Ошибка при удалении записи.",
  AppConstants.errorLoadingEntries: "Ошибка загрузки записей дневника.",
  AppConstants.noEntriesForDate: "Нет записей за эту дату.",
  AppConstants.noEntriesForMonth: "За этот месяц записей не найдено.",
  AppConstants.selectMonthAndYear: "Выберите месяц и год",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Очень неприятно",
  AppConstants.unpleasant: "Неприятно",
  AppConstants.slightlyUnpleasant: "Слегка неприятно",
  AppConstants.neutral: "Нейтрально",
  AppConstants.slightlyPleasant: "Слегка приятно",
  AppConstants.pleasant: "Приятно",
  AppConstants.veryPleasant: "Очень приятно",
  AppConstants.reflection: "Размышление",
  AppConstants.edit: "Изменить",
  AppConstants.removeBookmark: "Удалить из закладок",
  AppConstants.bookmark: "В закладки",
  AppConstants.share: "Поделиться",
  AppConstants.saveAsPdf: "Сохранить как PDF",
  AppConstants.audioTrack: "Аудиодорожка",
  AppConstants.generatingPdf: "Создание PDF...",
  AppConstants.voiceRecording: "Голосовая запись",
  AppConstants.audioRecording: "Аудиозапись",
  AppConstants.couldNotLoadAudio: "Не удалось загрузить аудиофайл.",
  AppConstants.stateOfMind: "Состояние души",

  // Mood Colors
  AppConstants.moodColors: "Цвета настроения",
  AppConstants.customizeMoodColors: "Настроить цвета настроения",
  AppConstants.reset: "Сбросить",
  AppConstants.resetMoodColors: "Сбросить по умолчанию",
  AppConstants.resetMoodColorsConfirm:
      "Сбросить все цвета настроения к значениям по умолчанию?",
  AppConstants.paletteThemes: "Темы палитры",
  AppConstants.customColor: "Свой цвет",
  AppConstants.moodUnsavedChangesMessage:
      "У вас есть несохраненные изменения цветов настроения. Сохранить их перед закрытием?",

  // Drafts & Auto-save
  AppConstants.drafts: "Черновики",
  AppConstants.draft: "Черновик",
  AppConstants.draftSaved: "Сохранено в черновики",
  AppConstants.unsavedChanges: "Несохраненные изменения",
  AppConstants.unsavedChangesMessage:
      "У вас есть несохраненные изменения. Сохранить их как черновик или отменить?",
  AppConstants.saveAsDraft: "Сохранить в черновики",
  AppConstants.discardChanges: "Отменить",
  AppConstants.autoDeleteDrafts: "Автоудаление черновиков",
  AppConstants.days7: "7 дней",
  AppConstants.never: "Никогда",
  AppConstants.custom: "Свой срок...",
  AppConstants.enterCustomDays: "Введите количество дней",
  AppConstants.customDaysExample: "Напр., 14",
  AppConstants.days: "дней",
  AppConstants.draftsNeverDeleted: "Черновики никогда не будут удалены",
  AppConstants.draftsDeletedAfterDays:
      "Черновики будут удалены через %d дн.",

  // Home Menu & Sorting
  AppConstants.sortBy: "Сортировка",
  AppConstants.insights: "Статистика",
  AppConstants.reflections: "Размышления",
  AppConstants.settings: "Настройки",
  AppConstants.entryTime: "Время записи",
  AppConstants.bookmarkFirst: "Сначала закладки",
  AppConstants.reflectionFirst: "Сначала размышления",
  AppConstants.withMediaFirst: "Сначала с медиа",
  AppConstants.textOnlyFirst: "Сначала только текст",
  AppConstants.withLocationFirst: "Сначала с местом",
  AppConstants.withMoodFirst: "Сначала с настроением",
  AppConstants.withTagsFirst: "Сначала с тегами",

  // Insights
  AppConstants.stats: "Статистика",
  AppConstants.calendar: "Календарь",
  AppConstants.entriesSuffix: " зап.",
  AppConstants.memoriesFromThisDay: "Воспоминания этого дня",
  AppConstants.standard: "Обычный",
  AppConstants.media: "Медиа",
  AppConstants.mood: "Настроение",
  AppConstants.mostly: "В основном",
  AppConstants.averageForThisDay: "Среднее за этот день",
  AppConstants.averageForThisYear: "Среднее за этот год",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Добро пожаловать в OpenJot",
  AppConstants.feature1:
      "Пишите свободно, добавляйте фото и места и храните всё в безопасности на вашем устройстве.",
  AppConstants.feature2:
      "Понимайте свои эмоции со временем с помощью встроенного отслеживания настроения.",
  AppConstants.feature3:
      "Ваши данные остаются на телефоне — никакого облака, только локальное хранение и полная приватность.",
  AppConstants.continueButton: "Продолжить",

  // Notifications
  AppConstants.notificationTitle: "Время вести дневник!",
  AppConstants.notificationBody: "Не забудьте записать свои мысли за день.",
  AppConstants.notificationChannelName: "Ежедневные напоминания",
  AppConstants.notificationChannelDescription:
      "Канал для ежедневных напоминаний о дневнике",
  AppConstants.onThisDayChannelName: "Воспоминания «В этот день»",
  AppConstants.onThisDayChannelDescription:
      "Уведомления о воспоминаниях прошлых лет.",
  AppConstants.onThisDayNotificationTitle: "Воспоминание из вашего дневника",
  AppConstants.onThisDaySingleEntry:
      "Ровно год назад вы написали нечто особенное. Нажмите, чтобы перечитать свои мысли.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "В этот день год назад вы сохранили это воспоминание. Нажмите, чтобы пережить его снова.",
  AppConstants.onThisDayMultipleEntries:
      "У вас есть воспоминания за этот день из прошлых лет. Нажмите, чтобы посмотреть их.",
  AppConstants.onThisDayGroupedNotification:
      "У вас %d воспоминаний за этот день",

  // Exclude Entries
  AppConstants.excludeEntries: "Исключить записи",
  AppConstants.saveExclusions: "Сохранить исключения",
  AppConstants.excludeUnsavedChangesMessage:
      "У вас есть несохраненные изменения. Вы уверены, что хотите выйти без сохранения?",
  AppConstants.sortDefault: "По умолчанию",
  AppConstants.sortMutedFirst: "Сначала скрытые",
  AppConstants.sortUnmutedFirst: "Сначала активные",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Сегодня",
  AppConstants.yesterday: "Вчера",
  AppConstants.contentForQuote: "Текст для цитаты",
  AppConstants.noContentSelected: "Ничего не выбрано.",
  AppConstants.photos: "Фото",
  AppConstants.video: "Видео",
  AppConstants.audio: "Аудио",
  AppConstants.add: "Добавить",
  AppConstants.noMediaFound: "%s не найдены.",
  AppConstants.permissionRequired:
      "Для отображения требуется разрешение на доступ к: %s.",
  AppConstants.openSettings: "Открыть настройки",
  AppConstants.videos: "Видео",
  AppConstants.audios: "Аудио",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Удалить запись?",
  AppConstants.deleteRecordingMessage:
      "Вы уверены, что хотите удалить эту запись?",
  AppConstants.listen: "Слушать",
  AppConstants.tapAndHold: "нажмите и удерживайте",
  AppConstants.clear: "Очистить",
  AppConstants.all: "Все",
  AppConstants.folder: "Папка",
  AppConstants.browse: "Обзор",
  AppConstants.tiles: "Плитки",
  AppConstants.graph: "График",
  AppConstants.recording: "Идёт запись...",
  AppConstants.recordingLabel: "Запись",
  AppConstants.startAudioRecording: "Начать аудиозапись",
  AppConstants.howAreYouFeeling: "Как вы себя чувствуете?",
  AppConstants.paused: "Пауза",
  AppConstants.stop: "Стоп",
  AppConstants.tapOrHoldToResume: "Нажмите или удерживайте для продолжения",
  AppConstants.tapOrReleaseToPause: "Нажмите или отпустите для паузы",
  AppConstants.unsupportedImageType: "Неподдерживаемый формат изображения",
  AppConstants.couldNotLoadVideo: "Не удалось загрузить видео",
  AppConstants.couldNotOpenMap: "Не удалось открыть ссылку на карту.",
  AppConstants.dismiss: "Закрыть",
  AppConstants.selectTime: "Выберите время",
  AppConstants.now: "Сейчас",
  AppConstants.searchPlacesHint: "Поиск мест, заведений...",
  AppConstants.locationPermissionDenied:
      "Доступ к местоположению запрещён.",
  AppConstants.failedGetCurrentLocation:
      "Не удалось определить текущее местоположение.",

  // Search
  AppConstants.searchJournalsHint: "Поиск по дневнику...",
  AppConstants.textOnly: "Только текст",
  AppConstants.withMedia: "С медиа",
  AppConstants.withMood: "С настроением",
  AppConstants.withLocation: "С местом",
  AppConstants.withTags: "С тегами",
  AppConstants.noResultsFound: "Ничего не найдено",
  AppConstants.searchHintText: "Поиск записей...",

  // Settings
  AppConstants.language: "Язык",
  AppConstants.selectLanguage: "Выберите язык",
  AppConstants.systemDefault: "Как в системе",
  AppConstants.searchLanguagesHint: "Поиск языков...",
  AppConstants.languageChanged: "Язык изменён на %s.",
  AppConstants.dailyReminder: "Напоминания",
  AppConstants.addReminder: "Добавить напоминание",
  AppConstants.deleteReminder: "Удалить напоминание",
  AppConstants.noRemindersSet: "Напоминания не настроены.",
  AppConstants.onThisDay: "В этот день",
  AppConstants.appLock: "Блокировка приложения",
  AppConstants.backup: "Резервная копия",
  AppConstants.restore: "Восстановить",
  AppConstants.importFromAnotherApp: "Импорт из другого приложения",
  AppConstants.importFromDailyYou: "Импорт из Daily You",
  AppConstants.selectDailyYouBackup:
      "Выберите zip-архив резервной копии Daily You",
  AppConstants.importingEntries: "Импорт записей...",
  AppConstants.importSuccess:
      "Успешно импортировано %d записей из Daily You!",
  AppConstants.importFailed: "Ошибка импорта: %s",
  AppConstants.noEntriesToImport: "Новых записей для импорта не найдено.",
  AppConstants.askSupport: "Связаться с поддержкой",
  AppConstants.importSupportNote:
      "Форматы других приложений могут поддерживать не все функции. Если вы столкнётесь с проблемами или формат изменится, создайте отчёт об ошибке.",
  AppConstants.extractingBackup: "Распаковка резервной копии...",
  AppConstants.parsingDatabase: "Чтение базы данных...",
  AppConstants.dailyYouDbNotFound:
      "База данных Daily You не найдена в резервной копии.",
  AppConstants.privacyPolicy: "Политика конфиденциальности",
  AppConstants.termsNConditions: "Условия использования",
  AppConstants.about: "О приложении",
  AppConstants.changeTheme: "Сменить тему",
  AppConstants.theme: "Тема",
  AppConstants.pitchBlack: "Глубокий чёрный",
  AppConstants.themeLight: "Светлая",
  AppConstants.themeDark: "Тёмная",
  AppConstants.themeSystem: "Системная",
  AppConstants.changePin: "Изменить PIN",
  AppConstants.loading: "Загрузка...",
  AppConstants.confirmRestoreTitle: "Подтвердите восстановление",
  AppConstants.confirmRestoreMessage:
      "Восстановление из резервной копии перезапишет все текущие данные. Это действие нельзя отменить. Продолжить?",
  AppConstants.notificationScheduled: "Напоминание запланировано на %s",
  AppConstants.notificationCanceled: "Напоминание отменено",
  AppConstants.notificationRescheduled: "Напоминание перенесено на %s",
  AppConstants.notificationPermissionRequired:
      "Для настройки напоминаний требуется разрешение на уведомления.",
  AppConstants.pinChangedSuccess: "PIN успешно изменён",
  AppConstants.onThisDayOn:
      "Теперь вы будете получать воспоминания за этот день.",
  AppConstants.onThisDayOff: "Напоминания «В этот день» отключены.",
  AppConstants.themeChanged: "Выбрана тема: %s.",
  AppConstants.hideStats: "Скрыть статистику",
  AppConstants.hideHomeStats: "Скрыть статистику на главном экране",
  AppConstants.hideInsightsStats: "Скрыть статистику в разделе «Аналитика»",

  // Reflection Sheet
  AppConstants.reflectionTitle: "РАЗМЫШЛЕНИЕ",
  AppConstants.reflectButton: "Размышлять",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Неверный PIN",
  AppConstants.verifyYourPin: "Подтвердите свой PIN",
  AppConstants.setAPin: "Установить PIN",
  AppConstants.confirmPin: "Подтвердите PIN",
  AppConstants.pinsDoNotMatch: "PIN-коды не совпадают",
  AppConstants.setPin: "Установить PIN",
  AppConstants.hello: "Привет!",
  AppConstants.enterYourPin: "Введите ваш PIN",
  AppConstants.useBiometrics: "Использовать биометрию",
  AppConstants.authenticateToUnlock:
      "Пройдите аутентификацию, чтобы разблокировать приложение",
  AppConstants.databaseEncryption: "Шифрование базы данных",
  AppConstants.databaseEncryptionDesc: "Локальное шифрование AES-256-GCM",
  AppConstants.changeMasterPassword: "Изменить мастер-пароль",
  AppConstants.biometricUnlock: "Биометрическая разблокировка",
  AppConstants.enterMasterPassword: "Введите мастер-пароль",
  AppConstants.enterMasterPasswordHint:
      "Введите мастер-пароль для расшифровки вашего дневника.",
  AppConstants.unlockButton: "Разблокировать",
  AppConstants.unlockWithBiometrics: "Разблокировать по биометрии",
  AppConstants.incorrectMasterPassword:
      "Неверный мастер-пароль. Пожалуйста, попробуйте снова.",
  AppConstants.databaseEncryptedSuccess:
      "База данных дневника зашифрована с помощью AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "База данных расшифрована, блокировка приложения отключена.",
  AppConstants.masterPasswordChangedSuccess: "Мастер-пароль успешно обновлён.",
  AppConstants.encryptedBackupPasswordRequired:
      "Для открытия зашифрованной резервной копии требуется пароль.",
  AppConstants.incorrectBackupPassword: "Неверный пароль резервной копии.",
  AppConstants.invalidBackupFile:
      "Выбранный файл не является корректной резервной копией OpenJot.",
  AppConstants.encryptedBackup: "Зашифрованная копия (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Защищено AES-256-GCM и паролем резервной копии",
  AppConstants.standardBackup: "Обычная копия (.zip)",
  AppConstants.standardBackupDesc:
      "Незашифрованный архив, совместимый со всеми версиями",
  AppConstants.takingBackup: "Создание резервной копии...",
  AppConstants.encryptingBackup: "Шифрование резервной копии...",
  AppConstants.savingBackup: "Сохранение резервной копии...",
  AppConstants.preparingBackup: "Подготовка резервной копии...",
  AppConstants.decryptingBackup: "Расшифровка резервной копии...",
  AppConstants.restoringBackup: "Восстановление резервной копии...",
  AppConstants.backupEncodingFailed:
      "Не удалось закодировать файл резервной копии.",
  AppConstants.backupCreatedSuccess: "Резервная копия успешно создана!",
  AppConstants.backupFailed: "Не удалось создать резервную копию: %s",
  AppConstants.restorePermissionsRequired:
      "Для восстановления данных требуются разрешения на доступ к хранилищу и медиа.",
  AppConstants.databaseRestoredNoMedia:
      "База данных восстановлена. Медиафайлы в копии не найдены.",
  AppConstants.restoreSuccess: "Восстановление прошло успешно!",
  AppConstants.restoreSuccessRestartRecommended:
      "Восстановление завершено. Рекомендуется перезапустить приложение.",
  AppConstants.restoreFailed: "Не удалось восстановить данные: %s",
  AppConstants.storagePermissionsRequired:
      "Для создания резервной копии требуются разрешения на доступ к хранилищу и медиа.",
  AppConstants.selectBackupFolder:
      "Выберите папку для сохранения резервной копии",
  AppConstants.encryptDatabase: "Зашифровать базу данных",
  AppConstants.disableEncryption: "Отключить шифрование",
  AppConstants.backupPasswordTitle: "Пароль резервной копии",
  AppConstants.changeMasterPasswordDesc:
      "Введите текущий мастер-пароль и выберите новый пароль (минимум 6 символов).",
  AppConstants.disableEncryptionDesc:
      "Введите мастер-пароль, чтобы расшифровать базу данных на диске и отключить шифрование.",
  AppConstants.enableEncryptionDesc:
      "Защитите все записи дневника локальным шифрованием AES-256-GCM. Если вы забудете мастер-пароль, восстановить данные будет невозможно.",
  AppConstants.verifyForBiometricsDesc:
      "Введите мастер-пароль один раз, чтобы сохранить ключ в защищённом хранилище устройства для быстрой биометрической разблокировки.",
  AppConstants.createBackupPasswordDesc:
      "Задайте надёжный пароль для шифрования этой копии .openjot. Он понадобится для восстановления на любом устройстве.",
  AppConstants.enterBackupPasswordDesc:
      "Введите пароль, использованный при создании этой резервной копии .openjot.",
  AppConstants.updatePasswordAction: "Обновить пароль",
  AppConstants.decryptAndDisable: "Расшифровать и отключить",
  AppConstants.enableBiometricsAction: "Включить биометрию",
  AppConstants.createBackupAction: "Создать копию",
  AppConstants.decryptBackupAction: "Расшифровать копию",
  AppConstants.newMasterPasswordHint: "Новый мастер-пароль",
  AppConstants.backupPasswordHint: "Пароль резервной копии",
  AppConstants.masterPasswordHint: "Мастер-пароль",
  AppConstants.enterCurrentMasterPasswordError:
      "Пожалуйста, введите текущий мастер-пароль.",
  AppConstants.passwordEmptyError: "Пароль не может быть пустым.",
  AppConstants.passwordMinLengthError:
      "Пароль должен содержать не менее 6 символов.",
  AppConstants.passwordsDoNotMatchError: "Пароли не совпадают.",
  AppConstants.currentMasterPasswordHint: "Текущий мастер-пароль",
  AppConstants.confirmPasswordHint: "Подтвердите пароль",

  // About & Terms
  AppConstants.aboutApp: "О приложении OpenJot",
  AppConstants.versionPrefix: "Версия: %s",
  AppConstants.aboutSubtitle:
      "Минималистичный дневник с открытым исходным кодом для ваших мыслей, настроения и воспоминаний. Все данные остаются на вашем устройстве.",
  AppConstants.keyFeatures: "Основные возможности",
  AppConstants.aboutFeature1: "• Чистый интерфейс для письма без отвлечений.",
  AppConstants.aboutFeature2:
      "• Добавляйте фото, голосовые заметки и музыку к записям.",
  AppConstants.aboutFeature3:
      "• Отмечайте своё настроение вместе с записями.",
  AppConstants.aboutFeature4:
      "• Персонализируйте текст различными стилями.",
  AppConstants.aboutFeature5:
      "• Полностью работает офлайн — данные хранятся только у вас.",
  AppConstants.openSource: "Открытый исходный код",
  AppConstants.openSourceDesc:
      "OpenJot — приложение с открытым исходным кодом. Исходный код доступен всем для изучения, изменения и участия в разработке. Мы верим в прозрачность и силу сообщества.",
  AppConstants.dataPrivacy: "Конфиденциальность данных",
  AppConstants.dataPrivacyDesc:
      "Мы ценим вашу приватность. OpenJot не собирает, не хранит и не передаёт ваши личные данные. Все записи, включая текст, изображения и аудио, хранятся исключительно на вашем устройстве.",
  AppConstants.linksTitle: "Ссылки",
  AppConstants.sourceCodeOnGithub: "Исходный код на GitHub",
  AppConstants.sendFeedback: "Отправить отзыв",
  AppConstants.couldNotLaunchUrl: "Не удалось открыть ссылку",
  AppConstants.termsIntro:
      "Добро пожаловать в OpenJot! В этом документе изложены условия использования нашего приложения. Используя OpenJot, вы соглашаетесь с этими условиями.",
  AppConstants.termsSectionDataPrivacy: "Хранение данных и приватность",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot создан как личное пространство для ваших мыслей. Все записи дневника, включая текст, изображения, аудиофайлы и другие медиа, хранятся исключительно локально на вашем устройстве. Приложение не собирает, не хранит и не отправляет персональные данные на внешние серверы. У нас нет доступа к вашему контенту.",
  AppConstants.termsSectionUserContent: "Пользовательский контент",
  AppConstants.termsSectionUserContentBody:
      "Вы несёте полную ответственность за контент, который создаёте и храните в OpenJot, включая тексты, изображения, аудиозаписи и другие файлы. Вы обязаны убедиться, что обладаете необходимыми правами на любой контент, импортируемый в приложение.",
  AppConstants.termsSectionDisclaimer: "Отказ от гарантий",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot предоставляется «как есть» без каких-либо явных или подразумеваемых гарантий. Мы не гарантируем бесперебойную работу или отсутствие ошибок. Вы используете приложение на свой страх и риск.",
  AppConstants.termsSectionLiability: "Ограничение ответственности",
  AppConstants.termsSectionLiabilityBody:
      "Ни при каких обстоятельствах разработчики OpenJot не несут ответственности за любые прямые, косвенные, случайные или последующие убытки, включая потерю данных, возникшие в результате использования или невозможности использования этого приложения.",
  AppConstants.termsSectionThirdParty: "Сторонние библиотеки",
  AppConstants.termsSectionThirdPartyBody:
      "Это приложение использует следующие сторонние библиотеки, каждая из которых регулируется собственной лицензией:",

  // Months
  'January': 'Январь',
  'February': 'Февраль',
  'March': 'Март',
  'April': 'Апрель',
  'May': 'Май',
  'June': 'Июнь',
  'July': 'Июль',
  'August': 'Август',
  'September': 'Сентябрь',
  'October': 'Октябрь',
  'November': 'Ноябрь',
  'December': 'Декабрь',

  // Reflection Prompts (62)
  "What made you smile today?": "Что заставило вас улыбнуться сегодня?",
  "Who are you thankful for this week, and why?":
      "Кому вы благодарны на этой неделе и почему?",
  "What is something small that brought you joy today?":
      "Какая мелочь принесла вам радость сегодня?",
  "Which part of your day felt most comforting?":
      "Какая часть дня показалась вам самой уютной?",
  "What’s something you often take for granted but appreciate now?":
      "Что вы обычно принимаете как должное, но цените сейчас?",
  "What’s the best thing that happened today?":
      "Что самое лучшее произошло сегодня?",
  "Did someone make your day easier today?":
      "Сделал ли кто-то ваш день легче сегодня?",
  "Who made a positive impact on you recently?":
      "Кто недавно оказал на вас положительное влияние?",
  "What’s a quality you admire in someone close to you?":
      "Каким качеством в близком человеке вы восхищаетесь?",
  "When did you last feel truly connected with someone?":
      "Когда вы в последний раз чувствовали глубокую связь с кем-то?",
  "Who do you want to reach out to soon?":
      "С кем вы хотите связаться в ближайшее время?",
  "Did someone’s kindness stand out today?":
      "Запомнилась ли вам сегодня чья-то доброта?",
  "How did you support someone else recently?":
      "Как вы поддержали кого-то недавно?",
  "Who do you miss the most right now?":
      "По кому вы скучаете больше всего прямо сейчас?",
  "What’s a moment from today you want to remember?":
      "Какой момент сегодняшнего дня вы хотите запомнить?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Какую деталь сегодняшнего дня вы можете забыть, если не запишете?",
  "What’s the most peaceful moment you had today?":
      "Какой момент сегодня был самым спокойным?",
  "Did you see something beautiful today?":
      "Видели ли вы сегодня что-то красивое?",
  "Which memory from this week stands out?":
      "Какое воспоминание этой недели выделяется больше всего?",
  "What song, photo, or place will always remind you of today?":
      "Какая песня, фото или место всегда будут напоминать вам о сегодняшнем дне?",
  "What surprised you today?": "Что удивило вас сегодня?",
  "What challenge did you overcome today?":
      "С какой трудностью вы справились сегодня?",
  "What’s a small win you had today?":
      "Какая небольшая победа у вас была сегодня?",
  "What new thing did you learn about yourself recently?":
      "Что нового вы недавно узнали о себе?",
  "What are you proud of yourself for?": "Чем вы гордитесь в себе?",
  "What habit do you feel good about keeping?":
      "Какая привычка радует вас тем, что вы её сохраняете?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Какое улучшение в себе вы заметили в этом году?",
  "How did you push yourself out of your comfort zone?":
      "Как вы вышли из своей зоны комфорта?",
  "How are you truly feeling right now?":
      "Как вы на самом деле чувствуете себя прямо сейчас?",
  "Which emotion stood out the most today?":
      "Какая эмоция преобладала сегодня?",
  "Did you feel present in any moment today?":
      "Чувствовали ли вы себя в настоящем моменте сегодня?",
  "When did you feel the most at peace today?":
      "Когда вы чувствовали наибольший покой сегодня?",
  "What gave you energy today?": "Что дало вам энергию сегодня?",
  "What drained your energy today?": "Что забрало ваши силы сегодня?",
  "If your mood had a color today, what would it be?":
      "Если бы у вашего сегодняшнего настроения был цвет, каким бы он был?",
  "What’s something you’re excited about tomorrow?":
      "Чего вы с нетерпением ждёте завтра?",
  "What’s one thing you want to improve tomorrow?":
      "Что одно вы хотите улучшить завтра?",
  "What would make tomorrow feel successful?":
      "Что сделает завтрашний день успешным?",
  "What do you hope to achieve this week?":
      "Чего вы надеетесь достичь на этой неделе?",
  "What’s a habit you’d like to start tomorrow?":
      "Какую привычку вы хотели бы начать завтра?",
  "What’s something you want to look forward to in the next month?":
      "Чего вам хочется ждать в следующем месяце?",
  "What would your ideal tomorrow look like?":
      "Как выглядел бы ваш идеальный завтрашний день?",
  "What’s one lesson you learned recently?":
      "Какой урок вы недавно усвоили?",
  "If you could freeze one moment today, which would it be?":
      "Если бы вы могли остановить один момент сегодня, какой бы это был?",
  "What makes your life feel meaningful right now?":
      "Что сейчас делает вашу жизнь осмысленной?",
  "If you described today in one word, what would it be?":
      "Если описать сегодняшний день одним словом, каким бы оно было?",
  "What inspired you today?": "Что вдохновило вас сегодня?",
  "What did you notice today that you usually overlook?":
      "Что вы заметили сегодня, на что обычно не обращаете внимания?",
  "How has today changed your perspective?":
      "Как сегодняшний день изменил ваш взгляд на вещи?",
  "What’s something you’ve been overthinking?":
      "О чём вы слишком много думаете в последнее время?",
  "What do you need to let go of?": "Что вам нужно отпустить?",
  "What part of nature did you notice today?":
      "На что в природе вы обратили внимание сегодня?",
  "Did the weather affect your mood today?":
      "Повлияла ли погода на ваше настроение сегодня?",
  "What place felt most comforting today?":
      "Какое место показалось вам самым уютным сегодня?",
  "Where did you feel most at home today?":
      "Где вы чувствовали себя как дома сегодня?",
  "What sound or smell reminded you of something important?":
      "Какой звук или запах напомнил вам о чём-то важном?",
  "How did you take care of yourself today?":
      "Как вы позаботились о себе сегодня?",
  "When did you feel most like yourself today?":
      "Когда вы сегодня чувствовали себя наиболее самим собой?",
  "What’s something kind you can say to yourself right now?":
      "Какие добрые слова вы можете сказать себе прямо сейчас?",
  "What do you want to forgive yourself for?":
      "За что вы хотите простить себя?",
  "What do you deserve more of in your life?":
      "Чего вы заслуживаете больше в своей жизни?",
};

/// Complete Polish (Polski) translations for OpenJot.
final Map<String, String> plTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Mój dziennik",
  AppConstants.noEntriesMessage: "Brak wpisów w dzienniku. Zacznij pisać!",
  AppConstants.noBookmarksYet: "Brak zakładek.",
  AppConstants.noDraftsYet: "Brak szkiców.",
  AppConstants.addEntryButton: "Dodaj nowy wpis",
  AppConstants.jotYourThoughts: "Zapisz swoje myśli",
  AppConstants.tapToCreateJournal:
      "Dotknij +, aby utworzyć swój osobisty dziennik.",
  AppConstants.entriesThisYear: "Wpisy w tym roku",
  AppConstants.wordsWritten: "Napisane słowa",
  AppConstants.daysJournaled: "Dni z wpisami",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Nowy wpis w dzienniku",
  AppConstants.editEntryAppBarTitle: "Edytuj wpis w dzienniku",
  AppConstants.titleHintText: "Tytuł (np. 'Mój dzień', 'Przemyślenia...')",
  AppConstants.contentHintText: "Zapisz tutaj swoje myśli...",
  AppConstants.saveButton: "Zapisz wpis",
  AppConstants.updateButton: "Aktualizuj",
  AppConstants.deleteButton: "Usuń wpis",
  AppConstants.requiredFieldMessage: "To pole nie może być puste.",
  AppConstants.newEntry: "Nowy wpis",
  AppConstants.todayDate: "Dzisiejsza data",
  AppConstants.customDate: "Własna data",
  AppConstants.done: "Gotowe",
  AppConstants.startWriting: " Zacznij pisać...",
  AppConstants.tags: "Tagi",
  AppConstants.addTags: "Dodaj tagi",
  AppConstants.openInMaps: "Otwórz w Mapach",
  AppConstants.changeLocation: "Zmień lokalizację",
  AppConstants.remove: "Usuń",
  AppConstants.discardSelectionsTitle: "Odrzucić wybrane?",
  AppConstants.discardSelectionsMessage:
      "Wybrano multimedia lub aktywne nagranie. Czy na pewno chcesz je odrzucić?",
  AppConstants.journalEntryEmpty: "Wpis w dzienniku nie może być pusty",
  AppConstants.discardDateConfirm:
      "Odrzucić wybraną datę/godzinę dla tego wpisu?",
  AppConstants.addMediaLocationMoodFirst:
      "Najpierw dodaj multimedia, lokalizację lub nastrój",
  AppConstants.location: "Lokalizacja",
  AppConstants.record: "Nagraj",
  AppConstants.selectMomentsToJournal: "Wybierz chwile do zapisania",
  AppConstants.addMomentsFromMenu:
      "Dodaj multimedia, lokalizację, nagranie lub nastrój z menu",
  AppConstants.writeSomething: "Napisz coś",
  AppConstants.saveWithoutWriting: "Zapisz bez pisania",
  AppConstants.oneLocation: "1 lokalizacja",
  AppConstants.mediaCount: "%d multimediów",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Potwierdź usunięcie",
  AppConstants.confirmDeleteMessage: "Czy na pewno chcesz usunąć ten wpis?",
  AppConstants.pleaseConfirm: "Proszę potwierdzić",
  AppConstants.confirmDeleteJournalEntry:
      "Czy na pewno chcesz usunąć ten wpis w dzienniku? Tej operacji nie można cofnąć.",
  AppConstants.yes: "Tak",
  AppConstants.no: "Nie",
  AppConstants.cancel: "Anuluj",
  AppConstants.delete: "Usuń",
  AppConstants.save: "Zapisz",
  AppConstants.entrySavedSuccess: "Wpis zapisany pomyślnie!",
  AppConstants.entryUpdatedSuccess: "Wpis zaktualizowany pomyślnie!",
  AppConstants.entryDeletedSuccess: "Wpis usunięty.",
  AppConstants.errorSavingEntry: "Błąd podczas zapisywania wpisu.",
  AppConstants.errorDeletingEntry: "Błąd podczas usuwania wpisu.",
  AppConstants.errorLoadingEntries: "Błąd podczas wczytywania wpisów.",
  AppConstants.noEntriesForDate: "Brak wpisów dla tej daty.",
  AppConstants.noEntriesForMonth: "Nie znaleziono wpisów dla tego miesiąca.",
  AppConstants.selectMonthAndYear: "Wybierz miesiąc i rok",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Bardzo nieprzyjemny",
  AppConstants.unpleasant: "Nieprzyjemny",
  AppConstants.slightlyUnpleasant: "Lekko nieprzyjemny",
  AppConstants.neutral: "Neutralny",
  AppConstants.slightlyPleasant: "Lekko przyjemny",
  AppConstants.pleasant: "Przyjemny",
  AppConstants.veryPleasant: "Bardzo przyjemny",
  AppConstants.reflection: "Refleksja",
  AppConstants.edit: "Edytuj",
  AppConstants.removeBookmark: "Usuń zakładkę",
  AppConstants.bookmark: "Dodaj zakładkę",
  AppConstants.share: "Udostępnij",
  AppConstants.saveAsPdf: "Zapisz jako PDF",
  AppConstants.audioTrack: "Ścieżka audio",
  AppConstants.generatingPdf: "Generowanie PDF...",
  AppConstants.voiceRecording: "Nagranie głosowe",
  AppConstants.audioRecording: "Nagranie audio",
  AppConstants.couldNotLoadAudio: "Nie udało się wczytać pliku audio.",
  AppConstants.stateOfMind: "Stan umysłu",

  // Mood Colors
  AppConstants.moodColors: "Kolory nastroju",
  AppConstants.customizeMoodColors: "Dostosuj kolory nastroju",
  AppConstants.reset: "Resetuj",
  AppConstants.resetMoodColors: "Przywróć domyślne",
  AppConstants.resetMoodColorsConfirm:
      "Przywrócić wszystkie kolory nastroju do domyślnych?",
  AppConstants.paletteThemes: "Motywy palety",
  AppConstants.customColor: "Własny kolor",
  AppConstants.moodUnsavedChangesMessage:
      "Masz niezapisane zmiany kolorów nastroju. Czy chcesz je zapisać przed zamknięciem?",

  // Drafts & Auto-save
  AppConstants.drafts: "Szkice",
  AppConstants.draft: "Szkic",
  AppConstants.draftSaved: "Zapisano w szkicach",
  AppConstants.unsavedChanges: "Niezapisane zmiany",
  AppConstants.unsavedChangesMessage:
      "Masz niezapisane zmiany. Czy chcesz zapisać je jako szkic, czy odrzucić?",
  AppConstants.saveAsDraft: "Zapisz jako szkic",
  AppConstants.discardChanges: "Odrzuć",
  AppConstants.autoDeleteDrafts: "Automatyczne usuwanie szkiców",
  AppConstants.days7: "7 dni",
  AppConstants.never: "Nigdy",
  AppConstants.custom: "Własne...",
  AppConstants.enterCustomDays: "Wpisz liczbę dni",
  AppConstants.customDaysExample: "Np. 14",
  AppConstants.days: "dni",
  AppConstants.draftsNeverDeleted: "Szkice nigdy nie zostaną usunięte",
  AppConstants.draftsDeletedAfterDays: "Szkice zostaną usunięte po %d dniach",

  // Home Menu & Sorting
  AppConstants.sortBy: "Sortuj według",
  AppConstants.insights: "Statystyki",
  AppConstants.reflections: "Refleksje",
  AppConstants.settings: "Ustawienia",
  AppConstants.entryTime: "Czas wpisu",
  AppConstants.bookmarkFirst: "Najpierw zakładki",
  AppConstants.reflectionFirst: "Najpierw refleksje",
  AppConstants.withMediaFirst: "Najpierw z multimediami",
  AppConstants.textOnlyFirst: "Najpierw tylko tekst",
  AppConstants.withLocationFirst: "Najpierw z lokalizacją",
  AppConstants.withMoodFirst: "Najpierw z nastrojem",
  AppConstants.withTagsFirst: "Najpierw z tagami",

  // Insights
  AppConstants.stats: "Statystyki",
  AppConstants.calendar: "Kalendarz",
  AppConstants.entriesSuffix: " wpisów",
  AppConstants.memoriesFromThisDay: "Wspomnienia z tego dnia",
  AppConstants.standard: "Standardowy",
  AppConstants.media: "Multimedia",
  AppConstants.mood: "Nastrój",
  AppConstants.mostly: "Głównie",
  AppConstants.averageForThisDay: "Średnia dla tego dnia",
  AppConstants.averageForThisYear: "Średnia dla tego roku",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Witamy w OpenJot",
  AppConstants.feature1:
      "Pisz swobodnie, dodawaj zdjęcia i lokalizacje oraz przechowuj wszystko bezpiecznie na swoim urządzeniu.",
  AppConstants.feature2:
      "Zrozum swoje emocje na przestrzeni czasu dzięki zintegrowanemu śledzeniu nastroju.",
  AppConstants.feature3:
      "Twoje dane zostają w telefonie – żadnej chmury, tylko lokalna pamięć i pełna prywatność.",
  AppConstants.continueButton: "Kontynuuj",

  // Notifications
  AppConstants.notificationTitle: "Czas na dziennik!",
  AppConstants.notificationBody:
      "Nie zapomnij zapisać swoich myśli z dzisiejszego dnia.",
  AppConstants.notificationChannelName: "Codzienne przypomnienia",
  AppConstants.notificationChannelDescription:
      "Kanał dla codziennych przypomnień o pisaniu dziennika",
  AppConstants.onThisDayChannelName: "Wspomnienia Tego Dnia",
  AppConstants.onThisDayChannelDescription:
      "Powiadomienia o wspomnieniach z poprzednich lat.",
  AppConstants.onThisDayNotificationTitle: "Wspomnienie z Twojego dziennika",
  AppConstants.onThisDaySingleEntry:
      "Rok temu tego dnia napisałeś coś wyjątkowego. Dotknij, aby wrócić do swoich myśli.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Tego dnia rok temu podzieliłeś się tym wspomnieniem. Dotknij, aby przeżyć je ponownie.",
  AppConstants.onThisDayMultipleEntries:
      "Masz wspomnienia z tego dnia z poprzednich lat. Dotknij, aby je zobaczyć.",
  AppConstants.onThisDayGroupedNotification: "Masz %d wspomnień z tego dnia",

  // Exclude Entries
  AppConstants.excludeEntries: "Wyklucz wpisy",
  AppConstants.saveExclusions: "Zapisz wykluczenia",
  AppConstants.excludeUnsavedChangesMessage:
      "Masz niezapisane zmiany. Czy na pewno chcesz je odrzucić i wyjść?",
  AppConstants.sortDefault: "Domyślnie",
  AppConstants.sortMutedFirst: "Najpierw wyciszone",
  AppConstants.sortUnmutedFirst: "Najpierw niewyciszone",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Dzisiaj",
  AppConstants.yesterday: "Wczoraj",
  AppConstants.contentForQuote: "Treść do cytatu",
  AppConstants.noContentSelected: "Nie wybrano żadnej treści.",
  AppConstants.photos: "Zdjęcia",
  AppConstants.video: "Wideo",
  AppConstants.audio: "Audio",
  AppConstants.add: "Dodaj",
  AppConstants.noMediaFound: "Nie znaleziono: %s.",
  AppConstants.permissionRequired:
      "Wymagane jest uprawnienie dostępu do %s, aby je wyświetlić.",
  AppConstants.openSettings: "Otwórz ustawienia",
  AppConstants.videos: "Wideo",
  AppConstants.audios: "Audio",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Usunąć nagranie?",
  AppConstants.deleteRecordingMessage:
      "Czy na pewno chcesz usunąć to nagranie?",
  AppConstants.listen: "Słuchaj",
  AppConstants.tapAndHold: "dotknij i przytrzymaj",
  AppConstants.clear: "Wyczyść",
  AppConstants.all: "Wszystkie",
  AppConstants.folder: "Folder",
  AppConstants.browse: "Przeglądaj",
  AppConstants.tiles: "Kafelki",
  AppConstants.graph: "Wykres",
  AppConstants.recording: "Nagrywanie...",
  AppConstants.recordingLabel: "Nagrywanie",
  AppConstants.startAudioRecording: "Rozpocznij nagrywanie audio",
  AppConstants.howAreYouFeeling: "Jak się czujesz?",
  AppConstants.paused: "Wstrzymano",
  AppConstants.stop: "Stop",
  AppConstants.tapOrHoldToResume: "Dotknij lub przytrzymaj, aby wznowić",
  AppConstants.tapOrReleaseToPause: "Dotknij lub puść, aby wstrzymać",
  AppConstants.unsupportedImageType: "Nieobsługiwany typ obrazu",
  AppConstants.couldNotLoadVideo: "Nie udało się wczytać wideo",
  AppConstants.couldNotOpenMap: "Nie udało się otworzyć linku do mapy.",
  AppConstants.dismiss: "Zamknij",
  AppConstants.selectTime: "Wybierz godzinę",
  AppConstants.now: "Teraz",
  AppConstants.searchPlacesHint: "Szukaj miejsc, sklepów...",
  AppConstants.locationPermissionDenied: "Odmówiono dostępu do lokalizacji.",
  AppConstants.failedGetCurrentLocation:
      "Nie udało się pobrać bieżącej lokalizacji.",

  // Search
  AppConstants.searchJournalsHint: "Szukaj w dziennikach...",
  AppConstants.textOnly: "Tylko tekst",
  AppConstants.withMedia: "Z multimediami",
  AppConstants.withMood: "Z nastrojem",
  AppConstants.withLocation: "Z lokalizacją",
  AppConstants.withTags: "Z tagami",
  AppConstants.noResultsFound: "Nie znaleziono wyników",
  AppConstants.searchHintText: "Szukaj wpisów...",

  // Settings
  AppConstants.language: "Język",
  AppConstants.selectLanguage: "Wybierz język",
  AppConstants.systemDefault: "Domyślny systemowy",
  AppConstants.searchLanguagesHint: "Szukaj języków...",
  AppConstants.languageChanged: "Zmieniono język na %s.",
  AppConstants.dailyReminder: "Przypomnienia",
  AppConstants.addReminder: "Dodaj przypomnienie",
  AppConstants.deleteReminder: "Usuń przypomnienie",
  AppConstants.noRemindersSet: "Brak ustawionych przypomnień.",
  AppConstants.onThisDay: "Tego dnia",
  AppConstants.appLock: "Blokada aplikacji",
  AppConstants.backup: "Kopia zapasowa",
  AppConstants.restore: "Przywróć",
  AppConstants.importFromAnotherApp: "Importuj z innej aplikacji",
  AppConstants.importFromDailyYou: "Importuj z Daily You",
  AppConstants.selectDailyYouBackup:
      "Wybierz plik zip kopii zapasowej Daily You",
  AppConstants.importingEntries: "Importowanie wpisów...",
  AppConstants.importSuccess:
      "Pomyślnie zaimportowano %d wpisów z Daily You!",
  AppConstants.importFailed: "Import nie powiódł się: %s",
  AppConstants.noEntriesToImport: "Nie znaleziono nowych wpisów do importu.",
  AppConstants.askSupport: "Poproś o wsparcie",
  AppConstants.importSupportNote:
      "Formaty innych aplikacji mogą nie obsługiwać wszystkich funkcji. Jeśli napotkasz problemy lub formaty się zmienią, zgłoś błąd.",
  AppConstants.extractingBackup: "Wypakowywanie kopii zapasowej...",
  AppConstants.parsingDatabase: "Analizowanie bazy danych...",
  AppConstants.dailyYouDbNotFound:
      "Nie znaleziono bazy danych Daily You w kopii zapasowej.",
  AppConstants.privacyPolicy: "Polityka prywatności",
  AppConstants.termsNConditions: "Warunki korzystania",
  AppConstants.about: "O aplikacji",
  AppConstants.changeTheme: "Zmień motyw",
  AppConstants.theme: "Motyw",
  AppConstants.pitchBlack: "Głęboka czerń",
  AppConstants.themeLight: "Jasny",
  AppConstants.themeDark: "Ciemny",
  AppConstants.themeSystem: "Systemowy",
  AppConstants.changePin: "Zmień PIN",
  AppConstants.loading: "Ładowanie...",
  AppConstants.confirmRestoreTitle: "Potwierdź przywracanie",
  AppConstants.confirmRestoreMessage:
      "Przywrócenie z kopii zapasowej nadpisze wszystkie bieżące dane. Tej czynności nie można cofnąć. Czy na pewno chcesz kontynuować?",
  AppConstants.notificationScheduled: "Powiadomienie zaplanowane na %s",
  AppConstants.notificationCanceled: "Powiadomienie anulowane",
  AppConstants.notificationRescheduled: "Powiadomienie przełożone na %s",
  AppConstants.notificationPermissionRequired:
      "Uprawnienie do powiadomień jest wymagane do ustawiania przypomnień.",
  AppConstants.pinChangedSuccess: "PIN został pomyślnie zmieniony",
  AppConstants.onThisDayOn: "Będziesz otrzymywać wspomnienia z tego dnia.",
  AppConstants.onThisDayOff: "Przypomnienia 'Tego dnia' są wyłączone.",
  AppConstants.themeChanged: "Wybrano motyw: %s.",
  AppConstants.hideStats: "Ukryj statystyki",
  AppConstants.hideHomeStats: "Ukryj statystyki ekranu głównego",
  AppConstants.hideInsightsStats: "Ukryj statystyki w Analizach",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLEKSJA",
  AppConstants.reflectButton: "Reflektuj",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Nieprawidłowy PIN",
  AppConstants.verifyYourPin: "Zweryfikuj swój PIN",
  AppConstants.setAPin: "Ustaw PIN",
  AppConstants.confirmPin: "Potwierdź PIN",
  AppConstants.pinsDoNotMatch: "Kody PIN nie są zgodne",
  AppConstants.setPin: "Ustaw PIN",
  AppConstants.hello: "Cześć!",
  AppConstants.enterYourPin: "Wpisz swój PIN",
  AppConstants.useBiometrics: "Użyj biometrii",
  AppConstants.authenticateToUnlock:
      "Uwierzytelnij się, aby odblokować aplikację",
  AppConstants.databaseEncryption: "Szyfrowanie bazy danych",
  AppConstants.databaseEncryptionDesc: "Lokalne szyfrowanie AES-256-GCM",
  AppConstants.changeMasterPassword: "Zmień hasło główne",
  AppConstants.biometricUnlock: "Odblokowanie biometryczne",
  AppConstants.enterMasterPassword: "Wpisz hasło główne",
  AppConstants.enterMasterPasswordHint:
      "Wpisz swoje hasło główne, aby odszyfrować dziennik.",
  AppConstants.unlockButton: "Odblokuj",
  AppConstants.unlockWithBiometrics: "Odblokuj biometrią",
  AppConstants.incorrectMasterPassword:
      "Nieprawidłowe hasło główne. Spróbuj ponownie.",
  AppConstants.databaseEncryptedSuccess:
      "Baza danych dziennika zaszyfrowana za pomocą AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Baza danych odszyfrowana, a blokada aplikacji wyłączona.",
  AppConstants.masterPasswordChangedSuccess:
      "Hasło główne zaktualizowane pomyślnie.",
  AppConstants.encryptedBackupPasswordRequired:
      "Do otwarcia zaszyfrowanej kopii zapasowej wymagane jest hasło.",
  AppConstants.incorrectBackupPassword: "Nieprawidłowe hasło kopii zapasowej.",
  AppConstants.invalidBackupFile:
      "Wybrany plik nie jest prawidłową kopią zapasową OpenJot.",
  AppConstants.encryptedBackup: "Zaszyfrowana kopia (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Chroniona przez AES-256-GCM i hasło kopii zapasowej",
  AppConstants.standardBackup: "Standardowa kopia (.zip)",
  AppConstants.standardBackupDesc:
      "Nieszyfrowane archiwum kompatybilne ze wszystkimi wersjami",
  AppConstants.takingBackup: "Tworzenie kopii zapasowej...",
  AppConstants.encryptingBackup: "Szyfrowanie kopii zapasowej...",
  AppConstants.savingBackup: "Zapisywanie kopii zapasowej...",
  AppConstants.preparingBackup: "Przygotowywanie kopii zapasowej...",
  AppConstants.decryptingBackup: "Odszyfrowywanie kopii zapasowej...",
  AppConstants.restoringBackup: "Przywracanie kopii zapasowej...",
  AppConstants.backupEncodingFailed:
      "Nie udało się zakodować pliku kopii zapasowej.",
  AppConstants.backupCreatedSuccess: "Kopia zapasowa utworzona pomyślnie!",
  AppConstants.backupFailed: "Nie udało się utworzyć kopii zapasowej: %s",
  AppConstants.restorePermissionsRequired:
      "Do przywrócenia danych wymagane są uprawnienia pamięci i multimediów.",
  AppConstants.databaseRestoredNoMedia:
      "Baza danych przywrócona. Nie znaleziono multimediów w kopii.",
  AppConstants.restoreSuccess: "Przywracanie zakończone sukcesem!",
  AppConstants.restoreSuccessRestartRecommended:
      "Przywracanie zakończone sukcesem. Zalecany jest restart, aby zastosować zmiany.",
  AppConstants.restoreFailed: "Nie udało się przywrócić danych: %s",
  AppConstants.storagePermissionsRequired:
      "Do utworzenia kopii zapasowej wymagane są uprawnienia pamięci i multimediów.",
  AppConstants.selectBackupFolder: "Wybierz folder do zapisania kopii zapasowej",
  AppConstants.encryptDatabase: "Zaszyfruj bazę danych",
  AppConstants.disableEncryption: "Wyłącz szyfrowanie",
  AppConstants.backupPasswordTitle: "Hasło kopii zapasowej",
  AppConstants.changeMasterPasswordDesc:
      "Wpisz bieżące hasło główne i wybierz nowe hasło (minimum 6 znaków).",
  AppConstants.disableEncryptionDesc:
      "Wpisz hasło główne, aby odszyfrować bazę danych na dysku i wyłączyć szyfrowanie.",
  AppConstants.enableEncryptionDesc:
      "Chroń wszystkie notatki w dzienniku lokalnie za pomocą szyfrowania AES-256-GCM. Jeśli zapomnisz hasła głównego, nie będzie można odzyskać zaszyfrowanych danych.",
  AppConstants.verifyForBiometricsDesc:
      "Wpisz hasło główne jednorazowo, aby zapisać klucz odblokowujący w bezpiecznym magazynie sprzętowym do szybkiego odblokowania biometrią.",
  AppConstants.createBackupPasswordDesc:
      "Ustaw silne hasło do zaszyfrowania tej kopii .openjot. Będzie ono potrzebne do przywrócenia na dowolnym urządzeniu.",
  AppConstants.enterBackupPasswordDesc:
      "Wpisz hasło użyte podczas tworzenia tej kopii zapasowej .openjot.",
  AppConstants.updatePasswordAction: "Aktualizuj hasło",
  AppConstants.decryptAndDisable: "Odszyfruj i wyłącz",
  AppConstants.enableBiometricsAction: "Włącz biometrię",
  AppConstants.createBackupAction: "Utwórz kopię",
  AppConstants.decryptBackupAction: "Odszyfruj kopię",
  AppConstants.newMasterPasswordHint: "Nowe hasło główne",
  AppConstants.backupPasswordHint: "Hasło kopii zapasowej",
  AppConstants.masterPasswordHint: "Hasło główne",
  AppConstants.enterCurrentMasterPasswordError:
      "Wpisz swoje bieżące hasło główne.",
  AppConstants.passwordEmptyError: "Hasło nie może być puste.",
  AppConstants.passwordMinLengthError:
      "Hasło musi mieć co najmniej 6 znaków.",
  AppConstants.passwordsDoNotMatchError: "Hasła nie są zgodne.",
  AppConstants.currentMasterPasswordHint: "Bieżące hasło główne",
  AppConstants.confirmPasswordHint: "Potwierdź hasło",

  // About & Terms
  AppConstants.aboutApp: "O OpenJot",
  AppConstants.versionPrefix: "Wersja: %s",
  AppConstants.aboutSubtitle:
      "Minimalistyczny dziennik open-source do zapisywania myśli, nastrojów i wspomnień. Wszystkie dane pozostają na Twoim urządzeniu.",
  AppConstants.keyFeatures: "Główne funkcje",
  AppConstants.aboutFeature1: "• Przejrzyste środowisko do pisania bez rozpraszaczy.",
  AppConstants.aboutFeature2:
      "• Dodawaj zdjęcia, notatki głosowe i muzykę do swoich wpisów.",
  AppConstants.aboutFeature3: "• Zapisuj swój nastrój obok wpisów.",
  AppConstants.aboutFeature4: "• Personalizuj za pomocą różnych stylów tekstu.",
  AppConstants.aboutFeature5:
      "• Działa całkowicie offline, Twoje dane zostają na urządzeniu.",
  AppConstants.openSource: "Open Source",
  AppConstants.openSourceDesc:
      "OpenJot jest aplikacją open-source. Kod źródłowy jest publicznie dostępny dla każdego do przeglądania, modyfikowania i współtworzenia. Wierzymy w przejrzystość i współpracę społeczności.",
  AppConstants.dataPrivacy: "Prywatność danych",
  AppConstants.dataPrivacyDesc:
      "Cenimy Twoją prywatność. OpenJot nie zbiera, nie przechowuje ani nie przesyła żadnych danych osobowych. Wszystkie wpisy, w tym tekst, obrazy i pliki audio, są przechowywane wyłącznie na Twoim urządzeniu.",
  AppConstants.linksTitle: "Linki",
  AppConstants.sourceCodeOnGithub: "Kod źródłowy na GitHub",
  AppConstants.sendFeedback: "Wyślij opinię",
  AppConstants.couldNotLaunchUrl: "Nie udało się otworzyć adresu URL",
  AppConstants.termsIntro:
      "Witamy w OpenJot! Ten dokument określa warunki korzystania z naszej aplikacji. Korzystając z OpenJot, akceptujesz te warunki.",
  AppConstants.termsSectionDataPrivacy: "Przechowywanie danych i prywatność",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot został zaprojektowany jako prywatna przestrzeń dla Twoich myśli. Wszystkie wpisy, w tym tekst, zdjęcia, pliki audio i inne multimedia, są przechowywane wyłącznie lokalnie na Twoim urządzeniu. Aplikacja nie zbiera, nie przechowuje ani nie wysyła danych na serwery zewnętrzne. Nie mamy dostępu do Twoich treści.",
  AppConstants.termsSectionUserContent: "Treści tworzone przez użytkownika",
  AppConstants.termsSectionUserContentBody:
      "Ponosisz wyłączną odpowiedzialność za treści tworzone i przechowywane w OpenJot, w tym tekst, obrazy, nagrania audio i inne pliki. Jesteś odpowiedzialny za posiadanie praw do wszelkich treści importowanych do aplikacji.",
  AppConstants.termsSectionDisclaimer: "Wyłączenie gwarancji",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot jest dostarczany w stanie \"takim, jaki jest\", bez jakichkolwiek gwarancji, wyraźnych lub dorozumianych. Nie gwarantujemy, że aplikacja będzie wolna od błędów lub przerw w działaniu. Korzystasz z niej na własne ryzyko.",
  AppConstants.termsSectionLiability: "Ograniczenie odpowiedzialności",
  AppConstants.termsSectionLiabilityBody:
      "W żadnym wypadku twórcy OpenJot nie ponoszą odpowiedzialności za jakiekolwiek szkody bezpośrednie, pośrednie, przypadkowe, szczególne lub wynikowe, w tym utratę danych, wynikające z korzystania lub niemożności korzystania z tej aplikacji.",
  AppConstants.termsSectionThirdParty: "Biblioteki stron trzecich",
  AppConstants.termsSectionThirdPartyBody:
      "Ta aplikacja korzysta z następujących bibliotek stron trzecich, z których każda podlega własnej licencji:",

  // Months
  'January': 'Styczeń',
  'February': 'Luty',
  'March': 'Marzec',
  'April': 'Kwiecień',
  'May': 'Maj',
  'June': 'Czerwiec',
  'July': 'Lipiec',
  'August': 'Sierpień',
  'September': 'Wrzesień',
  'October': 'Październik',
  'November': 'Listopad',
  'December': 'Grudzień',

  // Reflection Prompts (62)
  "What made you smile today?": "Co sprawiło, że dzisiaj się uśmiechnąłeś?",
  "Who are you thankful for this week, and why?":
      "Komu jesteś wdzięczny w tym tygodniu i dlaczego?",
  "What is something small that brought you joy today?":
      "Jaka drobna rzecz sprawiła Ci dziś radość?",
  "Which part of your day felt most comforting?":
      "Która część dnia była dla Ciebie najbardziej kojąca?",
  "What’s something you often take for granted but appreciate now?":
      "Co często bierzesz za pewnik, ale teraz doceniasz?",
  "What’s the best thing that happened today?":
      "Jaka najlepsza rzecz wydarzyła się dzisiaj?",
  "Did someone make your day easier today?":
      "Czy ktoś ułatwił Ci dzisiaj dzień?",
  "Who made a positive impact on you recently?":
      "Kto wywarł na Ciebie ostatnio pozytywny wpływ?",
  "What’s a quality you admire in someone close to you?":
      "Jaką cechę podziwiasz u bliskiej Ci osoby?",
  "When did you last feel truly connected with someone?":
      "Kiedy ostatnio poczułeś prawdziwą więź z kimś?",
  "Who do you want to reach out to soon?":
      "Do kogo chcesz się wkrótce odezwać?",
  "Did someone’s kindness stand out today?":
      "Czy czyjaś życzliwość szczególnie zwróciła dziś Twoją uwagę?",
  "How did you support someone else recently?":
      "Jak wsparłeś kogoś innego w ostatnim czasie?",
  "Who do you miss the most right now?":
      "Za kim tęsknisz teraz najbardziej?",
  "What’s a moment from today you want to remember?":
      "Jaką chwilę z dzisiejszego dnia chcesz zapamiętać?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Jaki szczegół z dzisiejszego dnia możesz zapomnieć, jeśli go nie zapiszesz?",
  "What’s the most peaceful moment you had today?":
      "Jaka była Twoja najspokojniejsza chwila dzisiaj?",
  "Did you see something beautiful today?":
      "Czy widziałeś dziś coś pięknego?",
  "Which memory from this week stands out?":
      "Które wspomnienie z tego tygodnia wyróżnia się najbardziej?",
  "What song, photo, or place will always remind you of today?":
      "Jaka piosenka, zdjęcie lub miejsce zawsze będzie przypominać Ci o dzisiejszym dniu?",
  "What surprised you today?": "Co Cię dzisiaj zaskoczyło?",
  "What challenge did you overcome today?":
      "Jakie wyzwanie pokonałeś dzisiaj?",
  "What’s a small win you had today?":
      "Jaki mały sukces odniosłeś dzisiaj?",
  "What new thing did you learn about yourself recently?":
      "Czego nowego dowiedziałeś się o sobie ostatnio?",
  "What are you proud of yourself for?": "Z czego jesteś z siebie dumny?",
  "What habit do you feel good about keeping?":
      "Z jakiego nawyku, który utrzymujesz, jesteś zadowolony?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Jaką jedną poprawę zauważyłeś u siebie w tym roku?",
  "How did you push yourself out of your comfort zone?":
      "Jak wyszedłeś poza swoją strefę komfortu?",
  "How are you truly feeling right now?":
      "Jak naprawdę się teraz czujesz?",
  "Which emotion stood out the most today?":
      "Która emocja dominowała dzisiaj najbardziej?",
  "Did you feel present in any moment today?":
      "Czy w którejś chwili dzisiaj czułeś się w pełni obecny?",
  "When did you feel the most at peace today?":
      "Kiedy dzisiaj czułeś największy spokój?",
  "What gave you energy today?": "Co dodało Ci dzisiaj energii?",
  "What drained your energy today?": "Co odebrało Ci dzisiaj energię?",
  "If your mood had a color today, what would it be?":
      "Gdyby Twój dzisiejszy nastrój miał kolor, jaki by on był?",
  "What’s something you’re excited about tomorrow?":
      "Na co cieszysz się w związku z jutrem?",
  "What’s one thing you want to improve tomorrow?":
      "Jaką jedną rzecz chcesz poprawić jutro?",
  "What would make tomorrow feel successful?":
      "Co sprawiłoby, że jutrzejszy dzień byłby udany?",
  "What do you hope to achieve this week?":
      "Co masz nadzieję osiągnąć w tym tygodniu?",
  "What’s a habit you’d like to start tomorrow?":
      "Jaki nawyk chciałbyś zacząć od jutra?",
  "What’s something you want to look forward to in the next month?":
      "Na co chcesz czekać z niecierpliwością w przyszłym miesiącu?",
  "What would your ideal tomorrow look like?":
      "Jak wyglądałoby Twoje idealne jutro?",
  "What’s one lesson you learned recently?":
      "Jaką jedną lekcję wyciągnąłeś ostatnio?",
  "If you could freeze one moment today, which would it be?":
      "Gdybyś mógł zatrzymać jedną chwilę z dzisiejszego dnia, która by to była?",
  "What makes your life feel meaningful right now?":
      "Co sprawia, że Twoje życie ma teraz sens?",
  "If you described today in one word, what would it be?":
      "Gdybyś miał opisać dzisiejszy dzień jednym słowem, jakie by ono było?",
  "What inspired you today?": "Co Cię dzisiaj zainspirowało?",
  "What did you notice today that you usually overlook?":
      "Co zauważyłeś dzisiaj, co zazwyczaj przeoczasz?",
  "How has today changed your perspective?":
      "Jak dzisiejszy dzień zmienił Twoją perspektywę?",
  "What’s something you’ve been overthinking?":
      "O czym ostatnio za dużo rozmyślasz?",
  "What do you need to let go of?": "Co musisz odpuścić?",
  "What part of nature did you notice today?":
      "Jaką część natury zauważyłeś dzisiaj?",
  "Did the weather affect your mood today?":
      "Czy pogoda wpłynęła dzisiaj na Twój nastrój?",
  "What place felt most comforting today?":
      "Które miejsce było dzisiaj najbardziej przytulne?",
  "Where did you feel most at home today?":
      "Gdzie czułeś się dzisiaj najbardziej jak w domu?",
  "What sound or smell reminded you of something important?":
      "Jaki dźwięk lub zapach przypomniał Ci o czymś ważnym?",
  "How did you take care of yourself today?":
      "Jak zadbałeś dzisiaj o siebie?",
  "When did you feel most like yourself today?":
      "Kiedy dzisiaj czułeś się najbardziej sobą?",
  "What’s something kind you can say to yourself right now?":
      "Co miłego możesz sobie teraz powiedzieć?",
  "What do you want to forgive yourself for?":
      "Co chcesz sobie wybaczyć?",
  "What do you deserve more of in your life?":
      "Na co zasługujesz bardziej w swoim życiu?",
};

/// Complete Ukrainian (Українська) translations for OpenJot.
final Map<String, String> ukTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Мій щоденник",
  AppConstants.noEntriesMessage: "Записів у щоденнику ще немає. Почніть писати!",
  AppConstants.noBookmarksYet: "Закладок ще немає.",
  AppConstants.noDraftsYet: "Чернеток ще немає.",
  AppConstants.addEntryButton: "Новий запис",
  AppConstants.jotYourThoughts: "Запишіть свої думки",
  AppConstants.tapToCreateJournal:
      "Натисніть +, щоб створити особистий щоденник.",
  AppConstants.entriesThisYear: "Записів цього року",
  AppConstants.wordsWritten: "Написано слів",
  AppConstants.daysJournaled: "Днів із записами",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Новий запис у щоденнику",
  AppConstants.editEntryAppBarTitle: "Редагувати запис",
  AppConstants.titleHintText: "Заголовок (напр., 'Мій день', 'Думки про...')",
  AppConstants.contentHintText: "Запишіть свої думки тут...",
  AppConstants.saveButton: "Зберегти запис",
  AppConstants.updateButton: "Оновити",
  AppConstants.deleteButton: "Видалити запис",
  AppConstants.requiredFieldMessage: "Це поле не може бути порожнім.",
  AppConstants.newEntry: "Новий запис",
  AppConstants.todayDate: "Сьогоднішня дата",
  AppConstants.customDate: "Власна дата",
  AppConstants.done: "Готово",
  AppConstants.startWriting: " Почніть писати...",
  AppConstants.tags: "Теги",
  AppConstants.addTags: "Додати теги",
  AppConstants.openInMaps: "Відкрити на мапі",
  AppConstants.changeLocation: "Змінити місцезнаходження",
  AppConstants.remove: "Видалити",
  AppConstants.discardSelectionsTitle: "Скасувати вибране?",
  AppConstants.discardSelectionsMessage:
      "Ви вибрали медіафайли або активний аудіозапис. Впевнені, що хочете їх скасувати?",
  AppConstants.journalEntryEmpty: "Запис у щоденнику не може бути порожнім",
  AppConstants.discardDateConfirm:
      "Скасувати вибрану дату/час для цього запису?",
  AppConstants.addMediaLocationMoodFirst:
      "Спочатку додайте медіа, місцезнаходження або настрій",
  AppConstants.location: "Місце",
  AppConstants.record: "Запис",
  AppConstants.selectMomentsToJournal: "Оберіть моменти для щоденника",
  AppConstants.addMomentsFromMenu:
      "Додайте медіа, місце, аудіозапис або настрій із меню",
  AppConstants.writeSomething: "Написати текст",
  AppConstants.saveWithoutWriting: "Зберегти без тексту",
  AppConstants.oneLocation: "1 місце",
  AppConstants.mediaCount: "%d медіа",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Підтвердіть видалення",
  AppConstants.confirmDeleteMessage:
      "Ви впевнені, що хочете видалити цей запис?",
  AppConstants.pleaseConfirm: "Будь ласка, підтвердіть",
  AppConstants.confirmDeleteJournalEntry:
      "Ви впевнені, що хочете видалити цей запис? Цю дію неможливо скасувати.",
  AppConstants.yes: "Так",
  AppConstants.no: "Ні",
  AppConstants.cancel: "Скасувати",
  AppConstants.delete: "Видалити",
  AppConstants.save: "Зберегти",
  AppConstants.entrySavedSuccess: "Запис успішно збережено!",
  AppConstants.entryUpdatedSuccess: "Запис успішно оновлено!",
  AppConstants.entryDeletedSuccess: "Запис видалено.",
  AppConstants.errorSavingEntry: "Помилка збереження запису.",
  AppConstants.errorDeletingEntry: "Помилка видалення запису.",
  AppConstants.errorLoadingEntries: "Помилка завантаження записів.",
  AppConstants.noEntriesForDate: "Немає записів за цю дату.",
  AppConstants.noEntriesForMonth: "За цей місяць записів не знайдено.",
  AppConstants.selectMonthAndYear: "Виберіть місяць і рік",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Дуже неприємно",
  AppConstants.unpleasant: "Неприємно",
  AppConstants.slightlyUnpleasant: "Трохи неприємно",
  AppConstants.neutral: "Нейтрально",
  AppConstants.slightlyPleasant: "Трохи приємно",
  AppConstants.pleasant: "Приємно",
  AppConstants.veryPleasant: "Дуже приємно",
  AppConstants.reflection: "Роздум",
  AppConstants.edit: "Редагувати",
  AppConstants.removeBookmark: "Видалити закладку",
  AppConstants.bookmark: "У закладки",
  AppConstants.share: "Поділитися",
  AppConstants.saveAsPdf: "Зберегти як PDF",
  AppConstants.audioTrack: "Аудіодоріжка",
  AppConstants.generatingPdf: "Створення PDF...",
  AppConstants.voiceRecording: "Голосовий запис",
  AppConstants.audioRecording: "Аудіозапис",
  AppConstants.couldNotLoadAudio: "Не вдалося завантажити аудіофайл.",
  AppConstants.stateOfMind: "Стан душі",

  // Mood Colors
  AppConstants.moodColors: "Кольори настрою",
  AppConstants.customizeMoodColors: "Налаштувати кольори настрою",
  AppConstants.reset: "Скинути",
  AppConstants.resetMoodColors: "Скинути до стандартних",
  AppConstants.resetMoodColorsConfirm:
      "Скинути всі кольори настрою до стандартних значень?",
  AppConstants.paletteThemes: "Теми палітри",
  AppConstants.customColor: "Власний колір",
  AppConstants.moodUnsavedChangesMessage:
      "У вас є незбережені зміни кольорів настрою. Зберегти їх перед закриттям?",

  // Drafts & Auto-save
  AppConstants.drafts: "Чернетки",
  AppConstants.draft: "Чернетка",
  AppConstants.draftSaved: "Збережено до чернеток",
  AppConstants.unsavedChanges: "Незбережені зміни",
  AppConstants.unsavedChangesMessage:
      "У вас є незбережені зміни. Зберегти їх як чернетку чи скасувати?",
  AppConstants.saveAsDraft: "Зберегти як чернетку",
  AppConstants.discardChanges: "Скасувати",
  AppConstants.autoDeleteDrafts: "Автовидалення чернеток",
  AppConstants.days7: "7 днів",
  AppConstants.never: "Ніколи",
  AppConstants.custom: "Власне...",
  AppConstants.enterCustomDays: "Введіть кількість днів",
  AppConstants.customDaysExample: "Напр., 14",
  AppConstants.days: "днів",
  AppConstants.draftsNeverDeleted: "Чернетки ніколи не будуть видалені",
  AppConstants.draftsDeletedAfterDays: "Чернетки буде видалено через %d дн.",

  // Home Menu & Sorting
  AppConstants.sortBy: "Сортувати",
  AppConstants.insights: "Статистика",
  AppConstants.reflections: "Роздуми",
  AppConstants.settings: "Налаштування",
  AppConstants.entryTime: "Час запису",
  AppConstants.bookmarkFirst: "Спочатку закладки",
  AppConstants.reflectionFirst: "Спочатку роздуми",
  AppConstants.withMediaFirst: "Спочатку з медіа",
  AppConstants.textOnlyFirst: "Спочатку лише текст",
  AppConstants.withLocationFirst: "Спочатку з місцем",
  AppConstants.withMoodFirst: "Спочатку з настроєм",
  AppConstants.withTagsFirst: "Спочатку з тегами",

  // Insights
  AppConstants.stats: "Статистика",
  AppConstants.calendar: "Календар",
  AppConstants.entriesSuffix: " зап.",
  AppConstants.memoriesFromThisDay: "Спогади цього дня",
  AppConstants.standard: "Звичайний",
  AppConstants.media: "Медіа",
  AppConstants.mood: "Настрій",
  AppConstants.mostly: "Переважно",
  AppConstants.averageForThisDay: "Середнє за цей день",
  AppConstants.averageForThisYear: "Середнє за цей рік",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Ласкаво просимо до OpenJot",
  AppConstants.feature1:
      "Пишіть вільно, додавайте фото та місця й зберігайте все безпечно на своєму пристрої.",
  AppConstants.feature2:
      "Розумійте свої емоції з часом завдяки вбудованому відстеженню настрою.",
  AppConstants.feature3:
      "Ваші дані залишаються на телефоні — без хмари, лише локальне сховище та повна приватність.",
  AppConstants.continueButton: "Продовжити",

  // Notifications
  AppConstants.notificationTitle: "Час для щоденника!",
  AppConstants.notificationBody: "Не забудьте записати свої думки за день.",
  AppConstants.notificationChannelName: "Щоденні нагадування",
  AppConstants.notificationChannelDescription:
      "Канал для щоденних нагадувань про щоденник",
  AppConstants.onThisDayChannelName: "Спогади «Цього дня»",
  AppConstants.onThisDayChannelDescription:
      "Сповіщення про спогади з минулих років.",
  AppConstants.onThisDayNotificationTitle: "Спогад із вашого щоденника",
  AppConstants.onThisDaySingleEntry:
      "Рік тому сьогодні ви написали щось особливе. Натисніть, щоб перечитати свої думки.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Цього дня торік ви зберегли цей спогад. Натисніть, щоб пережити його знову.",
  AppConstants.onThisDayMultipleEntries:
      "У вас є спогади за цей день з минулих років. Натисніть, щоб переглянути їх.",
  AppConstants.onThisDayGroupedNotification: "У вас %d спогадів за цей день",

  // Exclude Entries
  AppConstants.excludeEntries: "Виключити записи",
  AppConstants.saveExclusions: "Зберегти виключення",
  AppConstants.excludeUnsavedChangesMessage:
      "У вас є незбережені зміни. Ви впевнені, що хочете вийти без збереження?",
  AppConstants.sortDefault: "За замовчуванням",
  AppConstants.sortMutedFirst: "Спочатку приховані",
  AppConstants.sortUnmutedFirst: "Спочатку активні",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Сьогодні",
  AppConstants.yesterday: "Учора",
  AppConstants.contentForQuote: "Текст для цитати",
  AppConstants.noContentSelected: "Нічого не вибрано.",
  AppConstants.photos: "Фото",
  AppConstants.video: "Відео",
  AppConstants.audio: "Аудіо",
  AppConstants.add: "Додати",
  AppConstants.noMediaFound: "%s не знайдено.",
  AppConstants.permissionRequired:
      "Для відображення потрібен дозвіл на доступ до %s.",
  AppConstants.openSettings: "Відкрити налаштування",
  AppConstants.videos: "Відео",
  AppConstants.audios: "Аудіо",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Видалити запис?",
  AppConstants.deleteRecordingMessage:
      "Ви впевнені, що хочете видалити цей запис?",
  AppConstants.listen: "Слухати",
  AppConstants.tapAndHold: "натисніть і утримуйте",
  AppConstants.clear: "Очистити",
  AppConstants.all: "Усі",
  AppConstants.folder: "Папка",
  AppConstants.browse: "Огляд",
  AppConstants.tiles: "Плитки",
  AppConstants.graph: "Графік",
  AppConstants.recording: "Триває запис...",
  AppConstants.recordingLabel: "Запис",
  AppConstants.startAudioRecording: "Почати аудіозапис",
  AppConstants.howAreYouFeeling: "Як ви почуваєтеся?",
  AppConstants.paused: "Пауза",
  AppConstants.stop: "Стоп",
  AppConstants.tapOrHoldToResume: "Натисніть або утримуйте для продовження",
  AppConstants.tapOrReleaseToPause: "Натисніть або відпустіть для паузи",
  AppConstants.unsupportedImageType: "Непідтримуваний тип зображення",
  AppConstants.couldNotLoadVideo: "Не вдалося завантажити відео",
  AppConstants.couldNotOpenMap: "Не вдалося відкрити посилання на мапу.",
  AppConstants.dismiss: "Закрити",
  AppConstants.selectTime: "Виберіть час",
  AppConstants.now: "Зараз",
  AppConstants.searchPlacesHint: "Пошук місць, закладів...",
  AppConstants.locationPermissionDenied: "Доступ до місцезнаходження заборонено.",
  AppConstants.failedGetCurrentLocation:
      "Не вдалося отримати поточне місцезнаходження.",

  // Search
  AppConstants.searchJournalsHint: "Пошук у щоденниках...",
  AppConstants.textOnly: "Лише текст",
  AppConstants.withMedia: "З медіа",
  AppConstants.withMood: "З настроєм",
  AppConstants.withLocation: "З місцем",
  AppConstants.withTags: "З тегами",
  AppConstants.noResultsFound: "Нічого не знайдено",
  AppConstants.searchHintText: "Пошук записів...",

  // Settings
  AppConstants.language: "Мова",
  AppConstants.selectLanguage: "Виберіть мову",
  AppConstants.systemDefault: "Системна за замовчуванням",
  AppConstants.searchLanguagesHint: "Пошук мов...",
  AppConstants.languageChanged: "Мову змінено на %s.",
  AppConstants.dailyReminder: "Нагадування",
  AppConstants.addReminder: "Додати нагадування",
  AppConstants.deleteReminder: "Видалити нагадування",
  AppConstants.noRemindersSet: "Нагадувань не встановлено.",
  AppConstants.onThisDay: "Цього дня",
  AppConstants.appLock: "Блокування додатка",
  AppConstants.backup: "Резервна копія",
  AppConstants.restore: "Відновити",
  AppConstants.importFromAnotherApp: "Імпорт з іншого додатка",
  AppConstants.importFromDailyYou: "Імпорт з Daily You",
  AppConstants.selectDailyYouBackup:
      "Виберіть zip-файл резервної копії Daily You",
  AppConstants.importingEntries: "Імпортування записів...",
  AppConstants.importSuccess: "Успішно імпортовано %d записів із Daily You!",
  AppConstants.importFailed: "Помилка імпорту: %s",
  AppConstants.noEntriesToImport: "Нових записів для імпорту не знайдено.",
  AppConstants.askSupport: "Звернутися до підтримки",
  AppConstants.importSupportNote:
      "Формати інших додатків можуть підтримувати не всі функції. Якщо виникнуть проблеми або формат зміниться, повідомте про помилку.",
  AppConstants.extractingBackup: "Розпакування резервної копії...",
  AppConstants.parsingDatabase: "Обробка бази даних...",
  AppConstants.dailyYouDbNotFound:
      "Базу даних Daily You не знайдено в резервній копії.",
  AppConstants.privacyPolicy: "Політика конфіденційності",
  AppConstants.termsNConditions: "Умови використання",
  AppConstants.about: "Про додаток",
  AppConstants.changeTheme: "Змінити тему",
  AppConstants.theme: "Тема",
  AppConstants.pitchBlack: "Глибокий чорний",
  AppConstants.themeLight: "Світла",
  AppConstants.themeDark: "Темна",
  AppConstants.themeSystem: "Системна",
  AppConstants.changePin: "Змінити PIN",
  AppConstants.loading: "Завантаження...",
  AppConstants.confirmRestoreTitle: "Підтвердіть відновлення",
  AppConstants.confirmRestoreMessage:
      "Відновлення з резервної копії перезапише всі поточні дані. Цю дію неможливо скасувати. Продовжити?",
  AppConstants.notificationScheduled: "Нагадування заплановано на %s",
  AppConstants.notificationCanceled: "Нагадування скасовано",
  AppConstants.notificationRescheduled: "Нагадування перенесено на %s",
  AppConstants.notificationPermissionRequired:
      "Для налаштування нагадувань потрібен дозвіл на сповіщення.",
  AppConstants.pinChangedSuccess: "PIN успішно змінено",
  AppConstants.onThisDayOn: "Тепер ви отримуватимете спогади за цей день.",
  AppConstants.onThisDayOff: "Нагадування «Цього дня» вимкнено.",
  AppConstants.themeChanged: "Обрано тему: %s.",
  AppConstants.hideStats: "Приховати статистику",
  AppConstants.hideHomeStats: "Приховати статистику на головній",
  AppConstants.hideInsightsStats: "Приховати статистику в Аналітиці",

  // Reflection Sheet
  AppConstants.reflectionTitle: "РОЗДУМ",
  AppConstants.reflectButton: "Міркувати",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Неправильний PIN",
  AppConstants.verifyYourPin: "Підтвердіть свій PIN",
  AppConstants.setAPin: "Установити PIN",
  AppConstants.confirmPin: "Підтвердіть PIN",
  AppConstants.pinsDoNotMatch: "PIN-коди не збігаються",
  AppConstants.setPin: "Установити PIN",
  AppConstants.hello: "Вітаємо!",
  AppConstants.enterYourPin: "Введіть ваш PIN",
  AppConstants.useBiometrics: "Використовувати біометрію",
  AppConstants.authenticateToUnlock:
      "Пройдіть автентифікацію, щоб розблокувати додаток",
  AppConstants.databaseEncryption: "Шифрування бази даних",
  AppConstants.databaseEncryptionDesc: "Локальне шифрування AES-256-GCM",
  AppConstants.changeMasterPassword: "Змінити майстер-пароль",
  AppConstants.biometricUnlock: "Біометричне розблокування",
  AppConstants.enterMasterPassword: "Введіть майстер-пароль",
  AppConstants.enterMasterPasswordHint:
      "Введіть майстер-пароль, щоб розшифрувати ваш щоденник.",
  AppConstants.unlockButton: "Розблокувати",
  AppConstants.unlockWithBiometrics: "Розблокувати біометрією",
  AppConstants.incorrectMasterPassword:
      "Неправильний майстер-пароль. Спробуйте ще раз.",
  AppConstants.databaseEncryptedSuccess:
      "Базу даних щоденника зашифровано за допомогою AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Базу даних розшифровано, блокування додатка вимкнено.",
  AppConstants.masterPasswordChangedSuccess: "Майстер-пароль успішно оновлено.",
  AppConstants.encryptedBackupPasswordRequired:
      "Для відкриття зашифрованої резервної копії потрібен пароль.",
  AppConstants.incorrectBackupPassword: "Неправильний пароль резервної копії.",
  AppConstants.invalidBackupFile:
      "Вибраний файл не є коректною резервною копією OpenJot.",
  AppConstants.encryptedBackup: "Зашифрована копія (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Захищено AES-256-GCM і паролем резервної копії",
  AppConstants.standardBackup: "Стандартна копія (.zip)",
  AppConstants.standardBackupDesc:
      "Незашифрований архів, сумісний з усіма версіями",
  AppConstants.takingBackup: "Створення резервної копії...",
  AppConstants.encryptingBackup: "Шифрування резервної копії...",
  AppConstants.savingBackup: "Збереження резервної копії...",
  AppConstants.preparingBackup: "Підготовка резервної копії...",
  AppConstants.decryptingBackup: "Розшифрування резервної копії...",
  AppConstants.restoringBackup: "Відновлення резервної копії...",
  AppConstants.backupEncodingFailed:
      "Не вдалося закодувати файл резервної копії.",
  AppConstants.backupCreatedSuccess: "Резервну копію успішно створено!",
  AppConstants.backupFailed: "Не вдалося створити резервну копію: %s",
  AppConstants.restorePermissionsRequired:
      "Для відновлення даних потрібні дозволи на доступ до сховища й медіа.",
  AppConstants.databaseRestoredNoMedia:
      "Базу даних відновлено. Медіафайлів у копії не знайдено.",
  AppConstants.restoreSuccess: "Відновлення успішне!",
  AppConstants.restoreSuccessRestartRecommended:
      "Відновлення успішне. Рекомендується перезапустити додаток для застосування змін.",
  AppConstants.restoreFailed: "Не вдалося відновити дані: %s",
  AppConstants.storagePermissionsRequired:
      "Для створення резервної копії потрібні дозволи на доступ до сховища й медіа.",
  AppConstants.selectBackupFolder:
      "Виберіть папку для збереження резервної копії",
  AppConstants.encryptDatabase: "Зашифрувати базу даних",
  AppConstants.disableEncryption: "Вимкнути шифрування",
  AppConstants.backupPasswordTitle: "Пароль резервної копії",
  AppConstants.changeMasterPasswordDesc:
      "Введіть поточний майстер-пароль і виберіть новий пароль (мінімум 6 символів).",
  AppConstants.disableEncryptionDesc:
      "Введіть майстер-пароль, щоб розшифрувати базу даних на диску та вимкнути шифрування.",
  AppConstants.enableEncryptionDesc:
      "Захистіть усі нотатки щоденника локально шифруванням AES-256-GCM. Якщо ви забудете майстер-пароль, зашифровані дані неможливо буде відновити.",
  AppConstants.verifyForBiometricsDesc:
      "Введіть майстер-пароль один раз, щоб зберегти ключ розблокування в захищеному апаратному сховищі для швидкого біометричного входу.",
  AppConstants.createBackupPasswordDesc:
      "Установіть надійний пароль для шифрування цієї копії .openjot. Він знадобиться для відновлення на будь-якому пристрої.",
  AppConstants.enterBackupPasswordDesc:
      "Введіть пароль, використаний під час створення цієї копії .openjot.",
  AppConstants.updatePasswordAction: "Оновити пароль",
  AppConstants.decryptAndDisable: "Розшифрувати й вимкнути",
  AppConstants.enableBiometricsAction: "Увімкнути біометрію",
  AppConstants.createBackupAction: "Створити копію",
  AppConstants.decryptBackupAction: "Розшифрувати копію",
  AppConstants.newMasterPasswordHint: "Новий майстер-пароль",
  AppConstants.backupPasswordHint: "Пароль резервної копії",
  AppConstants.masterPasswordHint: "Майстер-пароль",
  AppConstants.enterCurrentMasterPasswordError:
      "Будь ласка, введіть поточний майстер-пароль.",
  AppConstants.passwordEmptyError: "Пароль не може бути порожнім.",
  AppConstants.passwordMinLengthError:
      "Пароль має містити щонайменше 6 символів.",
  AppConstants.passwordsDoNotMatchError: "Паролі не збігаються.",
  AppConstants.currentMasterPasswordHint: "Поточний майстер-пароль",
  AppConstants.confirmPasswordHint: "Підтвердіть пароль",

  // About & Terms
  AppConstants.aboutApp: "Про OpenJot",
  AppConstants.versionPrefix: "Версія: %s",
  AppConstants.aboutSubtitle:
      "Мінімалістичний щоденник з відкритим вихідним кодом для ваших думок, настроїв і спогадів. Усі дані залишаються на вашому пристрої.",
  AppConstants.keyFeatures: "Основні можливості",
  AppConstants.aboutFeature1: "• Чистий інтерфейс для письма без відволікань.",
  AppConstants.aboutFeature2:
      "• Додавайте фото, голосові нотатки й музику до записів.",
  AppConstants.aboutFeature3: "• Фіксуйте свій настрій поруч із записами.",
  AppConstants.aboutFeature4: "• Персоналізуйте різними стилями тексту.",
  AppConstants.aboutFeature5:
      "• Працює повністю офлайн, дані залишаються на вашому пристрої.",
  AppConstants.openSource: "Відкритий код",
  AppConstants.openSourceDesc:
      "OpenJot — це додаток з відкритим вихідним кодом. Код публічно доступний кожному для перегляду, змін і внесків. Ми віримо у прозорість і співпрацю спільноти.",
  AppConstants.dataPrivacy: "Конфіденційність даних",
  AppConstants.dataPrivacyDesc:
      "Ми цінуємо вашу приватність. OpenJot не збирає, не зберігає й не передає ваші особисті дані. Усі записи, включно з текстом, зображеннями й аудіо, зберігаються виключно на вашому пристрої.",
  AppConstants.linksTitle: "Посилання",
  AppConstants.sourceCodeOnGithub: "Вихідний код на GitHub",
  AppConstants.sendFeedback: "Надіслати відгук",
  AppConstants.couldNotLaunchUrl: "Не вдалося відкрити URL",
  AppConstants.termsIntro:
      "Ласкаво просимо до OpenJot! Цей документ описує умови використання нашого додатка. Використовуючи OpenJot, ви погоджуєтеся з цими умовами.",
  AppConstants.termsSectionDataPrivacy: "Зберігання даних і приватність",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot створено як приватний простір для ваших думок. Усі записи, включно з текстом, зображеннями, аудіофайлами та іншими медіа, зберігаються виключно локально на вашому пристрої. Додаток не збирає, не зберігає і не надсилає персональні дані на зовнішні сервери. Ми не маємо доступу до вашого вмісту.",
  AppConstants.termsSectionUserContent: "Контент користувача",
  AppConstants.termsSectionUserContentBody:
      "Ви несете повну відповідальність за контент, який створюєте і зберігаєте в OpenJot, включно з текстом, зображеннями, аудіозаписами та іншими файлами. Ви відповідаєте за наявність необхідних прав на будь-який контент, що імпортується в додаток.",
  AppConstants.termsSectionDisclaimer: "Відмова від гарантій",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot надається «як є» без жодних прямих чи непрямих гарантій. Ми не гарантуємо безпомилкову або безперебійну роботу додатка. Ви використовуєте його на власний ризик.",
  AppConstants.termsSectionLiability: "Обмеження відповідальності",
  AppConstants.termsSectionLiabilityBody:
      "За жодних обставин розробники OpenJot не несуть відповідальності за будь-які прямі, непрямі, випадкові, спеціальні чи непрямі збитки, зокрема втрату даних, що виникли внаслідок використання або неможливості використання цього додатка.",
  AppConstants.termsSectionThirdParty: "Сторонні бібліотеки",
  AppConstants.termsSectionThirdPartyBody:
      "Цей додаток використовує наведені нижче сторонні бібліотеки, кожна з яких регулюється власною ліцензією:",

  // Months
  'January': 'Січень',
  'February': 'Лютий',
  'March': 'Березень',
  'April': 'Квітень',
  'May': 'Травень',
  'June': 'Червень',
  'July': 'Липень',
  'August': 'Серпень',
  'September': 'Вересень',
  'October': 'Жовтень',
  'November': 'Листопад',
  'December': 'Грудень',

  // Reflection Prompts (62)
  "What made you smile today?": "Що змусило вас усміхнутися сьогодні?",
  "Who are you thankful for this week, and why?":
      "Кому ви вдячні цього тижня і чому?",
  "What is something small that brought you joy today?":
      "Яка дрібниця принесла вам радість сьогодні?",
  "Which part of your day felt most comforting?":
      "Яка частина дня була для вас найзатишнішою?",
  "What’s something you often take for granted but appreciate now?":
      "Що ви зазвичай сприймаєте як належне, але цінуєте зараз?",
  "What’s the best thing that happened today?":
      "Що найкраще сталося сьогодні?",
  "Did someone make your day easier today?":
      "Чи полегшив хтось ваш день сьогодні?",
  "Who made a positive impact on you recently?":
      "Хто нещодавно позитивно вплинув на вас?",
  "What’s a quality you admire in someone close to you?":
      "Якою рисою близької людини ви захоплюєтеся?",
  "When did you last feel truly connected with someone?":
      "Коли ви востаннє відчували справжній зв’язок із кимось?",
  "Who do you want to reach out to soon?":
      "З ким ви хочете зв’язатися найближчим часом?",
  "Did someone’s kindness stand out today?":
      "Чи запам’яталася вам сьогодні чиясь доброта?",
  "How did you support someone else recently?":
      "Як ви підтримали когось нещодавно?",
  "Who do you miss the most right now?":
      "За ким ви сумуєте найбільше прямо зараз?",
  "What’s a moment from today you want to remember?":
      "Яку мить сьогоднішнього дня ви хочете запам’ятати?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Яку деталь сьогоднішнього дня ви можете забути, якщо не запишете?",
  "What’s the most peaceful moment you had today?":
      "Яка мить сьогодні була найспокійнішою?",
  "Did you see something beautiful today?":
      "Чи бачили ви сьогодні щось прекрасне?",
  "Which memory from this week stands out?":
      "Який спогад цього тижня виділяється найбільше?",
  "What song, photo, or place will always remind you of today?":
      "Яка пісня, фото чи місце завжди нагадуватимуть вам про сьогодні?",
  "What surprised you today?": "Що здивувало вас сьогодні?",
  "What challenge did you overcome today?":
      "Який виклик ви подолали сьогодні?",
  "What’s a small win you had today?":
      "Яка маленька перемога у вас була сьогодні?",
  "What new thing did you learn about yourself recently?":
      "Що нового ви нещодавно дізналися про себе?",
  "What are you proud of yourself for?": "Чим у собі ви пишаєтеся?",
  "What habit do you feel good about keeping?":
      "Яку звичку вам приємно підтримувати?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Яке одне покращення у собі ви помітили цього року?",
  "How did you push yourself out of your comfort zone?":
      "Як ви вийшли зі своєї зони комфорту?",
  "How are you truly feeling right now?":
      "Як ви насправді почуваєтеся прямо зараз?",
  "Which emotion stood out the most today?":
      "Яка емоція переважала сьогодні?",
  "Did you feel present in any moment today?":
      "Чи відчували ви себе в теперішньому моменті сьогодні?",
  "When did you feel the most at peace today?":
      "Коли сьогодні ви відчували найбільший спокій?",
  "What gave you energy today?": "Що дало вам енергію сьогодні?",
  "What drained your energy today?": "Що виснажило вашу енергію сьогодні?",
  "If your mood had a color today, what would it be?":
      "Якби ваш сьогоднішній настрій мав колір, яким би він був?",
  "What’s something you’re excited about tomorrow?":
      "Чого ви з нетерпінням чекаєте завтра?",
  "What’s one thing you want to improve tomorrow?":
      "Що одне ви хочете покращити завтра?",
  "What would make tomorrow feel successful?":
      "Що зробить завтрашній день успішним?",
  "What do you hope to achieve this week?":
      "Чого ви сподіваєтеся досягти цього тижня?",
  "What’s a habit you’d like to start tomorrow?":
      "Яку звичку ви хотіли б почати завтра?",
  "What’s something you want to look forward to in the next month?":
      "Чого вам хочеться чекати наступного місяця?",
  "What would your ideal tomorrow look like?":
      "Яким би виглядав ваш ідеальний завтрашній день?",
  "What’s one lesson you learned recently?":
      "Який один урок ви засвоїли нещодавно?",
  "If you could freeze one moment today, which would it be?":
      "Якби ви могли зупинити одну мить сьогодні, яка б це була?",
  "What makes your life feel meaningful right now?":
      "Що зараз робить ваше життя змістовним?",
  "If you described today in one word, what would it be?":
      "Якби ви описали сьогоднішній день одним словом, яким би воно було?",
  "What inspired you today?": "Що надихнуло вас сьогодні?",
  "What did you notice today that you usually overlook?":
      "Що ви помітили сьогодні, чого зазвичай не помічаєте?",
  "How has today changed your perspective?":
      "Як сьогоднішній день змінив ваш погляд?",
  "What’s something you’ve been overthinking?":
      "Про що ви занадто багато думаєте останнім часом?",
  "What do you need to let go of?": "Що вам потрібно відпустити?",
  "What part of nature did you notice today?":
      "На що в природі ви звернули увагу сьогодні?",
  "Did the weather affect your mood today?":
      "Чи вплинула погода на ваш настрій сьогодні?",
  "What place felt most comforting today?":
      "Яке місце здалося вам найзатишнішим сьогодні?",
  "Where did you feel most at home today?":
      "Де ви почувалися найбільш як удома сьогодні?",
  "What sound or smell reminded you of something important?":
      "Який звук чи запах нагадав вам про щось важливе?",
  "How did you take care of yourself today?":
      "Як ви подбали про себе сьогодні?",
  "When did you feel most like yourself today?":
      "Коли сьогодні ви почувалися найбільше собою?",
  "What’s something kind you can say to yourself right now?":
      "Які добрі слова ви можете сказати собі прямо зараз?",
  "What do you want to forgive yourself for?":
      "За що ви хочете пробачити собі?",
  "What do you deserve more of in your life?":
      "Чого ви заслуговуєте більше у своєму житті?",
};

/// Complete Czech (Čeština) translations for OpenJot.
final Map<String, String> csTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Můj deník",
  AppConstants.noEntriesMessage: "Zatím žádné záznamy v deníku. Začněte psát!",
  AppConstants.noBookmarksYet: "Zatím žádné záložky.",
  AppConstants.noDraftsYet: "Zatím žádné koncepty.",
  AppConstants.addEntryButton: "Přidat nový záznam",
  AppConstants.jotYourThoughts: "Zapište své myšlenky",
  AppConstants.tapToCreateJournal:
      "Klepnutím na + vytvoříte svůj osobní deník.",
  AppConstants.entriesThisYear: "Záznamů v tomto roce",
  AppConstants.wordsWritten: "Napsaných slov",
  AppConstants.daysJournaled: "Dnů se zápisem",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Nový záznam v deníku",
  AppConstants.editEntryAppBarTitle: "Upravit záznam",
  AppConstants.titleHintText: "Název (např. 'Můj den', 'Myšlenky o...')",
  AppConstants.contentHintText: "Napište své myšlenky sem...",
  AppConstants.saveButton: "Uložit záznam",
  AppConstants.updateButton: "Aktualizovat",
  AppConstants.deleteButton: "Smazat záznam",
  AppConstants.requiredFieldMessage: "Toto pole nemůže být prázdné.",
  AppConstants.newEntry: "Nový záznam",
  AppConstants.todayDate: "Dnešní datum",
  AppConstants.customDate: "Vlastní datum",
  AppConstants.done: "Hotovo",
  AppConstants.startWriting: " Začněte psát...",
  AppConstants.tags: "Štítky",
  AppConstants.addTags: "Přidat štítky",
  AppConstants.openInMaps: "Otevřít v Mapách",
  AppConstants.changeLocation: "Změnit polohu",
  AppConstants.remove: "Odebrat",
  AppConstants.discardSelectionsTitle: "Zahodit výběr?",
  AppConstants.discardSelectionsMessage:
      "Vybrali jste média nebo aktivní nahrávku. Opravdu je chcete zahodit?",
  AppConstants.journalEntryEmpty: "Záznam v deníku nesmí být prázdný",
  AppConstants.discardDateConfirm:
      "Zahodit vybrané datum/čas pro tento záznam?",
  AppConstants.addMediaLocationMoodFirst:
      "Nejprve přidejte média, polohu nebo náladu",
  AppConstants.location: "Poloha",
  AppConstants.record: "Nahrát",
  AppConstants.selectMomentsToJournal: "Vyberte momenty pro zápis",
  AppConstants.addMomentsFromMenu:
      "Přidejte média, polohu, nahrávku nebo náladu z nabídky",
  AppConstants.writeSomething: "Napsat něco",
  AppConstants.saveWithoutWriting: "Uložit bez psaní",
  AppConstants.oneLocation: "1 místo",
  AppConstants.mediaCount: "%d médií",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Potvrdit smazání",
  AppConstants.confirmDeleteMessage: "Opravdu chcete tento záznam smazat?",
  AppConstants.pleaseConfirm: "Prosím potvrďte",
  AppConstants.confirmDeleteJournalEntry:
      "Opravdu chcete smazat tento záznam z deníku? Tuto akci nelze vrátit zpět.",
  AppConstants.yes: "Ano",
  AppConstants.no: "Ne",
  AppConstants.cancel: "Zrušit",
  AppConstants.delete: "Smazat",
  AppConstants.save: "Uložit",
  AppConstants.entrySavedSuccess: "Záznam byl úspěšně uložen!",
  AppConstants.entryUpdatedSuccess: "Záznam byl úspěšně aktualizován!",
  AppConstants.entryDeletedSuccess: "Záznam byl smazán.",
  AppConstants.errorSavingEntry: "Chyba při ukládání záznamu.",
  AppConstants.errorDeletingEntry: "Chyba při mazání záznamu.",
  AppConstants.errorLoadingEntries: "Chyba při načítání záznamů.",
  AppConstants.noEntriesForDate: "Pro toto datum nejsou žádné záznamy.",
  AppConstants.noEntriesForMonth: "Pro tento měsíc nebyly nalezeny žádné záznamy.",
  AppConstants.selectMonthAndYear: "Vyberte měsíc a rok",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Velmi nepříjemné",
  AppConstants.unpleasant: "Nepříjemné",
  AppConstants.slightlyUnpleasant: "Mírně nepříjemné",
  AppConstants.neutral: "Neutrální",
  AppConstants.slightlyPleasant: "Mírně příjemné",
  AppConstants.pleasant: "Příjemné",
  AppConstants.veryPleasant: "Velmi příjemné",
  AppConstants.reflection: "Reflexe",
  AppConstants.edit: "Upravit",
  AppConstants.removeBookmark: "Odebrat záložku",
  AppConstants.bookmark: "Záložka",
  AppConstants.share: "Sdílet",
  AppConstants.saveAsPdf: "Uložit jako PDF",
  AppConstants.audioTrack: "Zvuková stopa",
  AppConstants.generatingPdf: "Generování PDF...",
  AppConstants.voiceRecording: "Hlasová nahrávka",
  AppConstants.audioRecording: "Zvuková nahrávka",
  AppConstants.couldNotLoadAudio: "Zvukový soubor se nepodařilo načíst.",
  AppConstants.stateOfMind: "Stav mysli",

  // Mood Colors
  AppConstants.moodColors: "Barvy nálad",
  AppConstants.customizeMoodColors: "Přizpůsobit barvy nálad",
  AppConstants.reset: "Obnovit",
  AppConstants.resetMoodColors: "Obnovit výchozí",
  AppConstants.resetMoodColorsConfirm:
      "Obnovit všechny barvy nálad na výchozí hodnoty?",
  AppConstants.paletteThemes: "Motivy palety",
  AppConstants.customColor: "Vlastní barva",
  AppConstants.moodUnsavedChangesMessage:
      "Máte neuložené změny barev nálad. Chcete je před zavřením uložit?",

  // Drafts & Auto-save
  AppConstants.drafts: "Koncepty",
  AppConstants.draft: "Koncept",
  AppConstants.draftSaved: "Uloženo do konceptů",
  AppConstants.unsavedChanges: "Neuložené změny",
  AppConstants.unsavedChangesMessage:
      "Máte neuložené změny. Chcete je uložit jako koncept, nebo je zahodit?",
  AppConstants.saveAsDraft: "Uložit jako koncept",
  AppConstants.discardChanges: "Zahodit",
  AppConstants.autoDeleteDrafts: "Automaticky mazat koncepty",
  AppConstants.days7: "7 dní",
  AppConstants.never: "Nikdy",
  AppConstants.custom: "Vlastní...",
  AppConstants.enterCustomDays: "Zadejte počet dní",
  AppConstants.customDaysExample: "Např. 14",
  AppConstants.days: "dní",
  AppConstants.draftsNeverDeleted: "Koncepty nebudou nikdy smazány",
  AppConstants.draftsDeletedAfterDays: "Koncepty budou smazány po %d dnech",

  // Home Menu & Sorting
  AppConstants.sortBy: "Seřadit podle",
  AppConstants.insights: "Přehledy",
  AppConstants.reflections: "Reflexe",
  AppConstants.settings: "Nastavení",
  AppConstants.entryTime: "Čas záznamu",
  AppConstants.bookmarkFirst: "Nejprve záložky",
  AppConstants.reflectionFirst: "Nejprve reflexe",
  AppConstants.withMediaFirst: "Nejprve s médii",
  AppConstants.textOnlyFirst: "Nejprve pouze text",
  AppConstants.withLocationFirst: "Nejprve s polohou",
  AppConstants.withMoodFirst: "Nejprve s náladou",
  AppConstants.withTagsFirst: "Nejprve se štítky",

  // Insights
  AppConstants.stats: "Statistiky",
  AppConstants.calendar: "Kalendář",
  AppConstants.entriesSuffix: " záznamů",
  AppConstants.memoriesFromThisDay: "Vzpomínky z tohoto dne",
  AppConstants.standard: "Standardní",
  AppConstants.media: "Média",
  AppConstants.mood: "Nálada",
  AppConstants.mostly: "Většinou",
  AppConstants.averageForThisDay: "Průměr pro tento den",
  AppConstants.averageForThisYear: "Průměr pro tento rok",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Vítejte v OpenJot",
  AppConstants.feature1:
      "Pište svobodně, přidávejte fotky a místa a uchovávejte vše bezpečně na svém zařízení.",
  AppConstants.feature2:
      "Porozumějte svým emocím v průběhu času díky integrovanému sledování nálady.",
  AppConstants.feature3:
      "Vaše data zůstávají v telefonu – žádný cloud, jen lokální úložiště a naprosté soukromí.",
  AppConstants.continueButton: "Pokračovat",

  // Notifications
  AppConstants.notificationTitle: "Čas psát deník!",
  AppConstants.notificationBody: "Nezapomeňte si zapsat své dnešní myšlenky.",
  AppConstants.notificationChannelName: "Denní připomínky deníku",
  AppConstants.notificationChannelDescription:
      "Kanál pro každodenní připomínky psaní deníku",
  AppConstants.onThisDayChannelName: "Vzpomínky V tento den",
  AppConstants.onThisDayChannelDescription:
      "Oznámení o vzpomínkách z minulých let.",
  AppConstants.onThisDayNotificationTitle: "Vzpomínka z vašeho deníku",
  AppConstants.onThisDaySingleEntry:
      "Před rokem v tento den jste napsali něco výjimečného. Klepnutím si připomeňte své myšlenky.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "V tento den před rokem jste uložili tuto vzpomínku. Klepnutím si ji znovu prožijte.",
  AppConstants.onThisDayMultipleEntries:
      "Z tohoto dne máte vzpomínky z minulých let. Klepnutím je zobrazíte.",
  AppConstants.onThisDayGroupedNotification: "Máte %d vzpomínek z tohoto dne",

  // Exclude Entries
  AppConstants.excludeEntries: "Vyloučit záznamy",
  AppConstants.saveExclusions: "Uložit vyloučení",
  AppConstants.excludeUnsavedChangesMessage:
      "Máte neuložené změny. Opravdu je chcete zahodit a odejít?",
  AppConstants.sortDefault: "Výchozí",
  AppConstants.sortMutedFirst: "Nejprve skryté",
  AppConstants.sortUnmutedFirst: "Nejprve zobrazené",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Dnes",
  AppConstants.yesterday: "Včera",
  AppConstants.contentForQuote: "Obsah pro citát",
  AppConstants.noContentSelected: "Nebyl vybrán žádný obsah.",
  AppConstants.photos: "Fotky",
  AppConstants.video: "Video",
  AppConstants.audio: "Audio",
  AppConstants.add: "Přidat",
  AppConstants.noMediaFound: "Nenalezeny žádné položky: %s.",
  AppConstants.permissionRequired:
      "Pro zobrazení je vyžadováno oprávnění k přístupu k %s.",
  AppConstants.openSettings: "Otevřít nastavení",
  AppConstants.videos: "Videa",
  AppConstants.audios: "Zvuky",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Smazat nahrávku?",
  AppConstants.deleteRecordingMessage:
      "Opravdu chcete smazat tuto nahrávku?",
  AppConstants.listen: "Poslechnout",
  AppConstants.tapAndHold: "klepněte a podržte",
  AppConstants.clear: "Vymazat",
  AppConstants.all: "Vše",
  AppConstants.folder: "Složka",
  AppConstants.browse: "Procházet",
  AppConstants.tiles: "Dlaždice",
  AppConstants.graph: "Graf",
  AppConstants.recording: "Nahrávání...",
  AppConstants.recordingLabel: "Nahrávka",
  AppConstants.startAudioRecording: "Spustit nahrávání zvuku",
  AppConstants.howAreYouFeeling: "Jak se cítíte?",
  AppConstants.paused: "Pozastaveno",
  AppConstants.stop: "Zastavit",
  AppConstants.tapOrHoldToResume: "Klepnutím nebo podržením pokračujte",
  AppConstants.tapOrReleaseToPause: "Klepnutím nebo uvolněním pozastavíte",
  AppConstants.unsupportedImageType: "Nepodporovaný formát obrázku",
  AppConstants.couldNotLoadVideo: "Video se nepodařilo načíst",
  AppConstants.couldNotOpenMap: "Nepodařilo se otevřít odkaz na mapu.",
  AppConstants.dismiss: "Zavřít",
  AppConstants.selectTime: "Vyberte čas",
  AppConstants.now: "Nyní",
  AppConstants.searchPlacesHint: "Hledat místa, obchody...",
  AppConstants.locationPermissionDenied: "Oprávnění k poloze bylo zamítnuto.",
  AppConstants.failedGetCurrentLocation:
      "Nepodařilo se získat aktuální polohu.",

  // Search
  AppConstants.searchJournalsHint: "Hledat v denících...",
  AppConstants.textOnly: "Pouze text",
  AppConstants.withMedia: "S médii",
  AppConstants.withMood: "S náladou",
  AppConstants.withLocation: "S polohou",
  AppConstants.withTags: "Se štítky",
  AppConstants.noResultsFound: "Nebyly nalezeny žádné výsledky",
  AppConstants.searchHintText: "Hledat záznamy...",

  // Settings
  AppConstants.language: "Jazyk",
  AppConstants.selectLanguage: "Vybrat jazyk",
  AppConstants.systemDefault: "Výchozí systému",
  AppConstants.searchLanguagesHint: "Hledat jazyky...",
  AppConstants.languageChanged: "Jazyk byl změněn na %s.",
  AppConstants.dailyReminder: "Připomínky",
  AppConstants.addReminder: "Přidat připomínku",
  AppConstants.deleteReminder: "Smazat připomínku",
  AppConstants.noRemindersSet: "Nejsou nastaveny žádné připomínky.",
  AppConstants.onThisDay: "V tento den",
  AppConstants.appLock: "Zámek aplikace",
  AppConstants.backup: "Záloha",
  AppConstants.restore: "Obnovit",
  AppConstants.importFromAnotherApp: "Importovat z jiné aplikace",
  AppConstants.importFromDailyYou: "Importovat z Daily You",
  AppConstants.selectDailyYouBackup:
      "Vyberte zip soubor zálohy Daily You",
  AppConstants.importingEntries: "Importování záznamů...",
  AppConstants.importSuccess: "Úspěšně importováno %d záznamů z Daily You!",
  AppConstants.importFailed: "Import se nezdařil: %s",
  AppConstants.noEntriesToImport: "Nebyly nalezeny žádné nové záznamy k importu.",
  AppConstants.askSupport: "Požádat o podporu",
  AppConstants.importSupportNote:
      "Formáty jiných aplikací nemusí podporovat všechny funkce. Pokud narazíte na problémy nebo se formát změní, nahlaste prosím chybu.",
  AppConstants.extractingBackup: "Rozbalování zálohy...",
  AppConstants.parsingDatabase: "Zpracování databáze...",
  AppConstants.dailyYouDbNotFound:
      "Databáze Daily You nebyla v záloze nalezena.",
  AppConstants.privacyPolicy: "Zásady ochrany osobních údajů",
  AppConstants.termsNConditions: "Obchodní podmínky",
  AppConstants.about: "O aplikaci",
  AppConstants.changeTheme: "Změnit motiv",
  AppConstants.theme: "Motiv",
  AppConstants.pitchBlack: "Uhlově černý",
  AppConstants.themeLight: "Světlý",
  AppConstants.themeDark: "Tmavý",
  AppConstants.themeSystem: "Systémový",
  AppConstants.changePin: "Změnit PIN",
  AppConstants.loading: "Načítání...",
  AppConstants.confirmRestoreTitle: "Potvrdit obnovení",
  AppConstants.confirmRestoreMessage:
      "Obnovení ze zálohy přepíše všechna aktuální data. Tuto akci nelze vrátit zpět. Opravdu chcete pokračovat?",
  AppConstants.notificationScheduled: "Oznámení naplánováno na %s",
  AppConstants.notificationCanceled: "Oznámení zrušeno",
  AppConstants.notificationRescheduled: "Oznámení přeplánováno na %s",
  AppConstants.notificationPermissionRequired:
      "Pro nastavení připomínek je vyžadováno oprávnění k oznámením.",
  AppConstants.pinChangedSuccess: "PIN byl úspěšně změněn",
  AppConstants.onThisDayOn: "Nyní budete dostávat vzpomínky z tohoto dne.",
  AppConstants.onThisDayOff: "Připomínky 'V tento den' jsou vypnuty.",
  AppConstants.themeChanged: "Vybrán motiv: %s.",
  AppConstants.hideStats: "Skrýt statistiky",
  AppConstants.hideHomeStats: "Skrýt statistiky na domovské obrazovce",
  AppConstants.hideInsightsStats: "Skrýt statistiky v Přehledech",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLEXE",
  AppConstants.reflectButton: "Přemýšlet",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Nesprávný PIN",
  AppConstants.verifyYourPin: "Ověřte svůj PIN",
  AppConstants.setAPin: "Nastavit PIN",
  AppConstants.confirmPin: "Potvrdit PIN",
  AppConstants.pinsDoNotMatch: "PIN kódy se neshodují",
  AppConstants.setPin: "Nastavit PIN",
  AppConstants.hello: "Ahoj!",
  AppConstants.enterYourPin: "Zadejte svůj PIN",
  AppConstants.useBiometrics: "Použít biometriku",
  AppConstants.authenticateToUnlock:
      "Ověřte se pro odemčení aplikace",
  AppConstants.databaseEncryption: "Šifrování databáze",
  AppConstants.databaseEncryptionDesc: "Lokální šifrování AES-256-GCM",
  AppConstants.changeMasterPassword: "Změnit hlavní heslo",
  AppConstants.biometricUnlock: "Biometrické odemčení",
  AppConstants.enterMasterPassword: "Zadejte hlavní heslo",
  AppConstants.enterMasterPasswordHint:
      "Zadejte své hlavní heslo pro dešifrování deníku.",
  AppConstants.unlockButton: "Odemknout",
  AppConstants.unlockWithBiometrics: "Odemknout biometrikou",
  AppConstants.incorrectMasterPassword:
      "Nesprávné hlavní heslo. Zkuste to prosím znovu.",
  AppConstants.databaseEncryptedSuccess:
      "Databáze deníku byla zašifrována pomocí AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Databáze deníku byla dešifrována a zámek aplikace byl vypnut.",
  AppConstants.masterPasswordChangedSuccess:
      "Hlavní heslo bylo úspěšně aktualizováno.",
  AppConstants.encryptedBackupPasswordRequired:
      "Pro otevření šifrované zálohy je vyžadováno heslo.",
  AppConstants.incorrectBackupPassword: "Nesprávné heslo zálohy.",
  AppConstants.invalidBackupFile:
      "Vybraný soubor není platnou zálohou OpenJot.",
  AppConstants.encryptedBackup: "Šifrovaná záloha (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Chráněno pomocí AES-256-GCM a hesla zálohy",
  AppConstants.standardBackup: "Standardní záloha (.zip)",
  AppConstants.standardBackupDesc:
      "Nešifrovaný archiv kompatibilní se všemi verzemi",
  AppConstants.takingBackup: "Vytváření zálohy...",
  AppConstants.encryptingBackup: "Šifrování zálohy...",
  AppConstants.savingBackup: "Ukládání zálohy...",
  AppConstants.preparingBackup: "Příprava zálohy...",
  AppConstants.decryptingBackup: "Dešifrování zálohy...",
  AppConstants.restoringBackup: "Obnovování zálohy...",
  AppConstants.backupEncodingFailed:
      "Nepodařilo se zakódovat soubor zálohy.",
  AppConstants.backupCreatedSuccess: "Záloha byla úspěšně vytvořena!",
  AppConstants.backupFailed: "Vytvoření zálohy se nezdařilo: %s",
  AppConstants.restorePermissionsRequired:
      "K obnovení dat jsou vyžadována oprávnění k úložišti a médiím.",
  AppConstants.databaseRestoredNoMedia:
      "Databáze obnovena. V záloze nebyla nalezena žádná média.",
  AppConstants.restoreSuccess: "Obnovení proběhlo úspěšně!",
  AppConstants.restoreSuccessRestartRecommended:
      "Obnovení proběhlo úspěšně. Pro uplatnění všech změn se doporučuje restart.",
  AppConstants.restoreFailed: "Obnovení dat se nezdařilo: %s",
  AppConstants.storagePermissionsRequired:
      "K vytvoření zálohy jsou vyžadována oprávnění k úložišti a médiím.",
  AppConstants.selectBackupFolder: "Vyberte složku pro uložení zálohy",
  AppConstants.encryptDatabase: "Zašifrovat databázi",
  AppConstants.disableEncryption: "Vypnout šifrování",
  AppConstants.backupPasswordTitle: "Heslo zálohy",
  AppConstants.changeMasterPasswordDesc:
      "Zadejte své aktuální hlavní heslo a zvolte nové heslo (minimálně 6 znaků).",
  AppConstants.disableEncryptionDesc:
      "Zadejte své hlavní heslo pro dešifrování databáze na disku a vypnutí šifrování.",
  AppConstants.enableEncryptionDesc:
      "Chraňte všechny poznámky deníku lokálně šifrováním AES-256-GCM. Pokud zapomenete hlavní heslo, šifrovaná data nebude možné obnovit.",
  AppConstants.verifyForBiometricsDesc:
      "Zadejte jednou své hlavní heslo pro uložení klíče v zabezpečeném hardwarovém úložišti pro rychlé biometrické odemčení.",
  AppConstants.createBackupPasswordDesc:
      "Nastavte silné heslo pro zašifrování této zálohy .openjot. Toto heslo budete potřebovat k obnovení na jakémkoli zařízení.",
  AppConstants.enterBackupPasswordDesc:
      "Zadejte heslo použité při vytváření této zálohy .openjot.",
  AppConstants.updatePasswordAction: "Aktualizovat heslo",
  AppConstants.decryptAndDisable: "Dešifrovat a vypnout",
  AppConstants.enableBiometricsAction: "Povolit biometriku",
  AppConstants.createBackupAction: "Vytvořit zálohu",
  AppConstants.decryptBackupAction: "Dešifrovat zálohu",
  AppConstants.newMasterPasswordHint: "Nové hlavní heslo",
  AppConstants.backupPasswordHint: "Heslo zálohy",
  AppConstants.masterPasswordHint: "Hlavní heslo",
  AppConstants.enterCurrentMasterPasswordError:
      "Zadejte prosím své aktuální hlavní heslo.",
  AppConstants.passwordEmptyError: "Heslo nemůže být prázdné.",
  AppConstants.passwordMinLengthError:
      "Heslo musí mít alespoň 6 znaků.",
  AppConstants.passwordsDoNotMatchError: "Hesla se neshodují.",
  AppConstants.currentMasterPasswordHint: "Aktuální hlavní heslo",
  AppConstants.confirmPasswordHint: "Potvrdit heslo",

  // About & Terms
  AppConstants.aboutApp: "O aplikaci OpenJot",
  AppConstants.versionPrefix: "Verze: %s",
  AppConstants.aboutSubtitle:
      "Minimalistický open-source deník pro záznam vašich myšlenek, nálad a vzpomínek. Všechna vaše data zůstávají ve vašem zařízení.",
  AppConstants.keyFeatures: "Klíčové funkce",
  AppConstants.aboutFeature1: "• Čisté prostředí pro psaní bez rušivých prvků.",
  AppConstants.aboutFeature2:
      "• Přidávejte do záznamů fotky, hlasové poznámky a hudbu.",
  AppConstants.aboutFeature3: "• Zaznamenávejte si k zápiskům svou náladu.",
  AppConstants.aboutFeature4: "• Přizpůsobte si text různými styly.",
  AppConstants.aboutFeature5:
      "• Funguje zcela offline, vaše data zůstávají na vašem zařízení.",
  AppConstants.openSource: "Open Source",
  AppConstants.openSourceDesc:
      "OpenJot je aplikace s otevřeným zdrojovým kódem. Zdrojový kód je veřejně dostupný komukoli k nahlédnutí, úpravám a přispívání. Věříme v transparentnost a spolupráci komunity.",
  AppConstants.dataPrivacy: "Ochrana osobních údajů",
  AppConstants.dataPrivacyDesc:
      "Vážíme si vašeho soukromí. OpenJot neshromažďuje, neukládá ani nepřenáší žádné vaše osobní údaje. Všechny vaše záznamy včetně textu, obrázků a zvuku jsou uloženy výhradně ve vašem zařízení.",
  AppConstants.linksTitle: "Odkazy",
  AppConstants.sourceCodeOnGithub: "Zdrojový kód na GitHubu",
  AppConstants.sendFeedback: "Odeslat zpětnou vazbu",
  AppConstants.couldNotLaunchUrl: "Nepodařilo se otevřít URL",
  AppConstants.termsIntro:
      "Vítejte v OpenJot! Tento dokument popisuje podmínky používání naší aplikace. Používáním aplikace OpenJot s těmito podmínkami souhlasíte.",
  AppConstants.termsSectionDataPrivacy: "Ukládání dat a soukromí",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot je navržen jako soukromý prostor pro vaše myšlenky. Všechny záznamy, včetně textu, obrázků, zvukových souborů a dalších médií, jsou uloženy výhradně lokálně ve vašem zařízení. Aplikace neshromažďuje, neukládá ani neodesílá osobní údaje na žádné externí servery. K vašemu obsahu nemáme žádný přístup.",
  AppConstants.termsSectionUserContent: "Uživatelský obsah",
  AppConstants.termsSectionUserContentBody:
      "Jste výhradně odpovědní za obsah, který v aplikaci OpenJot vytváříte a ukládáte, včetně textu, obrázků, zvukových nahrávek a dalších souborů. Jste odpovědní za zajištění potřebných práv k jakémukoli obsahu, který do aplikace importujete.",
  AppConstants.termsSectionDisclaimer: "Vyloučení záruky",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot je poskytován \"tak, jak je\" bez jakýchkoli výslovných či předpokládaných záruk. Nezaručujeme, že aplikace bude bezchybná nebo nepřerušovaná. Aplikaci používáte na vlastní riziko.",
  AppConstants.termsSectionLiability: "Omezení odpovědnosti",
  AppConstants.termsSectionLiabilityBody:
      "Vývojáři aplikace OpenJot v žádném případě nenesou odpovědnost za jakékoli přímé, nepřímé, náhodné, zvláštní nebo následné škody, včetně ztráty dat, vzniklé v důsledku používání nebo nemožnosti používat tuto aplikaci.",
  AppConstants.termsSectionThirdParty: "Knihovny třetích stran",
  AppConstants.termsSectionThirdPartyBody:
      "Tato aplikace využívá následující knihovny třetích stran, z nichž každá se řídí vlastní licencí:",

  // Months
  'January': 'Leden',
  'February': 'Únor',
  'March': 'Březen',
  'April': 'Duben',
  'May': 'Květen',
  'June': 'Červen',
  'July': 'Červenec',
  'August': 'Srpen',
  'September': 'Září',
  'October': 'Říjen',
  'November': 'Listopad',
  'December': 'Prosinec',

  // Reflection Prompts (62)
  "What made you smile today?": "Co vám dnes vykouzlilo úsměv na tváři?",
  "Who are you thankful for this week, and why?":
      "Komu jste tento týden vděční a proč?",
  "What is something small that brought you joy today?":
      "Jaká maličkost vám dnes udělala radost?",
  "Which part of your day felt most comforting?":
      "Která část dne byla pro vás nejpříjemnější?",
  "What’s something you often take for granted but appreciate now?":
      "Co často berete jako samozřejmost, ale teď si toho vážíte?",
  "What’s the best thing that happened today?":
      "Co nejlepšího se dnes stalo?",
  "Did someone make your day easier today?":
      "Usnadnil vám dnes někdo den?",
  "Who made a positive impact on you recently?":
      "Kdo na vás v poslední době pozitivně zapůsobil?",
  "What’s a quality you admire in someone close to you?":
      "Jakou vlastnost obdivujete na někom blízkém?",
  "When did you last feel truly connected with someone?":
      "Kdy jste naposledy cítili skutečné spojení s někým?",
  "Who do you want to reach out to soon?":
      "Komu se chcete brzy ozvat?",
  "Did someone’s kindness stand out today?":
      "Vynikla dnes něčí laskavost?",
  "How did you support someone else recently?":
      "Jak jste nedávno někoho podpořili?",
  "Who do you miss the most right now?":
      "Kdo vám právě teď nejvíce chybí?",
  "What’s a moment from today you want to remember?":
      "Jaký okamžik z dneška si chcete zapamatovat?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Jaký detail o dnešku byste mohli zapomenout, kdybyste si ho nezapsali?",
  "What’s the most peaceful moment you had today?":
      "Jaký byl váš nejklidnější okamžik dneška?",
  "Did you see something beautiful today?":
      "Viděli jste dnes něco krásného?",
  "Which memory from this week stands out?":
      "Která vzpomínka z tohoto týdne nejvíce vyniká?",
  "What song, photo, or place will always remind you of today?":
      "Která píseň, fotka nebo místo vám bude vždy připomínat dnešek?",
  "What surprised you today?": "Co vás dnes překvapilo?",
  "What challenge did you overcome today?":
      "Jakou výzvu jste dnes překonali?",
  "What’s a small win you had today?":
      "Jaké malé vítězství jste dnes zažili?",
  "What new thing did you learn about yourself recently?":
      "Co nového jste se o sobě nedávno dozvěděli?",
  "What are you proud of yourself for?": "Na co jste na sebe hrdí?",
  "What habit do you feel good about keeping?":
      "Z jakého návyku, který udržujete, máte dobrý pocit?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Jakého jednoho zlepšení jste si u sebe letos všimli?",
  "How did you push yourself out of your comfort zone?":
      "Jak jste vystoupili ze své komfortní zóny?",
  "How are you truly feeling right now?":
      "Jak se právě teď doopravdy cítíte?",
  "Which emotion stood out the most today?":
      "Která emoce dnes nejvíce vynikala?",
  "Did you feel present in any moment today?":
      "Cítili jste se dnes v nějakém okamžiku plně přítomní?",
  "When did you feel the most at peace today?":
      "Kdy jste se dnes cítili nejklidnější?",
  "What gave you energy today?": "Co vám dnes dodalo energii?",
  "What drained your energy today?": "Co vám dnes vzalo energii?",
  "If your mood had a color today, what would it be?":
      "Kdyby měla vaše dnešní nálada barvu, jaká by byla?",
  "What’s something you’re excited about tomorrow?":
      "Na co se zítra těšíte?",
  "What’s one thing you want to improve tomorrow?":
      "Co jedno chcete zítra zlepšit?",
  "What would make tomorrow feel successful?":
      "Díky čemu by byl zítřek úspěšný?",
  "What do you hope to achieve this week?":
      "Čeho doufáte, že tento týden dosáhnete?",
  "What’s a habit you’d like to start tomorrow?":
      "S jakým návykem byste chtěli zítra začít?",
  "What’s something you want to look forward to in the next month?":
      "Na co se chcete v příštím měsíci těšit?",
  "What would your ideal tomorrow look like?":
      "Jak by vypadal váš ideální zítřek?",
  "What’s one lesson you learned recently?":
      "Jakou jednu lekci jste se nedávno naučili?",
  "If you could freeze one moment today, which would it be?":
      "Kdybyste mohli dnes zastavit jeden okamžik, který by to byl?",
  "What makes your life feel meaningful right now?":
      "Co dává vašemu životu právě teď smysl?",
  "If you described today in one word, what would it be?":
      "Kdybyste měli dnešek popsat jedním slovem, jaké by to bylo?",
  "What inspired you today?": "Co vás dnes inspirovalo?",
  "What did you notice today that you usually overlook?":
      "Čeho jste si dnes všimli, co obvykle přehlížíte?",
  "How has today changed your perspective?":
      "Jak dnešní den změnil váš pohled?",
  "What’s something you’ve been overthinking?":
      "Nad čím v poslední době příliš přemýšlíte?",
  "What do you need to let go of?": "Čeho se potřebujete pustit?",
  "What part of nature did you notice today?":
      "Které části přírody jste si dnes všimli?",
  "Did the weather affect your mood today?":
      "Ovlivnilo dnes počasí vaši náladu?",
  "What place felt most comforting today?":
      "Které místo působilo dnes nejpříjemněji?",
  "Where did you feel most at home today?":
      "Kde jste se dnes cítili nejvíce jako doma?",
  "What sound or smell reminded you of something important?":
      "Jaký zvuk nebo vůně vám připomněly něco důležitého?",
  "How did you take care of yourself today?":
      "Jak jste se o sebe dnes postarali?",
  "When did you feel most like yourself today?":
      "Kdy jste se dnes cítili nejvíce sami sebou?",
  "What’s something kind you can say to yourself right now?":
      "Co laskavého si můžete právě teď říct?",
  "What do you want to forgive yourself for?":
      "Co si chcete odpustit?",
  "What do you deserve more of in your life?":
      "Čeho si ve svém životě zasloužíte více?",
};

/// Complete Slovak (Slovenčina) translations for OpenJot.
final Map<String, String> skTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Môj denník",
  AppConstants.noEntriesMessage: "Zatiaľ žiadne záznamy v denníku. Začnite písať!",
  AppConstants.noBookmarksYet: "Zatiaľ žiadne záložky.",
  AppConstants.noDraftsYet: "Zatiaľ žiadne koncepty.",
  AppConstants.addEntryButton: "Pridať nový záznam",
  AppConstants.jotYourThoughts: "Zapíšte si svoje myšlienky",
  AppConstants.tapToCreateJournal:
      "Klepnutím na + vytvoríte svoj osobný denník.",
  AppConstants.entriesThisYear: "Záznamov v tomto roku",
  AppConstants.wordsWritten: "Napísaných slov",
  AppConstants.daysJournaled: "Dní so zápisom",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Nový záznam v denníku",
  AppConstants.editEntryAppBarTitle: "Upraviť záznam",
  AppConstants.titleHintText: "Názov (napr. 'Môj deň', 'Myšlienky o...')",
  AppConstants.contentHintText: "Napíšte svoje myšlienky sem...",
  AppConstants.saveButton: "Uložiť záznam",
  AppConstants.updateButton: "Aktualizovať",
  AppConstants.deleteButton: "Vymazať záznam",
  AppConstants.requiredFieldMessage: "Toto pole nemôže byť prázdne.",
  AppConstants.newEntry: "Nový záznam",
  AppConstants.todayDate: "Dnešný dátum",
  AppConstants.customDate: "Vlastný dátum",
  AppConstants.done: "Hotovo",
  AppConstants.startWriting: " Začnite písať...",
  AppConstants.tags: "Štítky",
  AppConstants.addTags: "Pridať štítky",
  AppConstants.openInMaps: "Otvoriť v Mapách",
  AppConstants.changeLocation: "Zmeniť polohu",
  AppConstants.remove: "Odstrániť",
  AppConstants.discardSelectionsTitle: "Zahodiť výber?",
  AppConstants.discardSelectionsMessage:
      "Vybrali ste médiá alebo aktívnu nahrávku. Naozaj ich chcete zahodiť?",
  AppConstants.journalEntryEmpty: "Záznam v denníku nemôže byť prázdny",
  AppConstants.discardDateConfirm:
      "Zahodiť vybraný dátum/čas pre tento záznam?",
  AppConstants.addMediaLocationMoodFirst:
      "Najprv pridajte médiá, polohu alebo náladu",
  AppConstants.location: "Poloha",
  AppConstants.record: "Nahrať",
  AppConstants.selectMomentsToJournal: "Vyberte momenty na zapísanie",
  AppConstants.addMomentsFromMenu:
      "Pridajte médiá, polohu, nahrávku alebo náladu z ponuky",
  AppConstants.writeSomething: "Napísať niečo",
  AppConstants.saveWithoutWriting: "Uložiť bez písania",
  AppConstants.oneLocation: "1 miesto",
  AppConstants.mediaCount: "%d médií",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Potvrdiť vymazanie",
  AppConstants.confirmDeleteMessage:
      "Naozaj chcete vymazať tento záznam?",
  AppConstants.pleaseConfirm: "Prosím potvrďte",
  AppConstants.confirmDeleteJournalEntry:
      "Naozaj chcete vymazať tento záznam z denníka? Túto akciu nie je možné vrátiť späť.",
  AppConstants.yes: "Áno",
  AppConstants.no: "Nie",
  AppConstants.cancel: "Zrušiť",
  AppConstants.delete: "Vymazať",
  AppConstants.save: "Uložiť",
  AppConstants.entrySavedSuccess: "Záznam bol úspešne uložený!",
  AppConstants.entryUpdatedSuccess: "Záznam bol úspešne aktualizovaný!",
  AppConstants.entryDeletedSuccess: "Záznam bol vymazaný.",
  AppConstants.errorSavingEntry: "Chyba pri ukladaní záznamu.",
  AppConstants.errorDeletingEntry: "Chyba pri mazaní záznamu.",
  AppConstants.errorLoadingEntries: "Chyba pri načítavaní záznamov.",
  AppConstants.noEntriesForDate: "Pre tento dátum nie sú žiadne záznamy.",
  AppConstants.noEntriesForMonth: "Pre tento mesiac sa nenašli žiadne záznamy.",
  AppConstants.selectMonthAndYear: "Vyberte mesiac a rok",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Veľmi nepríjemné",
  AppConstants.unpleasant: "Nepríjemné",
  AppConstants.slightlyUnpleasant: "Mierne nepríjemné",
  AppConstants.neutral: "Neutrálne",
  AppConstants.slightlyPleasant: "Mierne príjemné",
  AppConstants.pleasant: "Príjemné",
  AppConstants.veryPleasant: "Veľmi príjemné",
  AppConstants.reflection: "Reflexia",
  AppConstants.edit: "Upraviť",
  AppConstants.removeBookmark: "Odstrániť záložku",
  AppConstants.bookmark: "Záložka",
  AppConstants.share: "Zdieľať",
  AppConstants.saveAsPdf: "Uložiť ako PDF",
  AppConstants.audioTrack: "Zvuková stopa",
  AppConstants.generatingPdf: "Generovanie PDF...",
  AppConstants.voiceRecording: "Hlasová nahrávka",
  AppConstants.audioRecording: "Zvuková nahrávka",
  AppConstants.couldNotLoadAudio: "Zvukový súbor sa nepodarilo načítať.",
  AppConstants.stateOfMind: "Stav mysle",

  // Mood Colors
  AppConstants.moodColors: "Farby nálad",
  AppConstants.customizeMoodColors: "Prispôsobiť farby nálad",
  AppConstants.reset: "Obnoviť",
  AppConstants.resetMoodColors: "Obnoviť predvolené",
  AppConstants.resetMoodColorsConfirm:
      "Obnoviť všetky farby nálad na predvolené hodnoty?",
  AppConstants.paletteThemes: "Motívy palety",
  AppConstants.customColor: "Vlastná farba",
  AppConstants.moodUnsavedChangesMessage:
      "Máte neuložené zmeny farieb nálad. Chcete ich pred zatvorením uložiť?",

  // Drafts & Auto-save
  AppConstants.drafts: "Koncepty",
  AppConstants.draft: "Koncept",
  AppConstants.draftSaved: "Uložené do konceptov",
  AppConstants.unsavedChanges: "Neuložené zmeny",
  AppConstants.unsavedChangesMessage:
      "Máte neuložené zmeny. Chcete ich uložiť ako koncept alebo zahodiť?",
  AppConstants.saveAsDraft: "Uložiť ako koncept",
  AppConstants.discardChanges: "Zahodiť",
  AppConstants.autoDeleteDrafts: "Automaticky mazať koncepty",
  AppConstants.days7: "7 dní",
  AppConstants.never: "Nikdy",
  AppConstants.custom: "Vlastné...",
  AppConstants.enterCustomDays: "Zadajte počet dní",
  AppConstants.customDaysExample: "Napr. 14",
  AppConstants.days: "dní",
  AppConstants.draftsNeverDeleted: "Koncepty nebudú nikdy vymazané",
  AppConstants.draftsDeletedAfterDays: "Koncepty budú vymazané po %d dňoch",

  // Home Menu & Sorting
  AppConstants.sortBy: "Zoradiť podľa",
  AppConstants.insights: "Prehľady",
  AppConstants.reflections: "Reflexie",
  AppConstants.settings: "Nastavenia",
  AppConstants.entryTime: "Čas záznamu",
  AppConstants.bookmarkFirst: "Najprv záložky",
  AppConstants.reflectionFirst: "Najprv reflexie",
  AppConstants.withMediaFirst: "Najprv s médiami",
  AppConstants.textOnlyFirst: "Najprv iba text",
  AppConstants.withLocationFirst: "Najprv s polohou",
  AppConstants.withMoodFirst: "Najprv s náladou",
  AppConstants.withTagsFirst: "Najprv so štítkami",

  // Insights
  AppConstants.stats: "Štatistiky",
  AppConstants.calendar: "Kalendár",
  AppConstants.entriesSuffix: " záznamov",
  AppConstants.memoriesFromThisDay: "Spomienky z tohto dňa",
  AppConstants.standard: "Štandardný",
  AppConstants.media: "Médiá",
  AppConstants.mood: "Nálada",
  AppConstants.mostly: "Väčšinou",
  AppConstants.averageForThisDay: "Priemer pre tento deň",
  AppConstants.averageForThisYear: "Priemer pre tento rok",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Vitajte v OpenJot",
  AppConstants.feature1:
      "Píšte slobodne, pridávajte fotky a miesta a uchovávajte všetko bezpečne vo svojom zariadení.",
  AppConstants.feature2:
      "Porozumejte svojim emóciám v priebehu času vďaka integrovanému sledovaniu nálady.",
  AppConstants.feature3:
      "Vaše dáta zostávajú v telefóne – žiadny cloud, len lokálne úložisko a úplné súkromie.",
  AppConstants.continueButton: "Pokračovať",

  // Notifications
  AppConstants.notificationTitle: "Čas písať denník!",
  AppConstants.notificationBody: "Nezabudnite si zapísať svoje dnešné myšlienky.",
  AppConstants.notificationChannelName: "Denné pripomienky denníka",
  AppConstants.notificationChannelDescription:
      "Kanál pre denné pripomienky písania denníka",
  AppConstants.onThisDayChannelName: "Spomienky V tento deň",
  AppConstants.onThisDayChannelDescription:
      "Upozornenia na spomienky z minulých rokov.",
  AppConstants.onThisDayNotificationTitle: "Spomienka z vášho denníka",
  AppConstants.onThisDaySingleEntry:
      "Pred rokom v tento deň ste napísali niečo výnimočné. Klepnutím si pripomeňte svoje myšlienky.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "V tento deň pred rokom ste uložili túto spomienku. Klepnutím si ju znova prežite.",
  AppConstants.onThisDayMultipleEntries:
      "Z tohto dňa máte spomienky z minulých rokov. Klepnutím ich zobrazíte.",
  AppConstants.onThisDayGroupedNotification: "Máte %d spomienok z tohto dňa",

  // Exclude Entries
  AppConstants.excludeEntries: "Vylúčiť záznamy",
  AppConstants.saveExclusions: "Uložiť vylúčenia",
  AppConstants.excludeUnsavedChangesMessage:
      "Máte neuložené zmeny. Naozaj ich chcete zahodiť a odísť?",
  AppConstants.sortDefault: "Predvolené",
  AppConstants.sortMutedFirst: "Najprv skryté",
  AppConstants.sortUnmutedFirst: "Najprv zobrazené",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Dnes",
  AppConstants.yesterday: "Včera",
  AppConstants.contentForQuote: "Obsah pre citát",
  AppConstants.noContentSelected: "Nebol vybraný žiadny obsah.",
  AppConstants.photos: "Fotky",
  AppConstants.video: "Video",
  AppConstants.audio: "Audio",
  AppConstants.add: "Pridať",
  AppConstants.noMediaFound: "Nenašli sa žiadne položky: %s.",
  AppConstants.permissionRequired:
      "Na zobrazenie je potrebné povolenie na prístup k %s.",
  AppConstants.openSettings: "Otvoriť nastavenia",
  AppConstants.videos: "Videá",
  AppConstants.audios: "Zvuky",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Vymazať nahrávku?",
  AppConstants.deleteRecordingMessage:
      "Naozaj chcete vymazať túto nahrávku?",
  AppConstants.listen: "Vypočuť",
  AppConstants.tapAndHold: "klepnite a podržte",
  AppConstants.clear: "Vymazať",
  AppConstants.all: "Všetko",
  AppConstants.folder: "Priečinok",
  AppConstants.browse: "Prehliadať",
  AppConstants.tiles: "Dlaždice",
  AppConstants.graph: "Graf",
  AppConstants.recording: "Nahrávanie...",
  AppConstants.recordingLabel: "Nahrávka",
  AppConstants.startAudioRecording: "Spustiť nahrávanie zvuku",
  AppConstants.howAreYouFeeling: "Ako sa cítite?",
  AppConstants.paused: "Pozastavené",
  AppConstants.stop: "Zastaviť",
  AppConstants.tapOrHoldToResume: "Klepnutím alebo podržaním pokračujte",
  AppConstants.tapOrReleaseToPause: "Klepnutím alebo uvoľnením pozastavíte",
  AppConstants.unsupportedImageType: "Nepodporovaný formát obrázka",
  AppConstants.couldNotLoadVideo: "Video sa nepodarilo načítať",
  AppConstants.couldNotOpenMap: "Nepodarilo sa otvoriť odkaz na mapu.",
  AppConstants.dismiss: "Zavrieť",
  AppConstants.selectTime: "Vyberte čas",
  AppConstants.now: "Teraz",
  AppConstants.searchPlacesHint: "Hľadať miesta, obchody...",
  AppConstants.locationPermissionDenied: "Povolenie polohy bolo zamietnuté.",
  AppConstants.failedGetCurrentLocation:
      "Nepodarilo sa získať aktuálnu polohu.",

  // Search
  AppConstants.searchJournalsHint: "Hľadať v denníkoch...",
  AppConstants.textOnly: "Iba text",
  AppConstants.withMedia: "S médiami",
  AppConstants.withMood: "S náladou",
  AppConstants.withLocation: "S polohou",
  AppConstants.withTags: "So štítkami",
  AppConstants.noResultsFound: "Nenašli sa žiadne výsledky",
  AppConstants.searchHintText: "Hľadať záznamy...",

  // Settings
  AppConstants.language: "Jazyk",
  AppConstants.selectLanguage: "Vybrať jazyk",
  AppConstants.systemDefault: "Predvolený systému",
  AppConstants.searchLanguagesHint: "Hľadať jazyky...",
  AppConstants.languageChanged: "Jazyk bol zmenený na %s.",
  AppConstants.dailyReminder: "Pripomienky",
  AppConstants.addReminder: "Pridať pripomienku",
  AppConstants.deleteReminder: "Vymazať pripomienku",
  AppConstants.noRemindersSet: "Nie sú nastavené žiadne pripomienky.",
  AppConstants.onThisDay: "V tento deň",
  AppConstants.appLock: "Zámok aplikácie",
  AppConstants.backup: "Záloha",
  AppConstants.restore: "Obnoviť",
  AppConstants.importFromAnotherApp: "Importovať z inej aplikácie",
  AppConstants.importFromDailyYou: "Importovať z Daily You",
  AppConstants.selectDailyYouBackup:
      "Vyberte zip súbor zálohy Daily You",
  AppConstants.importingEntries: "Importovanie záznamov...",
  AppConstants.importSuccess: "Úspešne importovaných %d záznamov z Daily You!",
  AppConstants.importFailed: "Import zlyhal: %s",
  AppConstants.noEntriesToImport: "Nenašli sa žiadne nové záznamy na import.",
  AppConstants.askSupport: "Požiadať o podporu",
  AppConstants.importSupportNote:
      "Formáty iných aplikácií nemusia podporovať všetky funkcie. Ak narazíte na problémy alebo sa formát zmení, nahláste prosím chybu.",
  AppConstants.extractingBackup: "Rozbaľovanie zálohy...",
  AppConstants.parsingDatabase: "Spracovanie databázy...",
  AppConstants.dailyYouDbNotFound:
      "Databáza Daily You sa v zálohe nenašla.",
  AppConstants.privacyPolicy: "Zásady ochrany osobných údajov",
  AppConstants.termsNConditions: "Obchodné podmienky",
  AppConstants.about: "O aplikácii",
  AppConstants.changeTheme: "Zmeniť motív",
  AppConstants.theme: "Motív",
  AppConstants.pitchBlack: "Úplne čierny",
  AppConstants.themeLight: "Svetlý",
  AppConstants.themeDark: "Tmavý",
  AppConstants.themeSystem: "Systémový",
  AppConstants.changePin: "Zmeniť PIN",
  AppConstants.loading: "Načítava sa...",
  AppConstants.confirmRestoreTitle: "Potvrdiť obnovenie",
  AppConstants.confirmRestoreMessage:
      "Obnovenie zo zálohy prepíše všetky aktuálne dáta. Túto akciu nie je možné vrátiť späť. Naozaj chcete pokračovať?",
  AppConstants.notificationScheduled: "Upozornenie naplánované na %s",
  AppConstants.notificationCanceled: "Upozornenie zrušené",
  AppConstants.notificationRescheduled: "Upozornenie preplánované na %s",
  AppConstants.notificationPermissionRequired:
      "Na nastavenie pripomienok je potrebné povolenie na upozornenia.",
  AppConstants.pinChangedSuccess: "PIN bol úspešne zmenený",
  AppConstants.onThisDayOn: "Teraz budete dostávať spomienky z tohto dňa.",
  AppConstants.onThisDayOff: "Pripomienky 'V tento deň' sú vypnuté.",
  AppConstants.themeChanged: "Vybratý motív: %s.",
  AppConstants.hideStats: "Skryť štatistiky",
  AppConstants.hideHomeStats: "Skryť štatistiky na domovskej obrazovke",
  AppConstants.hideInsightsStats: "Skryť štatistiky v Prehľadoch",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLEXIA",
  AppConstants.reflectButton: "Premýšľať",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Nesprávny PIN",
  AppConstants.verifyYourPin: "Overte svoj PIN",
  AppConstants.setAPin: "Nastaviť PIN",
  AppConstants.confirmPin: "Potvrdiť PIN",
  AppConstants.pinsDoNotMatch: "PIN kódy sa nezhodujú",
  AppConstants.setPin: "Nastaviť PIN",
  AppConstants.hello: "Ahoj!",
  AppConstants.enterYourPin: "Zadajte svoj PIN",
  AppConstants.useBiometrics: "Použiť biometriu",
  AppConstants.authenticateToUnlock:
      "Overte sa pre odomknutie aplikácie",
  AppConstants.databaseEncryption: "Šifrovanie databázy",
  AppConstants.databaseEncryptionDesc: "Lokálne šifrovanie AES-256-GCM",
  AppConstants.changeMasterPassword: "Zmeniť hlavné heslo",
  AppConstants.biometricUnlock: "Biometrické odomknutie",
  AppConstants.enterMasterPassword: "Zadajte hlavné heslo",
  AppConstants.enterMasterPasswordHint:
      "Zadajte svoje hlavné heslo na dešifrovanie denníka.",
  AppConstants.unlockButton: "Odomknúť",
  AppConstants.unlockWithBiometrics: "Odomknúť biometriou",
  AppConstants.incorrectMasterPassword:
      "Nesprávne hlavné heslo. Skúste to prosím znova.",
  AppConstants.databaseEncryptedSuccess:
      "Databáza denníka bola zašifrovaná pomocou AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Databáza denníka bola dešifrovaná a zámok aplikácie bol vypnutý.",
  AppConstants.masterPasswordChangedSuccess:
      "Hlavné heslo bolo úspešne aktualizované.",
  AppConstants.encryptedBackupPasswordRequired:
      "Na otvorenie šifrovanej zálohy je potrebné heslo.",
  AppConstants.incorrectBackupPassword: "Nesprávne heslo zálohy.",
  AppConstants.invalidBackupFile:
      "Vybraný súbor nie je platnou zálohou OpenJot.",
  AppConstants.encryptedBackup: "Šifrovaná záloha (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Chránené pomocou AES-256-GCM a hesla zálohy",
  AppConstants.standardBackup: "Štandardná záloha (.zip)",
  AppConstants.standardBackupDesc:
      "Nešifrovaný archív kompatibilný so všetkými verziami",
  AppConstants.takingBackup: "Vytváranie zálohy...",
  AppConstants.encryptingBackup: "Šifrovanie zálohy...",
  AppConstants.savingBackup: "Ukladanie zálohy...",
  AppConstants.preparingBackup: "Príprava zálohy...",
  AppConstants.decryptingBackup: "Dešifrovanie zálohy...",
  AppConstants.restoringBackup: "Obnovovanie zálohy...",
  AppConstants.backupEncodingFailed:
      "Nepodarilo sa zakódovať súbor zálohy.",
  AppConstants.backupCreatedSuccess: "Záloha bola úspešne vytvorená!",
  AppConstants.backupFailed: "Vytvorenie zálohy zlyhalo: %s",
  AppConstants.restorePermissionsRequired:
      "Na obnovenie dát sú potrebné povolenia na úložisko a médiá.",
  AppConstants.databaseRestoredNoMedia:
      "Databáza obnovená. V zálohe sa nenašli žiadne médiá.",
  AppConstants.restoreSuccess: "Obnovenie bolo úspešné!",
  AppConstants.restoreSuccessRestartRecommended:
      "Obnovenie bolo úspešné. Na uplatnenie všetkých zmien sa odporúča reštart.",
  AppConstants.restoreFailed: "Obnovenie dát zlyhalo: %s",
  AppConstants.storagePermissionsRequired:
      "Na vytvorenie zálohy sú potrebné povolenia na úložisko a médiá.",
  AppConstants.selectBackupFolder: "Vyberte priečinok na uloženie zálohy",
  AppConstants.encryptDatabase: "Zašifrovať databázu",
  AppConstants.disableEncryption: "Vypnúť šifrovanie",
  AppConstants.backupPasswordTitle: "Heslo zálohy",
  AppConstants.changeMasterPasswordDesc:
      "Zadajte svoje aktuálne hlavné heslo a zvoľte nové heslo (minimálne 6 znakov).",
  AppConstants.disableEncryptionDesc:
      "Zadajte svoje hlavné heslo na dešifrovanie databázy na disku a vypnutie šifrovania.",
  AppConstants.enableEncryptionDesc:
      "Chráňte všetky poznámky denníka lokálne šifrovaním AES-256-GCM. Ak zabudnete hlavné heslo, zašifrované dáta nebude možné obnoviť.",
  AppConstants.verifyForBiometricsDesc:
      "Zadajte raz svoje hlavné heslo na uloženie kľúča v zabezpečenom hardvérovom úložisku pre rýchle biometrické odomknutie.",
  AppConstants.createBackupPasswordDesc:
      "Nastavte silné heslo na zašifrovanie tejto zálohy .openjot. Toto heslo budete potrebovať na obnovenie na akomkoľvek zariadení.",
  AppConstants.enterBackupPasswordDesc:
      "Zadajte heslo použité pri vytváraní tejto zálohy .openjot.",
  AppConstants.updatePasswordAction: "Aktualizovať heslo",
  AppConstants.decryptAndDisable: "Dešifrovať a vypnúť",
  AppConstants.enableBiometricsAction: "Povoliť biometriu",
  AppConstants.createBackupAction: "Vytvoriť zálohu",
  AppConstants.decryptBackupAction: "Dešifrovať zálohu",
  AppConstants.newMasterPasswordHint: "Nové hlavné heslo",
  AppConstants.backupPasswordHint: "Heslo zálohy",
  AppConstants.masterPasswordHint: "Hlavné heslo",
  AppConstants.enterCurrentMasterPasswordError:
      "Zadajte prosím svoje aktuálne hlavné heslo.",
  AppConstants.passwordEmptyError: "Heslo nemôže byť prázdne.",
  AppConstants.passwordMinLengthError:
      "Heslo musí mať aspoň 6 znakov.",
  AppConstants.passwordsDoNotMatchError: "Heslá sa nezhodujú.",
  AppConstants.currentMasterPasswordHint: "Aktuálne hlavné heslo",
  AppConstants.confirmPasswordHint: "Potvrdiť heslo",

  // About & Terms
  AppConstants.aboutApp: "O aplikácii OpenJot",
  AppConstants.versionPrefix: "Verzia: %s",
  AppConstants.aboutSubtitle:
      "Minimalistický open-source denník na záznam vašich myšlienok, nálad a spomienok. Všetky vaše dáta zostávajú vo vašom zariadení.",
  AppConstants.keyFeatures: "Kľúčové funkcie",
  AppConstants.aboutFeature1: "• Čisté prostredie na písanie bez rušivých prvkov.",
  AppConstants.aboutFeature2:
      "• Pridávajte do záznamov fotky, hlasové poznámky a hudbu.",
  AppConstants.aboutFeature3: "• Zaznamenávajte si k zápiskom svoju náladu.",
  AppConstants.aboutFeature4: "• Prispôsobte si text rôznymi štýlmi.",
  AppConstants.aboutFeature5:
      "• Funguje úplne offline, vaše dáta zostávajú vo vašom zariadení.",
  AppConstants.openSource: "Open Source",
  AppConstants.openSourceDesc:
      "OpenJot je aplikácia s otvoreným zdrojovým kódom. Zdrojový kód je verejne dostupný komukoľvek na nahliadnutie, úpravy a prispievanie. Veríme v transparentnosť a spoluprácu komunity.",
  AppConstants.dataPrivacy: "Ochrana osobných údajov",
  AppConstants.dataPrivacyDesc:
      "Vážime si vaše súkromie. OpenJot nezhromažďuje, neukladá ani neprenáša žiadne vaše osobné údaje. Všetky vaše záznamy vrátane textu, obrázkov a zvuku sú uložené výhradne vo vašom zariadení.",
  AppConstants.linksTitle: "Odkazy",
  AppConstants.sourceCodeOnGithub: "Zdrojový kód na GitHube",
  AppConstants.sendFeedback: "Odoslať spätnú väzbu",
  AppConstants.couldNotLaunchUrl: "Nepodarilo sa otvoriť URL",
  AppConstants.termsIntro:
      "Vitajte v OpenJot! Tento dokument opisuje podmienky používania našej aplikácie. Používaním aplikácie OpenJot súhlasíte s týmito podmienkami.",
  AppConstants.termsSectionDataPrivacy: "Ukladanie dát a súkromie",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot je navrhnutý ako súkromný priestor pre vaše myšlienky. Všetky záznamy vrátane textu, obrázkov, zvukových súborov a ďalších médií sú uložené výhradne lokálne vo vašom zariadení. Aplikácia nezhromažďuje, neukladá ani neodosiela osobné údaje na žiadne externé servery. K vášmu obsahu nemáme žiadny prístup.",
  AppConstants.termsSectionUserContent: "Používateľský obsah",
  AppConstants.termsSectionUserContentBody:
      "Ste výhradne zodpovední za obsah, ktorý v aplikácii OpenJot vytvárate a ukladáte, vrátane textu, obrázkov, zvukových nahrávok a ďalších súborov. Ste zodpovední za zabezpečenie potrebných práv na akýkoľvek obsah, ktorý do aplikácie importujete.",
  AppConstants.termsSectionDisclaimer: "Vylúčenie záruky",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot sa poskytuje \"tak, ako je\" bez akýchkoľvek výslovných či predpokladaných záruk. Nezaručujeme, že aplikácia bude bezchybná alebo neprerušovaná. Aplikáciu používate na vlastné riziko.",
  AppConstants.termsSectionLiability: "Obmedzenie zodpovednosti",
  AppConstants.termsSectionLiabilityBody:
      "Vývojári aplikácie OpenJot v žiadnom prípade nenesú zodpovednosť za akékoľvek priame, nepriame, náhodné, osobitné alebo následné škody, vrátane straty dát, vzniknuté v dôsledku používania alebo nemožnosti používať túto aplikáciu.",
  AppConstants.termsSectionThirdParty: "Knižnice tretích strán",
  AppConstants.termsSectionThirdPartyBody:
      "Táto aplikácia využíva nasledujúce knižnice tretích strán, z ktorých každá sa riadi vlastnou licenciou:",

  // Months
  'January': 'Január',
  'February': 'Február',
  'March': 'Marec',
  'April': 'Apríl',
  'May': 'Máj',
  'June': 'Jún',
  'July': 'Júl',
  'August': 'August',
  'September': 'September',
  'October': 'Október',
  'November': 'November',
  'December': 'December',

  // Reflection Prompts (62)
  "What made you smile today?": "Čo vám dnes vyčarilo úsmev na tvári?",
  "Who are you thankful for this week, and why?":
      "Komu ste tento týždeň vďační a prečo?",
  "What is something small that brought you joy today?":
      "Aká maličkosť vám dnes urobila radosť?",
  "Which part of your day felt most comforting?":
      "Ktorá časť dňa bola pre vás najpríjemnejšia?",
  "What’s something you often take for granted but appreciate now?":
      "Čo často beriete ako samozrejmosť, no teraz si to vážite?",
  "What’s the best thing that happened today?":
      "Čo najlepšie sa dnes stalo?",
  "Did someone make your day easier today?":
      "Uľahčil vám dnes niekto deň?",
  "Who made a positive impact on you recently?":
      "Kto na vás v poslednom čase pozitívne zapôsobil?",
  "What’s a quality you admire in someone close to you?":
      "Akú vlastnosť obdivujete na niekom blízkom?",
  "When did you last feel truly connected with someone?":
      "Kedy ste naposledy cítili skutočné spojenie s niekým?",
  "Who do you want to reach out to soon?":
      "Komu sa chcete čoskoro ozvať?",
  "Did someone’s kindness stand out today?":
      "Vynikla dnes niečia láskavosť?",
  "How did you support someone else recently?":
      "Ako ste nedávno niekoho podporili?",
  "Who do you miss the most right now?":
      "Kto vám práve teraz najviac chýba?",
  "What’s a moment from today you want to remember?":
      "Aký okamih z dneška si chcete zapamätať?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Aký detail o dnešku by ste mohli zabudnúť, ak si ho nezapíšete?",
  "What’s the most peaceful moment you had today?":
      "Aký bol váš najpokojnejší okamih dneška?",
  "Did you see something beautiful today?":
      "Videli ste dnes niečo krásne?",
  "Which memory from this week stands out?":
      "Ktorá spomienka z tohto týždňa najviac vyniká?",
  "What song, photo, or place will always remind you of today?":
      "Ktorá pieseň, fotka alebo miesto vám bude vždy pripomínať dnešok?",
  "What surprised you today?": "Čo vás dnes prekvapilo?",
  "What challenge did you overcome today?":
      "Akú výzvu ste dnes prekonali?",
  "What’s a small win you had today?":
      "Aké malé víťazstvo ste dnes zažili?",
  "What new thing did you learn about yourself recently?":
      "Čo nové ste sa o sebe nedávno dozvedeli?",
  "What are you proud of yourself for?": "Na čo ste na seba hrdí?",
  "What habit do you feel good about keeping?":
      "Z akého návyku, ktorý si udržujete, máte dobrý pocit?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Akého jedného zlepšenia ste si na sebe tento rok všimli?",
  "How did you push yourself out of your comfort zone?":
      "Ako ste vystúpili zo svojej komfortnej zóny?",
  "How are you truly feeling right now?":
      "Ako sa práve teraz naozaj cítite?",
  "Which emotion stood out the most today?":
      "Ktorá emócia dnes najviac vynikala?",
  "Did you feel present in any moment today?":
      "Cítili ste sa dnes v nejakom okamihu naplno prítomní?",
  "When did you feel the most at peace today?":
      "Kedy ste sa dnes cítili najpokojnejšie?",
  "What gave you energy today?": "Čo vám dnes dodalo energiu?",
  "What drained your energy today?": "Čo vám dnes zobralo energiu?",
  "If your mood had a color today, what would it be?":
      "Keby mala vaša dnešná nálada farbu, aká by bola?",
  "What’s something you’re excited about tomorrow?":
      "Na čo sa zajtra tešíte?",
  "What’s one thing you want to improve tomorrow?":
      "Čo jedno chcete zajtra zlepšiť?",
  "What would make tomorrow feel successful?":
      "Vďaka čomu by bol zajtrajšok úspešný?",
  "What do you hope to achieve this week?":
      "Čo dúfate, že tento týždeň dosiahnete?",
  "What’s a habit you’d like to start tomorrow?":
      "S akým návykom by ste chceli zajtra začať?",
  "What’s something you want to look forward to in the next month?":
      "Na čo sa chcete v budúcom mesiaci tešiť?",
  "What would your ideal tomorrow look like?":
      "Ako by vyzeral váš ideálny zajtrajšok?",
  "What’s one lesson you learned recently?":
      "Akú jednu lekciu ste sa nedávno naučili?",
  "If you could freeze one moment today, which would it be?":
      "Keby ste mohli dnes zastaviť jeden okamih, ktorý by to bol?",
  "What makes your life feel meaningful right now?":
      "Čo dáva vášmu životu práve teraz zmysel?",
  "If you described today in one word, what would it be?":
      "Keby ste mali dnešok opísať jedným slovom, aké by to bolo?",
  "What inspired you today?": "Čo vás dnes inšpirovalo?",
  "What did you notice today that you usually overlook?":
      "Čoho ste si dnes všimli, čo zvyčajne prehliadate?",
  "How has today changed your perspective?":
      "Ako dnešný deň zmenil váš pohľad?",
  "What’s something you’ve been overthinking?":
      "Nad čím v poslednom čase príliš premýšľate?",
  "What do you need to let go of?": "Čoho sa potrebujete pustiť?",
  "What part of nature did you notice today?":
      "Ktorú časť prírody ste si dnes všimli?",
  "Did the weather affect your mood today?":
      "Ovplyvnilo dnes počasie vašu náladu?",
  "What place felt most comforting today?":
      "Ktoré miesto pôsobilo dnes najpríjemnejšie?",
  "Where did you feel most at home today?":
      "Kde ste sa dnes cítili najviac ako doma?",
  "What sound or smell reminded you of something important?":
      "Aký zvuk alebo vôňa vám pripomenuli niečo dôležité?",
  "How did you take care of yourself today?":
      "Ako ste sa o seba dnes postarali?",
  "When did you feel most like yourself today?":
      "Kedy ste sa dnes cítili najviac sami sebou?",
  "What’s something kind you can say to yourself right now?":
      "Čo láskavé si môžete práve teraz povedať?",
  "What do you want to forgive yourself for?":
      "Čo si chcete odpustiť?",
  "What do you deserve more of in your life?":
      "Čoho si vo svojom živote zaslúžite viac?",
};
