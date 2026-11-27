class AppConstants {
  // App Titles
  static const String appTitle = "OpenJot";
  static const String journalTitle = "My Journal";

  // Home Screen Strings
  static const String noEntriesMessage = "No journal entries yet. Start writing!";
  static const String noBookmarksYet = "No bookmarks yet.";
  static const String noDraftsYet = "No drafts yet.";
  static const String addEntryButton = "Add New Entry";
  static const String jotYourThoughts = "Jot Your Thoughts";
  static const String tapToCreateJournal =
      "Tap + to create your personal journal.";
  static const String entriesThisYear = "Entries This Year";
  static const String wordsWritten = "Words Written";
  static const String daysJournaled = "Days Journaled";

  // Add Entry Screen Strings
  static const String addEntryAppBarTitle = "New Journal Entry";
  static const String editEntryAppBarTitle = "Edit Journal Entry";
  static const String titleHintText = "Title (e.g., 'My Day', 'Thoughts on...')";
  static const String contentHintText = "Write your thoughts here...";
  static const String saveButton = "Save Entry";
  static const String updateButton = "Update";
  static const String deleteButton = "Delete Entry";
  static const String requiredFieldMessage = "This field cannot be empty.";

  // Dialogs and Messages
  static const String confirmDeleteTitle = "Confirm Delete";
  static const String confirmDeleteMessage =
      "Are you sure you want to delete this entry?";
  static const String pleaseConfirm = "Please Confirm";
  static const String confirmDeleteJournalEntry =
      "Are you sure you want to delete this journal entry? This action is irreversible.";
  static const String yes = "Yes";
  static const String no = "No";
  static const String cancel = "Cancel";
  static const String delete = "Delete";
  static const String save = "Save";
  static const String entrySavedSuccess = "Journal entry saved successfully!";
  static const String entryUpdatedSuccess = "Journal entry updated successfully!";
  static const String entryDeletedSuccess = "Journal entry deleted.";
  static const String errorSavingEntry = "Error saving entry.";
  static const String errorDeletingEntry = "Error deleting entry.";
  static const String errorLoadingEntries = "Error loading journal entries.";
  static const String noEntriesForDate = "No entries for this date.";
  static const String noEntriesForMonth = "No entries found for this month.";
  static const String selectMonthAndYear = "Select Month & Year";

  // Journal Tile
  static const String veryUnpleasant = "Very Unpleasant";
  static const String slightlyUnpleasant = "Slightly Unpleasant";
  static const String unpleasant = "Unpleasant";
  static const String neutral = "Neutral";
  static const String pleasant = "Pleasant";
  static const String slightlyPleasant = "Slightly Pleasant";
  static const String veryPleasant = "Very Pleasant";
  static const String reflection = "Reflection";
  static const String edit = "Edit";
  static const String removeBookmark = "Remove Bookmark";
  static const String bookmark = "Bookmark";
  static const String share = "Share";
  static const String saveAsPdf = "Save as PDF";
  static const String audioTrack = "Audio track";
  static const String emptyDuration = "--:--";

  static const String moodColors = "Mood Colors";
  static const String customizeMoodColors = "Customize Mood Colors";
  static const String reset = "Reset";
  static const String resetMoodColors = "Reset to Default";
  static const String resetMoodColorsConfirm = "Reset all mood colors to default?";
  static const String paletteThemes = "Palette Themes";
  static const String customColor = "Custom Color";

  static const String moodSvgPath = 'assets/mood.svg';

  static const List<Map<String, String>> moods = [
    {'svg': moodSvgPath, 'label': veryUnpleasant},
    {'svg': moodSvgPath, 'label': unpleasant},
    {'svg': moodSvgPath, 'label': slightlyUnpleasant},
    {'svg': moodSvgPath, 'label': neutral},
    {'svg': moodSvgPath, 'label': slightlyPleasant},
    {'svg': moodSvgPath, 'label': pleasant},
    {'svg': moodSvgPath, 'label': veryPleasant},
  ];

  // Drafts & Auto-saves
  static const String drafts = "Drafts";
  static const String draft = "Draft";
  static const String draftSaved = "Saved to Drafts";
  static const String unsavedChanges = "Unsaved Changes";
  static const String unsavedChangesMessage = "You have unsaved changes. Do you want to save them as a draft or discard them?";
  static const String saveAsDraft = "Save as Draft";
  static const String discardChanges = "Discard";
  static const String autoDeleteDrafts = "Auto-delete Drafts";
  static const String days7 = "7 Days";
  static const String never = "Never";
  static const String custom = "Custom...";
  static const String enterCustomDays = "Enter Custom Days";
  static const String customDaysExample = "E.g. 14";
  static const String days = "Days";

  // Home View Menu
  static const String sortBy = "Sort by";
  static const String insights = "Insights";
  static const String reflections = "Reflections";
  static const String settings = "Settings";
  static const String entryTime = "Entry time";
  static const String bookmarkFirst = "Bookmark first";
  static const String reflectionFirst = "Reflection first";
  static const String withMediaFirst = "With media first";
  static const String textOnlyFirst = "Text only first";
  static const String withLocationFirst = "With location first";
  static const String withMoodFirst = "With mood first";
  static const String withTagsFirst = "With tags first";

  // Insights Bottom Sheet
  static const String stats = "Stats";
  static const String calendar = "Calendar";
  static const String entriesSuffix = " entries";
  static const String memoriesFromThisDay = "Memories from this day";
  static const String standard = "Standard";
  static const String media = "Media";
  static const String mood = "Mood";

  // Onboarding
  static const String welcomeToOpenJot = "Welcome to OpenJot";
  static const String feature1 =
      "Write freely, add photos and locations, and keep everything secure on your device.";
  static const String feature2 =
      "Understand your emotions over time with integrated mood tracking.";
  static const String feature3 =
      "Your data stays on your phone – no cloud, just local storage and complete privacy.";
  static const String continueButton = "Continue";

  // Notifications
  static const String notificationTitle = "Time to Journal!";
  static const String notificationBody =
      "Don't forget to write down your thoughts for the day.";
  static const String notificationChannelId = "daily_journal_reminder_channel";
  static const String notificationChannelName = "Daily Journal Reminders";
  static const String notificationChannelDescription =
      "Channel for daily journal reminder notifications";

  // --- NEW: On This Day Notification Constants ---
  static const String onThisDayChannelId = "on_this_day_channel";
  static const String onThisDayChannelName = "On This Day Memories";
  static const String onThisDayChannelDescription =
      "Notifications for memories from past years.";
  static const String onThisDayNotificationTitle = "A memory from your journal";
  static const String mostly = "Mostly";
  static const String averageForThisDay = "Average for this day";
  static const String averageForThisYear = "Average for this year";
  static const String onThisDaySingleEntry =
      "A year ago today, you wrote something special. Tap to revisit your thoughts.";
  static const String onThisDaySingleEntryWithMedia =
      "On this day last year, you shared this memory. Tap to relive it.";
  static const String onThisDayMultipleEntries =
      "You have memories from this day in past years. Tap to revisit them.";
  static const String onThisDayGroupedNotification =
      "You have %d memories from this day"; // %d will be replaced with the count

  // --- NEW: Exclude Entries Constants ---
  static const String excludeEntries = "Exclude Entries";
  static const String excludedEntriesKey = "excludedEntries";
  static const String saveExclusions = "Save Exclusions";

  // Write Journal Toolbar Content
  static const String today = "Today";
  static const String yesterday = "Yesterday";
  static const String contentForQuote = "Content for Quote";
  static const String noContentSelected = "No content selected.";
  static const String photos = "Photos";
  static const String video = "Video";
  static const String audio = "Audio";
  static const String add = "Add";
  static const String noMediaFound = "No %s found.";
  static const String permissionRequired =
      "Permission to access %s is required to display them.";
  static const String openSettings = "Open Settings";
  static const String videos = "Videos";
  static const String audios = "Audios";
  static const String gif = "GIF";
  static const String deleteRecordingTitle = "Delete Recording?";
  static const String deleteRecordingMessage =
      "Are you sure you want to delete this recording?";
  static const String discard = "Discard";
  static const String listen = "Listen";
  static const String tapAndHold = "tap  &  hold";
  static const String clear = "Clear";
  static const String all = "All";
  static const String folder = "Folder";
  static const String browse = "Browse";
  static const String tiles = "Tiles";
  static const String graph = "Graph";
  static const String recording = "Recording...";
  static const String paused = "Paused";
  static const String stop = "Stop";
  static const String tapOrHoldToResume = "Tap or hold to resume";
  static const String tapOrReleaseToPause = "Tap or release to pause";

  // Media Preview Bottom Sheet
  static const String unsupportedImageType = "Unsupported Image Type";
  static const String couldNotLoadVideo = "Could not load video";

  // Read Journal Bottom Sheet
  static const String couldNotOpenMap = "Could not open map link.";

  // Search View
  static const String searchJournalsHint = "Search journals...";
  static const String textOnly = "Text Only";
  static const String withMedia = "With Media";
  static const String withMood = "With Mood";
  static const String withLocation = "With Location";
  static const String withTags = "With Tags";
  static const String noResultsFound = "No results found";

  // Settings Bottom Sheet
  static const String dailyReminder = "Reminders";
  static const String addReminder = "Add Reminder";
  static const String reminders = "Reminders";
  static const String deleteReminder = "Delete Reminder";
  static const String onThisDay = "On This Day";
  static const String appLock = "App Lock";
  static const String backup = "Backup";
  static const String restore = "Restore";
  static const String importFromAnotherApp = "Import from another app";
  static const String importFromDailyYou = "Import from Daily You";
  static const String selectDailyYouBackup = "Select Daily You backup zip file";
  static const String importingEntries = "Importing entries...";
  static const String importSuccess = "Successfully imported %d entries from Daily You!";
  static const String importFailed = "Import failed: %s";
  static const String noEntriesToImport = "No new entries found to import.";
  static const String privacyPolicy = "Privacy Policy";
  static const String termsNConditions = "Terms & Conditions";
  static const String about = "About App";
  static const String changeTheme = "Change theme";
  static const String theme = "Theme";
  static const String pitchBlack = "Pitch Black";
  static const String themeLight = "Light";
  static const String themeDark = "Dark";
  static const String themeSystem = "System";
  static const String changePin = "Change PIN";
  static const String loading = "Loading...";
  static const String confirmRestoreTitle = "Confirm Restore";
  static const String confirmRestoreMessage =
      "Restoring from a backup will overwrite all current data. This action cannot be undone. Are you sure you want to continue?";
  static const String restoreButton = "Restore";

  // Settings Controller
  static const String notificationScheduled = "Notification scheduled for %s";
  static const String notificationCanceled = "Notification canceled";
  static const String notificationRescheduled = "Notification rescheduled for %s";
  static const String notificationPermissionRequired =
      "Notification permission is required to set reminders.";
  static const String pinChangedSuccess = "PIN changed successfully";
  static const String onThisDayOn = "You'll now get memories from this day.";
  static const String onThisDayOff = "'On This Day' reminders are turned off.";
  static const String themeChanged = "%s theme selected.";
  static const String hideStats = "Hide Stats";
  static const String hideHomeStats = "Hide Home Stats";
  static const String hideInsightsStats = "Hide Insights Stats";

  // Write Journal Bottom Sheet
  static const String sharedImage = "Shared Image";
  static const String sharedVideo = "Shared Video";
  static const String sharedAudio = "Shared Audio (%s)";
  static const String openJotRecording = "OpenJot.rec.%s";
  static const String openJotImage = "OpenJot image (%s)";
  static const String tags = "Tags";
  static const String addTags = "Add tags";
  static const String tagPlaceholder = "#tag";
  static const String todayDate = "Today date";
  static const String customDate = "Custom Date";
  static const String done = "Done";
  static const String startWriting = " Start writing...";
  static const String openInMaps = "Open in Maps";
  static const String changeLocation = "Change Location";
  static const String remove = "Remove";
  static const String discardSelectionsTitle = "Discard Selections?";
  static const String discardSelectionsMessage =
      "You have selected media or an active recording. Are you sure you want to discard them?";

  // Reflection Bottom Sheet
  static const String reflectionTitle = "REFLECTION";
  static const String reflectButton = "Reflect";

  // Other
  static const String searchHintText = "Search entries...";
  static const String aboutApp = "About Open Jot";
  static const String font = "OpenRunde";
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // PIN Management
  static const String incorrectPin = "Incorrect PIN";
  static const String verifyYourPin = "Verify your PIN";
  static const String setAPin = "Set a PIN";
  static const String confirmPin = "Confirm PIN";
  static const String pinsDoNotMatch = "PINs do not match";
  static const String setPin = "Set PIN";
  static const String hello = "Hello!";
  static const String enterYourPin = "Enter your PIN";
  static const String useBiometrics = "Use Biometrics";

  // Hive Service
  static const String settingsBoxName = 'settings';
  static const String journalsBoxName = 'journals';
  static const String isFirstLaunchKey = 'isFirstLaunch';
  static const String themeKey = 'theme';
  static const String pitchBlackKey = 'pitchBlack';
  static const String dailyReminderKey = 'dailyReminder';
  static const String onThisDayKey = 'onThisDay'; // NEW
  static const String rtlSupportKey = 'rtlSupport'; // NEW
  static const String lastOnThisDayNotificationDateKey = 'lastOnThisDayNotificationDate'; // NEW
  static const String autoDeleteDraftsKey = 'autoDeleteDrafts'; // NEW
  static const String reminderTimeKey = 'reminderTime';
  static const String reminderTimesKey = 'reminderTimes';
  static const String reminderSchemaVersionKey = 'reminder_schema_version';
  static const String appLockEnabledKey = 'appLockEnabled';
  static const String appLockPinKey = 'appLockPin';
  static const String dbEncryptionEnabledKey = 'dbEncryptionEnabled';
  static const String encryptionKdfSaltKey = 'encryptionKdfSalt';
  static const String encryptionKdfIterationsKey = 'encryptionKdfIterations';
  static const String encryptionWrappedDekKey = 'encryptionWrappedDek';
  static const String encryptionBiometricEnabledKey =
      'encryptionBiometricEnabled';
  static const String hideHomeStatsKey = 'hideHomeStats';
  static const String hideInsightsStatsKey = 'hideInsightsStats';
  static const String appLocaleKey = 'appLocale';

  // Language & Localization
  static const String language = "Language";
  static const String selectLanguage = "Select Language";
  static const String systemDefault = "System Default";
  static const String searchLanguagesHint = "Search languages...";
  static const String languageChanged = "Language changed to %s.";

  // Additional UI Strings (previously inline literals)
  static const String journalEntryEmpty = "Journal entry cannot be empty";
  static const String discardDateConfirm = "Discard the selected date/time for this entry?";
  static const String addMediaLocationMoodFirst = "Add media, location, or mood first";
  static const String newEntry = "New Entry";
  static const String location = "Location";
  static const String record = "Record";
  static const String selectMomentsToJournal = "Select moments to journal";
  static const String addMomentsFromMenu = "Add media, location, recording, or mood from menu";
  static const String writeSomething = "Write Something";
  static const String saveWithoutWriting = "Save Without Writing";
  static const String oneLocation = "1 Location";
  static const String mediaCount = "%d Media";
  static const String recordingLabel = "Recording";
  static const String startAudioRecording = "Start Audio Recording";
  static const String howAreYouFeeling = "How are you feeling?";
  static const String stateOfMind = "State of Mind";
  static const String generatingPdf = "Generating PDF...";
  static const String voiceRecording = "Voice Recording";
  static const String audioRecording = "Audio Recording";
  static const String couldNotLoadAudio = "Could not load audio file.";
  static const String noRemindersSet = "No reminders set.";
  static const String draftsNeverDeleted = "Drafts will never be deleted";
  static const String draftsDeletedAfterDays = "Drafts will be deleted after %d days";
  static const String dismiss = "Dismiss";
  static const String selectTime = "Select Time";
  static const String now = "Now";
  static const String searchPlacesHint = "Search places, shops...";
  static const String locationPermissionDenied = "Location permission denied.";
  static const String failedGetCurrentLocation = "Failed to get current location.";
  static const String authenticateToUnlock = "Please authenticate to unlock the app";
  static const String encryptDatabase = "Encrypt Database";
  static const String disableEncryption = "Disable Encryption";
  static const String backupPasswordTitle = "Backup Password";
  static const String changeMasterPasswordDesc =
      "Enter your current master password and choose a new password (minimum 6 characters).";
  static const String disableEncryptionDesc =
      "Enter your master password to decrypt your database on disk and turn off encryption.";
  static const String enableEncryptionDesc =
      "Protect all journal notes locally with AES-256-GCM encryption. If you forget your master password, your encrypted data cannot be recovered.";
  static const String verifyForBiometricsDesc =
      "Enter your master password once to store an unlock key in secure hardware storage for biometric quick-unlock.";
  static const String createBackupPasswordDesc =
      "Set a strong password to encrypt this .openjot backup. You will need this password to restore it on any device.";
  static const String enterBackupPasswordDesc =
      "Enter the password used when this .openjot backup was created.";
  static const String encryptDatabaseAction = "Encrypt Database";
  static const String updatePasswordAction = "Update Password";
  static const String decryptAndDisable = "Decrypt & Disable";
  static const String enableBiometricsAction = "Enable Biometrics";
  static const String createBackupAction = "Create Backup";
  static const String decryptBackupAction = "Decrypt Backup";
  static const String newMasterPasswordHint = "New master password";
  static const String backupPasswordHint = "Backup password";
  static const String masterPasswordHint = "Master password";
  static const String enterCurrentMasterPasswordError = "Please enter your current master password.";
  static const String passwordEmptyError = "Password cannot be empty.";
  static const String passwordMinLengthError = "Password must be at least 6 characters long.";
  static const String passwordsDoNotMatchError = "Passwords do not match.";
  static const String currentMasterPasswordHint = "Current master password";
  static const String confirmPasswordHint = "Confirm password";
  static const String excludeUnsavedChangesMessage =
      "You have unsaved changes. Are you sure you want to discard them and exit?";
  static const String sortDefault = "Default";
  static const String sortMutedFirst = "Muted first";
  static const String sortUnmutedFirst = "Unmuted first";
  static const String moodUnsavedChangesMessage =
      "You have unsaved mood color changes. Would you like to save them before closing?";
  static const String askSupport = "Ask Support";
  static const String importSupportNote =
      "Other app formats may not support all features. If you encounter issues or formats change, please raise an issue report so we can fix it.";
  static const String extractingBackup = "Extracting backup...";
  static const String parsingDatabase = "Parsing database...";
  static const String dailyYouDbNotFound = "Daily You database not found in backup.";
  static const String versionPrefix = "Version: %s";
  static const String aboutSubtitle =
      "A minimal, open-source journal to log your thoughts, moods, and memories. All your data stays on your device.";
  static const String keyFeatures = "Key Features";
  static const String aboutFeature1 = "• Clean, distraction-free writing experience.";
  static const String aboutFeature2 = "• Add photos, voice notes, and music to your entries.";
  static const String aboutFeature3 = "• Record your mood alongside your journals.";
  static const String aboutFeature4 = "• Personalize with different text styles.";
  static const String aboutFeature5 = "• Works fully offline, your data stays on your device.";
  static const String openSource = "Open Source";
  static const String openSourceDesc =
      "OpenJot is an open-source application. The source code is publicly available for anyone to inspect, modify, and contribute. We believe in transparency and community collaboration.";
  static const String dataPrivacy = "Data Privacy";
  static const String dataPrivacyDesc =
      "We value your privacy. OpenJot does not collect, store, or transmit any of your personal data. All your journal entries, including text, images, and audio files, are stored exclusively on your device.";
  static const String linksTitle = "Links";
  static const String sourceCodeOnGithub = "Source Code on GitHub";
  static const String sendFeedback = "Send Feedback";
  static const String couldNotLaunchUrl = "Could not launch URL";
  static const String termsIntro =
      "Welcome to OpenJot! This document outlines the terms and conditions for using our application. By using OpenJot, you agree to these terms.";
  static const String termsSectionDataPrivacy = "Data Storage and Privacy";
  static const String termsSectionDataPrivacyBody =
      "OpenJot is designed to be a private space for your thoughts. All journal entries, including text, images, audio files, and other media, are stored exclusively on your local device. The application does not collect, store, or transmit any of your personal data to any external servers. We have no access to your content.";
  static const String termsSectionUserContent = "User-Generated Content";
  static const String termsSectionUserContentBody =
      "You are solely responsible for the content you create and store within OpenJot. This includes any text, images, audio recordings, and other files you add to your journal entries. You are responsible for ensuring you have the necessary rights to use any content you import into the app.";
  static const String termsSectionDisclaimer = "Disclaimer of Warranty";
  static const String termsSectionDisclaimerBody =
      "OpenJot is provided \"as is\" without any warranties, express or implied. We do not guarantee that the app will be error-free or uninterrupted. You use the application at your own risk.";
  static const String termsSectionLiability = "Limitation of Liability";
  static const String termsSectionLiabilityBody =
      "In no event shall the developers of OpenJot be liable for any direct, indirect, incidental, special, or consequential damages, including but not limited to, loss of data, arising out of the use or inability to use this application.";
  static const String termsSectionThirdParty = "Third-Party Libraries";
  static const String termsSectionThirdPartyBody =
      "This application utilizes the following third-party libraries, each governed by its own license:";
  static const String couldNotRestoreNoMedia = "Database restored. No media found in backup.";
  static const String audioFallbackLabel = "Audio";
  static const String storagePermissionsRequired =
      "Storage and media permissions are required to create a backup.";
  static const String selectBackupFolder = 'Select a folder to save the backup';
  static const String backupTempDir = '/backup_temp';
  static const String mediaDir = '/media';
  static const String hiveExtension = '.hive';
  static const String lockExtension = '.lock';
  static const String cameraPhotosKey = 'cameraPhotos';
  static const String galleryImagesKey = 'galleryImages';
  static const String galleryAudiosKey = 'galleryAudios';
  static const String recordingsKey = 'recordings';
  static const String idKey = 'id';
  static const String backupFileNameKey = 'backupFileName';
  static const String backupFileError = 'Could not back up file %s: %s';
  static const String mediaManifestFileName = '/media_manifest.json';
  static const String backupFileNamePrefix = 'OpenJot-Backup-';
  static const String backupFileExtension = '.zip';
  static const String encryptedBackupFileNamePrefix = 'OpenJot-Encrypted-';
  static const String encryptedBackupFileExtension = '.openjot';

  // Database Encryption & Encrypted Backup Strings
  static const String databaseEncryption = "Database Encryption";
  static const String databaseEncryptionDesc = "AES-256-GCM local encryption";
  static const String changeMasterPassword = "Change Master Password";
  static const String biometricUnlock = "Biometric Unlock";
  static const String enterMasterPassword = "Enter Master Password";
  static const String enterMasterPasswordHint =
      "Enter your master password to decrypt your journal.";
  static const String unlockButton = "Unlock";
  static const String unlockWithBiometrics = "Unlock with Biometrics";
  static const String incorrectMasterPassword =
      "Incorrect master password. Please try again.";
  static const String databaseEncryptedSuccess =
      "Journal database encrypted with AES-256-GCM.";
  static const String databaseDecryptedSuccess =
      "Journal database decrypted and app lock turned off.";
  static const String masterPasswordChangedSuccess =
      "Master password updated successfully.";
  static const String encryptedBackupPasswordRequired =
      "A password is required to open an encrypted backup.";
  static const String incorrectBackupPassword = "Incorrect backup password.";
  static const String invalidBackupFile =
      "Selected file is not a valid OpenJot backup.";
  static const String encryptedBackup = "Encrypted Backup (.openjot)";
  static const String encryptedBackupDesc =
      "Protected with AES-256-GCM and a backup password";
  static const String standardBackup = "Standard Backup (.zip)";
  static const String standardBackupDesc =
      "Unencrypted archive compatible with all versions";
  static const String takingBackup = "Taking backup...";
  static const String encryptingBackup = "Encrypting backup...";
  static const String savingBackup = "Saving backup...";
  static const String preparingBackup = "Preparing backup...";
  static const String decryptingBackup = "Decrypting backup...";
  static const String restoringBackup = "Restoring backup...";
  static const String importingBackup = "Importing entries...";
  static const String backupEncodingFailed = "Failed to encode the backup file.";
  static const String backupCreatedSuccess = "Backup created successfully!";
  static const String backupFailed = "Failed to create backup: %s";
  static const String restorePermissionsRequired =
      "Storage and media permissions are required to restore data.";
  static const String restoreTempDir = '/restore_temp';
  static const String databaseRestoredNoMedia =
      "Database restored. No media found in backup.";
  static const String errorRestoringFile = 'Error restoring file %s: %s';
  static const String restoreSuccess = "Restore successful!";
  static const String restoreSuccessRestartRecommended =
      "Restore successful. A restart is recommended to apply all changes.";
  static const String restoreFailed = "Failed to restore data: %s";

  // Reflection Prompts
  static const List<String> reflectionPrompts = [
    "What made you smile today?",
    "Who are you thankful for this week, and why?",
    "What is something small that brought you joy today?",
    "Which part of your day felt most comforting?",
    "What’s something you often take for granted but appreciate now?",
    "What’s the best thing that happened today?",
    "Did someone make your day easier today?",
    "Who made a positive impact on you recently?",
    "What’s a quality you admire in someone close to you?",
    "When did you last feel truly connected with someone?",
    "Who do you want to reach out to soon?",
    "Did someone’s kindness stand out today?",
    "How did you support someone else recently?",
    "Who do you miss the most right now?",
    "What’s a moment from today you want to remember?",
    "What’s a detail about today you might forget if you don’t note it?",
    "What’s the most peaceful moment you had today?",
    "Did you see something beautiful today?",
    "Which memory from this week stands out?",
    "What song, photo, or place will always remind you of today?",
    "What surprised you today?",
    "What challenge did you overcome today?",
    "What’s a small win you had today?",
    "What new thing did you learn about yourself recently?",
    "What are you proud of yourself for?",
    "What habit do you feel good about keeping?",
    "What’s one improvement you’ve noticed in yourself this year?",
    "How did you push yourself out of your comfort zone?",
    "How are you truly feeling right now?",
    "Which emotion stood out the most today?",
    "Did you feel present in any moment today?",
    "When did you feel the most at peace today?",
    "What gave you energy today?",
    "What drained your energy today?",
    "If your mood had a color today, what would it be?",
    "What’s something you’re excited about tomorrow?",
    "What’s one thing you want to improve tomorrow?",
    "What would make tomorrow feel successful?",
    "What do you hope to achieve this week?",
    "What’s a habit you’d like to start tomorrow?",
    "What’s something you want to look forward to in the next month?",
    "What would your ideal tomorrow look like?",
    "What’s one lesson you learned recently?",
    "If you could freeze one moment today, which would it be?",
    "What makes your life feel meaningful right now?",
    "If you described today in one word, what would it be?",
    "What inspired you today?",
    "What did you notice today that you usually overlook?",
    "How has today changed your perspective?",
    "What’s something you’ve been overthinking?",
    "What do you need to let go of?",
    "What part of nature did you notice today?",
    "Did the weather affect your mood today?",
    "What place felt most comforting today?",
    "Where did you feel most at home today?",
    "What sound or smell reminded you of something important?",
    "How did you take care of yourself today?",
    "When did you feel most like yourself today?",
    "What’s something kind you can say to yourself right now?",
    "What do you want to forgive yourself for?",
    "What do you deserve more of in your life?",
  ];
}