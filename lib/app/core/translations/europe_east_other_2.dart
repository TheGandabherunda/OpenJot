import '../constants.dart';

/// Complete Greek (Ελληνικά) translations for OpenJot.
final Map<String, String> elTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Το Ημερολόγιό μου",
  AppConstants.noEntriesMessage:
      "Δεν υπάρχουν καταχωρίσεις ακόμα. Ξεκινήστε να γράφετε!",
  AppConstants.noBookmarksYet: "Δεν υπάρχουν σελιδοδείκτες ακόμα.",
  AppConstants.noDraftsYet: "Δεν υπάρχουν πρόχειρα ακόμα.",
  AppConstants.addEntryButton: "Προσθήκη νέας καταχώρισης",
  AppConstants.jotYourThoughts: "Καταγράψτε τις σκέψεις σας",
  AppConstants.tapToCreateJournal:
      "Πατήστε + για να δημιουργήσετε το προσωπικό σας ημερολόγιο.",
  AppConstants.entriesThisYear: "Καταχωρίσεις φέτος",
  AppConstants.wordsWritten: "Γραμμένες λέξεις",
  AppConstants.daysJournaled: "Ημέρες καταγραφής",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Νέα καταχώριση ημερολογίου",
  AppConstants.editEntryAppBarTitle: "Επεξεργασία καταχώρισης",
  AppConstants.titleHintText: "Τίτλος (π.χ. 'Η μέρα μου', 'Σκέψεις για...')",
  AppConstants.contentHintText: "Γράψτε τις σκέψεις σας εδώ...",
  AppConstants.saveButton: "Αποθήκευση καταχώρισης",
  AppConstants.updateButton: "Ενημέρωση",
  AppConstants.deleteButton: "Διαγραφή καταχώρισης",
  AppConstants.requiredFieldMessage: "Αυτό το πεδίο δεν μπορεί να είναι κενό.",
  AppConstants.newEntry: "Νέα καταχώριση",
  AppConstants.todayDate: "Σημερινή ημερομηνία",
  AppConstants.customDate: "Προσαρμοσμένη ημερομηνία",
  AppConstants.done: "Τέλος",
  AppConstants.startWriting: " Ξεκινήστε να γράφετε...",
  AppConstants.tags: "Ετικέτες",
  AppConstants.addTags: "Προσθήκη ετικετών",
  AppConstants.openInMaps: "Άνοιγμα στους Χάρτες",
  AppConstants.changeLocation: "Αλλαγή τοποθεσίας",
  AppConstants.remove: "Αφαίρεση",
  AppConstants.discardSelectionsTitle: "Απόρριψη επιλογών;",
  AppConstants.discardSelectionsMessage:
      "Έχετε επιλέξει πολυμέσα ή μια ενεργή ηχογράφηση. Είστε βέβαιοι ότι θέλετε να τα απορρίψετε;",
  AppConstants.journalEntryEmpty:
      "Η καταχώριση ημερολογίου δεν μπορεί να είναι κενή",
  AppConstants.discardDateConfirm:
      "Απόρριψη της επιλεγμένης ημερομηνίας/ώρας για αυτή την καταχώριση;",
  AppConstants.addMediaLocationMoodFirst:
      "Προσθέστε πρώτα πολυμέσα, τοποθεσία ή διάθεση",
  AppConstants.location: "Τοποθεσία",
  AppConstants.record: "Εγγραφή",
  AppConstants.selectMomentsToJournal: "Επιλέξτε στιγμές για καταγραφή",
  AppConstants.addMomentsFromMenu:
      "Προσθέστε πολυμέσα, τοποθεσία, ηχογράφηση ή διάθεση από το μενού",
  AppConstants.writeSomething: "Γράψτε κάτι",
  AppConstants.saveWithoutWriting: "Αποθήκευση χωρίς κείμενο",
  AppConstants.oneLocation: "1 τοποθεσία",
  AppConstants.mediaCount: "%d πολυμέσα",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Επιβεβαίωση διαγραφής",
  AppConstants.confirmDeleteMessage:
      "Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή την καταχώριση;",
  AppConstants.pleaseConfirm: "Παρακαλώ επιβεβαιώστε",
  AppConstants.confirmDeleteJournalEntry:
      "Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή την καταχώριση; Αυτή η ενέργεια είναι μη αναστρέψιμη.",
  AppConstants.yes: "Ναι",
  AppConstants.no: "Όχι",
  AppConstants.cancel: "Ακύρωση",
  AppConstants.delete: "Διαγραφή",
  AppConstants.save: "Αποθήκευση",
  AppConstants.entrySavedSuccess: "Η καταχώριση αποθηκεύτηκε με επιτυχία!",
  AppConstants.entryUpdatedSuccess: "Η καταχώριση ενημερώθηκε με επιτυχία!",
  AppConstants.entryDeletedSuccess: "Η καταχώριση διαγράφηκε.",
  AppConstants.errorSavingEntry: "Σφάλμα κατά την αποθήκευση της καταχώρισης.",
  AppConstants.errorDeletingEntry: "Σφάλμα κατά τη διαγραφή της καταχώρισης.",
  AppConstants.errorLoadingEntries: "Σφάλμα κατά τη φόρτωση των καταχωρίσεων.",
  AppConstants.noEntriesForDate:
      "Δεν υπάρχουν καταχωρίσεις για αυτή την ημερομηνία.",
  AppConstants.noEntriesForMonth:
      "Δεν βρέθηκαν καταχωρίσεις για αυτόν τον μήνα.",
  AppConstants.selectMonthAndYear: "Επιλογή μήνα και έτους",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Πολύ δυσάρεστη",
  AppConstants.unpleasant: "Δυσάρεστη",
  AppConstants.slightlyUnpleasant: "Ελαφρώς δυσάρεστη",
  AppConstants.neutral: "Ουδέτερη",
  AppConstants.slightlyPleasant: "Ελαφρώς ευχάριστη",
  AppConstants.pleasant: "Ευχάριστη",
  AppConstants.veryPleasant: "Πολύ ευχάριστη",
  AppConstants.reflection: "Αναστοχασμός",
  AppConstants.edit: "Επεξεργασία",
  AppConstants.removeBookmark: "Αφαίρεση σελιδοδείκτη",
  AppConstants.bookmark: "Σελιδοδείκτης",
  AppConstants.share: "Κοινοποίηση",
  AppConstants.saveAsPdf: "Αποθήκευση ως PDF",
  AppConstants.audioTrack: "Κομμάτι ήχου",
  AppConstants.generatingPdf: "Δημιουργία PDF...",
  AppConstants.voiceRecording: "Φωνητική εγγραφή",
  AppConstants.audioRecording: "Ηχογράφηση",
  AppConstants.couldNotLoadAudio: "Δεν ήταν δυνατή η φόρτωση του αρχείου ήχου.",
  AppConstants.stateOfMind: "Ψυχική κατάσταση",

  // Mood Colors
  AppConstants.moodColors: "Χρώματα διάθεσης",
  AppConstants.customizeMoodColors: "Προσαρμογή χρωμάτων διάθεσης",
  AppConstants.reset: "Επαναφορά",
  AppConstants.resetMoodColors: "Επαναφορά στις προεπιλογές",
  AppConstants.resetMoodColorsConfirm:
      "Επαναφορά όλων των χρωμάτων διάθεσης στις προεπιλεγμένες τιμές;",
  AppConstants.paletteThemes: "Θέματα παλέτας",
  AppConstants.customColor: "Προσαρμοσμένο χρώμα",
  AppConstants.moodUnsavedChangesMessage:
      "Έχετε μη αποθηκευμένες αλλαγές στα χρώματα διάθεσης. Θέλετε να τις αποθηκεύσετε πριν κλείσετε;",

  // Drafts & Auto-save
  AppConstants.drafts: "Πρόχειρα",
  AppConstants.draft: "Πρόχειρο",
  AppConstants.draftSaved: "Αποθηκεύτηκε στα πρόχειρα",
  AppConstants.unsavedChanges: "Μη αποθηκευμένες αλλαγές",
  AppConstants.unsavedChangesMessage:
      "Έχετε μη αποθηκευμένες αλλαγές. Θέλετε να τις αποθηκεύσετε ως πρόχειρο ή να τις απορρίψετε;",
  AppConstants.saveAsDraft: "Αποθήκευση ως πρόχειρο",
  AppConstants.discardChanges: "Απόρριψη",
  AppConstants.autoDeleteDrafts: "Αυτόματη διαγραφή προχείρων",
  AppConstants.days7: "7 ημέρες",
  AppConstants.never: "Ποτέ",
  AppConstants.custom: "Προσαρμοσμένο...",
  AppConstants.enterCustomDays: "Εισαγωγή ημερών",
  AppConstants.customDaysExample: "Π.χ. 14",
  AppConstants.days: "ημέρες",
  AppConstants.draftsNeverDeleted: "Τα πρόχειρα δεν θα διαγραφούν ποτέ",
  AppConstants.draftsDeletedAfterDays:
      "Τα πρόχειρα θα διαγράφονται μετά από %d ημέρες",

  // Home Menu & Sorting
  AppConstants.sortBy: "Ταξινόμηση κατά",
  AppConstants.insights: "Στατιστικά",
  AppConstants.reflections: "Αναστοχασμοί",
  AppConstants.settings: "Ρυθμίσεις",
  AppConstants.entryTime: "Ώρα καταχώρισης",
  AppConstants.bookmarkFirst: "Πρώτα οι σελιδοδείκτες",
  AppConstants.reflectionFirst: "Πρώτα οι αναστοχασμοί",
  AppConstants.withMediaFirst: "Πρώτα με πολυμέσα",
  AppConstants.textOnlyFirst: "Πρώτα μόνο κείμενο",
  AppConstants.withLocationFirst: "Πρώτα με τοποθεσία",
  AppConstants.withMoodFirst: "Πρώτα με διάθεση",
  AppConstants.withTagsFirst: "Πρώτα με ετικέτες",

  // Insights
  AppConstants.stats: "Στατιστικά",
  AppConstants.calendar: "Ημερολόγιο",
  AppConstants.entriesSuffix: " καταχωρίσεις",
  AppConstants.memoriesFromThisDay: "Αναμνήσεις από αυτή την ημέρα",
  AppConstants.standard: "Τυπικό",
  AppConstants.media: "Πολυμέσα",
  AppConstants.mood: "Διάθεση",
  AppConstants.mostly: "Κυρίως",
  AppConstants.averageForThisDay: "Μέσος όρος για αυτή την ημέρα",
  AppConstants.averageForThisYear: "Μέσος όρος για αυτό το έτος",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Καλώς ήρθατε στο OpenJot",
  AppConstants.feature1:
      "Γράψτε ελεύθερα, προσθέστε φωτογραφίες και τοποθεσίες και κρατήστε τα πάντα ασφαλή στη συσκευή σας.",
  AppConstants.feature2:
      "Κατανοήστε τα συναισθήματά σας διαχρονικά με ενσωματωμένη παρακολούθηση διάθεσης.",
  AppConstants.feature3:
      "Τα δεδομένα σας μένουν στο τηλέφωνό σας – χωρίς cloud, μόνο τοπική αποθήκευση και απόλυτη ιδιωτικότητα.",
  AppConstants.continueButton: "Συνέχεια",

  // Notifications
  AppConstants.notificationTitle: "Ώρα για ημερολόγιο!",
  AppConstants.notificationBody:
      "Μην ξεχάσετε να καταγράψετε τις σκέψεις σας για σήμερα.",
  AppConstants.notificationChannelName: "Καθημερινές υπενθυμίσεις",
  AppConstants.notificationChannelDescription:
      "Κανάλι για καθημερινές ειδοποιήσεις υπενθύμισης ημερολογίου",
  AppConstants.onThisDayChannelName: "Αναμνήσεις Σαν Σήμερα",
  AppConstants.onThisDayChannelDescription:
      "Ειδοποιήσεις για αναμνήσεις από προηγούμενα χρόνια.",
  AppConstants.onThisDayNotificationTitle: "Μια ανάμνηση από το ημερολόγιό σας",
  AppConstants.onThisDaySingleEntry:
      "Πριν από ένα χρόνο σήμερα, γράψατε κάτι ξεχωριστό. Πατήστε για να ξαναδείτε τις σκέψεις σας.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Σαν σήμερα πέρυσι, μοιραστήκατε αυτή την ανάμνηση. Πατήστε για να την ξαναζήσετε.",
  AppConstants.onThisDayMultipleEntries:
      "Έχετε αναμνήσεις από αυτή την ημέρα σε προηγούμενα χρόνια. Πατήστε για να τις δείτε.",
  AppConstants.onThisDayGroupedNotification:
      "Έχετε %d αναμνήσεις από αυτή την ημέρα",

  // Exclude Entries
  AppConstants.excludeEntries: "Εξαίρεση καταχωρίσεων",
  AppConstants.saveExclusions: "Αποθήκευση εξαιρέσεων",
  AppConstants.excludeUnsavedChangesMessage:
      "Έχετε μη αποθηκευμένες αλλαγές. Είστε βέβαιοι ότι θέλετε να τις απορρίψετε και να βγείτε;",
  AppConstants.sortDefault: "Προεπιλογή",
  AppConstants.sortMutedFirst: "Πρώτα οι σιωπηλές",
  AppConstants.sortUnmutedFirst: "Πρώτα οι ενεργές",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Σήμερα",
  AppConstants.yesterday: "Χθες",
  AppConstants.contentForQuote: "Περιεχόμενο για παράθεμα",
  AppConstants.noContentSelected: "Δεν επιλέχθηκε περιεχόμενο.",
  AppConstants.photos: "Φωτογραφίες",
  AppConstants.video: "Βίντεο",
  AppConstants.audio: "Ήχος",
  AppConstants.add: "Προσθήκη",
  AppConstants.noMediaFound: "Δεν βρέθηκαν %s.",
  AppConstants.permissionRequired:
      "Απαιτείται άδεια πρόσβασης σε %s για την εμφάνισή τους.",
  AppConstants.openSettings: "Άνοιγμα ρυθμίσεων",
  AppConstants.videos: "Βίντεο",
  AppConstants.audios: "Ήχοι",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Διαγραφή ηχογράφησης;",
  AppConstants.deleteRecordingMessage:
      "Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή την ηχογράφηση;",
  AppConstants.listen: "Ακρόαση",
  AppConstants.tapAndHold: "πατήστε παρατεταμένα",
  AppConstants.clear: "Εκκαθάριση",
  AppConstants.all: "Όλα",
  AppConstants.folder: "Φάκελος",
  AppConstants.browse: "Περιήγηση",
  AppConstants.tiles: "Πλακίδια",
  AppConstants.graph: "Γράφημα",
  AppConstants.recording: "Εγγραφή...",
  AppConstants.recordingLabel: "Εγγραφή",
  AppConstants.startAudioRecording: "Έναρξη ηχογράφησης",
  AppConstants.howAreYouFeeling: "Πώς αισθάνεστε;",
  AppConstants.paused: "Σε παύση",
  AppConstants.stop: "Διακοπή",
  AppConstants.tapOrHoldToResume: "Πατήστε ή κρατήστε πατημένο για συνέχεια",
  AppConstants.tapOrReleaseToPause: "Πατήστε ή αφήστε για παύση",
  AppConstants.unsupportedImageType: "Μη υποστηριζόμενος τύπος εικόνας",
  AppConstants.couldNotLoadVideo: "Δεν ήταν δυνατή η φόρτωση του βίντεο",
  AppConstants.couldNotOpenMap:
      "Δεν ήταν δυνατό το άνοιγμα του συνδέσμου χάρτη.",
  AppConstants.dismiss: "Κλείσιμο",
  AppConstants.selectTime: "Επιλογή ώρας",
  AppConstants.now: "Τώρα",
  AppConstants.searchPlacesHint: "Αναζήτηση μερών, καταστημάτων...",
  AppConstants.locationPermissionDenied: "Απορρίφθηκε η άδεια τοποθεσίας.",
  AppConstants.failedGetCurrentLocation:
      "Αποτυχία λήψης τρέχουσας τοποθεσίας.",

  // Search
  AppConstants.searchJournalsHint: "Αναζήτηση στα ημερολόγια...",
  AppConstants.textOnly: "Μόνο κείμενο",
  AppConstants.withMedia: "Με πολυμέσα",
  AppConstants.withMood: "Με διάθεση",
  AppConstants.withLocation: "Με τοποθεσία",
  AppConstants.withTags: "Με ετικέτες",
  AppConstants.noResultsFound: "Δεν βρέθηκαν αποτελέσματα",
  AppConstants.searchHintText: "Αναζήτηση καταχωρίσεων...",

  // Settings
  AppConstants.language: "Γλώσσα",
  AppConstants.selectLanguage: "Επιλογή γλώσσας",
  AppConstants.systemDefault: "Προεπιλογή συστήματος",
  AppConstants.searchLanguagesHint: "Αναζήτηση γλωσσών...",
  AppConstants.languageChanged: "Η γλώσσα άλλαξε σε %s.",
  AppConstants.dailyReminder: "Υπενθυμίσεις",
  AppConstants.addReminder: "Προσθήκη υπενθύμισης",
  AppConstants.deleteReminder: "Διαγραφή υπενθύμισης",
  AppConstants.noRemindersSet: "Δεν έχουν οριστεί υπενθυμίσεις.",
  AppConstants.onThisDay: "Σαν σήμερα",
  AppConstants.appLock: "Κλείδωμα εφαρμογής",
  AppConstants.backup: "Αντίγραφο ασφαλείας",
  AppConstants.restore: "Επαναφορά",
  AppConstants.importFromAnotherApp: "Εισαγωγή από άλλη εφαρμογή",
  AppConstants.importFromDailyYou: "Εισαγωγή από Daily You",
  AppConstants.selectDailyYouBackup:
      "Επιλέξτε αρχείο zip αντιγράφου Daily You",
  AppConstants.importingEntries: "Εισαγωγή καταχωρίσεων...",
  AppConstants.importSuccess:
      "Εισήχθησαν με επιτυχία %d καταχωρίσεις από το Daily You!",
  AppConstants.importFailed: "Η εισαγωγή απέτυχε: %s",
  AppConstants.noEntriesToImport:
      "Δεν βρέθηκαν νέες καταχωρίσεις για εισαγωγή.",
  AppConstants.askSupport: "Αίτημα υποστήριξης",
  AppConstants.importSupportNote:
      "Οι μορφές άλλων εφαρμογών ενδέχεται να μην υποστηρίζουν όλες τις λειτουργίες. Αν αντιμετωπίσετε προβλήματα ή αλλάξουν οι μορφές, υποβάλετε αναφορά σφάλματος.",
  AppConstants.extractingBackup: "Εξαγωγή αντιγράφου ασφαλείας...",
  AppConstants.parsingDatabase: "Ανάλυση βάσης δεδομένων...",
  AppConstants.dailyYouDbNotFound:
      "Η βάση δεδομένων Daily You δεν βρέθηκε στο αντίγραφο ασφαλείας.",
  AppConstants.privacyPolicy: "Πολιτική απορρήτου",
  AppConstants.termsNConditions: "Όροι και προϋποθέσεις",
  AppConstants.about: "Σχετικά με την εφαρμογή",
  AppConstants.changeTheme: "Αλλαγή θέματος",
  AppConstants.theme: "Θέμα",
  AppConstants.pitchBlack: "Απόλυτο μαύρο",
  AppConstants.themeLight: "Φωτεινό",
  AppConstants.themeDark: "Σκοτεινό",
  AppConstants.themeSystem: "Συστήματος",
  AppConstants.changePin: "Αλλαγή PIN",
  AppConstants.loading: "Φόρτωση...",
  AppConstants.confirmRestoreTitle: "Επιβεβαίωση επαναφοράς",
  AppConstants.confirmRestoreMessage:
      "Η επαναφορά από αντίγραφο ασφαλείας θα αντικαταστήσει όλα τα τρέχοντα δεδομένα. Αυτή η ενέργεια δεν αναιρείται. Είστε βέβαιοι ότι θέλετε να συνεχίσετε;",
  AppConstants.notificationScheduled:
      "Η ειδοποίηση προγραμματίστηκε για τις %s",
  AppConstants.notificationCanceled: "Η ειδοποίηση ακυρώθηκε",
  AppConstants.notificationRescheduled:
      "Η ειδοποίηση επαναπρογραμματίστηκε για τις %s",
  AppConstants.notificationPermissionRequired:
      "Απαιτείται άδεια ειδοποιήσεων για τον ορισμό υπενθυμίσεων.",
  AppConstants.pinChangedSuccess: "Το PIN άλλαξε με επιτυχία",
  AppConstants.onThisDayOn:
      "Πλέον θα λαμβάνετε αναμνήσεις από αυτή την ημέρα.",
  AppConstants.onThisDayOff:
      "Οι υπενθυμίσεις 'Σαν σήμερα' είναι απενεργοποιημένες.",
  AppConstants.themeChanged: "Επιλέχθηκε το θέμα %s.",
  AppConstants.hideStats: "Απόκρυψη στατιστικών",
  AppConstants.hideHomeStats: "Απόκρυψη στατιστικών αρχικής",
  AppConstants.hideInsightsStats: "Απόκρυψη στατιστικών στα Στατιστικά",

  // Reflection Sheet
  AppConstants.reflectionTitle: "ΑΝΑΣΤΟΧΑΣΜΟΣ",
  AppConstants.reflectButton: "Αναστοχασμός",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Λανθασμένο PIN",
  AppConstants.verifyYourPin: "Επαληθεύστε το PIN σας",
  AppConstants.setAPin: "Ορισμός PIN",
  AppConstants.confirmPin: "Επιβεβαίωση PIN",
  AppConstants.pinsDoNotMatch: "Οι κωδικοί PIN δεν ταιριάζουν",
  AppConstants.setPin: "Ορισμός PIN",
  AppConstants.hello: "Γεια σας!",
  AppConstants.enterYourPin: "Εισαγάγετε το PIN σας",
  AppConstants.useBiometrics: "Χρήση βιομετρικών",
  AppConstants.authenticateToUnlock:
      "Παρακαλούμε πιστοποιηθείτε για ξεκλείδωμα της εφαρμογής",
  AppConstants.databaseEncryption: "Κρυπτογράφηση βάσης δεδομένων",
  AppConstants.databaseEncryptionDesc: "Τοπική κρυπτογράφηση AES-256-GCM",
  AppConstants.changeMasterPassword: "Αλλαγή κύριου κωδικού",
  AppConstants.biometricUnlock: "Βιομετρικό ξεκλείδωμα",
  AppConstants.enterMasterPassword: "Εισαγωγή κύριου κωδικού",
  AppConstants.enterMasterPasswordHint:
      "Εισαγάγετε τον κύριο κωδικό σας για να αποκρυπτογραφήσετε το ημερολόγιό σας.",
  AppConstants.unlockButton: "Ξεκλείδωμα",
  AppConstants.unlockWithBiometrics: "Ξεκλείδωμα με βιομετρικά",
  AppConstants.incorrectMasterPassword:
      "Λανθασμένος κύριος κωδικός. Παρακαλώ δοκιμάστε ξανά.",
  AppConstants.databaseEncryptedSuccess:
      "Η βάση δεδομένων ημερολογίου κρυπτογραφήθηκε με AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Η βάση δεδομένων αποκρυπτογραφήθηκε και το κλείδωμα εφαρμογής απενεργοποιήθηκε.",
  AppConstants.masterPasswordChangedSuccess:
      "Ο κύριος κωδικός ενημερώθηκε με επιτυχία.",
  AppConstants.encryptedBackupPasswordRequired:
      "Απαιτείται κωδικός πρόσβασης για το άνοιγμα κρυπτογραφημένου αντιγράφου ασφαλείας.",
  AppConstants.incorrectBackupPassword:
      "Λανθασμένος κωδικός αντιγράφου ασφαλείας.",
  AppConstants.invalidBackupFile:
      "Το επιλεγμένο αρχείο δεν είναι έγκυρο αντίγραφο ασφαλείας OpenJot.",
  AppConstants.encryptedBackup: "Κρυπτογραφημένο αντίγραφο (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Προστατεύεται με AES-256-GCM και κωδικό αντιγράφου",
  AppConstants.standardBackup: "Τυπικό αντίγραφο (.zip)",
  AppConstants.standardBackupDesc:
      "Μη κρυπτογραφημένο αρχείο συμβατό με όλες τις εκδόσεις",
  AppConstants.takingBackup: "Δημιουργία αντιγράφου ασφαλείας...",
  AppConstants.encryptingBackup: "Κρυπτογράφηση αντιγράφου ασφαλείας...",
  AppConstants.savingBackup: "Αποθήκευση αντιγράφου ασφαλείας...",
  AppConstants.preparingBackup: "Προετοιμασία αντιγράφου ασφαλείας...",
  AppConstants.decryptingBackup: "Αποκρυπτογράφηση αντιγράφου ασφαλείας...",
  AppConstants.restoringBackup: "Επαναφορά αντιγράφου ασφαλείας...",
  AppConstants.backupEncodingFailed:
      "Αποτυχία κωδικοποίησης του αρχείου αντιγράφου ασφαλείας.",
  AppConstants.backupCreatedSuccess:
      "Το αντίγραφο ασφαλείας δημιουργήθηκε με επιτυχία!",
  AppConstants.backupFailed:
      "Αποτυχία δημιουργίας αντιγράφου ασφαλείας: %s",
  AppConstants.restorePermissionsRequired:
      "Απαιτούνται δικαιώματα αποθήκευσης και πολυμέσων για την επαναφορά δεδομένων.",
  AppConstants.databaseRestoredNoMedia:
      "Η βάση δεδομένων επαναφέρθηκε. Δεν βρέθηκαν πολυμέσα στο αντίγραφο.",
  AppConstants.restoreSuccess: "Η επαναφορά ολοκληρώθηκε με επιτυχία!",
  AppConstants.restoreSuccessRestartRecommended:
      "Η επαναφορά ολοκληρώθηκε με επιτυχία. Συνιστάται επανεκκίνηση για να εφαρμοστούν όλες οι αλλαγές.",
  AppConstants.restoreFailed: "Αποτυχία επαναφοράς δεδομένων: %s",
  AppConstants.storagePermissionsRequired:
      "Απαιτούνται δικαιώματα αποθήκευσης και πολυμέσων για τη δημιουργία αντιγράφου ασφαλείας.",
  AppConstants.selectBackupFolder:
      "Επιλέξτε φάκελο για αποθήκευση του αντιγράφου",
  AppConstants.encryptDatabase: "Κρυπτογράφηση βάσης δεδομένων",
  AppConstants.disableEncryption: "Απενεργοποίηση κρυπτογράφησης",
  AppConstants.backupPasswordTitle: "Κωδικός αντιγράφου ασφαλείας",
  AppConstants.changeMasterPasswordDesc:
      "Εισαγάγετε τον τρέχοντα κύριο κωδικό σας και επιλέξτε νέο κωδικό (τουλάχιστον 6 χαρακτήρες).",
  AppConstants.disableEncryptionDesc:
      "Εισαγάγετε τον κύριο κωδικό σας για να αποκρυπτογραφήσετε τη βάση δεδομένων στον δίσκο και να απενεργοποιήσετε την κρυπτογράφηση.",
  AppConstants.enableEncryptionDesc:
      "Προστατέψτε όλες τις σημειώσεις του ημερολογίου τοπικά με κρυπτογράφηση AES-256-GCM. Αν ξεχάσετε τον κύριο κωδικό σας, τα κρυπτογραφημένα δεδομένα δεν μπορούν να ανακτηθούν.",
  AppConstants.verifyForBiometricsDesc:
      "Εισαγάγετε τον κύριο κωδικό σας μία φορά για να αποθηκευτεί το κλειδί ξεκλειδώματος σε ασφαλή χώρο υλικού για γρήγορο βιομετρικό ξεκλείδωμα.",
  AppConstants.createBackupPasswordDesc:
      "Ορίστε έναν ισχυρό κωδικό για την κρυπτογράφηση αυτού του αντιγράφου .openjot. Θα χρειαστείτε αυτόν τον κωδικό για επαναφορά σε οποιαδήποτε συσκευή.",
  AppConstants.enterBackupPasswordDesc:
      "Εισαγάγετε τον κωδικό που χρησιμοποιήθηκε κατά τη δημιουργία αυτού του αντιγράφου .openjot.",
  AppConstants.updatePasswordAction: "Ενημέρωση κωδικού",
  AppConstants.decryptAndDisable: "Αποκρυπτογράφηση & απενεργοποίηση",
  AppConstants.enableBiometricsAction: "Ενεργοποίηση βιομετρικών",
  AppConstants.createBackupAction: "Δημιουργία αντιγράφου",
  AppConstants.decryptBackupAction: "Αποκρυπτογράφηση αντιγράφου",
  AppConstants.newMasterPasswordHint: "Νέος κύριος κωδικός",
  AppConstants.backupPasswordHint: "Κωδικός αντιγράφου ασφαλείας",
  AppConstants.masterPasswordHint: "Κύριος κωδικός",
  AppConstants.enterCurrentMasterPasswordError:
      "Παρακαλούμε εισαγάγετε τον τρέχοντα κύριο κωδικό σας.",
  AppConstants.passwordEmptyError: "Ο κωδικός δεν μπορεί να είναι κενός.",
  AppConstants.passwordMinLengthError:
      "Ο κωδικός πρέπει να έχει μήκος τουλάχιστον 6 χαρακτήρων.",
  AppConstants.passwordsDoNotMatchError: "Οι κωδικοί δεν ταιριάζουν.",
  AppConstants.currentMasterPasswordHint: "Τρέχων κύριος κωδικός",
  AppConstants.confirmPasswordHint: "Επιβεβαίωση κωδικού",

  // About & Terms
  AppConstants.aboutApp: "Σχετικά με το OpenJot",
  AppConstants.versionPrefix: "Έκδοση: %s",
  AppConstants.aboutSubtitle:
      "Ένα μινιμαλιστικό ημερολόγιο ανοιχτού κώδικα για να καταγράφετε τις σκέψεις, τις διαθέσεις και τις αναμνήσεις σας. Όλα τα δεδομένα σας μένουν στη συσκευή σας.",
  AppConstants.keyFeatures: "Βασικά χαρακτηριστικά",
  AppConstants.aboutFeature1: "• Καθαρή εμπειρία γραφής χωρίς περισπασμούς.",
  AppConstants.aboutFeature2:
      "• Προσθέστε φωτογραφίες, φωνητικές σημειώσεις και μουσική στις καταχωρίσεις σας.",
  AppConstants.aboutFeature3:
      "• Καταγράψτε τη διάθεσή σας παράλληλα με το ημερολόγιό σας.",
  AppConstants.aboutFeature4:
      "• Εξατομικεύστε με διαφορετικά στυλ κειμένου.",
  AppConstants.aboutFeature5:
      "• Λειτουργεί πλήρως εκτός σύνδεσης, τα δεδομένα σας μένουν στη συσκευή σας.",
  AppConstants.openSource: "Ανοιχτός Κώδικας",
  AppConstants.openSourceDesc:
      "Το OpenJot είναι εφαρμογή ανοιχτού κώδικα. Ο πηγαίος κώδικας είναι δημόσια διαθέσιμος σε οποιονδήποτε για έλεγχο, τροποποίηση και συνεισφορά. Πιστεύουμε στη διαφάνεια και τη συνεργασία της κοινότητας.",
  AppConstants.dataPrivacy: "Απόρρητο Δεδομένων",
  AppConstants.dataPrivacyDesc:
      "Εκτιμούμε την ιδιωτικότητά σας. Το OpenJot δεν συλλέγει, δεν αποθηκεύει και δεν μεταδίδει κανένα προσωπικό σας δεδομένο. Όλες οι καταχωρίσεις σας, συμπεριλαμβανομένων κειμένου, εικόνων και ήχου, αποθηκεύονται αποκλειστικά στη συσκευή σας.",
  AppConstants.linksTitle: "Σύνδεσμοι",
  AppConstants.sourceCodeOnGithub: "Πηγαίος κώδικας στο GitHub",
  AppConstants.sendFeedback: "Αποστολή σχολίων",
  AppConstants.couldNotLaunchUrl: "Δεν ήταν δυνατό το άνοιγμα του URL",
  AppConstants.termsIntro:
      "Καλώς ήρθατε στο OpenJot! Αυτό το έγγραφο περιγράφει τους όρους και τις προϋποθέσεις χρήσης της εφαρμογής μας. Χρησιμοποιώντας το OpenJot, συμφωνείτε με αυτούς τους όρους.",
  AppConstants.termsSectionDataPrivacy: "Αποθήκευση δεδομένων και απόρρητο",
  AppConstants.termsSectionDataPrivacyBody:
      "Το OpenJot έχει σχεδιαστεί ως ένας ιδιωτικός χώρος για τις σκέψεις σας. Όλες οι καταχωρίσεις ημερολογίου, συμπεριλαμβανομένων κειμένου, εικόνων, αρχείων ήχου και άλλων πολυμέσων, αποθηκεύονται αποκλειστικά τοπικά στη συσκευή σας. Η εφαρμογή δεν συλλέγει, δεν αποθηκεύει και δεν μεταδίδει προσωπικά δεδομένα σε εξωτερικούς διακομιστές. Δεν έχουμε καμία πρόσβαση στο περιεχόμενό σας.",
  AppConstants.termsSectionUserContent: "Περιεχόμενο χρήστη",
  AppConstants.termsSectionUserContentBody:
      "Είστε αποκλειστικά υπεύθυνοι για το περιεχόμενο που δημιουργείτε και αποθηκεύετε στο OpenJot, συμπεριλαμβανομένων κειμένων, εικόνων, ηχογραφήσεων και άλλων αρχείων. Είστε υπεύθυνοι να διασφαλίσετε ότι διαθέτετε τα απαραίτητα δικαιώματα για οποιοδήποτε περιεχόμενο εισάγετε στην εφαρμογή.",
  AppConstants.termsSectionDisclaimer: "Αποποίηση εγγύησης",
  AppConstants.termsSectionDisclaimerBody:
      "Το OpenJot παρέχεται «ως έχει» χωρίς καμία ρητή ή σιωπηρή εγγύηση. Δεν εγγυόμαστε ότι η εφαρμογή θα είναι χωρίς σφάλματα ή αδιάλειπτη. Χρησιμοποιείτε την εφαρμογή με δική σας ευθύνη.",
  AppConstants.termsSectionLiability: "Περιορισμός ευθύνης",
  AppConstants.termsSectionLiabilityBody:
      "Σε καμία περίπτωση οι δημιουργοί του OpenJot δεν ευθύνονται για οποιεσδήποτε άμεσες, έμμεσες, τυχαίες, ειδικές ή επακόλουθες ζημίες, συμπεριλαμβανομένης της απώλειας δεδομένων, που προκύπτουν από τη χρήση ή την αδυναμία χρήσης αυτής της εφαρμογής.",
  AppConstants.termsSectionThirdParty: "Βιβλιοθήκες τρίτων",
  AppConstants.termsSectionThirdPartyBody:
      "Αυτή η εφαρμογή χρησιμοποιεί τις ακόλουθες βιβλιοθήκες τρίτων, καθεμία από τις οποίες διέπεται από τη δική της άδεια:",

  // Months
  'January': 'Ιανουάριος',
  'February': 'Φεβρουάριος',
  'March': 'Μάρτιος',
  'April': 'Απρίλιος',
  'May': 'Μάιος',
  'June': 'Ιούνιος',
  'July': 'Ιούλιος',
  'August': 'Αύγουστος',
  'September': 'Σεπτέμβριος',
  'October': 'Οκτώβριος',
  'November': 'Νοέμβριος',
  'December': 'Δεκέμβριος',

  // Reflection Prompts (62)
  "What made you smile today?": "Τι σας έκανε να χαμογελάσετε σήμερα;",
  "Who are you thankful for this week, and why?":
      "Για ποιον είστε ευγνώμονες αυτή την εβδομάδα και γιατί;",
  "What is something small that brought you joy today?":
      "Ποιο μικρό πράγμα σας έφερε χαρά σήμερα;",
  "Which part of your day felt most comforting?":
      "Ποιο μέρος της ημέρας σας ένιωθε πιο παρηγορητικό;",
  "What’s something you often take for granted but appreciate now?":
      "Τι θεωρείτε συχνά δεδομένο αλλά το εκτιμάτε τώρα;",
  "What’s the best thing that happened today?":
      "Ποιο ήταν το καλύτερο πράγμα που συνέβη σήμερα;",
  "Did someone make your day easier today?":
      "Έκανε κάποιος τη μέρα σας πιο εύκολη σήμερα;",
  "Who made a positive impact on you recently?":
      "Ποιος είχε θετικό αντίκτυπο πάνω σας πρόσφατα;",
  "What’s a quality you admire in someone close to you?":
      "Ποια ιδιότητα θαυμάζετε σε ένα κοντινό σας πρόσωπο;",
  "When did you last feel truly connected with someone?":
      "Πότε νιώσατε τελευταία φορά πραγματική σύνδεση με κάποιον;",
  "Who do you want to reach out to soon?":
      "Με ποιον θέλετε να επικοινωνήσετε σύντομα;",
  "Did someone’s kindness stand out today?":
      "Ξεχώρισε η καλοσύνη κάποιου σήμερα;",
  "How did you support someone else recently?":
      "Πώς στηρίξατε κάποιον άλλον πρόσφατα;",
  "Who do you miss the most right now?":
      "Ποιος σας λείπει περισσότερο αυτή τη στιγμή;",
  "What’s a moment from today you want to remember?":
      "Ποια στιγμή από σήμερα θέλετε να θυμάστε;",
  "What’s a detail about today you might forget if you don’t note it?":
      "Ποια λεπτομέρεια της σημερινής ημέρας μπορεί να ξεχάσετε αν δεν τη σημειώσετε;",
  "What’s the most peaceful moment you had today?":
      "Ποια ήταν η πιο γαλήνια στιγμή που είχατε σήμερα;",
  "Did you see something beautiful today?":
      "Είδατε κάτι όμορφο σήμερα;",
  "Which memory from this week stands out?":
      "Ποια ανάμνηση αυτής της εβδομάδας ξεχωρίζει;",
  "What song, photo, or place will always remind you of today?":
      "Ποιο τραγούδι, φωτογραφία ή μέρος θα σας θυμίζει πάντα τη σημερινή μέρα;",
  "What surprised you today?": "Τι σας εξέπληξε σήμερα;",
  "What challenge did you overcome today?":
      "Ποια πρόκληση ξεπεράσατε σήμερα;",
  "What’s a small win you had today?":
      "Ποια μικρή νίκη πετύχατε σήμερα;",
  "What new thing did you learn about yourself recently?":
      "Τι καινούργιο μάθατε για τον εαυτό σας πρόσφατα;",
  "What are you proud of yourself for?":
      "Για τι είστε περήφανοι για τον εαυτό σας;",
  "What habit do you feel good about keeping?":
      "Ποια συνήθεια νιώθετε καλά που διατηρείτε;",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Ποια βελτίωση έχετε παρατηρήσει στον εαυτό σας φέτος;",
  "How did you push yourself out of your comfort zone?":
      "Πώς βγήκατε από τη ζώνη άνεσής σας;",
  "How are you truly feeling right now?":
      "Πώς αισθάνεστε πραγματικά αυτή τη στιγμή;",
  "Which emotion stood out the most today?":
      "Ποιο συναίσθημα ξεχώρισε περισσότερο σήμερα;",
  "Did you feel present in any moment today?":
      "Νιώσατε παρόντες σε κάποια στιγμή σήμερα;",
  "When did you feel the most at peace today?":
      "Πότε νιώσατε τη μεγαλύτερη γαλήνη σήμερα;",
  "What gave you energy today?": "Τι σας έδωσε ενέργεια σήμερα;",
  "What drained your energy today?": "Τι σας εξάντλησε την ενέργεια σήμερα;",
  "If your mood had a color today, what would it be?":
      "Αν η διάθεσή σας είχε ένα χρώμα σήμερα, ποιο θα ήταν;",
  "What’s something you’re excited about tomorrow?":
      "Για τι ανυπομονείτε αύριο;",
  "What’s one thing you want to improve tomorrow?":
      "Ποιο είναι ένα πράγμα που θέλετε να βελτιώσετε αύριο;",
  "What would make tomorrow feel successful?":
      "Τι θα έκανε το αύριο να μοιάζει επιτυχημένο;",
  "What do you hope to achieve this week?":
      "Τι ελπίζετε να πετύχετε αυτή την εβδομάδα;",
  "What’s a habit you’d like to start tomorrow?":
      "Ποια συνήθεια θα θέλατε να ξεκινήσετε αύριο;",
  "What’s something you want to look forward to in the next month?":
      "Τι θέλετε να περιμένετε με χαρά τον επόμενο μήνα;",
  "What would your ideal tomorrow look like?":
      "Πώς θα έμοιαζε το ιδανικό σας αύριο;",
  "What’s one lesson you learned recently?":
      "Ποιο είναι ένα μάθημα που πήρατε πρόσφατα;",
  "If you could freeze one moment today, which would it be?":
      "Αν μπορούσατε να παγώσετε μια στιγμή σήμερα, ποια θα ήταν;",
  "What makes your life feel meaningful right now?":
      "Τι κάνει τη ζωή σας να έχει νόημα αυτή τη στιγμή;",
  "If you described today in one word, what would it be?":
      "Αν περιγράφατε τη σημερινή μέρα με μία λέξη, ποια θα ήταν;",
  "What inspired you today?": "Τι σας ενέπνευσε σήμερα;",
  "What did you notice today that you usually overlook?":
      "Τι παρατηρήσατε σήμερα που συνήθως αγνοείτε;",
  "How has today changed your perspective?":
      "Πώς άλλαξε η σημερινή μέρα την οπτική σας;",
  "What’s something you’ve been overthinking?":
      "Τι είναι αυτό που υπεραναλύετε τελευταία;",
  "What do you need to let go of?": "Τι χρειάζεται να αφήσετε πίσω σας;",
  "What part of nature did you notice today?":
      "Ποιο κομμάτι της φύσης προσέξατε σήμερα;",
  "Did the weather affect your mood today?":
      "Επηρέασε ο καιρός τη διάθεσή σας σήμερα;",
  "What place felt most comforting today?":
      "Ποιο μέρος σας έκανε να νιώσετε πιο άνετα σήμερα;",
  "Where did you feel most at home today?":
      "Πού νιώσατε περισσότερο σαν στο σπίτι σας σήμερα;",
  "What sound or smell reminded you of something important?":
      "Ποιος ήχος ή μυρωδιά σας θύμισε κάτι σημαντικό;",
  "How did you take care of yourself today?":
      "Πώς φροντίσατε τον εαυτό σας σήμερα;",
  "When did you feel most like yourself today?":
      "Πότε νιώσατε περισσότερο ο εαυτός σας σήμερα;",
  "What’s something kind you can say to yourself right now?":
      "Τι ευγενικό μπορείτε να πείτε στον εαυτό σας αυτή τη στιγμή;",
  "What do you want to forgive yourself for?":
      "Για τι θέλετε να συγχωρήσετε τον εαυτό σας;",
  "What do you deserve more of in your life?":
      "Τι αξίζετε περισσότερο στη ζωή σας;",
};

/// Complete Romanian (Română) translations for OpenJot.
final Map<String, String> roTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Jurnalul meu",
  AppConstants.noEntriesMessage:
      "Nicio însemnare în jurnal încă. Începe să scrii!",
  AppConstants.noBookmarksYet: "Niciun semn de carte încă.",
  AppConstants.noDraftsYet: "Nicio ciornă încă.",
  AppConstants.addEntryButton: "Adaugă însemnare nouă",
  AppConstants.jotYourThoughts: "Notează-ți gândurile",
  AppConstants.tapToCreateJournal:
      "Atinge + pentru a crea jurnalul tău personal.",
  AppConstants.entriesThisYear: "Însemnări anul acesta",
  AppConstants.wordsWritten: "Cuvinte scrise",
  AppConstants.daysJournaled: "Zile cu jurnal",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Însemnare nouă în jurnal",
  AppConstants.editEntryAppBarTitle: "Editează însemnarea",
  AppConstants.titleHintText: "Titlu (ex., 'Ziua mea', 'Gânduri despre...')",
  AppConstants.contentHintText: "Scrie-ți gândurile aici...",
  AppConstants.saveButton: "Salvează însemnarea",
  AppConstants.updateButton: "Actualizează",
  AppConstants.deleteButton: "Șterge însemnarea",
  AppConstants.requiredFieldMessage: "Acest câmp nu poate fi gol.",
  AppConstants.newEntry: "Însemnare nouă",
  AppConstants.todayDate: "Data de azi",
  AppConstants.customDate: "Dată personalizată",
  AppConstants.done: "Gata",
  AppConstants.startWriting: " Începe să scrii...",
  AppConstants.tags: "Etichete",
  AppConstants.addTags: "Adaugă etichete",
  AppConstants.openInMaps: "Deschide în Hărți",
  AppConstants.changeLocation: "Schimbă locația",
  AppConstants.remove: "Elimină",
  AppConstants.discardSelectionsTitle: "Renunți la selecții?",
  AppConstants.discardSelectionsMessage:
      "Ai selectat conținut media sau o înregistrare activă. Sigur vrei să renunți la ele?",
  AppConstants.journalEntryEmpty: "Însemnarea din jurnal nu poate fi goală",
  AppConstants.discardDateConfirm:
      "Renunți la data/ora selectată pentru această însemnare?",
  AppConstants.addMediaLocationMoodFirst:
      "Adaugă mai întâi media, locație sau stare de spirit",
  AppConstants.location: "Locație",
  AppConstants.record: "Înregistrează",
  AppConstants.selectMomentsToJournal: "Selectează momente pentru jurnal",
  AppConstants.addMomentsFromMenu:
      "Adaugă media, locație, înregistrare sau stare de spirit din meniu",
  AppConstants.writeSomething: "Scrie ceva",
  AppConstants.saveWithoutWriting: "Salvează fără să scrii",
  AppConstants.oneLocation: "1 locație",
  AppConstants.mediaCount: "%d fișiere media",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Confirmă ștergerea",
  AppConstants.confirmDeleteMessage:
      "Sigur vrei să ștergi această însemnare?",
  AppConstants.pleaseConfirm: "Te rugăm să confirmi",
  AppConstants.confirmDeleteJournalEntry:
      "Sigur vrei să ștergi această însemnare din jurnal? Această acțiune este ireversibilă.",
  AppConstants.yes: "Da",
  AppConstants.no: "Nu",
  AppConstants.cancel: "Anulează",
  AppConstants.delete: "Șterge",
  AppConstants.save: "Salvează",
  AppConstants.entrySavedSuccess: "Însemnare salvată cu succes!",
  AppConstants.entryUpdatedSuccess: "Însemnare actualizată cu succes!",
  AppConstants.entryDeletedSuccess: "Însemnare ștearsă.",
  AppConstants.errorSavingEntry: "Eroare la salvarea însemnării.",
  AppConstants.errorDeletingEntry: "Eroare la ștergerea însemnării.",
  AppConstants.errorLoadingEntries: "Eroare la încărcarea însemnărilor.",
  AppConstants.noEntriesForDate: "Nicio însemnare pentru această dată.",
  AppConstants.noEntriesForMonth:
      "Nu s-au găsit însemnări pentru această lună.",
  AppConstants.selectMonthAndYear: "Selectează luna și anul",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Foarte neplăcut",
  AppConstants.unpleasant: "Neplăcut",
  AppConstants.slightlyUnpleasant: "Ușor neplăcut",
  AppConstants.neutral: "Neutru",
  AppConstants.slightlyPleasant: "Ușor plăcut",
  AppConstants.pleasant: "Plăcut",
  AppConstants.veryPleasant: "Foarte plăcut",
  AppConstants.reflection: "Reflecție",
  AppConstants.edit: "Editează",
  AppConstants.removeBookmark: "Elimină semnul de carte",
  AppConstants.bookmark: "Semn de carte",
  AppConstants.share: "Distribuie",
  AppConstants.saveAsPdf: "Salvează ca PDF",
  AppConstants.audioTrack: "Pistă audio",
  AppConstants.generatingPdf: "Se generează PDF...",
  AppConstants.voiceRecording: "Înregistrare vocală",
  AppConstants.audioRecording: "Înregistrare audio",
  AppConstants.couldNotLoadAudio: "Nu s-a putut încărca fișierul audio.",
  AppConstants.stateOfMind: "Stare de spirit",

  // Mood Colors
  AppConstants.moodColors: "Culori stare de spirit",
  AppConstants.customizeMoodColors: "Personalizează culorile stării",
  AppConstants.reset: "Resetează",
  AppConstants.resetMoodColors: "Resetează la implicit",
  AppConstants.resetMoodColorsConfirm:
      "Resetezi toate culorile stării de spirit la valorile implicite?",
  AppConstants.paletteThemes: "Teme de paletă",
  AppConstants.customColor: "Culoare personalizată",
  AppConstants.moodUnsavedChangesMessage:
      "Ai modificări nesalvate ale culorilor stării de spirit. Dorești să le salvezi înainte de închidere?",

  // Drafts & Auto-save
  AppConstants.drafts: "Ciorne",
  AppConstants.draft: "Ciornă",
  AppConstants.draftSaved: "Salvat în ciorne",
  AppConstants.unsavedChanges: "Modificări nesalvate",
  AppConstants.unsavedChangesMessage:
      "Ai modificări nesalvate. Vrei să le salvezi ca ciornă sau să renunți la ele?",
  AppConstants.saveAsDraft: "Salvează ca ciornă",
  AppConstants.discardChanges: "Renunță",
  AppConstants.autoDeleteDrafts: "Ștergere automată ciorne",
  AppConstants.days7: "7 zile",
  AppConstants.never: "Niciodată",
  AppConstants.custom: "Personalizat...",
  AppConstants.enterCustomDays: "Introdu numărul de zile",
  AppConstants.customDaysExample: "Ex. 14",
  AppConstants.days: "zile",
  AppConstants.draftsNeverDeleted: "Ciornele nu vor fi șterse niciodată",
  AppConstants.draftsDeletedAfterDays: "Ciornele vor fi șterse după %d zile",

  // Home Menu & Sorting
  AppConstants.sortBy: "Sortează după",
  AppConstants.insights: "Statistici",
  AppConstants.reflections: "Reflecții",
  AppConstants.settings: "Setări",
  AppConstants.entryTime: "Ora însemnării",
  AppConstants.bookmarkFirst: "Semne de carte mai întâi",
  AppConstants.reflectionFirst: "Reflecții mai întâi",
  AppConstants.withMediaFirst: "Cu media mai întâi",
  AppConstants.textOnlyFirst: "Doar text mai întâi",
  AppConstants.withLocationFirst: "Cu locație mai întâi",
  AppConstants.withMoodFirst: "Cu stare de spirit mai întâi",
  AppConstants.withTagsFirst: "Cu etichete mai întâi",

  // Insights
  AppConstants.stats: "Statistici",
  AppConstants.calendar: "Calendar",
  AppConstants.entriesSuffix: " însemnări",
  AppConstants.memoriesFromThisDay: "Amintiri din această zi",
  AppConstants.standard: "Standard",
  AppConstants.media: "Media",
  AppConstants.mood: "Stare",
  AppConstants.mostly: "În principal",
  AppConstants.averageForThisDay: "Media pentru această zi",
  AppConstants.averageForThisYear: "Media pentru acest an",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Bun venit la OpenJot",
  AppConstants.feature1:
      "Scrie liber, adaugă fotografii și locații și păstrează totul în siguranță pe dispozitivul tău.",
  AppConstants.feature2:
      "Înțelege-ți emoțiile în timp cu monitorizarea integrată a stării de spirit.",
  AppConstants.feature3:
      "Datele tale rămân pe telefon – fără cloud, doar stocare locală și confidențialitate deplină.",
  AppConstants.continueButton: "Continuă",

  // Notifications
  AppConstants.notificationTitle: "Timpul pentru jurnal!",
  AppConstants.notificationBody:
      "Nu uita să-ți notezi gândurile pentru ziua de azi.",
  AppConstants.notificationChannelName: "Mementouri zilnice",
  AppConstants.notificationChannelDescription:
      "Canal pentru notificările zilnice de reamintire a jurnalului",
  AppConstants.onThisDayChannelName: "Amintiri În această zi",
  AppConstants.onThisDayChannelDescription:
      "Notificări pentru amintiri din anii trecuți.",
  AppConstants.onThisDayNotificationTitle: "O amintire din jurnalul tău",
  AppConstants.onThisDaySingleEntry:
      "Acum un an, în această zi, ai scris ceva special. Atinge pentru a-ți revedea gândurile.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "În această zi anul trecut, ai salvat această amintire. Atinge pentru a o retrăi.",
  AppConstants.onThisDayMultipleEntries:
      "Ai amintiri din această zi din anii trecuți. Atinge pentru a le revedea.",
  AppConstants.onThisDayGroupedNotification:
      "Ai %d amintiri din această zi",

  // Exclude Entries
  AppConstants.excludeEntries: "Exclude însemnări",
  AppConstants.saveExclusions: "Salvează excluderile",
  AppConstants.excludeUnsavedChangesMessage:
      "Ai modificări nesalvate. Sigur vrei să renunți la ele și să ieși?",
  AppConstants.sortDefault: "Implicit",
  AppConstants.sortMutedFirst: "Ascunse mai întâi",
  AppConstants.sortUnmutedFirst: "Vizibile mai întâi",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Azi",
  AppConstants.yesterday: "Ieri",
  AppConstants.contentForQuote: "Conținut pentru citat",
  AppConstants.noContentSelected: "Niciun conținut selectat.",
  AppConstants.photos: "Fotografii",
  AppConstants.video: "Video",
  AppConstants.audio: "Audio",
  AppConstants.add: "Adaugă",
  AppConstants.noMediaFound: "Nu s-au găsit %s.",
  AppConstants.permissionRequired:
      "Este necesară permisiunea de acces la %s pentru afișare.",
  AppConstants.openSettings: "Deschide setările",
  AppConstants.videos: "Videoclipuri",
  AppConstants.audios: "Audio",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Ștergi înregistrarea?",
  AppConstants.deleteRecordingMessage:
      "Sigur vrei să ștergi această înregistrare?",
  AppConstants.listen: "Ascultă",
  AppConstants.tapAndHold: "atinge și ține apăsat",
  AppConstants.clear: "Șterge",
  AppConstants.all: "Toate",
  AppConstants.folder: "Dosar",
  AppConstants.browse: "Răsfoiește",
  AppConstants.tiles: "Dale",
  AppConstants.graph: "Grafic",
  AppConstants.recording: "Se înregistrează...",
  AppConstants.recordingLabel: "Înregistrare",
  AppConstants.startAudioRecording: "Începe înregistrarea audio",
  AppConstants.howAreYouFeeling: "Cum te simți?",
  AppConstants.paused: "În pauză",
  AppConstants.stop: "Oprește",
  AppConstants.tapOrHoldToResume: "Atinge sau ține apăsat pentru a relua",
  AppConstants.tapOrReleaseToPause: "Atinge sau eliberează pentru pauză",
  AppConstants.unsupportedImageType: "Tip de imagine neacceptat",
  AppConstants.couldNotLoadVideo: "Nu s-a putut încărca videoclipul",
  AppConstants.couldNotOpenMap: "Nu s-a putut deschide linkul hărții.",
  AppConstants.dismiss: "Închide",
  AppConstants.selectTime: "Selectează ora",
  AppConstants.now: "Acum",
  AppConstants.searchPlacesHint: "Caută locuri, magazine...",
  AppConstants.locationPermissionDenied: "Permisiunea de locație a fost refuzată.",
  AppConstants.failedGetCurrentLocation:
      "Nu s-a putut obține locația curentă.",

  // Search
  AppConstants.searchJournalsHint: "Caută în jurnale...",
  AppConstants.textOnly: "Doar text",
  AppConstants.withMedia: "Cu media",
  AppConstants.withMood: "Cu stare",
  AppConstants.withLocation: "Cu locație",
  AppConstants.withTags: "Cu etichete",
  AppConstants.noResultsFound: "Niciun rezultat găsit",
  AppConstants.searchHintText: "Caută însemnări...",

  // Settings
  AppConstants.language: "Limbă",
  AppConstants.selectLanguage: "Selectează limba",
  AppConstants.systemDefault: "Implicit sistem",
  AppConstants.searchLanguagesHint: "Caută limbi...",
  AppConstants.languageChanged: "Limba a fost schimbată în %s.",
  AppConstants.dailyReminder: "Mementouri",
  AppConstants.addReminder: "Adaugă memento",
  AppConstants.deleteReminder: "Șterge memento",
  AppConstants.noRemindersSet: "Niciun memento setat.",
  AppConstants.onThisDay: "În această zi",
  AppConstants.appLock: "Blocare aplicație",
  AppConstants.backup: "Copie de rezervă",
  AppConstants.restore: "Restaurează",
  AppConstants.importFromAnotherApp: "Importă din altă aplicație",
  AppConstants.importFromDailyYou: "Importă din Daily You",
  AppConstants.selectDailyYouBackup:
      "Selectează fișierul zip de backup Daily You",
  AppConstants.importingEntries: "Se importă însemnările...",
  AppConstants.importSuccess: "S-au importat cu succes %d însemnări din Daily You!",
  AppConstants.importFailed: "Import eșuat: %s",
  AppConstants.noEntriesToImport:
      "Nu s-au găsit însemnări noi pentru import.",
  AppConstants.askSupport: "Cere ajutor",
  AppConstants.importSupportNote:
      "Formatele altor aplicații pot să nu suporte toate funcțiile. Dacă întâmpini probleme sau formatele se schimbă, te rugăm să raportezi problema.",
  AppConstants.extractingBackup: "Se extrage copia de rezervă...",
  AppConstants.parsingDatabase: "Se analizează baza de date...",
  AppConstants.dailyYouDbNotFound:
      "Baza de date Daily You nu a fost găsită în copia de rezervă.",
  AppConstants.privacyPolicy: "Politica de confidențialitate",
  AppConstants.termsNConditions: "Termeni și condiții",
  AppConstants.about: "Despre aplicație",
  AppConstants.changeTheme: "Schimbă tema",
  AppConstants.theme: "Temă",
  AppConstants.pitchBlack: "Negru intens",
  AppConstants.themeLight: "Luminos",
  AppConstants.themeDark: "Întunecat",
  AppConstants.themeSystem: "Sistem",
  AppConstants.changePin: "Schimbă PIN",
  AppConstants.loading: "Se încarcă...",
  AppConstants.confirmRestoreTitle: "Confirmă restaurarea",
  AppConstants.confirmRestoreMessage:
      "Restaurarea dintr-o copie de rezervă va suprascrie toate datele curente. Această acțiune nu poate fi anulată. Sigur vrei să continui?",
  AppConstants.notificationScheduled: "Notificare programată pentru %s",
  AppConstants.notificationCanceled: "Notificare anulată",
  AppConstants.notificationRescheduled: "Notificare reprogramată pentru %s",
  AppConstants.notificationPermissionRequired:
      "Permisiunea pentru notificări este necesară pentru a seta mementouri.",
  AppConstants.pinChangedSuccess: "PIN schimbat cu succes",
  AppConstants.onThisDayOn: "Vei primi acum amintiri din această zi.",
  AppConstants.onThisDayOff: "Mementourile 'În această zi' sunt dezactivate.",
  AppConstants.themeChanged: "Tema %s a fost selectată.",
  AppConstants.hideStats: "Ascunde statisticile",
  AppConstants.hideHomeStats: "Ascunde statisticile de acasă",
  AppConstants.hideInsightsStats: "Ascunde statisticile din Statistici",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLECȚIE",
  AppConstants.reflectButton: "Reflectează",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "PIN incorect",
  AppConstants.verifyYourPin: "Verifică-ți codul PIN",
  AppConstants.setAPin: "Setează un PIN",
  AppConstants.confirmPin: "Confirmă PIN",
  AppConstants.pinsDoNotMatch: "Codurile PIN nu se potrivesc",
  AppConstants.setPin: "Setează PIN",
  AppConstants.hello: "Salut!",
  AppConstants.enterYourPin: "Introdu codul tău PIN",
  AppConstants.useBiometrics: "Folosește biometria",
  AppConstants.authenticateToUnlock:
      "Te rugăm să te autentifici pentru a debloca aplicația",
  AppConstants.databaseEncryption: "Criptare bază de date",
  AppConstants.databaseEncryptionDesc: "Criptare locală AES-256-GCM",
  AppConstants.changeMasterPassword: "Schimbă parola principală",
  AppConstants.biometricUnlock: "Deblocare biometrică",
  AppConstants.enterMasterPassword: "Introdu parola principală",
  AppConstants.enterMasterPasswordHint:
      "Introdu parola principală pentru a-ți decripta jurnalul.",
  AppConstants.unlockButton: "Deblochează",
  AppConstants.unlockWithBiometrics: "Deblochează biometric",
  AppConstants.incorrectMasterPassword:
      "Parolă principală incorectă. Te rugăm să încerci din nou.",
  AppConstants.databaseEncryptedSuccess:
      "Baza de date a jurnalului a fost criptată cu AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Baza de date a fost decriptată, iar blocarea aplicației a fost dezactivată.",
  AppConstants.masterPasswordChangedSuccess:
      "Parola principală a fost actualizată cu succes.",
  AppConstants.encryptedBackupPasswordRequired:
      "Este necesară o parolă pentru a deschide o copie de rezervă criptată.",
  AppConstants.incorrectBackupPassword: "Parolă de rezervă incorectă.",
  AppConstants.invalidBackupFile:
      "Fișierul selectat nu este o copie de rezervă OpenJot validă.",
  AppConstants.encryptedBackup: "Copie criptată (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Protejată cu AES-256-GCM și o parolă de rezervă",
  AppConstants.standardBackup: "Copie standard (.zip)",
  AppConstants.standardBackupDesc:
      "Arhivă necriptată compatibilă cu toate versiunile",
  AppConstants.takingBackup: "Se creează copia de rezervă...",
  AppConstants.encryptingBackup: "Se criptează copia de rezervă...",
  AppConstants.savingBackup: "Se salvează copia de rezervă...",
  AppConstants.preparingBackup: "Se pregătește copia de rezervă...",
  AppConstants.decryptingBackup: "Se decriptează copia de rezervă...",
  AppConstants.restoringBackup: "Se restaurează copia de rezervă...",
  AppConstants.backupEncodingFailed:
      "Codificarea fișierului de rezervă a eșuat.",
  AppConstants.backupCreatedSuccess: "Copie de rezervă creată cu succes!",
  AppConstants.backupFailed: "Crearea copiei de rezervă a eșuat: %s",
  AppConstants.restorePermissionsRequired:
      "Sunt necesare permisiuni de stocare și media pentru a restaura datele.",
  AppConstants.databaseRestoredNoMedia:
      "Baza de date restaurată. Nu s-a găsit conținut media în copie.",
  AppConstants.restoreSuccess: "Restaurare reușită!",
  AppConstants.restoreSuccessRestartRecommended:
      "Restaurare reușită. Se recomandă repornirea pentru a aplica toate modificările.",
  AppConstants.restoreFailed: "Restaurarea datelor a eșuat: %s",
  AppConstants.storagePermissionsRequired:
      "Sunt necesare permisiuni de stocare și media pentru a crea o copie de rezervă.",
  AppConstants.selectBackupFolder:
      "Selectează un dosar pentru a salva copia de rezervă",
  AppConstants.encryptDatabase: "Criptează baza de date",
  AppConstants.disableEncryption: "Dezactivează criptarea",
  AppConstants.backupPasswordTitle: "Parolă copie de rezervă",
  AppConstants.changeMasterPasswordDesc:
      "Introdu parola principală curentă și alege o parolă nouă (minim 6 caractere).",
  AppConstants.disableEncryptionDesc:
      "Introdu parola principală pentru a decripta baza de date de pe disc și a dezactiva criptarea.",
  AppConstants.enableEncryptionDesc:
      "Protejează toate notițele din jurnal local cu criptare AES-256-GCM. Dacă uiți parola principală, datele criptate nu pot fi recuperate.",
  AppConstants.verifyForBiometricsDesc:
      "Introdu parola principală o singură dată pentru a stoca o cheie de deblocare în stocarea hardware securizată pentru deblocare biometrică rapidă.",
  AppConstants.createBackupPasswordDesc:
      "Setează o parolă puternică pentru a cripta această copie .openjot. Vei avea nevoie de această parolă pentru restaurare pe orice dispozitiv.",
  AppConstants.enterBackupPasswordDesc:
      "Introdu parola folosită la crearea acestei copii de rezervă .openjot.",
  AppConstants.updatePasswordAction: "Actualizează parola",
  AppConstants.decryptAndDisable: "Decriptează și dezactivează",
  AppConstants.enableBiometricsAction: "Activează biometria",
  AppConstants.createBackupAction: "Creează copie",
  AppConstants.decryptBackupAction: "Decriptează copia",
  AppConstants.newMasterPasswordHint: "Parolă principală nouă",
  AppConstants.backupPasswordHint: "Parolă copie de rezervă",
  AppConstants.masterPasswordHint: "Parolă principală",
  AppConstants.enterCurrentMasterPasswordError:
      "Te rugăm să introduci parola principală curentă.",
  AppConstants.passwordEmptyError: "Parola nu poate fi goală.",
  AppConstants.passwordMinLengthError:
      "Parola trebuie să aibă cel puțin 6 caractere.",
  AppConstants.passwordsDoNotMatchError: "Parolele nu se potrivesc.",
  AppConstants.currentMasterPasswordHint: "Parola principală curentă",
  AppConstants.confirmPasswordHint: "Confirmă parola",

  // About & Terms
  AppConstants.aboutApp: "Despre OpenJot",
  AppConstants.versionPrefix: "Versiune: %s",
  AppConstants.aboutSubtitle:
      "Un jurnal minimalist, open-source, pentru a-ți nota gândurile, stările și amintirile. Toate datele tale rămân pe dispozitivul tău.",
  AppConstants.keyFeatures: "Funcții principale",
  AppConstants.aboutFeature1:
      "• Experiență de scriere curată, fără distrageri.",
  AppConstants.aboutFeature2:
      "• Adaugă fotografii, notițe vocale și muzică în însemnările tale.",
  AppConstants.aboutFeature3:
      "• Înregistrează-ți starea de spirit alături de jurnal.",
  AppConstants.aboutFeature4: "• Personalizează cu diferite stiluri de text.",
  AppConstants.aboutFeature5:
      "• Funcționează complet offline, datele tale rămân pe dispozitiv.",
  AppConstants.openSource: "Open Source",
  AppConstants.openSourceDesc:
      "OpenJot este o aplicație open-source. Codul sursă este disponibil public oricui pentru inspectare, modificare și contribuție. Credem în transparență și colaborare comunitară.",
  AppConstants.dataPrivacy: "Confidențialitatea datelor",
  AppConstants.dataPrivacyDesc:
      "Prețuim intimitatea ta. OpenJot nu colectează, nu stochează și nu transmite datele tale personale. Toate însemnările tale, inclusiv textul, imaginile și fișierele audio, sunt stocate exclusiv pe dispozitivul tău.",
  AppConstants.linksTitle: "Linkuri",
  AppConstants.sourceCodeOnGithub: "Cod sursă pe GitHub",
  AppConstants.sendFeedback: "Trimite feedback",
  AppConstants.couldNotLaunchUrl: "Nu s-a putut deschide URL-ul",
  AppConstants.termsIntro:
      "Bun venit la OpenJot! Acest document prezintă termenii și condițiile de utilizare a aplicației noastre. Folosind OpenJot, ești de acord cu acești termeni.",
  AppConstants.termsSectionDataPrivacy:
      "Stocarea datelor și confidențialitatea",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot este conceput ca un spațiu privat pentru gândurile tale. Toate însemnările, inclusiv textul, imaginile, fișierele audio și alte elemente media, sunt stocate exclusiv local pe dispozitivul tău. Aplicația nu colectează, nu stochează și nu transmite date personale către servere externe. Nu avem acces la conținutul tău.",
  AppConstants.termsSectionUserContent: "Conținut generat de utilizator",
  AppConstants.termsSectionUserContentBody:
      "Ești singurul responsabil pentru conținutul pe care îl creezi și îl stochezi în OpenJot, inclusiv text, imagini, înregistrări audio și alte fișiere. Ești responsabil să te asiguri că deții drepturile necesare pentru orice conținut importat în aplicație.",
  AppConstants.termsSectionDisclaimer: "Exonerare de garanție",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot este furnizat \"ca atare\", fără niciun fel de garanții, exprese sau implicite. Nu garantăm că aplicația va fi lipsită de erori sau neîntreruptă. Utilizezi aplicația pe propriul risc.",
  AppConstants.termsSectionLiability: "Limitarea răspunderii",
  AppConstants.termsSectionLiabilityBody:
      "În niciun caz dezvoltatorii OpenJot nu vor fi răspunzători pentru daune directe, indirecte, incidentale, speciale sau consecutive, inclusiv pierderea datelor, rezultate din utilizarea sau imposibilitatea utilizării acestei aplicații.",
  AppConstants.termsSectionThirdParty: "Biblioteci terțe",
  AppConstants.termsSectionThirdPartyBody:
      "Această aplicație utilizează următoarele biblioteci terțe, fiecare guvernată de propria licență:",

  // Months
  'January': 'Ianuarie',
  'February': 'Februarie',
  'March': 'Martie',
  'April': 'Aprilie',
  'May': 'Mai',
  'June': 'Iunie',
  'July': 'Iulie',
  'August': 'August',
  'September': 'Septembrie',
  'October': 'Octombrie',
  'November': 'Noiembrie',
  'December': 'Decembrie',

  // Reflection Prompts (62)
  "What made you smile today?": "Ce te-a făcut să zâmbești azi?",
  "Who are you thankful for this week, and why?":
      "Cui îi ești recunoscător săptămâna aceasta și de ce?",
  "What is something small that brought you joy today?":
      "Ce lucru mic ți-a adus bucurie azi?",
  "Which part of your day felt most comforting?":
      "Ce parte a zilei tale s-a simțit cea mai reconfortantă?",
  "What’s something you often take for granted but appreciate now?":
      "Ce iei adesea de bun, dar apreciezi acum?",
  "What’s the best thing that happened today?":
      "Care este cel mai bun lucru care s-a întâmplat azi?",
  "Did someone make your day easier today?":
      "Ți-a făcut cineva ziua mai ușoară azi?",
  "Who made a positive impact on you recently?":
      "Cine a avut un impact pozitiv asupra ta recent?",
  "What’s a quality you admire in someone close to you?":
      "Ce calitate admiri la cineva apropiat ție?",
  "When did you last feel truly connected with someone?":
      "Când te-ai simțit ultima dată cu adevărat conectat cu cineva?",
  "Who do you want to reach out to soon?":
      "Pe cine vrei să contactezi în curând?",
  "Did someone’s kindness stand out today?":
      "S-a remarcat bunătatea cuiva azi?",
  "How did you support someone else recently?":
      "Cum ai sprijinit pe altcineva recent?",
  "Who do you miss the most right now?":
      "De cine îți este cel mai dor acum?",
  "What’s a moment from today you want to remember?":
      "Ce moment de azi vrei să-ți amintești?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Ce detaliu de azi ai putea uita dacă nu-l notezi?",
  "What’s the most peaceful moment you had today?":
      "Care a fost cel mai liniștit moment pe care l-ai avut azi?",
  "Did you see something beautiful today?": "Ai văzut ceva frumos azi?",
  "Which memory from this week stands out?":
      "Ce amintire din această săptămână iese în evidență?",
  "What song, photo, or place will always remind you of today?":
      "Ce melodie, fotografie sau loc îți va aminti mereu de ziua de azi?",
  "What surprised you today?": "Ce te-a surprins azi?",
  "What challenge did you overcome today?": "Ce provocare ai depășit azi?",
  "What’s a small win you had today?": "Ce mică victorie ai avut azi?",
  "What new thing did you learn about yourself recently?":
      "Ce lucru nou ai aflat despre tine recent?",
  "What are you proud of yourself for?": "De ce ești mândru la tine?",
  "What habit do you feel good about keeping?":
      "Ce obicei te face să te simți bine că îl păstrezi?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Ce îmbunătățire ai observat la tine anul acesta?",
  "How did you push yourself out of your comfort zone?":
      "Cum ai ieșit din zona ta de confort?",
  "How are you truly feeling right now?":
      "Cum te simți cu adevărat chiar acum?",
  "Which emotion stood out the most today?":
      "Ce emoție a ieșit cel mai mult în evidență azi?",
  "Did you feel present in any moment today?":
      "Te-ai simțit prezent în vreun moment azi?",
  "When did you feel the most at peace today?":
      "Când te-ai simțit cel mai împăcat azi?",
  "What gave you energy today?": "Ce ți-a dat energie azi?",
  "What drained your energy today?": "Ce ți-a consumat energia azi?",
  "If your mood had a color today, what would it be?":
      "Dacă starea ta de azi ar avea o culoare, care ar fi?",
  "What’s something you’re excited about tomorrow?":
      "De ce ești entuziasmat pentru mâine?",
  "What’s one thing you want to improve tomorrow?":
      "Ce lucru vrei să îmbunătățești mâine?",
  "What would make tomorrow feel successful?":
      "Ce ar face ca ziua de mâine să pară o reușită?",
  "What do you hope to achieve this week?":
      "Ce speri să realizezi săptămâna aceasta?",
  "What’s a habit you’d like to start tomorrow?":
      "Ce obicei ai vrea să începi mâine?",
  "What’s something you want to look forward to in the next month?":
      "Ce aștepți cu nerăbdare în luna următoare?",
  "What would your ideal tomorrow look like?":
      "Cum ar arăta ziua ta de mâine ideală?",
  "What’s one lesson you learned recently?": "Ce lecție ai învățat recent?",
  "If you could freeze one moment today, which would it be?":
      "Dacă ai putea opri un moment azi, care ar fi?",
  "What makes your life feel meaningful right now?":
      "Ce face ca viața ta să pară plină de sens acum?",
  "If you described today in one word, what would it be?":
      "Dacă ai descrie ziua de azi într-un cuvânt, care ar fi?",
  "What inspired you today?": "Ce te-a inspirat azi?",
  "What did you notice today that you usually overlook?":
      "Ce ai observat azi din ce treci de obicei cu vederea?",
  "How has today changed your perspective?":
      "Cum ți-a schimbat ziua de azi perspectiva?",
  "What’s something you’ve been overthinking?":
      "La ce te-ai gândit prea mult în ultima vreme?",
  "What do you need to let go of?": "De ce trebuie să te eliberezi?",
  "What part of nature did you notice today?":
      "Ce parte a naturii ai observat azi?",
  "Did the weather affect your mood today?":
      "Ți-a influențat vremea starea de spirit azi?",
  "What place felt most comforting today?":
      "Ce loc s-a simțit cel mai confortabil azi?",
  "Where did you feel most at home today?":
      "Unde te-ai simțit cel mai mult ca acasă azi?",
  "What sound or smell reminded you of something important?":
      "Ce sunet sau miros ți-a amintit de ceva important?",
  "How did you take care of yourself today?":
      "Cum ai avut grijă de tine azi?",
  "When did you feel most like yourself today?":
      "Când te-ai simțit cel mai mult tu însuți azi?",
  "What’s something kind you can say to yourself right now?":
      "Ce lucru frumos îți poți spune chiar acum?",
  "What do you want to forgive yourself for?":
      "Pentru ce vrei să te ierți?",
  "What do you deserve more of in your life?":
      "Ce meriți mai mult în viața ta?",
};

/// Complete Hungarian (Magyar) translations for OpenJot.
final Map<String, String> huTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Naplóm",
  AppConstants.noEntriesMessage: "Még nincsenek bejegyzések. Kezdj el írni!",
  AppConstants.noBookmarksYet: "Még nincsenek könyvjelzők.",
  AppConstants.noDraftsYet: "Még nincsenek piszkozatok.",
  AppConstants.addEntryButton: "Új bejegyzés hozzáadása",
  AppConstants.jotYourThoughts: "Jegyezd le a gondolataidat",
  AppConstants.tapToCreateJournal:
      "Koppints a + gombra a személyes naplód létrehozásához.",
  AppConstants.entriesThisYear: "Idei bejegyzések",
  AppConstants.wordsWritten: "Leírt szavak",
  AppConstants.daysJournaled: "Naplózott napok",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Új naplóbejegyzés",
  AppConstants.editEntryAppBarTitle: "Bejegyzés szerkesztése",
  AppConstants.titleHintText: "Cím (pl. 'A napom', 'Gondolatok...')",
  AppConstants.contentHintText: "Írd ide a gondolataidat...",
  AppConstants.saveButton: "Bejegyzés mentése",
  AppConstants.updateButton: "Frissítés",
  AppConstants.deleteButton: "Bejegyzés törlése",
  AppConstants.requiredFieldMessage: "Ez a mező nem lehet üres.",
  AppConstants.newEntry: "Új bejegyzés",
  AppConstants.todayDate: "Mai dátum",
  AppConstants.customDate: "Egyéni dátum",
  AppConstants.done: "Kész",
  AppConstants.startWriting: " Kezdj el írni...",
  AppConstants.tags: "Címkék",
  AppConstants.addTags: "Címkék hozzáadása",
  AppConstants.openInMaps: "Megnyitás a Térképen",
  AppConstants.changeLocation: "Hely módosítása",
  AppConstants.remove: "Eltávolítás",
  AppConstants.discardSelectionsTitle: "Elveted a kijelöléseket?",
  AppConstants.discardSelectionsMessage:
      "Médiát vagy aktív hangfelvételt választottál ki. Biztosan elveted őket?",
  AppConstants.journalEntryEmpty: "A naplóbejegyzés nem lehet üres",
  AppConstants.discardDateConfirm:
      "Elveted a bejegyzéshez választott dátumot/időt?",
  AppConstants.addMediaLocationMoodFirst:
      "Először adj hozzá médiát, helyet vagy hangulatot",
  AppConstants.location: "Helyszín",
  AppConstants.record: "Felvétel",
  AppConstants.selectMomentsToJournal: "Válassz pillanatokat a naplóhoz",
  AppConstants.addMomentsFromMenu:
      "Adj hozzá médiát, helyszínt, felvételt vagy hangulatot a menüből",
  AppConstants.writeSomething: "Írj valamit",
  AppConstants.saveWithoutWriting: "Mentés írás nélkül",
  AppConstants.oneLocation: "1 helyszín",
  AppConstants.mediaCount: "%d média",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Törlés megerősítése",
  AppConstants.confirmDeleteMessage:
      "Biztosan törölni szeretnéd ezt a bejegyzést?",
  AppConstants.pleaseConfirm: "Kérjük, erősítsd meg",
  AppConstants.confirmDeleteJournalEntry:
      "Biztosan törölni szeretnéd ezt a naplóbejegyzést? Ez a művelet nem vonható vissza.",
  AppConstants.yes: "Igen",
  AppConstants.no: "Nem",
  AppConstants.cancel: "Mégse",
  AppConstants.delete: "Törlés",
  AppConstants.save: "Mentés",
  AppConstants.entrySavedSuccess: "Naplóbejegyzés sikeresen mentve!",
  AppConstants.entryUpdatedSuccess: "Naplóbejegyzés sikeresen frissítve!",
  AppConstants.entryDeletedSuccess: "Naplóbejegyzés törölve.",
  AppConstants.errorSavingEntry: "Hiba a bejegyzés mentésekor.",
  AppConstants.errorDeletingEntry: "Hiba a bejegyzés törlésekor.",
  AppConstants.errorLoadingEntries: "Hiba a bejegyzések betöltésekor.",
  AppConstants.noEntriesForDate: "Nincsenek bejegyzések erre a dátumra.",
  AppConstants.noEntriesForMonth: "Nem találhatók bejegyzések erre a hónapra.",
  AppConstants.selectMonthAndYear: "Hónap és év kiválasztása",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Nagyon kellemetlen",
  AppConstants.unpleasant: "Kellemetlen",
  AppConstants.slightlyUnpleasant: "Enyhén kellemetlen",
  AppConstants.neutral: "Semleges",
  AppConstants.slightlyPleasant: "Enyhén kellemes",
  AppConstants.pleasant: "Kellemes",
  AppConstants.veryPleasant: "Nagyon kellemes",
  AppConstants.reflection: "Elmélkedés",
  AppConstants.edit: "Szerkesztés",
  AppConstants.removeBookmark: "Könyvjelző eltávolítása",
  AppConstants.bookmark: "Könyvjelző",
  AppConstants.share: "Megosztás",
  AppConstants.saveAsPdf: "Mentés PDF-ként",
  AppConstants.audioTrack: "Hangsáv",
  AppConstants.generatingPdf: "PDF generálása...",
  AppConstants.voiceRecording: "Hangfelvétel",
  AppConstants.audioRecording: "Hangfelvétel",
  AppConstants.couldNotLoadAudio: "Nem sikerült betölteni a hangfájlt.",
  AppConstants.stateOfMind: "Lelkiállapot",

  // Mood Colors
  AppConstants.moodColors: "Hangulatszínek",
  AppConstants.customizeMoodColors: "Hangulatszínek testreszabása",
  AppConstants.reset: "Visszaállítás",
  AppConstants.resetMoodColors: "Alapértelmezés visszaállítása",
  AppConstants.resetMoodColorsConfirm:
      "Minden hangulatszínt visszaállítasz az alapértelmezettre?",
  AppConstants.paletteThemes: "Palettatémák",
  AppConstants.customColor: "Egyéni szín",
  AppConstants.moodUnsavedChangesMessage:
      "Mentetlen hangulatszín-módosításaid vannak. Szeretnéd menteni őket bezárás előtt?",

  // Drafts & Auto-save
  AppConstants.drafts: "Piszkozatok",
  AppConstants.draft: "Piszkozat",
  AppConstants.draftSaved: "Piszkozatokba mentve",
  AppConstants.unsavedChanges: "Mentetlen módosítások",
  AppConstants.unsavedChangesMessage:
      "Mentetlen módosításaid vannak. Elmented őket piszkozatként, vagy elveted?",
  AppConstants.saveAsDraft: "Mentés piszkozatként",
  AppConstants.discardChanges: "Elvetés",
  AppConstants.autoDeleteDrafts: "Piszkozatok automatikus törlése",
  AppConstants.days7: "7 nap",
  AppConstants.never: "Soha",
  AppConstants.custom: "Egyéni...",
  AppConstants.enterCustomDays: "Add meg a napok számát",
  AppConstants.customDaysExample: "Pl. 14",
  AppConstants.days: "nap",
  AppConstants.draftsNeverDeleted: "A piszkozatok soha nem törlődnek",
  AppConstants.draftsDeletedAfterDays: "A piszkozatok %d nap után törlődnek",

  // Home Menu & Sorting
  AppConstants.sortBy: "Rendezés",
  AppConstants.insights: "Betekintés",
  AppConstants.reflections: "Elmélkedések",
  AppConstants.settings: "Beállítások",
  AppConstants.entryTime: "Bejegyzés ideje",
  AppConstants.bookmarkFirst: "Könyvjelzők elöl",
  AppConstants.reflectionFirst: "Elmélkedések elöl",
  AppConstants.withMediaFirst: "Médiával elöl",
  AppConstants.textOnlyFirst: "Csak szöveg elöl",
  AppConstants.withLocationFirst: "Helyszínnel elöl",
  AppConstants.withMoodFirst: "Hangulattal elöl",
  AppConstants.withTagsFirst: "Címkékkel elöl",

  // Insights
  AppConstants.stats: "Statisztika",
  AppConstants.calendar: "Naptár",
  AppConstants.entriesSuffix: " bejegyzés",
  AppConstants.memoriesFromThisDay: "Emlékek erről a napról",
  AppConstants.standard: "Normál",
  AppConstants.media: "Média",
  AppConstants.mood: "Hangulat",
  AppConstants.mostly: "Többnyire",
  AppConstants.averageForThisDay: "Átlag erre a napra",
  AppConstants.averageForThisYear: "Átlag erre az évre",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Üdvözöl az OpenJot",
  AppConstants.feature1:
      "Írj szabadon, adj hozzá fotókat és helyszíneket, és tarts mindent biztonságban az eszközödön.",
  AppConstants.feature2:
      "Értsd meg az érzelmeidet az idő múlásával a beépített hangulatkövetéssel.",
  AppConstants.feature3:
      "Adataid a telefonodon maradnak – nincs felhő, csak helyi tárolás és teljes adatvédelem.",
  AppConstants.continueButton: "Tovább",

  // Notifications
  AppConstants.notificationTitle: "Ideje naplót írni!",
  AppConstants.notificationBody: "Ne felejtsd el leírni a mai gondolataidat.",
  AppConstants.notificationChannelName: "Napi napló emlékeztetők",
  AppConstants.notificationChannelDescription:
      "Csatorna a napi napló-emlékeztető értesítésekhez",
  AppConstants.onThisDayChannelName: "Ezen a napon emlékek",
  AppConstants.onThisDayChannelDescription:
      "Értesítések korábbi évek emlékeiről.",
  AppConstants.onThisDayNotificationTitle: "Egy emlék a naplódból",
  AppConstants.onThisDaySingleEntry:
      "Egy éve ezen a napon valami különlegeset írtál. Koppints a gondolataid felidézéséhez.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Tavaly ezen a napon osztottad meg ezt az emléket. Koppints az újraéléséhez.",
  AppConstants.onThisDayMultipleEntries:
      "Korábbi évekből emlékeid vannak erről a napról. Koppints a megtekintésükhöz.",
  AppConstants.onThisDayGroupedNotification:
      "%d emléked van erről a napról",

  // Exclude Entries
  AppConstants.excludeEntries: "Bejegyzések kizárása",
  AppConstants.saveExclusions: "Kizárások mentése",
  AppConstants.excludeUnsavedChangesMessage:
      "Mentetlen módosításaid vannak. Biztosan elveted őket és kilépsz?",
  AppConstants.sortDefault: "Alapértelmezett",
  AppConstants.sortMutedFirst: "Némítottak elöl",
  AppConstants.sortUnmutedFirst: "Aktívak elöl",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Ma",
  AppConstants.yesterday: "Tegnap",
  AppConstants.contentForQuote: "Tartalom az idézethez",
  AppConstants.noContentSelected: "Nincs kiválasztott tartalom.",
  AppConstants.photos: "Fotók",
  AppConstants.video: "Videó",
  AppConstants.audio: "Hang",
  AppConstants.add: "Hozzáadás",
  AppConstants.noMediaFound: "Nem található %s.",
  AppConstants.permissionRequired:
      "A megjelenítéshez hozzáférési engedély szükséges: %s.",
  AppConstants.openSettings: "Beállítások megnyitása",
  AppConstants.videos: "Videók",
  AppConstants.audios: "Hangok",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Törlöd a felvételt?",
  AppConstants.deleteRecordingMessage:
      "Biztosan törölni szeretnéd ezt a felvételt?",
  AppConstants.listen: "Meghallgatás",
  AppConstants.tapAndHold: "nyomd meg és tartsd",
  AppConstants.clear: "Törlés",
  AppConstants.all: "Mind",
  AppConstants.folder: "Mappa",
  AppConstants.browse: "Tallózás",
  AppConstants.tiles: "Csempék",
  AppConstants.graph: "Grafikon",
  AppConstants.recording: "Felvétel...",
  AppConstants.recordingLabel: "Felvétel",
  AppConstants.startAudioRecording: "Hangfelvétel indítása",
  AppConstants.howAreYouFeeling: "Hogy érzed magad?",
  AppConstants.paused: "Szüneteltetve",
  AppConstants.stop: "Leállítás",
  AppConstants.tapOrHoldToResume: "Koppints vagy tartsd nyomva a folytatáshoz",
  AppConstants.tapOrReleaseToPause: "Koppints vagy engedd fel a szünethez",
  AppConstants.unsupportedImageType: "Nem támogatott képtípus",
  AppConstants.couldNotLoadVideo: "A videó nem tölthető be",
  AppConstants.couldNotOpenMap: "A térképhivatkozás nem nyitható meg.",
  AppConstants.dismiss: "Bezárás",
  AppConstants.selectTime: "Idő kiválasztása",
  AppConstants.now: "Most",
  AppConstants.searchPlacesHint: "Helyek, üzletek keresése...",
  AppConstants.locationPermissionDenied: "Helyhozzáférési engedély megtagadva.",
  AppConstants.failedGetCurrentLocation:
      "Nem sikerült lekérni az aktuális helyet.",

  // Search
  AppConstants.searchJournalsHint: "Keresés a naplókban...",
  AppConstants.textOnly: "Csak szöveg",
  AppConstants.withMedia: "Médiával",
  AppConstants.withMood: "Hangulattal",
  AppConstants.withLocation: "Helyszínnel",
  AppConstants.withTags: "Címkékkel",
  AppConstants.noResultsFound: "Nincs találat",
  AppConstants.searchHintText: "Bejegyzések keresése...",

  // Settings
  AppConstants.language: "Nyelv",
  AppConstants.selectLanguage: "Nyelv kiválasztása",
  AppConstants.systemDefault: "Rendszer alapértelmezett",
  AppConstants.searchLanguagesHint: "Nyelvek keresése...",
  AppConstants.languageChanged: "A nyelv megváltozott erre: %s.",
  AppConstants.dailyReminder: "Emlékeztetők",
  AppConstants.addReminder: "Emlékeztető hozzáadása",
  AppConstants.deleteReminder: "Emlékeztető törlése",
  AppConstants.noRemindersSet: "Nincsenek beállított emlékeztetők.",
  AppConstants.onThisDay: "Ezen a napon",
  AppConstants.appLock: "Alkalmazászár",
  AppConstants.backup: "Biztonsági mentés",
  AppConstants.restore: "Visszaállítás",
  AppConstants.importFromAnotherApp: "Importálás másik alkalmazásból",
  AppConstants.importFromDailyYou: "Importálás Daily You-ból",
  AppConstants.selectDailyYouBackup:
      "Válaszd ki a Daily You mentési zip fájlt",
  AppConstants.importingEntries: "Bejegyzések importálása...",
  AppConstants.importSuccess:
      "%d bejegyzés sikeresen importálva a Daily You-ból!",
  AppConstants.importFailed: "Az importálás sikertelen: %s",
  AppConstants.noEntriesToImport:
      "Nem találhatók új importálható bejegyzések.",
  AppConstants.askSupport: "Segítség kérése",
  AppConstants.importSupportNote:
      "Más alkalmazások formátumai nem feltétlenül támogatnak minden funkciót. Ha problémába ütközöl vagy a formátum megváltozik, kérjük, jelentsd a hibát.",
  AppConstants.extractingBackup: "Biztonsági mentés kicsomagolása...",
  AppConstants.parsingDatabase: "Adatbázis feldolgozása...",
  AppConstants.dailyYouDbNotFound:
      "A Daily You adatbázis nem található a mentésben.",
  AppConstants.privacyPolicy: "Adatvédelmi irányelvek",
  AppConstants.termsNConditions: "Felhasználási feltételek",
  AppConstants.about: "Az alkalmazásról",
  AppConstants.changeTheme: "Téma váltása",
  AppConstants.theme: "Téma",
  AppConstants.pitchBlack: "Koromfekete",
  AppConstants.themeLight: "Világos",
  AppConstants.themeDark: "Sötét",
  AppConstants.themeSystem: "Rendszer",
  AppConstants.changePin: "PIN módosítása",
  AppConstants.loading: "Betöltés...",
  AppConstants.confirmRestoreTitle: "Visszaállítás megerősítése",
  AppConstants.confirmRestoreMessage:
      "A biztonsági mentésből történő visszaállítás felülírja az összes jelenlegi adatot. Ez a művelet nem vonható vissza. Biztosan folytatod?",
  AppConstants.notificationScheduled: "Értesítés ütemezve ekkorra: %s",
  AppConstants.notificationCanceled: "Értesítés törölve",
  AppConstants.notificationRescheduled: "Értesítés átütemezve ekkorra: %s",
  AppConstants.notificationPermissionRequired:
      "Az emlékeztetők beállításához értesítési engedély szükséges.",
  AppConstants.pinChangedSuccess: "PIN sikeresen megváltoztatva",
  AppConstants.onThisDayOn: "Mostantól emlékeket kapsz erről a napról.",
  AppConstants.onThisDayOff: "Az 'Ezen a napon' emlékeztetők ki vannak kapcsolva.",
  AppConstants.themeChanged: "%s téma kiválasztva.",
  AppConstants.hideStats: "Statisztikák elrejtése",
  AppConstants.hideHomeStats: "Kezdőképernyő statisztikák elrejtése",
  AppConstants.hideInsightsStats: "Betekintés statisztikák elrejtése",

  // Reflection Sheet
  AppConstants.reflectionTitle: "ELMÉLKEDÉS",
  AppConstants.reflectButton: "Elmélkedés",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Helytelen PIN",
  AppConstants.verifyYourPin: "Ellenőrizd a PIN kódod",
  AppConstants.setAPin: "PIN beállítása",
  AppConstants.confirmPin: "PIN megerősítése",
  AppConstants.pinsDoNotMatch: "A PIN kódok nem egyeznek",
  AppConstants.setPin: "PIN beállítása",
  AppConstants.hello: "Szia!",
  AppConstants.enterYourPin: "Add meg a PIN kódod",
  AppConstants.useBiometrics: "Biometria használata",
  AppConstants.authenticateToUnlock:
      "Kérjük, azonosítsd magad az alkalmazás feloldásához",
  AppConstants.databaseEncryption: "Adatbázis-titkosítás",
  AppConstants.databaseEncryptionDesc: "AES-256-GCM helyi titkosítás",
  AppConstants.changeMasterPassword: "Mesterjelszó módosítása",
  AppConstants.biometricUnlock: "Biometrikus feloldás",
  AppConstants.enterMasterPassword: "Add meg a mesterjelszót",
  AppConstants.enterMasterPasswordHint:
      "Add meg a mesterjelszavad a naplód visszafejtéséhez.",
  AppConstants.unlockButton: "Feloldás",
  AppConstants.unlockWithBiometrics: "Feloldás biometriával",
  AppConstants.incorrectMasterPassword:
      "Helytelen mesterjelszó. Próbáld újra.",
  AppConstants.databaseEncryptedSuccess:
      "A napló adatbázis titkosítva AES-256-GCM-mel.",
  AppConstants.databaseDecryptedSuccess:
      "A napló adatbázis visszafejtve és az alkalmazászár kikapcsolva.",
  AppConstants.masterPasswordChangedSuccess:
      "A mesterjelszó sikeresen frissítve.",
  AppConstants.encryptedBackupPasswordRequired:
      "A titkosított biztonsági mentés megnyitásához jelszó szükséges.",
  AppConstants.incorrectBackupPassword: "Helytelen mentési jelszó.",
  AppConstants.invalidBackupFile:
      "A kiválasztott fájl nem érvényes OpenJot biztonsági mentés.",
  AppConstants.encryptedBackup: "Titkosított mentés (.openjot)",
  AppConstants.encryptedBackupDesc:
      "AES-256-GCM-mel és mentési jelszóval védve",
  AppConstants.standardBackup: "Normál mentés (.zip)",
  AppConstants.standardBackupDesc:
      "Minden verzióval kompatibilis, titkosítatlan archívum",
  AppConstants.takingBackup: "Biztonsági mentés készítése...",
  AppConstants.encryptingBackup: "Mentés titkosítása...",
  AppConstants.savingBackup: "Mentés tárolása...",
  AppConstants.preparingBackup: "Mentés előkészítése...",
  AppConstants.decryptingBackup: "Mentés visszafejtése...",
  AppConstants.restoringBackup: "Mentés visszaállítása...",
  AppConstants.backupEncodingFailed:
      "Nem sikerült kódolni a biztonsági mentés fájlját.",
  AppConstants.backupCreatedSuccess:
      "Biztonsági mentés sikeresen létrehozva!",
  AppConstants.backupFailed:
      "Nem sikerült létrehozni a biztonsági mentést: %s",
  AppConstants.restorePermissionsRequired:
      "Az adatok visszaállításához tárhely- és médiaengedélyek szükségesek.",
  AppConstants.databaseRestoredNoMedia:
      "Adatbázis visszaállítva. Nem található média a mentésben.",
  AppConstants.restoreSuccess: "Visszaállítás sikeres!",
  AppConstants.restoreSuccessRestartRecommended:
      "Visszaállítás sikeres. A módosítások életbe lépéséhez újraindítás ajánlott.",
  AppConstants.restoreFailed: "Nem sikerült visszaállítani az adatokat: %s",
  AppConstants.storagePermissionsRequired:
      "A biztonsági mentés készítéséhez tárhely- és médiaengedélyek szükségesek.",
  AppConstants.selectBackupFolder:
      "Válassz mappát a biztonsági mentés mentéséhez",
  AppConstants.encryptDatabase: "Adatbázis titkosítása",
  AppConstants.disableEncryption: "Titkosítás kikapcsolása",
  AppConstants.backupPasswordTitle: "Mentési jelszó",
  AppConstants.changeMasterPasswordDesc:
      "Add meg a jelenlegi mesterjelszavad, és válassz új jelszót (legalább 6 karakter).",
  AppConstants.disableEncryptionDesc:
      "Add meg a mesterjelszavad a lemezen lévő adatbázis visszafejtéséhez és a titkosítás kikapcsolásához.",
  AppConstants.enableEncryptionDesc:
      "Védd az összes naplójegyzetet helyileg AES-256-GCM titkosítással. Ha elfelejted a mesterjelszavad, a titkosított adatok nem állíthatók helyre.",
  AppConstants.verifyForBiometricsDesc:
      "Add meg egyszer a mesterjelszavad, hogy a feloldókulcs biztonságos hardvertárban tárolódjon a gyors biometrikus feloldáshoz.",
  AppConstants.createBackupPasswordDesc:
      "Állíts be egy erős jelszót ennek a .openjot mentésnek a titkosításához. Bármely eszközön történő visszaállításhoz szükséged lesz erre a jelszóra.",
  AppConstants.enterBackupPasswordDesc:
      "Add meg a .openjot mentés létrehozásakor használt jelszót.",
  AppConstants.updatePasswordAction: "Jelszó frissítése",
  AppConstants.decryptAndDisable: "Visszafejtés és kikapcsolás",
  AppConstants.enableBiometricsAction: "Biometria engedélyezése",
  AppConstants.createBackupAction: "Mentés készítése",
  AppConstants.decryptBackupAction: "Mentés visszafejtése",
  AppConstants.newMasterPasswordHint: "Új mesterjelszó",
  AppConstants.backupPasswordHint: "Mentési jelszó",
  AppConstants.masterPasswordHint: "Mesterjelszó",
  AppConstants.enterCurrentMasterPasswordError:
      "Kérjük, add meg a jelenlegi mesterjelszavad.",
  AppConstants.passwordEmptyError: "A jelszó nem lehet üres.",
  AppConstants.passwordMinLengthError:
      "A jelszónak legalább 6 karakter hosszúnak kell lennie.",
  AppConstants.passwordsDoNotMatchError: "A jelszavak nem egyeznek.",
  AppConstants.currentMasterPasswordHint: "Jelenlegi mesterjelszó",
  AppConstants.confirmPasswordHint: "Jelszó megerősítése",

  // About & Terms
  AppConstants.aboutApp: "Az OpenJot névjegye",
  AppConstants.versionPrefix: "Verzió: %s",
  AppConstants.aboutSubtitle:
      "Minimalista, nyílt forráskódú napló a gondolataid, hangulataid és emlékeid rögzítéséhez. Minden adatod az eszközödön marad.",
  AppConstants.keyFeatures: "Főbb funkciók",
  AppConstants.aboutFeature1: "• Tiszta, zavaró tényezőktől mentes írási élmény.",
  AppConstants.aboutFeature2:
      "• Adj hozzá fotókat, hangjegyzeteket és zenét a bejegyzéseidhez.",
  AppConstants.aboutFeature3: "• Rögzítsd a hangulatodat a naplód mellett.",
  AppConstants.aboutFeature4: "• Szabd testre különböző szövegstílusokkal.",
  AppConstants.aboutFeature5:
      "• Teljesen offline működik, az adataid az eszközödön maradnak.",
  AppConstants.openSource: "Nyílt forráskód",
  AppConstants.openSourceDesc:
      "Az OpenJot egy nyílt forráskódú alkalmazás. A forráskód nyilvánosan elérhető bárki számára megtekintésre, módosításra és közreműködésre. Hiszünk az átláthatóságban és a közösségi együttműködésben.",
  AppConstants.dataPrivacy: "Adatvédelem",
  AppConstants.dataPrivacyDesc:
      "Nagyra értékeljük a magánéletedet. Az OpenJot nem gyűjt, nem tárol és nem továbbít személyes adatokat. Minden bejegyzésed, beleértve a szöveget, képeket és hangfájlokat, kizárólag az eszközödön tárolódik.",
  AppConstants.linksTitle: "Hivatkozások",
  AppConstants.sourceCodeOnGithub: "Forráskód a GitHubon",
  AppConstants.sendFeedback: "Visszajelzés küldése",
  AppConstants.couldNotLaunchUrl: "Nem sikerült megnyitni az URL-t",
  AppConstants.termsIntro:
      "Üdvözlünk az OpenJotban! Ez a dokumentum ismerteti alkalmazásunk használatának feltételeit. Az OpenJot használatával elfogadod ezeket a feltételeket.",
  AppConstants.termsSectionDataPrivacy: "Adattárolás és adatvédelem",
  AppConstants.termsSectionDataPrivacyBody:
      "Az OpenJot úgy lett kialakítva, hogy privát teret biztosítson a gondolataidnak. Minden naplóbejegyzés, beleértve a szöveget, képeket, hangfájlokat és egyéb médiát, kizárólag helyileg az eszközödön tárolódik. Az alkalmazás nem gyűjt, nem tárol és nem továbbít személyes adatokat külső szerverekre. Nincs hozzáférésünk a tartalmadhoz.",
  AppConstants.termsSectionUserContent: "Felhasználó által létrehozott tartalom",
  AppConstants.termsSectionUserContentBody:
      "Kizárólag te felelsz az OpenJotban létrehozott és tárolt tartalmakért, beleértve a szövegeket, képeket, hangfelvételeket és egyéb fájlokat. A te felelősséged gondoskodni arról, hogy rendelkezz a szükséges jogokkal az alkalmazásba importált tartalmak használatához.",
  AppConstants.termsSectionDisclaimer: "Szavatosság kizárása",
  AppConstants.termsSectionDisclaimerBody:
      "Az OpenJot \"adott állapotban\" kerül biztosításra, bármilyen kifejezett vagy hallgatólagos szavatosság nélkül. Nem garantáljuk, hogy az alkalmazás hibamentes vagy megszakítás nélküli lesz. Az alkalmazást saját felelősségedre használod.",
  AppConstants.termsSectionLiability: "Felelősség korlátozása",
  AppConstants.termsSectionLiabilityBody:
      "Az OpenJot fejlesztői semmilyen esetben sem tehetők felelőssé semmilyen közvetlen, közvetett, véletlen, különleges vagy következményes kárért, beleértve az adatvesztést is, amely az alkalmazás használatából vagy használhatatlanságából ered.",
  AppConstants.termsSectionThirdParty: "Harmadik féltől származó könyvtárak",
  AppConstants.termsSectionThirdPartyBody:
      "Ez az alkalmazás a következő harmadik féltől származó könyvtárakat használja, amelyek mindegyikére saját licence vonatkozik:",

  // Months
  'January': 'Január',
  'February': 'Február',
  'March': 'Március',
  'April': 'Április',
  'May': 'Május',
  'June': 'Június',
  'July': 'Július',
  'August': 'Augusztus',
  'September': 'Szeptember',
  'October': 'Október',
  'November': 'November',
  'December': 'December',

  // Reflection Prompts (62)
  "What made you smile today?": "Mi csalt mosolyt az arcodra ma?",
  "Who are you thankful for this week, and why?":
      "Kinek vagy hálás ezen a héten, és miért?",
  "What is something small that brought you joy today?":
      "Mi volt az az apróság, ami örömet okozott ma?",
  "Which part of your day felt most comforting?":
      "A napod melyik része volt a legmegnyugtatóbb?",
  "What’s something you often take for granted but appreciate now?":
      "Mi az, amit gyakran természetesnek veszel, de most értékelsz?",
  "What’s the best thing that happened today?":
      "Mi a legjobb dolog, ami ma történt?",
  "Did someone make your day easier today?":
      "Megkönnyítette valaki a napodat ma?",
  "Who made a positive impact on you recently?":
      "Ki volt rád pozitív hatással mostanában?",
  "What’s a quality you admire in someone close to you?":
      "Milyen tulajdonságot csodálsz egy hozzád közel állóban?",
  "When did you last feel truly connected with someone?":
      "Mikor érezted utoljára, hogy igazán kapcsolódsz valakihez?",
  "Who do you want to reach out to soon?":
      "Kihez szeretnél hamarosan szólni?",
  "Did someone’s kindness stand out today?":
      "Kitűnt ma valakinek a kedvessége?",
  "How did you support someone else recently?":
      "Hogyan támogattál valakit mostanában?",
  "Who do you miss the most right now?":
      "Ki hiányzik most a legjobban?",
  "What’s a moment from today you want to remember?":
      "A mai nap melyik pillanatára szeretnél emlékezni?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Milyen mai részletet felejthetsz el, ha nem jegyzed fel?",
  "What’s the most peaceful moment you had today?":
      "Melyik volt a legbékésebb pillanatod ma?",
  "Did you see something beautiful today?": "Láttál ma valami szépet?",
  "Which memory from this week stands out?":
      "Melyik emlék emelkedik ki erről a hétről?",
  "What song, photo, or place will always remind you of today?":
      "Melyik dal, fotó vagy hely fog mindig a mai napra emlékeztetni?",
  "What surprised you today?": "Mi lepett meg ma?",
  "What challenge did you overcome today?":
      "Milyen kihívást győztél le ma?",
  "What’s a small win you had today?": "Milyen kis sikert értél el ma?",
  "What new thing did you learn about yourself recently?":
      "Mit tudtál meg magadról újat mostanában?",
  "What are you proud of yourself for?": "Mire vagy büszke magadban?",
  "What habit do you feel good about keeping?":
      "Milyen szokás megtartása okoz jó érzést?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Milyen fejlődést vettél észre magadon ebben az évben?",
  "How did you push yourself out of your comfort zone?":
      "Hogyan léptél ki a komfortzónádból?",
  "How are you truly feeling right now?": "Hogyan érzed magad most valójában?",
  "Which emotion stood out the most today?":
      "Melyik érzelem volt ma a legerősebb?",
  "Did you feel present in any moment today?":
      "Érezted magad jelenvalónak ma bármelyik pillanatban?",
  "When did you feel the most at peace today?":
      "Mikor érezted magad ma a legbékésebbnek?",
  "What gave you energy today?": "Mi adott ma energiát?",
  "What drained your energy today?": "Mi szívta el ma az energiádat?",
  "If your mood had a color today, what would it be?":
      "Ha a mai hangulatodnak színe lenne, milyen lenne?",
  "What’s something you’re excited about tomorrow?":
      "Mi az, ami miatt izgatott vagy holnappal kapcsolatban?",
  "What’s one thing you want to improve tomorrow?":
      "Mi az az egy dolog, amin holnap javítani szeretnél?",
  "What would make tomorrow feel successful?":
      "Mitől éreznéd sikeresnek a holnapot?",
  "What do you hope to achieve this week?":
      "Mit remélsz elérni ezen a héten?",
  "What’s a habit you’d like to start tomorrow?":
      "Milyen szokást szeretnél holnap elkezdeni?",
  "What’s something you want to look forward to in the next month?":
      "Mire szeretnél örömmel várni a következő hónapban?",
  "What would your ideal tomorrow look like?":
      "Hogyan nézne ki az ideális holnapod?",
  "What’s one lesson you learned recently?":
      "Mi az az egy tanulság, amit mostanában levontál?",
  "If you could freeze one moment today, which would it be?":
      "Ha megállíthatnál ma egy pillanatot, melyik lenne az?",
  "What makes your life feel meaningful right now?":
      "Mitől érzed most értelmesnek az életed?",
  "If you described today in one word, what would it be?":
      "Ha egy szóval kellene jellemezned a mai napot, mi lenne az?",
  "What inspired you today?": "Mi inspirált ma?",
  "What did you notice today that you usually overlook?":
      "Mit vettél észre ma, ami felett általában átsiklasz?",
  "How has today changed your perspective?":
      "Hogyan változtatta meg a mai nap a szemléletedet?",
  "What’s something you’ve been overthinking?":
      "Min gondolkodtál túl sokat mostanában?",
  "What do you need to let go of?": "Mit kell elengedned?",
  "What part of nature did you notice today?":
      "A természet melyik részét vetted észre ma?",
  "Did the weather affect your mood today?":
      "Befolyásolta az időjárás a mai hangulatodat?",
  "What place felt most comforting today?":
      "Melyik hely tűnt ma a legmegnyugtatóbbnak?",
  "Where did you feel most at home today?":
      "Hol érezted magad ma a leginkább otthon?",
  "What sound or smell reminded you of something important?":
      "Milyen hang vagy illat emlékeztetett valami fontosra?",
  "How did you take care of yourself today?":
      "Hogyan gondoskodtál magadról ma?",
  "When did you feel most like yourself today?":
      "Mikor érezted magad ma a leginkább önmagadnak?",
  "What’s something kind you can say to yourself right now?":
      "Mi az a kedves dolog, amit most mondhatsz magadnak?",
  "What do you want to forgive yourself for?":
      "Miért szeretnél megbocsátani magadnak?",
  "What do you deserve more of in your life?":
      "Miből érdemelsz többet az életedben?",
};

/// Complete Bulgarian (Български) translations for OpenJot.
final Map<String, String> bgTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Моят дневник",
  AppConstants.noEntriesMessage:
      "Все още няма записи в дневника. Започнете да пишете!",
  AppConstants.noBookmarksYet: "Все още няма отметки.",
  AppConstants.noDraftsYet: "Все още няма чернови.",
  AppConstants.addEntryButton: "Добави нов запис",
  AppConstants.jotYourThoughts: "Запишете мислите си",
  AppConstants.tapToCreateJournal:
      "Докоснете +, за да създадете личния си дневник.",
  AppConstants.entriesThisYear: "Записи тази година",
  AppConstants.wordsWritten: "Написани думи",
  AppConstants.daysJournaled: "Дни с записи",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Нов запис в дневника",
  AppConstants.editEntryAppBarTitle: "Редактиране на запис",
  AppConstants.titleHintText: "Заглавие (напр. 'Моят ден', 'Мисли за...')",
  AppConstants.contentHintText: "Запишете мислите си тук...",
  AppConstants.saveButton: "Запази записа",
  AppConstants.updateButton: "Обнови",
  AppConstants.deleteButton: "Изтрий записа",
  AppConstants.requiredFieldMessage: "Това поле не може да бъде празно.",
  AppConstants.newEntry: "Нов запис",
  AppConstants.todayDate: "Днешна дата",
  AppConstants.customDate: "Друга дата",
  AppConstants.done: "Готово",
  AppConstants.startWriting: " Започнете да пишете...",
  AppConstants.tags: "Етикети",
  AppConstants.addTags: "Добави етикети",
  AppConstants.openInMaps: "Отвори в Карти",
  AppConstants.changeLocation: "Промени местоположението",
  AppConstants.remove: "Премахни",
  AppConstants.discardSelectionsTitle: "Отхвърляне на избраното?",
  AppConstants.discardSelectionsMessage:
      "Избрали сте медия или активен запис. Сигурни ли сте, че искате да ги отхвърлите?",
  AppConstants.journalEntryEmpty: "Записът в дневника не може да бъде празен",
  AppConstants.discardDateConfirm:
      "Отхвърляне на избраната дата/час за този запис?",
  AppConstants.addMediaLocationMoodFirst:
      "Първо добавете медия, местоположение или настроение",
  AppConstants.location: "Местоположение",
  AppConstants.record: "Запис",
  AppConstants.selectMomentsToJournal: "Изберете моменти за записване",
  AppConstants.addMomentsFromMenu:
      "Добавете медия, местоположение, запис или настроение от менюто",
  AppConstants.writeSomething: "Напишете нещо",
  AppConstants.saveWithoutWriting: "Запази без писане",
  AppConstants.oneLocation: "1 място",
  AppConstants.mediaCount: "%d медия",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Потвърдете изтриването",
  AppConstants.confirmDeleteMessage:
      "Сигурни ли сте, че искате да изтриете този запис?",
  AppConstants.pleaseConfirm: "Моля, потвърдете",
  AppConstants.confirmDeleteJournalEntry:
      "Сигурни ли сте, че искате да изтриете този запис от дневника? Това действие е необратимо.",
  AppConstants.yes: "Да",
  AppConstants.no: "Не",
  AppConstants.cancel: "Отказ",
  AppConstants.delete: "Изтрий",
  AppConstants.save: "Запази",
  AppConstants.entrySavedSuccess: "Записът е запазен успешно!",
  AppConstants.entryUpdatedSuccess: "Записът е обновен успешно!",
  AppConstants.entryDeletedSuccess: "Записът е изтрит.",
  AppConstants.errorSavingEntry: "Грешка при запазване на записа.",
  AppConstants.errorDeletingEntry: "Грешка при изтриване на записа.",
  AppConstants.errorLoadingEntries: "Грешка при зареждане на записите.",
  AppConstants.noEntriesForDate: "Няма записи за тази дата.",
  AppConstants.noEntriesForMonth: "Няма намерени записи за този месец.",
  AppConstants.selectMonthAndYear: "Изберете месец и година",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Много неприятно",
  AppConstants.unpleasant: "Неприятно",
  AppConstants.slightlyUnpleasant: "Леко неприятно",
  AppConstants.neutral: "Неутрално",
  AppConstants.slightlyPleasant: "Леко приятно",
  AppConstants.pleasant: "Приятно",
  AppConstants.veryPleasant: "Много приятно",
  AppConstants.reflection: "Размисъл",
  AppConstants.edit: "Редактирай",
  AppConstants.removeBookmark: "Премахни отметката",
  AppConstants.bookmark: "Отметка",
  AppConstants.share: "Сподели",
  AppConstants.saveAsPdf: "Запази като PDF",
  AppConstants.audioTrack: "Аудиозапис",
  AppConstants.generatingPdf: "Създаване на PDF...",
  AppConstants.voiceRecording: "Гласов запис",
  AppConstants.audioRecording: "Аудиозапис",
  AppConstants.couldNotLoadAudio: "Аудиофайлът не можа да бъде зареден.",
  AppConstants.stateOfMind: "Състояние на духа",

  // Mood Colors
  AppConstants.moodColors: "Цветове на настроението",
  AppConstants.customizeMoodColors: "Персонализиране на цветовете",
  AppConstants.reset: "Нулирай",
  AppConstants.resetMoodColors: "Възстанови стандартните",
  AppConstants.resetMoodColorsConfirm:
      "Възстановяване на всички цветове на настроението по подразбиране?",
  AppConstants.paletteThemes: "Теми на палитрата",
  AppConstants.customColor: "Персонализиран цвят",
  AppConstants.moodUnsavedChangesMessage:
      "Имате незапазени промени в цветовете на настроението. Искате ли да ги запазите преди затваряне?",

  // Drafts & Auto-save
  AppConstants.drafts: "Чернови",
  AppConstants.draft: "Чернова",
  AppConstants.draftSaved: "Запазено в чернови",
  AppConstants.unsavedChanges: "Незапазени промени",
  AppConstants.unsavedChangesMessage:
      "Имате незапазени промени. Искате ли да ги запазите като чернова или да ги отхвърлите?",
  AppConstants.saveAsDraft: "Запази като чернова",
  AppConstants.discardChanges: "Отхвърли",
  AppConstants.autoDeleteDrafts: "Автоматично изтриване на чернови",
  AppConstants.days7: "7 дни",
  AppConstants.never: "Никога",
  AppConstants.custom: "По избор...",
  AppConstants.enterCustomDays: "Въведете брой дни",
  AppConstants.customDaysExample: "Напр. 14",
  AppConstants.days: "дни",
  AppConstants.draftsNeverDeleted: "Черновите никога няма да бъдат изтрити",
  AppConstants.draftsDeletedAfterDays:
      "Черновите ще бъдат изтривани след %d дни",

  // Home Menu & Sorting
  AppConstants.sortBy: "Сортиране по",
  AppConstants.insights: "Статистика",
  AppConstants.reflections: "Размисли",
  AppConstants.settings: "Настройки",
  AppConstants.entryTime: "Време на записа",
  AppConstants.bookmarkFirst: "Първо отметките",
  AppConstants.reflectionFirst: "Първо размислите",
  AppConstants.withMediaFirst: "Първо с медия",
  AppConstants.textOnlyFirst: "Първо само текст",
  AppConstants.withLocationFirst: "Първо с местоположение",
  AppConstants.withMoodFirst: "Първо с настроение",
  AppConstants.withTagsFirst: "Първо с етикети",

  // Insights
  AppConstants.stats: "Статистика",
  AppConstants.calendar: "Календар",
  AppConstants.entriesSuffix: " записа",
  AppConstants.memoriesFromThisDay: "Спомени от този ден",
  AppConstants.standard: "Стандартен",
  AppConstants.media: "Медия",
  AppConstants.mood: "Настроение",
  AppConstants.mostly: "Предимно",
  AppConstants.averageForThisDay: "Средно за този ден",
  AppConstants.averageForThisYear: "Средно за тази година",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Добре дошли в OpenJot",
  AppConstants.feature1:
      "Пишете свободно, добавяйте снимки и места и пазете всичко сигурно на устройството си.",
  AppConstants.feature2:
      "Разбирайте емоциите си във времето с вграденото проследяване на настроението.",
  AppConstants.feature3:
      "Вашите данни остават на телефона ви – без облак, само локално съхранение и пълна поверителност.",
  AppConstants.continueButton: "Продължи",

  // Notifications
  AppConstants.notificationTitle: "Време е за дневника!",
  AppConstants.notificationBody: "Не забравяйте да запишете мислите си за деня.",
  AppConstants.notificationChannelName: "Ежедневни напомняния",
  AppConstants.notificationChannelDescription:
      "Канал за ежедневни известия за напомняне за дневник",
  AppConstants.onThisDayChannelName: "Спомени На този ден",
  AppConstants.onThisDayChannelDescription:
      "Известия за спомени от минали години.",
  AppConstants.onThisDayNotificationTitle: "Спомен от вашия дневник",
  AppConstants.onThisDaySingleEntry:
      "Преди една година днес написахте нещо специално. Докоснете, за да препрочетете мислите си.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "На този ден миналата година споделихте този спомен. Докоснете, за да го преживеете отново.",
  AppConstants.onThisDayMultipleEntries:
      "Имате спомени от този ден от минали години. Докоснете, за да ги видите.",
  AppConstants.onThisDayGroupedNotification:
      "Имате %d спомена от този ден",

  // Exclude Entries
  AppConstants.excludeEntries: "Изключване на записи",
  AppConstants.saveExclusions: "Запази изключенията",
  AppConstants.excludeUnsavedChangesMessage:
      "Имате незапазени промени. Сигурни ли сте, че искате да ги отхвърлите и да излезете?",
  AppConstants.sortDefault: "По подразбиране",
  AppConstants.sortMutedFirst: "Първо скритите",
  AppConstants.sortUnmutedFirst: "Първо активните",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Днес",
  AppConstants.yesterday: "Вчера",
  AppConstants.contentForQuote: "Съдържание за цитат",
  AppConstants.noContentSelected: "Няма избрано съдържание.",
  AppConstants.photos: "Снимки",
  AppConstants.video: "Видео",
  AppConstants.audio: "Аудио",
  AppConstants.add: "Добави",
  AppConstants.noMediaFound: "Не са намерени %s.",
  AppConstants.permissionRequired:
      "Изисква се разрешение за достъп до %s, за да се покажат.",
  AppConstants.openSettings: "Отвори настройките",
  AppConstants.videos: "Видеа",
  AppConstants.audios: "Аудио файлове",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Изтриване на записа?",
  AppConstants.deleteRecordingMessage:
      "Сигурни ли сте, че искате да изтриете този запис?",
  AppConstants.listen: "Слушай",
  AppConstants.tapAndHold: "докоснете и задръжте",
  AppConstants.clear: "Изчисти",
  AppConstants.all: "Всички",
  AppConstants.folder: "Папка",
  AppConstants.browse: "Преглед",
  AppConstants.tiles: "Плочки",
  AppConstants.graph: "Графика",
  AppConstants.recording: "Записване...",
  AppConstants.recordingLabel: "Запис",
  AppConstants.startAudioRecording: "Започни аудиозапис",
  AppConstants.howAreYouFeeling: "Как се чувствате?",
  AppConstants.paused: "На пауза",
  AppConstants.stop: "Стоп",
  AppConstants.tapOrHoldToResume: "Докоснете или задръжте за продължаване",
  AppConstants.tapOrReleaseToPause: "Докоснете или пуснете за пауза",
  AppConstants.unsupportedImageType: "Неподдържан тип изображение",
  AppConstants.couldNotLoadVideo: "Видеото не можа да бъде заредено",
  AppConstants.couldNotOpenMap: "Връзката към картата не можа да бъде отворена.",
  AppConstants.dismiss: "Затвори",
  AppConstants.selectTime: "Изберете час",
  AppConstants.now: "Сега",
  AppConstants.searchPlacesHint: "Търсене на места, магазини...",
  AppConstants.locationPermissionDenied:
      "Разрешението за местоположение е отказано.",
  AppConstants.failedGetCurrentLocation:
      "Неуспешно получаване на текущото местоположение.",

  // Search
  AppConstants.searchJournalsHint: "Търсене в дневниците...",
  AppConstants.textOnly: "Само текст",
  AppConstants.withMedia: "С медия",
  AppConstants.withMood: "С настроение",
  AppConstants.withLocation: "С местоположение",
  AppConstants.withTags: "С етикети",
  AppConstants.noResultsFound: "Няма намерени резултати",
  AppConstants.searchHintText: "Търсене на записи...",

  // Settings
  AppConstants.language: "Език",
  AppConstants.selectLanguage: "Изберете език",
  AppConstants.systemDefault: "По подразбиране на системата",
  AppConstants.searchLanguagesHint: "Търсене на езици...",
  AppConstants.languageChanged: "Езикът беше сменен на %s.",
  AppConstants.dailyReminder: "Напомняния",
  AppConstants.addReminder: "Добави напомняне",
  AppConstants.deleteReminder: "Изтрий напомняне",
  AppConstants.noRemindersSet: "Няма зададени напомняния.",
  AppConstants.onThisDay: "На този ден",
  AppConstants.appLock: "Заключване на приложението",
  AppConstants.backup: "Резервно копие",
  AppConstants.restore: "Възстановяване",
  AppConstants.importFromAnotherApp: "Импортиране от друго приложение",
  AppConstants.importFromDailyYou: "Импортиране от Daily You",
  AppConstants.selectDailyYouBackup:
      "Изберете zip файла на резервното копие на Daily You",
  AppConstants.importingEntries: "Импортиране на записи...",
  AppConstants.importSuccess:
      "Успешно импортирани %d записа от Daily You!",
  AppConstants.importFailed: "Неуспешен импорт: %s",
  AppConstants.noEntriesToImport: "Не са намерени нови записи за импортиране.",
  AppConstants.askSupport: "Поискайте поддръжка",
  AppConstants.importSupportNote:
      "Форматите на други приложения може да не поддържат всички функции. Ако срещнете проблеми или форматите се променят, моля подайте доклад за проблем.",
  AppConstants.extractingBackup: "Разархивиране на резервното копие...",
  AppConstants.parsingDatabase: "Анализиране на базата данни...",
  AppConstants.dailyYouDbNotFound:
      "Базата данни на Daily You не е намерена в резервното копие.",
  AppConstants.privacyPolicy: "Политика за поверителност",
  AppConstants.termsNConditions: "Условия за ползване",
  AppConstants.about: "За приложението",
  AppConstants.changeTheme: "Смяна на темата",
  AppConstants.theme: "Тема",
  AppConstants.pitchBlack: "Абсолютно черно",
  AppConstants.themeLight: "Светла",
  AppConstants.themeDark: "Тъмна",
  AppConstants.themeSystem: "Системна",
  AppConstants.changePin: "Смяна на PIN",
  AppConstants.loading: "Зареждане...",
  AppConstants.confirmRestoreTitle: "Потвърдете възстановяването",
  AppConstants.confirmRestoreMessage:
      "Възстановяването от резервно копие ще презапише всички текущи данни. Това действие не може да бъде отменено. Сигурни ли сте, че искате да продължите?",
  AppConstants.notificationScheduled: "Известието е планирано за %s",
  AppConstants.notificationCanceled: "Известието е отменено",
  AppConstants.notificationRescheduled: "Известието е пренасрочено за %s",
  AppConstants.notificationPermissionRequired:
      "Изисква се разрешение за известия за задаване на напомняния.",
  AppConstants.pinChangedSuccess: "PIN кодът е сменен успешно",
  AppConstants.onThisDayOn: "Вече ще получавате спомени от този ден.",
  AppConstants.onThisDayOff: "Напомнянията 'На този ден' са изключени.",
  AppConstants.themeChanged: "Избрана тема: %s.",
  AppConstants.hideStats: "Скрий статистиката",
  AppConstants.hideHomeStats: "Скрий статистиката на началния екран",
  AppConstants.hideInsightsStats: "Скрий статистиката в Анализи",

  // Reflection Sheet
  AppConstants.reflectionTitle: "РАЗМИСЪЛ",
  AppConstants.reflectButton: "Размишлявай",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Грешен PIN",
  AppConstants.verifyYourPin: "Потвърдете вашия PIN",
  AppConstants.setAPin: "Задайте PIN",
  AppConstants.confirmPin: "Потвърдете PIN",
  AppConstants.pinsDoNotMatch: "PIN кодовете не съвпадат",
  AppConstants.setPin: "Задай PIN",
  AppConstants.hello: "Здравейте!",
  AppConstants.enterYourPin: "Въведете вашия PIN",
  AppConstants.useBiometrics: "Използвай биометрия",
  AppConstants.authenticateToUnlock:
      "Моля, удостоверете се, за да отключите приложението",
  AppConstants.databaseEncryption: "Шифроване на базата данни",
  AppConstants.databaseEncryptionDesc: "Локално шифроване AES-256-GCM",
  AppConstants.changeMasterPassword: "Смяна на главната парола",
  AppConstants.biometricUnlock: "Биометрично отключване",
  AppConstants.enterMasterPassword: "Въведете главната парола",
  AppConstants.enterMasterPasswordHint:
      "Въведете главната си парола, за да дешифрирате дневника си.",
  AppConstants.unlockButton: "Отключи",
  AppConstants.unlockWithBiometrics: "Отключи с биометрия",
  AppConstants.incorrectMasterPassword:
      "Грешна главна парола. Моля, опитайте отново.",
  AppConstants.databaseEncryptedSuccess:
      "Базата данни на дневника е шифрована с AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Базата данни е дешифрирана и заключването е изключено.",
  AppConstants.masterPasswordChangedSuccess:
      "Главната парола е обновена успешно.",
  AppConstants.encryptedBackupPasswordRequired:
      "Изисква се парола за отваряне на шифровано резервно копие.",
  AppConstants.incorrectBackupPassword: "Грешна парола за резервното копие.",
  AppConstants.invalidBackupFile:
      "Избраният файл не е валидно резервно копие на OpenJot.",
  AppConstants.encryptedBackup: "Шифровано копие (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Защитено с AES-256-GCM и парола за резервното копие",
  AppConstants.standardBackup: "Стандартно копие (.zip)",
  AppConstants.standardBackupDesc:
      "Нешифрован архив, съвместим с всички версии",
  AppConstants.takingBackup: "Създаване на резервно копие...",
  AppConstants.encryptingBackup: "Шифроване на резервното копие...",
  AppConstants.savingBackup: "Запазване на резервното копие...",
  AppConstants.preparingBackup: "Подготовка на резервното копие...",
  AppConstants.decryptingBackup: "Дешифриране на резервното копие...",
  AppConstants.restoringBackup: "Възстановяване на резервното копие...",
  AppConstants.backupEncodingFailed:
      "Неуспешно кодиране на файла с резервното копие.",
  AppConstants.backupCreatedSuccess: "Резервното копие е създадено успешно!",
  AppConstants.backupFailed: "Неуспешно създаване на резервно копие: %s",
  AppConstants.restorePermissionsRequired:
      "Изискват се разрешения за съхранение и медия за възстановяване на данните.",
  AppConstants.databaseRestoredNoMedia:
      "Базата данни е възстановена. Не е намерена медия в резервното копие.",
  AppConstants.restoreSuccess: "Възстановяването е успешно!",
  AppConstants.restoreSuccessRestartRecommended:
      "Възстановяването е успешно. Препоръчва се рестартиране за прилагане на всички промени.",
  AppConstants.restoreFailed: "Неуспешно възстановяване на данните: %s",
  AppConstants.storagePermissionsRequired:
      "Изискват се разрешения за съхранение и медия за създаване на резервно копие.",
  AppConstants.selectBackupFolder:
      "Изберете папка за запазване на резервното копие",
  AppConstants.encryptDatabase: "Шифроване на базата данни",
  AppConstants.disableEncryption: "Изключване на шифроването",
  AppConstants.backupPasswordTitle: "Парола за резервно копие",
  AppConstants.changeMasterPasswordDesc:
      "Въведете текущата си главна парола и изберете нова парола (минимум 6 символа).",
  AppConstants.disableEncryptionDesc:
      "Въведете главната си парола, за да дешифрирате базата данни на диска и да изключите шифроването.",
  AppConstants.enableEncryptionDesc:
      "Защитете всички бележки в дневника локално с шифроване AES-256-GCM. Ако забравите главната си парола, шифрованите данни не могат да бъдат възстановени.",
  AppConstants.verifyForBiometricsDesc:
      "Въведете главната си парола веднъж, за да съхраните ключ за отключване в защитеното хардуерно хранилище за бързо биометрично отключване.",
  AppConstants.createBackupPasswordDesc:
      "Задайте силна парола за шифроване на това .openjot резервно копие. Ще ви е нужна тази парола за възстановяване на всяко устройство.",
  AppConstants.enterBackupPasswordDesc:
      "Въведете паролата, използвана при създаването на това .openjot резервно копие.",
  AppConstants.updatePasswordAction: "Обнови паролата",
  AppConstants.decryptAndDisable: "Дешифрирай и изключи",
  AppConstants.enableBiometricsAction: "Активирай биометрия",
  AppConstants.createBackupAction: "Създай копие",
  AppConstants.decryptBackupAction: "Дешифрирай копието",
  AppConstants.newMasterPasswordHint: "Нова главна парола",
  AppConstants.backupPasswordHint: "Парола за резервно копие",
  AppConstants.masterPasswordHint: "Главна парола",
  AppConstants.enterCurrentMasterPasswordError:
      "Моля, въведете текущата си главна парола.",
  AppConstants.passwordEmptyError: "Паролата не може да бъде празна.",
  AppConstants.passwordMinLengthError:
      "Паролата трябва да съдържа поне 6 символа.",
  AppConstants.passwordsDoNotMatchError: "Паролите не съвпадат.",
  AppConstants.currentMasterPasswordHint: "Текуща главна парола",
  AppConstants.confirmPasswordHint: "Потвърдете паролата",

  // About & Terms
  AppConstants.aboutApp: "За OpenJot",
  AppConstants.versionPrefix: "Версия: %s",
  AppConstants.aboutSubtitle:
      "Минималистичен дневник с отворен код за записване на вашите мисли, настроения и спомени. Всички ваши данни остават на вашето устройство.",
  AppConstants.keyFeatures: "Основни функции",
  AppConstants.aboutFeature1: "• Изчистено изживяване при писане без разсейване.",
  AppConstants.aboutFeature2:
      "• Добавяйте снимки, гласови бележки и музика към записите си.",
  AppConstants.aboutFeature3:
      "• Записвайте настроението си заедно с дневника.",
  AppConstants.aboutFeature4: "• Персонализирайте с различни стилове на текста.",
  AppConstants.aboutFeature5:
      "• Работи изцяло офлайн, данните ви остават на устройството ви.",
  AppConstants.openSource: "Отворен код",
  AppConstants.openSourceDesc:
      "OpenJot е приложение с отворен код. Изходният код е публично достъпен за преглед, промяна и принос от всеки. Вярваме в прозрачността и сътрудничеството на общността.",
  AppConstants.dataPrivacy: "Поверителност на данните",
  AppConstants.dataPrivacyDesc:
      "Ценим вашата поверителност. OpenJot не събира, не съхранява и не предава никакви ваши лични данни. Всички ваши записи, включително текст, изображения и аудиофайлове, се съхраняват единствено на вашето устройство.",
  AppConstants.linksTitle: "Връзки",
  AppConstants.sourceCodeOnGithub: "Изходен код в GitHub",
  AppConstants.sendFeedback: "Изпратете отзив",
  AppConstants.couldNotLaunchUrl: "Неуспешно отваряне на URL адреса",
  AppConstants.termsIntro:
      "Добре дошли в OpenJot! Този документ описва условията за ползване на нашето приложение. Използвайки OpenJot, вие се съгласявате с тези условия.",
  AppConstants.termsSectionDataPrivacy: "Съхранение на данни и поверителност",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot е проектиран да бъде лично пространство за вашите мисли. Всички записи в дневника, включително текст, изображения, аудиофайлове и друга медия, се съхраняват единствено локално на вашето устройство. Приложението не събира, не съхранява и не изпраща лични данни към външни сървъри. Нямаме достъп до вашето съдържание.",
  AppConstants.termsSectionUserContent: "Потребителско съдържание",
  AppConstants.termsSectionUserContentBody:
      "Вие носите пълна отговорност за съдържанието, което създавате и съхранявате в OpenJot, включително текст, изображения, аудиозаписи и други файлове. Вие сте отговорни да се уверите, че притежавате необходимите права за използване на всяко съдържание, което импортирате в приложението.",
  AppConstants.termsSectionDisclaimer: "Отказ от гаранция",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot се предоставя \"както е\" без каквито и да било гаранции, изрични или подразбиращи се. Не гарантираме, че приложението ще бъде без грешки или прекъсвания. Използвате приложението на свой собствен риск.",
  AppConstants.termsSectionLiability: "Ограничаване на отговорността",
  AppConstants.termsSectionLiabilityBody:
      "При никакви обстоятелства разработчиците на OpenJot не носят отговорност за каквито и да било преки, косвени, случайни, специални или последващи щети, включително загуба на данни, произтичащи от използването или невъзможността за използване на това приложение.",
  AppConstants.termsSectionThirdParty: "Библиотеки на трети страни",
  AppConstants.termsSectionThirdPartyBody:
      "Това приложение използва следните библиотеки на трети страни, всяка от които се урежда от собствен лиценз:",

  // Months
  'January': 'Януари',
  'February': 'Февруари',
  'March': 'Март',
  'April': 'Април',
  'May': 'Май',
  'June': 'Юни',
  'July': 'Юли',
  'August': 'Август',
  'September': 'Септември',
  'October': 'Октомври',
  'November': 'Ноември',
  'December': 'Декември',

  // Reflection Prompts (62)
  "What made you smile today?": "Какво ви накара да се усмихнете днес?",
  "Who are you thankful for this week, and why?":
      "На кого сте благодарни тази седмица и защо?",
  "What is something small that brought you joy today?":
      "Кое малко нещо ви донесе радост днес?",
  "Which part of your day felt most comforting?":
      "Коя част от деня ви се стори най-уютна?",
  "What’s something you often take for granted but appreciate now?":
      "Какво често приемате за даденост, но сега оценявате?",
  "What’s the best thing that happened today?":
      "Кое е най-хубавото нещо, което се случи днес?",
  "Did someone make your day easier today?":
      "Направи ли някой деня ви по-лесен днес?",
  "Who made a positive impact on you recently?":
      "Кой ви оказа положително влияние наскоро?",
  "What’s a quality you admire in someone close to you?":
      "Кое качество цените в близък за вас човек?",
  "When did you last feel truly connected with someone?":
      "Кога за последен път се почувствахте истински свързани с някого?",
  "Who do you want to reach out to soon?":
      "С кого искате да се свържете скоро?",
  "Did someone’s kindness stand out today?":
      "Открои ли се нечия доброта днес?",
  "How did you support someone else recently?":
      "Как подкрепихте някой друг наскоро?",
  "Who do you miss the most right now?":
      "Кой ви липсва най-много в момента?",
  "What’s a moment from today you want to remember?":
      "Кой момент от днес искате да запомните?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Кой детайл от днешния ден може да забравите, ако не го запишете?",
  "What’s the most peaceful moment you had today?":
      "Кой беше най-спокойният ви момент днес?",
  "Did you see something beautiful today?": "Видяхте ли нещо красиво днес?",
  "Which memory from this week stands out?":
      "Кой спомен от тази седмица се откроява?",
  "What song, photo, or place will always remind you of today?":
      "Коя песен, снимка или място винаги ще ви напомня за днес?",
  "What surprised you today?": "Какво ви изненада днес?",
  "What challenge did you overcome today?":
      "Кое предизвикателство преодоляхте днес?",
  "What’s a small win you had today?": "Каква малка победа постигнахте днес?",
  "What new thing did you learn about yourself recently?":
      "Какво ново научихте за себе си наскоро?",
  "What are you proud of yourself for?": "С какво се гордеете в себе си?",
  "What habit do you feel good about keeping?":
      "От кой навик, който поддържате, се чувствате добре?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Какво подобрение забелязахте в себе си тази година?",
  "How did you push yourself out of your comfort zone?":
      "Как излязохте от зоната си на комфорт?",
  "How are you truly feeling right now?":
      "Как се чувствате наистина в момента?",
  "Which emotion stood out the most today?":
      "Коя емоция се открои най-много днес?",
  "Did you feel present in any moment today?":
      "Почувствахте ли се напълно присъстващи в някой момент днес?",
  "When did you feel the most at peace today?":
      "Кога се почувствахте най-спокойни днес?",
  "What gave you energy today?": "Какво ви даде енергия днес?",
  "What drained your energy today?": "Какво изчерпа енергията ви днес?",
  "If your mood had a color today, what would it be?":
      "Ако настроението ви днес имаше цвят, какъв щеше да е той?",
  "What’s something you’re excited about tomorrow?":
      "За какво се вълнувате за утре?",
  "What’s one thing you want to improve tomorrow?":
      "Кое е нещото, което искате да подобрите утре?",
  "What would make tomorrow feel successful?":
      "Какво би направило утрешния ден успешен?",
  "What do you hope to achieve this week?":
      "Какво се надявате да постигнете тази седмица?",
  "What’s a habit you’d like to start tomorrow?":
      "Кой навик бихте искали да започнете утре?",
  "What’s something you want to look forward to in the next month?":
      "Какво искате да очаквате с нетърпение през следващия месец?",
  "What would your ideal tomorrow look like?":
      "Как би изглеждал идеалният ви утрешен ден?",
  "What’s one lesson you learned recently?":
      "Кой е един урок, който научихте наскоро?",
  "If you could freeze one moment today, which would it be?":
      "Ако можехте да замразите един момент днес, кой би бил той?",
  "What makes your life feel meaningful right now?":
      "Какво прави живота ви смислен в момента?",
  "If you described today in one word, what would it be?":
      "Ако опишете днешния ден с една дума, коя би била тя?",
  "What inspired you today?": "Какво ви вдъхнови днес?",
  "What did you notice today that you usually overlook?":
      "Какво забелязахте днес, което обикновено пропускате?",
  "How has today changed your perspective?":
      "Как днешният ден промени гледната ви точка?",
  "What’s something you’ve been overthinking?":
      "За какво мислите прекалено много напоследък?",
  "What do you need to let go of?": "От какво трябва да се освободите?",
  "What part of nature did you notice today?":
      "Коя част от природата забелязахте днес?",
  "Did the weather affect your mood today?":
      "Повлия ли времето на настроението ви днес?",
  "What place felt most comforting today?":
      "Кое място ви се стори най-уютно днес?",
  "Where did you feel most at home today?":
      "Къде се почувствахте най-много у дома днес?",
  "What sound or smell reminded you of something important?":
      "Кой звук или мирис ви напомни за нещо важно?",
  "How did you take care of yourself today?":
      "Как се погрижихте за себе си днес?",
  "When did you feel most like yourself today?":
      "Кога се почувствахте най-много себе си днес?",
  "What’s something kind you can say to yourself right now?":
      "Какво мило нещо можете да си кажете точно сега?",
  "What do you want to forgive yourself for?":
      "За какво искате да си простите?",
  "What do you deserve more of in your life?":
      "От какво заслужавате повече в живота си?",
};

/// Complete Croatian (Hrvatski) translations for OpenJot.
final Map<String, String> hrTranslations = <String, String>{
  // Home & Core
  AppConstants.journalTitle: "Moj dnevnik",
  AppConstants.noEntriesMessage:
      "Još nema zapisa u dnevniku. Počnite pisati!",
  AppConstants.noBookmarksYet: "Još nema oznaka.",
  AppConstants.noDraftsYet: "Još nema skica.",
  AppConstants.addEntryButton: "Dodaj novi zapis",
  AppConstants.jotYourThoughts: "Zapišite svoje misli",
  AppConstants.tapToCreateJournal:
      "Dodirnite + za stvaranje osobnog dnevnika.",
  AppConstants.entriesThisYear: "Zapisi ove godine",
  AppConstants.wordsWritten: "Napisanih riječi",
  AppConstants.daysJournaled: "Dana pisanja",

  // Write / Edit Journal
  AppConstants.addEntryAppBarTitle: "Novi zapis u dnevniku",
  AppConstants.editEntryAppBarTitle: "Uredi zapis",
  AppConstants.titleHintText: "Naslov (npr. 'Moj dan', 'Misli o...')",
  AppConstants.contentHintText: "Ovdje zapišite svoje misli...",
  AppConstants.saveButton: "Spremi zapis",
  AppConstants.updateButton: "Ažuriraj",
  AppConstants.deleteButton: "Izbriši zapis",
  AppConstants.requiredFieldMessage: "Ovo polje ne može biti prazno.",
  AppConstants.newEntry: "Novi zapis",
  AppConstants.todayDate: "Današnji datum",
  AppConstants.customDate: "Prilagođeni datum",
  AppConstants.done: "Gotovo",
  AppConstants.startWriting: " Počnite pisati...",
  AppConstants.tags: "Oznake",
  AppConstants.addTags: "Dodaj oznake",
  AppConstants.openInMaps: "Otvori u Kartama",
  AppConstants.changeLocation: "Promijeni lokaciju",
  AppConstants.remove: "Ukloni",
  AppConstants.discardSelectionsTitle: "Odbaciti odabrano?",
  AppConstants.discardSelectionsMessage:
      "Odabrali ste medije ili aktivnu snimku. Jeste li sigurni da ih želite odbaciti?",
  AppConstants.journalEntryEmpty: "Zapis u dnevniku ne može biti prazan",
  AppConstants.discardDateConfirm:
      "Odbaciti odabrani datum/vrijeme za ovaj zapis?",
  AppConstants.addMediaLocationMoodFirst:
      "Prvo dodajte medije, lokaciju ili raspoloženje",
  AppConstants.location: "Lokacija",
  AppConstants.record: "Snimi",
  AppConstants.selectMomentsToJournal: "Odaberite trenutke za dnevnik",
  AppConstants.addMomentsFromMenu:
      "Dodajte medije, lokaciju, snimku ili raspoloženje iz izbornika",
  AppConstants.writeSomething: "Napišite nešto",
  AppConstants.saveWithoutWriting: "Spremi bez pisanja",
  AppConstants.oneLocation: "1 lokacija",
  AppConstants.mediaCount: "%d medija",

  // Dialogs & Toasts
  AppConstants.confirmDeleteTitle: "Potvrdi brisanje",
  AppConstants.confirmDeleteMessage:
      "Jeste li sigurni da želite izbrisati ovaj zapis?",
  AppConstants.pleaseConfirm: "Molimo potvrdite",
  AppConstants.confirmDeleteJournalEntry:
      "Jeste li sigurni da želite izbrisati ovaj zapis iz dnevnika? Ova se radnja ne može poništiti.",
  AppConstants.yes: "Da",
  AppConstants.no: "Ne",
  AppConstants.cancel: "Odustani",
  AppConstants.delete: "Izbriši",
  AppConstants.save: "Spremi",
  AppConstants.entrySavedSuccess: "Zapis je uspješno spremljen!",
  AppConstants.entryUpdatedSuccess: "Zapis je uspješno ažuriran!",
  AppConstants.entryDeletedSuccess: "Zapis je izbrisan.",
  AppConstants.errorSavingEntry: "Pogreška pri spremanju zapisa.",
  AppConstants.errorDeletingEntry: "Pogreška pri brisanju zapisa.",
  AppConstants.errorLoadingEntries: "Pogreška pri učitavanju zapisa.",
  AppConstants.noEntriesForDate: "Nema zapisa za ovaj datum.",
  AppConstants.noEntriesForMonth: "Nisu pronađeni zapisi za ovaj mjesec.",
  AppConstants.selectMonthAndYear: "Odaberite mjesec i godinu",

  // Moods & Tile Actions
  AppConstants.veryUnpleasant: "Vrlo neugodno",
  AppConstants.unpleasant: "Neugodno",
  AppConstants.slightlyUnpleasant: "Blago neugodno",
  AppConstants.neutral: "Neutralno",
  AppConstants.slightlyPleasant: "Blago ugodno",
  AppConstants.pleasant: "Ugodno",
  AppConstants.veryPleasant: "Vrlo ugodno",
  AppConstants.reflection: "Refleksija",
  AppConstants.edit: "Uredi",
  AppConstants.removeBookmark: "Ukloni oznaku",
  AppConstants.bookmark: "Označi",
  AppConstants.share: "Podijeli",
  AppConstants.saveAsPdf: "Spremi kao PDF",
  AppConstants.audioTrack: "Audio zapis",
  AppConstants.generatingPdf: "Generiranje PDF-a...",
  AppConstants.voiceRecording: "Glasovna snimka",
  AppConstants.audioRecording: "Audio snimka",
  AppConstants.couldNotLoadAudio: "Nije moguće učitati audio datoteku.",
  AppConstants.stateOfMind: "Stanje uma",

  // Mood Colors
  AppConstants.moodColors: "Boje raspoloženja",
  AppConstants.customizeMoodColors: "Prilagodi boje raspoloženja",
  AppConstants.reset: "Vrati",
  AppConstants.resetMoodColors: "Vrati na zadano",
  AppConstants.resetMoodColorsConfirm:
      "Vratiti sve boje raspoloženja na zadane vrijednosti?",
  AppConstants.paletteThemes: "Teme palete",
  AppConstants.customColor: "Prilagođena boja",
  AppConstants.moodUnsavedChangesMessage:
      "Imate nespremljene promjene boja raspoloženja. Želite li ih spremiti prije zatvaranja?",

  // Drafts & Auto-save
  AppConstants.drafts: "Skice",
  AppConstants.draft: "Skica",
  AppConstants.draftSaved: "Spremljeno u skice",
  AppConstants.unsavedChanges: "Nespremljene promjene",
  AppConstants.unsavedChangesMessage:
      "Imate nespremljene promjene. Želite li ih spremiti kao skicu ili odbaciti?",
  AppConstants.saveAsDraft: "Spremi kao skicu",
  AppConstants.discardChanges: "Odbaci",
  AppConstants.autoDeleteDrafts: "Automatsko brisanje skica",
  AppConstants.days7: "7 dana",
  AppConstants.never: "Nikada",
  AppConstants.custom: "Prilagođeno...",
  AppConstants.enterCustomDays: "Unesite broj dana",
  AppConstants.customDaysExample: "Npr. 14",
  AppConstants.days: "dana",
  AppConstants.draftsNeverDeleted: "Skice se nikada neće izbrisati",
  AppConstants.draftsDeletedAfterDays: "Skice će se izbrisati nakon %d dana",

  // Home Menu & Sorting
  AppConstants.sortBy: "Sortiraj po",
  AppConstants.insights: "Uvidi",
  AppConstants.reflections: "Refleksije",
  AppConstants.settings: "Postavke",
  AppConstants.entryTime: "Vrijeme zapisa",
  AppConstants.bookmarkFirst: "Prvo označeni",
  AppConstants.reflectionFirst: "Prvo refleksije",
  AppConstants.withMediaFirst: "Prvo s medijima",
  AppConstants.textOnlyFirst: "Prvo samo tekst",
  AppConstants.withLocationFirst: "Prvo s lokacijom",
  AppConstants.withMoodFirst: "Prvo s raspoloženjem",
  AppConstants.withTagsFirst: "Prvo s oznakama",

  // Insights
  AppConstants.stats: "Statistika",
  AppConstants.calendar: "Kalendar",
  AppConstants.entriesSuffix: " zapisa",
  AppConstants.memoriesFromThisDay: "Uspomene od ovog dana",
  AppConstants.standard: "Standardno",
  AppConstants.media: "Mediji",
  AppConstants.mood: "Raspoloženje",
  AppConstants.mostly: "Uglavnom",
  AppConstants.averageForThisDay: "Prosjek za ovaj dan",
  AppConstants.averageForThisYear: "Prosjek za ovu godinu",

  // Onboarding
  AppConstants.welcomeToOpenJot: "Dobrodošli u OpenJot",
  AppConstants.feature1:
      "Pišite slobodno, dodajte fotografije i lokacije te držite sve sigurno na svom uređaju.",
  AppConstants.feature2:
      "Razumijte svoje emocije tijekom vremena uz ugrađeno praćenje raspoloženja.",
  AppConstants.feature3:
      "Vaši podaci ostaju na vašem telefonu – bez oblaka, samo lokalna pohrana i potpuna privatnost.",
  AppConstants.continueButton: "Nastavi",

  // Notifications
  AppConstants.notificationTitle: "Vrijeme je za dnevnik!",
  AppConstants.notificationBody: "Ne zaboravite zapisati svoje današnje misli.",
  AppConstants.notificationChannelName: "Dnevni podsjetnici",
  AppConstants.notificationChannelDescription:
      "Kanal za obavijesti dnevnih podsjetnika za pisanje dnevnika",
  AppConstants.onThisDayChannelName: "Uspomene Na ovaj dan",
  AppConstants.onThisDayChannelDescription:
      "Obavijesti o uspomenama iz prošlih godina.",
  AppConstants.onThisDayNotificationTitle: "Uspomena iz vašeg dnevnika",
  AppConstants.onThisDaySingleEntry:
      "Prije godinu dana na današnji dan napisali ste nešto posebno. Dodirnite za ponovni pregled svojih misli.",
  AppConstants.onThisDaySingleEntryWithMedia:
      "Na današnji dan prošle godine podijelili ste ovu uspomenu. Dodirnite da je ponovno proživite.",
  AppConstants.onThisDayMultipleEntries:
      "Imate uspomene s ovog dana iz prošlih godina. Dodirnite za pregled.",
  AppConstants.onThisDayGroupedNotification:
      "Imate %d uspomena s ovog dana",

  // Exclude Entries
  AppConstants.excludeEntries: "Izuzmi zapise",
  AppConstants.saveExclusions: "Spremi izuzeća",
  AppConstants.excludeUnsavedChangesMessage:
      "Imate nespremljene promjene. Jeste li sigurni da ih želite odbaciti i izaći?",
  AppConstants.sortDefault: "Zadano",
  AppConstants.sortMutedFirst: "Prvo skriveni",
  AppConstants.sortUnmutedFirst: "Prvo vidljivi",

  // Toolbar & Media & Map & DatePicker
  AppConstants.today: "Danas",
  AppConstants.yesterday: "Jučer",
  AppConstants.contentForQuote: "Sadržaj za citat",
  AppConstants.noContentSelected: "Nema odabranog sadržaja.",
  AppConstants.photos: "Fotografije",
  AppConstants.video: "Video",
  AppConstants.audio: "Audio",
  AppConstants.add: "Dodaj",
  AppConstants.noMediaFound: "Nije pronađeno: %s.",
  AppConstants.permissionRequired:
      "Potrebno je dopuštenje za pristup %s za njihov prikaz.",
  AppConstants.openSettings: "Otvori postavke",
  AppConstants.videos: "Videozapisi",
  AppConstants.audios: "Audio zapisi",
  AppConstants.gif: "GIF",
  AppConstants.deleteRecordingTitle: "Izbrisati snimku?",
  AppConstants.deleteRecordingMessage:
      "Jeste li sigurni da želite izbrisati ovu snimku?",
  AppConstants.listen: "Slušaj",
  AppConstants.tapAndHold: "dodirnite i držite",
  AppConstants.clear: "Očisti",
  AppConstants.all: "Sve",
  AppConstants.folder: "Mapa",
  AppConstants.browse: "Pregledaj",
  AppConstants.tiles: "Pločice",
  AppConstants.graph: "Graf",
  AppConstants.recording: "Snimanje...",
  AppConstants.recordingLabel: "Snimka",
  AppConstants.startAudioRecording: "Pokreni audio snimanje",
  AppConstants.howAreYouFeeling: "Kako se osjećate?",
  AppConstants.paused: "Pauzirano",
  AppConstants.stop: "Zaustavi",
  AppConstants.tapOrHoldToResume: "Dodirnite ili držite za nastavak",
  AppConstants.tapOrReleaseToPause: "Dodirnite ili otpustite za pauzu",
  AppConstants.unsupportedImageType: "Nepodržana vrsta slike",
  AppConstants.couldNotLoadVideo: "Nije moguće učitati video",
  AppConstants.couldNotOpenMap: "Nije moguće otvoriti poveznicu karte.",
  AppConstants.dismiss: "Zatvori",
  AppConstants.selectTime: "Odaberite vrijeme",
  AppConstants.now: "Sada",
  AppConstants.searchPlacesHint: "Pretražite mjesta, trgovine...",
  AppConstants.locationPermissionDenied:
      "Dopuštenje za lokaciju je odbijeno.",
  AppConstants.failedGetCurrentLocation:
      "Nije uspjelo dohvaćanje trenutne lokacije.",

  // Search
  AppConstants.searchJournalsHint: "Pretraži dnevnike...",
  AppConstants.textOnly: "Samo tekst",
  AppConstants.withMedia: "S medijima",
  AppConstants.withMood: "S raspoloženjem",
  AppConstants.withLocation: "S lokacijom",
  AppConstants.withTags: "S oznakama",
  AppConstants.noResultsFound: "Nema pronađenih rezultata",
  AppConstants.searchHintText: "Pretraži zapise...",

  // Settings
  AppConstants.language: "Jezik",
  AppConstants.selectLanguage: "Odaberite jezik",
  AppConstants.systemDefault: "Zadano sustava",
  AppConstants.searchLanguagesHint: "Pretraži jezike...",
  AppConstants.languageChanged: "Jezik promijenjen u %s.",
  AppConstants.dailyReminder: "Podsjetnici",
  AppConstants.addReminder: "Dodaj podsjetnik",
  AppConstants.deleteReminder: "Izbriši podsjetnik",
  AppConstants.noRemindersSet: "Nema postavljenih podsjetnika.",
  AppConstants.onThisDay: "Na ovaj dan",
  AppConstants.appLock: "Zaključavanje aplikacije",
  AppConstants.backup: "Sigurnosna kopija",
  AppConstants.restore: "Vrati",
  AppConstants.importFromAnotherApp: "Uvezi iz druge aplikacije",
  AppConstants.importFromDailyYou: "Uvezi iz Daily You",
  AppConstants.selectDailyYouBackup:
      "Odaberite Daily You zip datoteku sigurnosne kopije",
  AppConstants.importingEntries: "Uvoz zapisa...",
  AppConstants.importSuccess: "Uspješno uvezeno %d zapisa iz Daily You!",
  AppConstants.importFailed: "Uvoz nije uspio: %s",
  AppConstants.noEntriesToImport: "Nisu pronađeni novi zapisi za uvoz.",
  AppConstants.askSupport: "Zatraži podršku",
  AppConstants.importSupportNote:
      "Formati drugih aplikacija možda neće podržavati sve značajke. Ako naiđete na probleme ili se formati promijene, molimo prijavite problem.",
  AppConstants.extractingBackup: "Raspakiravanje sigurnosne kopije...",
  AppConstants.parsingDatabase: "Obrada baze podataka...",
  AppConstants.dailyYouDbNotFound:
      "Daily You baza podataka nije pronađena u sigurnosnoj kopiji.",
  AppConstants.privacyPolicy: "Politika privatnosti",
  AppConstants.termsNConditions: "Uvjeti korištenja",
  AppConstants.about: "O aplikaciji",
  AppConstants.changeTheme: "Promijeni temu",
  AppConstants.theme: "Tema",
  AppConstants.pitchBlack: "Potpuno crna",
  AppConstants.themeLight: "Svijetla",
  AppConstants.themeDark: "Tamna",
  AppConstants.themeSystem: "Sustav",
  AppConstants.changePin: "Promijeni PIN",
  AppConstants.loading: "Učitavanje...",
  AppConstants.confirmRestoreTitle: "Potvrdi vraćanje",
  AppConstants.confirmRestoreMessage:
      "Vraćanje iz sigurnosne kopije prebrisat će sve trenutne podatke. Ova se radnja ne može poništiti. Jeste li sigurni da želite nastaviti?",
  AppConstants.notificationScheduled: "Obavijest zakazana za %s",
  AppConstants.notificationCanceled: "Obavijest otkazana",
  AppConstants.notificationRescheduled: "Obavijest ponovno zakazana za %s",
  AppConstants.notificationPermissionRequired:
      "Dopuštenje za obavijesti potrebno je za postavljanje podsjetnika.",
  AppConstants.pinChangedSuccess: "PIN je uspješno promijenjen",
  AppConstants.onThisDayOn: "Sada ćete primati uspomene s ovog dana.",
  AppConstants.onThisDayOff: "Podsjetnici 'Na ovaj dan' su isključeni.",
  AppConstants.themeChanged: "Odabrana je tema %s.",
  AppConstants.hideStats: "Sakrij statistiku",
  AppConstants.hideHomeStats: "Sakrij statistiku početnog zaslona",
  AppConstants.hideInsightsStats: "Sakrij statistiku u Uvidima",

  // Reflection Sheet
  AppConstants.reflectionTitle: "REFLEKSIJA",
  AppConstants.reflectButton: "Promisli",

  // PIN & Encryption & Backup
  AppConstants.incorrectPin: "Neispravan PIN",
  AppConstants.verifyYourPin: "Potvrdite svoj PIN",
  AppConstants.setAPin: "Postavi PIN",
  AppConstants.confirmPin: "Potvrdi PIN",
  AppConstants.pinsDoNotMatch: "PIN-ovi se ne podudaraju",
  AppConstants.setPin: "Postavi PIN",
  AppConstants.hello: "Pozdrav!",
  AppConstants.enterYourPin: "Unesite svoj PIN",
  AppConstants.useBiometrics: "Koristi biometriju",
  AppConstants.authenticateToUnlock:
      "Molimo autentificirajte se za otključavanje aplikacije",
  AppConstants.databaseEncryption: "Šifriranje baze podataka",
  AppConstants.databaseEncryptionDesc: "Lokalno šifriranje AES-256-GCM",
  AppConstants.changeMasterPassword: "Promijeni glavnu lozinku",
  AppConstants.biometricUnlock: "Biometrijsko otključavanje",
  AppConstants.enterMasterPassword: "Unesite glavnu lozinku",
  AppConstants.enterMasterPasswordHint:
      "Unesite svoju glavnu lozinku za dešifriranje dnevnika.",
  AppConstants.unlockButton: "Otključaj",
  AppConstants.unlockWithBiometrics: "Otključaj biometrijom",
  AppConstants.incorrectMasterPassword:
      "Neispravna glavna lozinka. Pokušajte ponovno.",
  AppConstants.databaseEncryptedSuccess:
      "Baza podataka dnevnika šifrirana je pomoću AES-256-GCM.",
  AppConstants.databaseDecryptedSuccess:
      "Baza podataka dnevnika dešifrirana je i zaključavanje aplikacije je isključeno.",
  AppConstants.masterPasswordChangedSuccess:
      "Glavna lozinka je uspješno ažurirana.",
  AppConstants.encryptedBackupPasswordRequired:
      "Lozinka je potrebna za otvaranje šifrirane sigurnosne kopije.",
  AppConstants.incorrectBackupPassword:
      "Neispravna lozinka sigurnosne kopije.",
  AppConstants.invalidBackupFile:
      "Odabrana datoteka nije valjana sigurnosna kopija OpenJot.",
  AppConstants.encryptedBackup: "Šifrirana kopija (.openjot)",
  AppConstants.encryptedBackupDesc:
      "Zaštićeno pomoću AES-256-GCM i lozinke sigurnosne kopije",
  AppConstants.standardBackup: "Standardna kopija (.zip)",
  AppConstants.standardBackupDesc:
      "Nešifrirana arhiva kompatibilna sa svim verzijama",
  AppConstants.takingBackup: "Izrada sigurnosne kopije...",
  AppConstants.encryptingBackup: "Šifriranje sigurnosne kopije...",
  AppConstants.savingBackup: "Spremanje sigurnosne kopije...",
  AppConstants.preparingBackup: "Priprema sigurnosne kopije...",
  AppConstants.decryptingBackup: "Dešifriranje sigurnosne kopije...",
  AppConstants.restoringBackup: "Vraćanje sigurnosne kopije...",
  AppConstants.backupEncodingFailed:
      "Kodiranje datoteke sigurnosne kopije nije uspjelo.",
  AppConstants.backupCreatedSuccess: "Sigurnosna kopija uspješno stvorena!",
  AppConstants.backupFailed: "Stvaranje sigurnosne kopije nije uspjelo: %s",
  AppConstants.restorePermissionsRequired:
      "Dopuštenja za pohranu i medije potrebna su za vraćanje podataka.",
  AppConstants.databaseRestoredNoMedia:
      "Baza podataka vraćena. U kopiji nisu pronađeni mediji.",
  AppConstants.restoreSuccess: "Vraćanje uspješno!",
  AppConstants.restoreSuccessRestartRecommended:
      "Vraćanje uspješno. Preporučuje se ponovno pokretanje za primjenu svih promjena.",
  AppConstants.restoreFailed: "Vraćanje podataka nije uspjelo: %s",
  AppConstants.storagePermissionsRequired:
      "Dopuštenja za pohranu i medije potrebna su za izradu sigurnosne kopije.",
  AppConstants.selectBackupFolder:
      "Odaberite mapu za spremanje sigurnosne kopije",
  AppConstants.encryptDatabase: "Šifriraj bazu podataka",
  AppConstants.disableEncryption: "Onemogući šifriranje",
  AppConstants.backupPasswordTitle: "Lozinka sigurnosne kopije",
  AppConstants.changeMasterPasswordDesc:
      "Unesite trenutnu glavnu lozinku i odaberite novu lozinku (najmanje 6 znakova).",
  AppConstants.disableEncryptionDesc:
      "Unesite svoju glavnu lozinku za dešifriranje baze podataka na disku i isključivanje šifriranja.",
  AppConstants.enableEncryptionDesc:
      "Zaštitite sve bilješke dnevnika lokalno šifriranjem AES-256-GCM. Ako zaboravite glavnu lozinku, šifrirane podatke neće biti moguće oporaviti.",
  AppConstants.verifyForBiometricsDesc:
      "Unesite svoju glavnu lozinku jednom kako biste pohranili ključ za otključavanje u sigurnu hardversku pohranu za brzo biometrijsko otključavanje.",
  AppConstants.createBackupPasswordDesc:
      "Postavite snažnu lozinku za šifriranje ove .openjot sigurnosne kopije. Ova će vam lozinka trebati za vraćanje na bilo kojem uređaju.",
  AppConstants.enterBackupPasswordDesc:
      "Unesite lozinku korištenu pri izradi ove .openjot sigurnosne kopije.",
  AppConstants.updatePasswordAction: "Ažuriraj lozinku",
  AppConstants.decryptAndDisable: "Dešifriraj i onemogući",
  AppConstants.enableBiometricsAction: "Omogući biometriju",
  AppConstants.createBackupAction: "Izradi kopiju",
  AppConstants.decryptBackupAction: "Dešifriraj kopiju",
  AppConstants.newMasterPasswordHint: "Nova glavna lozinka",
  AppConstants.backupPasswordHint: "Lozinka sigurnosne kopije",
  AppConstants.masterPasswordHint: "Glavna lozinka",
  AppConstants.enterCurrentMasterPasswordError:
      "Molimo unesite trenutnu glavnu lozinku.",
  AppConstants.passwordEmptyError: "Lozinka ne može biti prazna.",
  AppConstants.passwordMinLengthError:
      "Lozinka mora imati najmanje 6 znakova.",
  AppConstants.passwordsDoNotMatchError: "Lozinke se ne podudaraju.",
  AppConstants.currentMasterPasswordHint: "Trenutna glavna lozinka",
  AppConstants.confirmPasswordHint: "Potvrdi lozinku",

  // About & Terms
  AppConstants.aboutApp: "O aplikaciji OpenJot",
  AppConstants.versionPrefix: "Verzija: %s",
  AppConstants.aboutSubtitle:
      "Minimalistički dnevnik otvorenog koda za bilježenje vaših misli, raspoloženja i uspomena. Svi vaši podaci ostaju na vašem uređaju.",
  AppConstants.keyFeatures: "Ključne značajke",
  AppConstants.aboutFeature1: "• Čisto iskustvo pisanja bez ometanja.",
  AppConstants.aboutFeature2:
      "• Dodajte fotografije, glasovne bilješke i glazbu svojim zapisima.",
  AppConstants.aboutFeature3: "• Bilježite svoje raspoloženje uz dnevnike.",
  AppConstants.aboutFeature4: "• Personalizirajte različitim stilovima teksta.",
  AppConstants.aboutFeature5:
      "• Radi potpuno izvanmrežno, podaci ostaju na vašem uređaju.",
  AppConstants.openSource: "Otvoreni kod",
  AppConstants.openSourceDesc:
      "OpenJot je aplikacija otvorenog koda. Izvorni kod je javno dostupan svima na uvid, izmjenu i doprinos. Vjerujemo u transparentnost i suradnju zajednice.",
  AppConstants.dataPrivacy: "Privatnost podataka",
  AppConstants.dataPrivacyDesc:
      "Cijenimo vašu privatnost. OpenJot ne prikuplja, ne pohranjuje niti prenosi vaše osobne podatke. Svi vaši zapisi, uključujući tekst, slike i audio datoteke, pohranjeni su isključivo na vašem uređaju.",
  AppConstants.linksTitle: "Poveznice",
  AppConstants.sourceCodeOnGithub: "Izvorni kod na GitHubu",
  AppConstants.sendFeedback: "Pošalji povratne informacije",
  AppConstants.couldNotLaunchUrl: "Nije moguće otvoriti URL",
  AppConstants.termsIntro:
      "Dobrodošli u OpenJot! Ovaj dokument opisuje uvjete korištenja naše aplikacije. Korištenjem aplikacije OpenJot pristajete na ove uvjete.",
  AppConstants.termsSectionDataPrivacy: "Pohrana podataka i privatnost",
  AppConstants.termsSectionDataPrivacyBody:
      "OpenJot je osmišljen kao privatni prostor za vaše misli. Svi zapisi dnevnika, uključujući tekst, slike, audio datoteke i druge medije, pohranjuju se isključivo lokalno na vašem uređaju. Aplikacija ne prikuplja, ne pohranjuje niti šalje osobne podatke vanjskim poslužiteljima. Nemamo pristup vašem sadržaju.",
  AppConstants.termsSectionUserContent: "Sadržaj koji stvara korisnik",
  AppConstants.termsSectionUserContentBody:
      "Vi ste jedini odgovorni za sadržaj koji stvarate i pohranjujete u aplikaciji OpenJot, uključujući tekst, slike, audio snimke i druge datoteke. Vaša je odgovornost osigurati da imate potrebna prava za korištenje bilo kojeg sadržaja koji uvozite u aplikaciju.",
  AppConstants.termsSectionDisclaimer: "Odricanje od jamstva",
  AppConstants.termsSectionDisclaimerBody:
      "OpenJot je pružen \"kakav jest\" bez ikakvih izričitih ili prešutnih jamstava. Ne jamčimo da će aplikacija biti bez grešaka ili neprekidna. Aplikaciju koristite na vlastitu odgovornost.",
  AppConstants.termsSectionLiability: "Ograničenje odgovornosti",
  AppConstants.termsSectionLiabilityBody:
      "Ni u kojem slučaju razvojni programeri OpenJot neće biti odgovorni za bilo kakvu izravnu, neizravnu, slučajnu, posebnu ili posljedičnu štetu, uključujući gubitak podataka, proizašlu iz korištenja ili nemogućnosti korištenja ove aplikacije.",
  AppConstants.termsSectionThirdParty: "Biblioteke trećih strana",
  AppConstants.termsSectionThirdPartyBody:
      "Ova aplikacija koristi sljedeće biblioteke trećih strana, od kojih svaka podliježe vlastitoj licenci:",

  // Months
  'January': 'Siječanj',
  'February': 'Veljača',
  'March': 'Ožujak',
  'April': 'Travanj',
  'May': 'Svibanj',
  'June': 'Lipanj',
  'July': 'Srpanj',
  'August': 'Kolovoz',
  'September': 'Rujan',
  'October': 'Listopad',
  'November': 'Studeni',
  'December': 'Prosinac',

  // Reflection Prompts (62)
  "What made you smile today?": "Što vas je danas nasmijalo?",
  "Who are you thankful for this week, and why?":
      "Kome ste zahvalni ovaj tjedan i zašto?",
  "What is something small that brought you joy today?":
      "Koja vam je sitnica danas donijela radost?",
  "Which part of your day felt most comforting?":
      "Koji vam je dio dana bio najugodniji?",
  "What’s something you often take for granted but appreciate now?":
      "Što često uzimate zdravo za gotovo, a sada cijenite?",
  "What’s the best thing that happened today?":
      "Što je najbolje što se danas dogodilo?",
  "Did someone make your day easier today?":
      "Je li vam netko danas olakšao dan?",
  "Who made a positive impact on you recently?":
      "Tko je nedavno pozitivno utjecao na vas?",
  "What’s a quality you admire in someone close to you?":
      "Kojoj se osobini divite kod nekoga bliskog?",
  "When did you last feel truly connected with someone?":
      "Kada ste se zadnji put osjećali istinski povezani s nekim?",
  "Who do you want to reach out to soon?":
      "Kome se želite uskoro javiti?",
  "Did someone’s kindness stand out today?":
      "Je li se danas istaknula nečija ljubaznost?",
  "How did you support someone else recently?":
      "Kako ste nedavno nekoga podržali?",
  "Who do you miss the most right now?":
      "Tko vam trenutno najviše nedostaje?",
  "What’s a moment from today you want to remember?":
      "Koji trenutak od danas želite zapamtiti?",
  "What’s a detail about today you might forget if you don’t note it?":
      "Koji detalj o današnjem danu biste mogli zaboraviti ako ga ne zapišete?",
  "What’s the most peaceful moment you had today?":
      "Koji vam je bio najmirniji trenutak danas?",
  "Did you see something beautiful today?": "Jeste li danas vidjeli nešto lijepo?",
  "Which memory from this week stands out?":
      "Koja se uspomena iz ovog tjedna najviše ističe?",
  "What song, photo, or place will always remind you of today?":
      "Koja će vas pjesma, fotografija ili mjesto uvijek podsjećati na današnji dan?",
  "What surprised you today?": "Što vas je danas iznenadilo?",
  "What challenge did you overcome today?":
      "Koji ste izazov danas svladali?",
  "What’s a small win you had today?": "Koju ste malu pobjedu danas ostvarili?",
  "What new thing did you learn about yourself recently?":
      "Što ste novo nedavno naučili o sebi?",
  "What are you proud of yourself for?": "Na što ste ponosni kod sebe?",
  "What habit do you feel good about keeping?":
      "Zbog koje navike koju održavate se osjećate dobro?",
  "What’s one improvement you’ve noticed in yourself this year?":
      "Koji ste napredak primijetili kod sebe ove godine?",
  "How did you push yourself out of your comfort zone?":
      "Kako ste izašli iz svoje zone komfora?",
  "How are you truly feeling right now?":
      "Kako se uistinu osjećate upravo sada?",
  "Which emotion stood out the most today?":
      "Koja se emocija danas najviše istaknula?",
  "Did you feel present in any moment today?":
      "Jeste li se u nekom trenutku danas osjećali potpuno prisutno?",
  "When did you feel the most at peace today?":
      "Kada ste se danas osjećali najmirnije?",
  "What gave you energy today?": "Što vam je danas dalo energiju?",
  "What drained your energy today?": "Što vam je danas iscrpilo energiju?",
  "If your mood had a color today, what would it be?":
      "Da vaše današnje raspoloženje ima boju, koja bi to bila?",
  "What’s something you’re excited about tomorrow?":
      "Čemu se radujete sutra?",
  "What’s one thing you want to improve tomorrow?":
      "Što je jedna stvar koju želite poboljšati sutra?",
  "What would make tomorrow feel successful?":
      "Što bi sutrašnji dan učinilo uspješnim?",
  "What do you hope to achieve this week?":
      "Što se nadate postići ovaj tjedan?",
  "What’s a habit you’d like to start tomorrow?":
      "Koju biste naviku željeli započeti sutra?",
  "What’s something you want to look forward to in the next month?":
      "Čemu se želite radovati u sljedećem mjesecu?",
  "What would your ideal tomorrow look like?":
      "Kako bi izgledao vaš idealan sutrašnji dan?",
  "What’s one lesson you learned recently?":
      "Koja je jedna lekcija koju ste nedavno naučili?",
  "If you could freeze one moment today, which would it be?":
      "Kad biste danas mogli zamrznuti jedan trenutak, koji bi to bio?",
  "What makes your life feel meaningful right now?":
      "Što vaš život trenutno čini smislenim?",
  "If you described today in one word, what would it be?":
      "Kad biste današnji dan opisali jednom riječju, koja bi to bila?",
  "What inspired you today?": "Što vas je danas inspiriralo?",
  "What did you notice today that you usually overlook?":
      "Što ste danas primijetili, a inače previdite?",
  "How has today changed your perspective?":
      "Kako je današnji dan promijenio vašu perspektivu?",
  "What’s something you’ve been overthinking?":
      "O čemu ste u zadnje vrijeme previše razmišljali?",
  "What do you need to let go of?": "Čega se trebate osloboditi?",
  "What part of nature did you notice today?":
      "Koji ste dio prirode danas primijetili?",
  "Did the weather affect your mood today?":
      "Je li vrijeme danas utjecalo na vaše raspoloženje?",
  "What place felt most comforting today?":
      "Koje vam se mjesto danas činilo najugodnijim?",
  "Where did you feel most at home today?":
      "Gdje ste se danas osjećali najviše kao kod kuće?",
  "What sound or smell reminded you of something important?":
      "Koji vas je zvuk ili miris podsjetio na nešto važno?",
  "How did you take care of yourself today?":
      "Kako ste se danas brinuli o sebi?",
  "When did you feel most like yourself today?":
      "Kada ste se danas osjećali najviše kao vi sami?",
  "What’s something kind you can say to yourself right now?":
      "Što lijepo možete reći sebi upravo sada?",
  "What do you want to forgive yourself for?":
      "Što si želite oprostiti?",
  "What do you deserve more of in your life?":
      "Čega zaslužujete više u svom životu?",
};
