import '../constants.dart';

/// Complete Western & Northern European translations (Part 3):
/// Danish (`da`), Norwegian Bokmål (`nb`), Finnish (`fi`).
final Map<String, Map<String, String>> europeWest3Translations =
    <String, Map<String, String>>{
  'da': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Min dagbog",
    AppConstants.noEntriesMessage:
        "Ingen dagbogsindlæg endnu. Begynd at skrive!",
    AppConstants.noBookmarksYet: "Ingen bogmærker endnu.",
    AppConstants.noDraftsYet: "Ingen kladder endnu.",
    AppConstants.addEntryButton: "Tilføj nyt indlæg",
    AppConstants.jotYourThoughts: "Skriv dine tanker ned",
    AppConstants.tapToCreateJournal:
        "Tryk på + for at oprette din personlige dagbog.",
    AppConstants.entriesThisYear: "Indlæg i år",
    AppConstants.wordsWritten: "Skrevne ord",
    AppConstants.daysJournaled: "Dage med dagbog",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nyt dagbogsindlæg",
    AppConstants.editEntryAppBarTitle: "Rediger dagbogsindlæg",
    AppConstants.titleHintText: "Titel (f.eks. 'Min dag', 'Tanker om...')",
    AppConstants.contentHintText: "Skriv dine tanker her...",
    AppConstants.saveButton: "Gem indlæg",
    AppConstants.updateButton: "Opdater",
    AppConstants.deleteButton: "Slet indlæg",
    AppConstants.requiredFieldMessage: "Dette felt må ikke være tomt.",
    AppConstants.newEntry: "Nyt indlæg",
    AppConstants.todayDate: "Dags dato",
    AppConstants.customDate: "Brugerdefineret dato",
    AppConstants.done: "Færdig",
    AppConstants.startWriting: " Begynd at skrive...",
    AppConstants.tags: "Tags",
    AppConstants.addTags: "Tilføj tags",
    AppConstants.openInMaps: "Åbn i Kort",
    AppConstants.changeLocation: "Skift placering",
    AppConstants.remove: "Fjern",
    AppConstants.discardSelectionsTitle: "Kassér valg?",
    AppConstants.discardSelectionsMessage:
        "Du har valgt medier eller en aktiv optagelse. Er du sikker på, at du vil kassere dem?",
    AppConstants.journalEntryEmpty: "Dagbogsindlægget må ikke være tomt",
    AppConstants.discardDateConfirm:
        "Kassér den valgte dato/tid for dette indlæg?",
    AppConstants.addMediaLocationMoodFirst:
        "Tilføj først medier, placering eller humør",
    AppConstants.location: "Placering",
    AppConstants.record: "Optag",
    AppConstants.selectMomentsToJournal: "Vælg øjeblikke til dagbogen",
    AppConstants.addMomentsFromMenu:
        "Tilføj medier, placering, optagelse eller humør fra menuen",
    AppConstants.writeSomething: "Skriv noget",
    AppConstants.saveWithoutWriting: "Gem uden tekst",
    AppConstants.oneLocation: "1 placering",
    AppConstants.mediaCount: "%d medier",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Bekræft sletning",
    AppConstants.confirmDeleteMessage:
        "Er du sikker på, at du vil slette dette indlæg?",
    AppConstants.pleaseConfirm: "Bekræft venligst",
    AppConstants.confirmDeleteJournalEntry:
        "Er du sikker på, at du vil slette dette dagbogsindlæg? Denne handling kan ikke fortrydes.",
    AppConstants.yes: "Ja",
    AppConstants.no: "Nej",
    AppConstants.cancel: "Annuller",
    AppConstants.delete: "Slet",
    AppConstants.save: "Gem",
    AppConstants.entrySavedSuccess: "Dagbogsindlæg gemt!",
    AppConstants.entryUpdatedSuccess: "Dagbogsindlæg opdateret!",
    AppConstants.entryDeletedSuccess: "Dagbogsindlæg slettet.",
    AppConstants.errorSavingEntry: "Fejl ved lagring af indlæg.",
    AppConstants.errorDeletingEntry: "Fejl ved sletning af indlæg.",
    AppConstants.errorLoadingEntries: "Fejl ved indlæsning af dagbogsindlæg.",
    AppConstants.noEntriesForDate: "Ingen indlæg for denne dato.",
    AppConstants.noEntriesForMonth: "Ingen indlæg fundet for denne måned.",
    AppConstants.selectMonthAndYear: "Vælg måned og år",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Meget ubehagelig",
    AppConstants.unpleasant: "Ubehagelig",
    AppConstants.slightlyUnpleasant: "Lidt ubehagelig",
    AppConstants.neutral: "Neutral",
    AppConstants.slightlyPleasant: "Lidt behagelig",
    AppConstants.pleasant: "Behagelig",
    AppConstants.veryPleasant: "Meget behagelig",
    AppConstants.reflection: "Refleksion",
    AppConstants.edit: "Rediger",
    AppConstants.removeBookmark: "Fjern bogmærke",
    AppConstants.bookmark: "Bogmærke",
    AppConstants.share: "Del",
    AppConstants.saveAsPdf: "Gem som PDF",
    AppConstants.audioTrack: "Lydspor",
    AppConstants.generatingPdf: "Genererer PDF...",
    AppConstants.voiceRecording: "Stemmeoptagelse",
    AppConstants.audioRecording: "Lydoptagelse",
    AppConstants.couldNotLoadAudio: "Kunne ikke indlæse lydfil.",
    AppConstants.stateOfMind: "Sindstilstand",

    // Mood Colors
    AppConstants.moodColors: "Humørfarver",
    AppConstants.customizeMoodColors: "Tilpas humørfarver",
    AppConstants.reset: "Nulstil",
    AppConstants.resetMoodColors: "Nulstil til standard",
    AppConstants.resetMoodColorsConfirm:
        "Nulstil alle humørfarver til standard?",
    AppConstants.paletteThemes: "Palettemaer",
    AppConstants.customColor: "Brugerdefineret farve",
    AppConstants.moodUnsavedChangesMessage:
        "Du har ikke-gemte ændringer i humørfarverne. Vil du gemme dem, før du lukker?",

    // Drafts & Auto-save
    AppConstants.drafts: "Kladder",
    AppConstants.draft: "Kladde",
    AppConstants.draftSaved: "Gemt i kladder",
    AppConstants.unsavedChanges: "Ikke-gemte ændringer",
    AppConstants.unsavedChangesMessage:
        "Du har ikke-gemte ændringer. Vil du gemme dem som kladde eller kassere dem?",
    AppConstants.saveAsDraft: "Gem som kladde",
    AppConstants.discardChanges: "Kassér",
    AppConstants.autoDeleteDrafts: "Slet kladder automatisk",
    AppConstants.days7: "7 dage",
    AppConstants.never: "Aldrig",
    AppConstants.custom: "Brugerdefineret...",
    AppConstants.enterCustomDays: "Indtast antal dage",
    AppConstants.customDaysExample: "F.eks. 14",
    AppConstants.days: "Dage",
    AppConstants.draftsNeverDeleted: "Kladder bliver aldrig slettet",
    AppConstants.draftsDeletedAfterDays: "Kladder slettes efter %d dage",

    // Home Menu & Sorting
    AppConstants.sortBy: "Sortér efter",
    AppConstants.insights: "Indsigter",
    AppConstants.reflections: "Refleksioner",
    AppConstants.settings: "Indstillinger",
    AppConstants.entryTime: "Tidspunkt for indlæg",
    AppConstants.bookmarkFirst: "Bogmærker først",
    AppConstants.reflectionFirst: "Refleksioner først",
    AppConstants.withMediaFirst: "Med medier først",
    AppConstants.textOnlyFirst: "Kun tekst først",
    AppConstants.withLocationFirst: "Med placering først",
    AppConstants.withMoodFirst: "Med humør først",
    AppConstants.withTagsFirst: "Med tags først",

    // Insights
    AppConstants.stats: "Statistik",
    AppConstants.calendar: "Kalender",
    AppConstants.entriesSuffix: " indlæg",
    AppConstants.memoriesFromThisDay: "Minder fra denne dag",
    AppConstants.standard: "Standard",
    AppConstants.media: "Medier",
    AppConstants.mood: "Humør",
    AppConstants.mostly: "Mest",
    AppConstants.averageForThisDay: "Gennemsnit for denne dag",
    AppConstants.averageForThisYear: "Gennemsnit for i år",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Velkommen til OpenJot",
    AppConstants.feature1:
        "Skriv frit, tilføj billeder og steder, og hold alt sikkert på din enhed.",
    AppConstants.feature2:
        "Forstå dine følelser over tid med indbygget humørsporing.",
    AppConstants.feature3:
        "Dine data bliver på din telefon – ingen sky, kun lokal lagring og fuld fortrolighed.",
    AppConstants.continueButton: "Fortsæt",

    // Notifications
    AppConstants.notificationTitle: "Tid til dagbog!",
    AppConstants.notificationBody:
        "Glem ikke at skrive dagens tanker ned.",
    AppConstants.notificationChannelName: "Daglige dagbogspåmindelser",
    AppConstants.notificationChannelDescription:
        "Kanal til daglige dagbogspåmindelser",
    AppConstants.onThisDayChannelName: "Minder på denne dag",
    AppConstants.onThisDayChannelDescription:
        "Notifikationer for minder fra tidligere år.",
    AppConstants.onThisDayNotificationTitle: "Et minde fra din dagbog",
    AppConstants.onThisDaySingleEntry:
        "For et år siden i dag skrev du noget særligt. Tryk for at læse dine tanker igen.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "På denne dag sidste år delte du dette minde. Tryk for at genopleve det.",
    AppConstants.onThisDayMultipleEntries:
        "Du har minder fra denne dag fra tidligere år. Tryk for at gense dem.",
    AppConstants.onThisDayGroupedNotification:
        "Du har %d minder fra denne dag",

    // Exclude Entries
    AppConstants.excludeEntries: "Ekskluder indlæg",
    AppConstants.saveExclusions: "Gem udeladelser",
    AppConstants.excludeUnsavedChangesMessage:
        "Du har ikke-gemte ændringer. Er du sikker på, at du vil kassere dem og afslutte?",
    AppConstants.sortDefault: "Standard",
    AppConstants.sortMutedFirst: "Dæmpede først",
    AppConstants.sortUnmutedFirst: "Ikke-dæmpede først",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "I dag",
    AppConstants.yesterday: "I går",
    AppConstants.contentForQuote: "Indhold til citat",
    AppConstants.noContentSelected: "Intet indhold valgt.",
    AppConstants.photos: "Billeder",
    AppConstants.video: "Video",
    AppConstants.audio: "Lyd",
    AppConstants.add: "Tilføj",
    AppConstants.noMediaFound: "Ingen %s fundet.",
    AppConstants.permissionRequired:
        "Tilladelse til adgang til %s er påkrævet for at vise dem.",
    AppConstants.openSettings: "Åbn indstillinger",
    AppConstants.videos: "Videoer",
    AppConstants.audios: "Lydfiler",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Slet optagelse?",
    AppConstants.deleteRecordingMessage:
        "Er du sikker på, at du vil slette denne optagelse?",
    AppConstants.listen: "Lyt",
    AppConstants.tapAndHold: "tryk og hold",
    AppConstants.clear: "Ryd",
    AppConstants.all: "Alle",
    AppConstants.folder: "Mappe",
    AppConstants.browse: "Gennemse",
    AppConstants.tiles: "Felter",
    AppConstants.graph: "Graf",
    AppConstants.recording: "Optager...",
    AppConstants.recordingLabel: "Optagelse",
    AppConstants.startAudioRecording: "Start lydoptagelse",
    AppConstants.howAreYouFeeling: "Hvordan har du det?",
    AppConstants.paused: "Sat på pause",
    AppConstants.stop: "Stop",
    AppConstants.tapOrHoldToResume: "Tryk eller hold for at genoptage",
    AppConstants.tapOrReleaseToPause: "Tryk eller slip for at pause",
    AppConstants.unsupportedImageType: "Ikke-understøttet billedtype",
    AppConstants.couldNotLoadVideo: "Kunne ikke indlæse video",
    AppConstants.couldNotOpenMap: "Kunne ikke åbne kortlink.",
    AppConstants.dismiss: "Luk",
    AppConstants.selectTime: "Vælg tidspunkt",
    AppConstants.now: "Nu",
    AppConstants.searchPlacesHint: "Søg steder, butikker...",
    AppConstants.locationPermissionDenied: "Placeringstilladelse nægtet.",
    AppConstants.failedGetCurrentLocation:
        "Kunne ikke hente nuværende placering.",

    // Search
    AppConstants.searchJournalsHint: "Søg i dagbøger...",
    AppConstants.textOnly: "Kun tekst",
    AppConstants.withMedia: "Med medier",
    AppConstants.withMood: "Med humør",
    AppConstants.withLocation: "Med placering",
    AppConstants.withTags: "Med tags",
    AppConstants.noResultsFound: "Ingen resultater fundet",
    AppConstants.searchHintText: "Søg i indlæg...",

    // Settings
    AppConstants.language: "Sprog",
    AppConstants.selectLanguage: "Vælg sprog",
    AppConstants.systemDefault: "Systemstandard",
    AppConstants.searchLanguagesHint: "Søg sprog...",
    AppConstants.languageChanged: "Sprog ændret til %s.",
    AppConstants.dailyReminder: "Påmindelser",
    AppConstants.addReminder: "Tilføj påmindelse",
    AppConstants.deleteReminder: "Slet påmindelse",
    AppConstants.noRemindersSet: "Ingen påmindelser indstillet.",
    AppConstants.onThisDay: "På denne dag",
    AppConstants.appLock: "Applås",
    AppConstants.backup: "Sikkerhedskopi",
    AppConstants.restore: "Gendan",
    AppConstants.importFromAnotherApp: "Importer fra anden app",
    AppConstants.importFromDailyYou: "Importer fra Daily You",
    AppConstants.selectDailyYouBackup:
        "Vælg Daily You sikkerhedskopi zip-fil",
    AppConstants.importingEntries: "Importerer indlæg...",
    AppConstants.importSuccess:
        "%d indlæg importeret fra Daily You!",
    AppConstants.importFailed: "Import mislykkedes: %s",
    AppConstants.noEntriesToImport: "Ingen nye indlæg at importere.",
    AppConstants.askSupport: "Bed om hjælp",
    AppConstants.importSupportNote:
        "Andre appformater understøtter muligvis ikke alle funktioner. Hvis du oplever problemer eller formater ændrer sig, bedes du oprette en fejlrapport.",
    AppConstants.extractingBackup: "Udpakker sikkerhedskopi...",
    AppConstants.parsingDatabase: "Indlæser database...",
    AppConstants.dailyYouDbNotFound:
        "Daily You-database ikke fundet i sikkerhedskopien.",
    AppConstants.privacyPolicy: "Privatlivspolitik",
    AppConstants.termsNConditions: "Vilkår og betingelser",
    AppConstants.about: "Om appen",
    AppConstants.changeTheme: "Skift tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Kulsort",
    AppConstants.themeLight: "Lyst",
    AppConstants.themeDark: "Mørkt",
    AppConstants.themeSystem: "System",
    AppConstants.changePin: "Skift PIN",
    AppConstants.loading: "Indlæser...",
    AppConstants.confirmRestoreTitle: "Bekræft gendannelse",
    AppConstants.confirmRestoreMessage:
        "Gendannelse fra en sikkerhedskopi vil overskrive alle nuværende data. Dette kan ikke fortrydes. Vil du fortsætte?",
    AppConstants.notificationScheduled: "Notifikation planlagt til %s",
    AppConstants.notificationCanceled: "Notifikation annulleret",
    AppConstants.notificationRescheduled: "Notifikation omplanlagt til %s",
    AppConstants.notificationPermissionRequired:
        "Notifikationstilladelse kræves for at indstille påmindelser.",
    AppConstants.pinChangedSuccess: "PIN ændret",
    AppConstants.onThisDayOn: "Du får nu minder fra denne dag.",
    AppConstants.onThisDayOff:
        "Påmindelser for 'På denne dag' er slået fra.",
    AppConstants.themeChanged: "Tema %s valgt.",
    AppConstants.hideStats: "Skjul statistik",
    AppConstants.hideHomeStats: "Skjul startskærmsstatistik",
    AppConstants.hideInsightsStats: "Skjul indsigtsstatistik",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEKSION",
    AppConstants.reflectButton: "Reflekter",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Forkert PIN",
    AppConstants.verifyYourPin: "Bekræft din PIN",
    AppConstants.setAPin: "Angiv en PIN",
    AppConstants.confirmPin: "Bekræft PIN",
    AppConstants.pinsDoNotMatch: "PIN-koderne stemmer ikke overens",
    AppConstants.setPin: "Angiv PIN",
    AppConstants.hello: "Hej!",
    AppConstants.enterYourPin: "Indtast din PIN",
    AppConstants.useBiometrics: "Brug biometri",
    AppConstants.authenticateToUnlock:
        "Godkend for at låse appen op",
    AppConstants.databaseEncryption: "Databasekryptering",
    AppConstants.databaseEncryptionDesc: "Lokal AES-256-GCM-kryptering",
    AppConstants.changeMasterPassword: "Skift hovedadgangskode",
    AppConstants.biometricUnlock: "Biometrisk oplåsning",
    AppConstants.enterMasterPassword: "Indtast hovedadgangskode",
    AppConstants.enterMasterPasswordHint:
        "Indtast din hovedadgangskode for at dekryptere din dagbog.",
    AppConstants.unlockButton: "Lås op",
    AppConstants.unlockWithBiometrics: "Lås op med biometri",
    AppConstants.incorrectMasterPassword:
        "Forkert hovedadgangskode. Prøv igen.",
    AppConstants.databaseEncryptedSuccess:
        "Dagbogsdatabase krypteret med AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Dagbogsdatabase dekrypteret og applås slået fra.",
    AppConstants.masterPasswordChangedSuccess:
        "Hovedadgangskode opdateret.",
    AppConstants.encryptedBackupPasswordRequired:
        "Der kræves en adgangskode for at åbne en krypteret sikkerhedskopi.",
    AppConstants.incorrectBackupPassword:
        "Forkert adgangskode til sikkerhedskopi.",
    AppConstants.invalidBackupFile:
        "Den valgte fil er ikke en gyldig OpenJot-sikkerhedskopi.",
    AppConstants.encryptedBackup: "Krypteret sikkerhedskopi (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Beskyttet med AES-256-GCM og en adgangskode",
    AppConstants.standardBackup: "Standard sikkerhedskopi (.zip)",
    AppConstants.standardBackupDesc:
        "Ukrypteret arkiv kompatibelt med alle versioner",
    AppConstants.takingBackup: "Opretter sikkerhedskopi...",
    AppConstants.encryptingBackup: "Krypterer sikkerhedskopi...",
    AppConstants.savingBackup: "Gemmer sikkerhedskopi...",
    AppConstants.preparingBackup: "Forbereder sikkerhedskopi...",
    AppConstants.decryptingBackup: "Dekrypterer sikkerhedskopi...",
    AppConstants.restoringBackup: "Gendanner sikkerhedskopi...",
    AppConstants.backupEncodingFailed:
        "Kunne ikke kode sikkerhedskopifilen.",
    AppConstants.backupCreatedSuccess: "Sikkerhedskopi oprettet!",
    AppConstants.backupFailed: "Kunne ikke oprette sikkerhedskopi: %s",
    AppConstants.restorePermissionsRequired:
        "Lager- og medietilladelser kræves for at gendanne data.",
    AppConstants.databaseRestoredNoMedia:
        "Database gendannet. Ingen medier fundet i sikkerhedskopien.",
    AppConstants.restoreSuccess: "Gendannelse lykkedes!",
    AppConstants.restoreSuccessRestartRecommended:
        "Gendannelse lykkedes. En genstart anbefales for at anvende alle ændringer.",
    AppConstants.restoreFailed: "Kunne ikke gendanne data: %s",
    AppConstants.storagePermissionsRequired:
        "Lager- og medietilladelser kræves for at oprette en sikkerhedskopi.",
    AppConstants.selectBackupFolder:
        "Vælg en mappe til at gemme sikkerhedskopien",
    AppConstants.encryptDatabase: "Krypter database",
    AppConstants.disableEncryption: "Deaktiver kryptering",
    AppConstants.backupPasswordTitle: "Adgangskode til sikkerhedskopi",
    AppConstants.changeMasterPasswordDesc:
        "Indtast din nuværende hovedadgangskode og vælg en ny adgangskode (mindst 6 tegn).",
    AppConstants.disableEncryptionDesc:
        "Indtast din hovedadgangskode for at dekryptere databasen på disken og slå kryptering fra.",
    AppConstants.enableEncryptionDesc:
        "Beskyt alle dagbogsnoter lokalt med AES-256-GCM-kryptering. Hvis du glemmer din hovedadgangskode, kan krypterede data ikke gendannes.",
    AppConstants.verifyForBiometricsDesc:
        "Indtast din hovedadgangskode én gang for at gemme en nøgle i sikker hardwarelagring til hurtig biometrisk oplåsning.",
    AppConstants.createBackupPasswordDesc:
        "Angiv en stærk adgangskode til at kryptere denne .openjot-sikkerhedskopi. Du skal bruge denne adgangskode for at gendanne på enhver enhed.",
    AppConstants.enterBackupPasswordDesc:
        "Indtast adgangskoden, der blev brugt ved oprettelsen af denne .openjot-sikkerhedskopi.",
    AppConstants.updatePasswordAction: "Opdater adgangskode",
    AppConstants.decryptAndDisable: "Dekrypter og deaktiver",
    AppConstants.enableBiometricsAction: "Aktiver biometri",
    AppConstants.createBackupAction: "Opret sikkerhedskopi",
    AppConstants.decryptBackupAction: "Dekrypter sikkerhedskopi",
    AppConstants.newMasterPasswordHint: "Ny hovedadgangskode",
    AppConstants.backupPasswordHint: "Adgangskode til sikkerhedskopi",
    AppConstants.masterPasswordHint: "Hovedadgangskode",
    AppConstants.enterCurrentMasterPasswordError:
        "Indtast venligst din nuværende hovedadgangskode.",
    AppConstants.passwordEmptyError: "Adgangskoden må ikke være tom.",
    AppConstants.passwordMinLengthError:
        "Adgangskoden skal være på mindst 6 tegn.",
    AppConstants.passwordsDoNotMatchError:
        "Adgangskoderne stemmer ikke overens.",
    AppConstants.currentMasterPasswordHint: "Nuværende hovedadgangskode",
    AppConstants.confirmPasswordHint: "Bekræft adgangskode",

    // About & Terms
    AppConstants.aboutApp: "Om OpenJot",
    AppConstants.versionPrefix: "Version: %s",
    AppConstants.aboutSubtitle:
        "En minimalistisk open source-dagbog til at registrere dine tanker, humør og minder. Alle dine data bliver på din enhed.",
    AppConstants.keyFeatures: "Nøglefunktioner",
    AppConstants.aboutFeature1: "• Ren skriveoplevelse uden forstyrrelser.",
    AppConstants.aboutFeature2:
        "• Tilføj billeder, stemmenoter og musik til dine indlæg.",
    AppConstants.aboutFeature3:
        "• Registrer dit humør sammen med din dagbog.",
    AppConstants.aboutFeature4: "• Tilpas med forskellige tekststile.",
    AppConstants.aboutFeature5:
        "• Virker helt offline; dine data bliver på din enhed.",
    AppConstants.openSource: "Open Source",
    AppConstants.openSourceDesc:
        "OpenJot er en open source-app. Kildekoden er offentligt tilgængelig for alle at gennemgå, ændre og bidrage til. Vi tror på gennemsigtighed og fællesskab.",
    AppConstants.dataPrivacy: "Databeskyttelse",
    AppConstants.dataPrivacyDesc:
        "Vi værner om dit privatliv. OpenJot indsamler, gemmer eller sender ingen personlige data. Alle dine indlæg, billeder og lydfiler gemmes udelukkende på din enhed.",
    AppConstants.linksTitle: "Links",
    AppConstants.sourceCodeOnGithub: "Kildekode på GitHub",
    AppConstants.sendFeedback: "Send feedback",
    AppConstants.couldNotLaunchUrl: "Kunne ikke åbne URL",
    AppConstants.termsIntro:
        "Velkommen til OpenJot! Dette dokument beskriver vilkårene og betingelserne for brug af vores app. Ved at bruge OpenJot accepterer du disse vilkår.",
    AppConstants.termsSectionDataPrivacy: "Datalagring og privatliv",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot er designet som et privat rum til dine tanker. Alle indlæg, herunder tekst, billeder, lydfiler og andre medier, gemmes udelukkende lokalt på din enhed. Appen sender ingen data til eksterne servere.",
    AppConstants.termsSectionUserContent: "Brugergenereret indhold",
    AppConstants.termsSectionUserContentBody:
        "Du er eneansvarlig for det indhold, du opretter og gemmer i OpenJot, herunder tekst, billeder og lydoptagelser. Det er dit ansvar at sikre, at du har de nødvendige rettigheder til importeret indhold.",
    AppConstants.termsSectionDisclaimer: "Ansvarsfraskrivelse for garanti",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot leveres \"som beset\" uden nogen garantier, hverken udtrykkelige eller stiltiende. Vi garanterer ikke fejlfri eller uafbrudt drift. Brug sker på eget ansvar.",
    AppConstants.termsSectionLiability: "Ansvarsbegrænsning",
    AppConstants.termsSectionLiabilityBody:
        "Under ingen omstændigheder er udviklerne af OpenJot ansvarlige for direkte, indirekte, tilfældige, særlige eller følgeskader, herunder datatab, som følge af brug eller manglende evne til at bruge appen.",
    AppConstants.termsSectionThirdParty: "Tredjepartsbiblioteker",
    AppConstants.termsSectionThirdPartyBody:
        "Denne applikation anvender følgende tredjepartsbiblioteker, som hver især er underlagt sin egen licens:",

    // Months
    'January': 'Januar',
    'February': 'Februar',
    'March': 'Marts',
    'April': 'April',
    'May': 'Maj',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'August',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'December',

    // Reflection Prompts (61)
    "What made you smile today?": "Hvad fik dig til at smile i dag?",
    "Who are you thankful for this week, and why?":
        "Hvem er du taknemmelig for i denne uge, og hvorfor?",
    "What is something small that brought you joy today?":
        "Hvad var en lille ting, der bragte dig glæde i dag?",
    "Which part of your day felt most comforting?":
        "Hvilken del af din dag føltes mest tryg?",
    "What’s something you often take for granted but appreciate now?":
        "Hvad tager du ofte for givet, men sætter pris på nu?",
    "What’s the best thing that happened today?":
        "Hvad var det bedste, der skete i dag?",
    "Did someone make your day easier today?":
        "Gjorde nogen din dag lettere i dag?",
    "Who made a positive impact on you recently?":
        "Hvem har haft en positiv indflydelse på dig for nylig?",
    "What’s a quality you admire in someone close to you?":
        "Hvilken egenskab beundrer du hos en, der står dig nær?",
    "When did you last feel truly connected with someone?":
        "Hvornår følte du dig sidst virkelig forbundet med nogen?",
    "Who do you want to reach out to soon?":
        "Hvem vil du gerne række ud til snart?",
    "Did someone’s kindness stand out today?":
        "Skilte nogens venlighed sig ud i dag?",
    "How did you support someone else recently?":
        "Hvordan støttede du en anden for nylig?",
    "Who do you miss the most right now?": "Hvem savner du mest lige nu?",
    "What’s a moment from today you want to remember?":
        "Hvilket øjeblik fra i dag vil du gerne huske?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Hvilken detalje om i dag kunne du glemme, hvis du ikke skriver den ned?",
    "What’s the most peaceful moment you had today?":
        "Hvad var dit mest fredfyldte øjeblik i dag?",
    "Did you see something beautiful today?": "Så du noget smukt i dag?",
    "Which memory from this week stands out?":
        "Hvilket minde fra denne uge skiller sig ud?",
    "What song, photo, or place will always remind you of today?":
        "Hvilken sang, foto eller sted vil altid minde dig om i dag?",
    "What surprised you today?": "Hvad overraskede dig i dag?",
    "What challenge did you overcome today?":
        "Hvilken udfordring overvandt du i dag?",
    "What’s a small win you had today?":
        "Hvilken lille sejr havde du i dag?",
    "What new thing did you learn about yourself recently?":
        "Hvad nyt har du lært om dig selv for nylig?",
    "What are you proud of yourself for?": "Hvad er du stolt af ved dig selv?",
    "What habit do you feel good about keeping?":
        "Hvilken vane har du det godt med at holde fast i?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Hvilken forbedring har du bemærket hos dig selv i år?",
    "How did you push yourself out of your comfort zone?":
        "Hvordan trådte du ud af din komfortzone?",
    "How are you truly feeling right now?":
        "Hvordan har du det egentlig lige nu?",
    "Which emotion stood out the most today?":
        "Hvilken følelse trådte tydeligst frem i dag?",
    "Did you feel present in any moment today?":
        "Følte du dig nærværende i noget øjeblik i dag?",
    "When did you feel the most at peace today?":
        "Hvornår følte du dig mest i fred i dag?",
    "What gave you energy today?": "Hvad gav dig energi i dag?",
    "What drained your energy today?": "Hvad drænede din energi i dag?",
    "If your mood had a color today, what would it be?":
        "Hvis dit humør havde en farve i dag, hvilken ville det være?",
    "What’s something you’re excited about tomorrow?":
        "Hvad glæder du dig til i morgen?",
    "What’s one thing you want to improve tomorrow?":
        "Hvad er én ting, du gerne vil forbedre i morgen?",
    "What would make tomorrow feel successful?":
        "Hvad ville få morgendagen til at føles vellykket?",
    "What do you hope to achieve this week?":
        "Hvad håber du at opnå i denne uge?",
    "What’s a habit you’d like to start tomorrow?":
        "Hvilken vane vil du gerne starte på i morgen?",
    "What’s something you want to look forward to in the next month?":
        "Hvad vil du glæde dig til i den kommende måned?",
    "What would your ideal tomorrow look like?":
        "Hvordan ville din ideelle dag i morgen se ud?",
    "What’s one lesson you learned recently?":
        "Hvilken lærestreg har du lært for nylig?",
    "If you could freeze one moment today, which would it be?":
        "Hvis du kunne fastfryse ét øjeblik i dag, hvilket skulle det være?",
    "What makes your life feel meaningful right now?":
        "Hvad får dit liv til at føles meningsfuldt lige nu?",
    "If you described today in one word, what would it be?":
        "Hvis du skulle beskrive i dag med ét ord, hvilket ville det være?",
    "What inspired you today?": "Hvad inspirerede dig i dag?",
    "What did you notice today that you usually overlook?":
        "Hvad lagde du mærke til i dag, som du normalt overser?",
    "How has today changed your perspective?":
        "Hvordan har dagen i dag ændret dit perspektiv?",
    "What’s something you’ve been overthinking?":
        "Hvad har du overtænkt på det seneste?",
    "What do you need to let go of?": "Hvad har du brug for at give slip på?",
    "What part of nature did you notice today?":
        "Hvilken del af naturen lagde du mærke til i dag?",
    "Did the weather affect your mood today?":
        "Påvirkede vejret dit humør i dag?",
    "What place felt most comforting today?":
        "Hvilket sted føltes mest trygt i dag?",
    "Where did you feel most at home today?":
        "Hvor følte du dig mest hjemme i dag?",
    "What sound or smell reminded you of something important?":
        "Hvilken lyd eller duft mindede dig om noget vigtigt?",
    "How did you take care of yourself today?":
        "Hvordan passede du på dig selv i dag?",
    "When did you feel most like yourself today?":
        "Hvornår følte du dig mest som dig selv i dag?",
    "What’s something kind you can say to yourself right now?":
        "Hvad venligt kan du sige til dig selv lige nu?",
    "What do you want to forgive yourself for?":
        "Hvad vil du tilgive dig selv for?",
    "What do you deserve more of in your life?":
        "Hvad fortjener du mere af i dit liv?",
  },
  'nb': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Min dagbok",
    AppConstants.noEntriesMessage:
        "Ingen dagbokinnlegg ennå. Begynn å skrive!",
    AppConstants.noBookmarksYet: "Ingen bokmerker ennå.",
    AppConstants.noDraftsYet: "Ingen utkast ennå.",
    AppConstants.addEntryButton: "Legg til nytt innlegg",
    AppConstants.jotYourThoughts: "Skriv ned tankene dine",
    AppConstants.tapToCreateJournal:
        "Trykk på + for å opprette din personlige dagbok.",
    AppConstants.entriesThisYear: "Innlegg i år",
    AppConstants.wordsWritten: "Skrevne ord",
    AppConstants.daysJournaled: "Dager med dagbok",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nytt dagbokinnlegg",
    AppConstants.editEntryAppBarTitle: "Rediger dagbokinnlegg",
    AppConstants.titleHintText: "Tittel (f.eks. 'Min dag', 'Tanker om...')",
    AppConstants.contentHintText: "Skriv tankene dine her...",
    AppConstants.saveButton: "Lagre innlegg",
    AppConstants.updateButton: "Oppdater",
    AppConstants.deleteButton: "Slett innlegg",
    AppConstants.requiredFieldMessage: "Dette feltet kan ikke være tomt.",
    AppConstants.newEntry: "Nytt innlegg",
    AppConstants.todayDate: "Dagens dato",
    AppConstants.customDate: "Egendefinert dato",
    AppConstants.done: "Ferdig",
    AppConstants.startWriting: " Begynn å skrive...",
    AppConstants.tags: "Tagger",
    AppConstants.addTags: "Legg til tagger",
    AppConstants.openInMaps: "Åpne i Kart",
    AppConstants.changeLocation: "Endre sted",
    AppConstants.remove: "Fjern",
    AppConstants.discardSelectionsTitle: "Forkaste valg?",
    AppConstants.discardSelectionsMessage:
        "Du har valgt medier eller et aktivt opptak. Er du sikker på at du vil forkaste dem?",
    AppConstants.journalEntryEmpty: "Dagbokinnlegget kan ikke være tomt",
    AppConstants.discardDateConfirm:
        "Forkaste valgt dato/tid for dette innlegget?",
    AppConstants.addMediaLocationMoodFirst:
        "Legg til medier, sted eller humør først",
    AppConstants.location: "Sted",
    AppConstants.record: "Ta opp",
    AppConstants.selectMomentsToJournal: "Velg øyeblikk å skrive om",
    AppConstants.addMomentsFromMenu:
        "Legg til medier, sted, opptak eller humør fra menyen",
    AppConstants.writeSomething: "Skriv noe",
    AppConstants.saveWithoutWriting: "Lagre uten tekst",
    AppConstants.oneLocation: "1 sted",
    AppConstants.mediaCount: "%d medier",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Bekreft sletting",
    AppConstants.confirmDeleteMessage:
        "Er du sikker på at du vil slette dette innlegget?",
    AppConstants.pleaseConfirm: "Vennligst bekreft",
    AppConstants.confirmDeleteJournalEntry:
        "Er du sikker på at du vil slette dette dagbokinnlegget? Denne handlingen kan ikke angres.",
    AppConstants.yes: "Ja",
    AppConstants.no: "Nei",
    AppConstants.cancel: "Avbryt",
    AppConstants.delete: "Slett",
    AppConstants.save: "Lagre",
    AppConstants.entrySavedSuccess: "Dagbokinnlegg lagret!",
    AppConstants.entryUpdatedSuccess: "Dagbokinnlegg oppdatert!",
    AppConstants.entryDeletedSuccess: "Dagbokinnlegg slettet.",
    AppConstants.errorSavingEntry: "Feil ved lagring av innlegg.",
    AppConstants.errorDeletingEntry: "Feil ved sletting av innlegg.",
    AppConstants.errorLoadingEntries: "Feil ved lasting av dagbokinnlegg.",
    AppConstants.noEntriesForDate: "Ingen innlegg for denne datoen.",
    AppConstants.noEntriesForMonth: "Ingen innlegg funnet for denne måneden.",
    AppConstants.selectMonthAndYear: "Velg måned og år",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Svært ubehagelig",
    AppConstants.unpleasant: "Ubehagelig",
    AppConstants.slightlyUnpleasant: "Litt ubehagelig",
    AppConstants.neutral: "Nøytral",
    AppConstants.slightlyPleasant: "Litt behagelig",
    AppConstants.pleasant: "Behagelig",
    AppConstants.veryPleasant: "Svært behagelig",
    AppConstants.reflection: "Refleksjon",
    AppConstants.edit: "Rediger",
    AppConstants.removeBookmark: "Fjern bokmerke",
    AppConstants.bookmark: "Bokmerke",
    AppConstants.share: "Del",
    AppConstants.saveAsPdf: "Lagre som PDF",
    AppConstants.audioTrack: "Lydspor",
    AppConstants.generatingPdf: "Genererer PDF...",
    AppConstants.voiceRecording: "Taleopptak",
    AppConstants.audioRecording: "Lydopptak",
    AppConstants.couldNotLoadAudio: "Kunne ikke laste inn lydfilen.",
    AppConstants.stateOfMind: "Sinnstilstand",

    // Mood Colors
    AppConstants.moodColors: "Humørfarger",
    AppConstants.customizeMoodColors: "Tilpass humørfarger",
    AppConstants.reset: "Tilbakestill",
    AppConstants.resetMoodColors: "Tilbakestill til standard",
    AppConstants.resetMoodColorsConfirm:
        "Tilbakestille alle humørfarger til standard?",
    AppConstants.paletteThemes: "Palettemaer",
    AppConstants.customColor: "Egendefinert farge",
    AppConstants.moodUnsavedChangesMessage:
        "Du har ulagrede endringer i humørfargene. Vil du lagre dem før du lukker?",

    // Drafts & Auto-save
    AppConstants.drafts: "Utkast",
    AppConstants.draft: "Utkast",
    AppConstants.draftSaved: "Lagret i utkast",
    AppConstants.unsavedChanges: "Ulagrede endringer",
    AppConstants.unsavedChangesMessage:
        "Du har ulagrede endringer. Vil du lagre dem som utkast eller forkaste dem?",
    AppConstants.saveAsDraft: "Lagre som utkast",
    AppConstants.discardChanges: "Forkast",
    AppConstants.autoDeleteDrafts: "Slett utkast automatisk",
    AppConstants.days7: "7 dager",
    AppConstants.never: "Aldri",
    AppConstants.custom: "Egendefinert...",
    AppConstants.enterCustomDays: "Angi egendefinerte dager",
    AppConstants.customDaysExample: "F.eks. 14",
    AppConstants.days: "Dager",
    AppConstants.draftsNeverDeleted: "Utkast slettes aldri",
    AppConstants.draftsDeletedAfterDays: "Utkast slettes etter %d dager",

    // Home Menu & Sorting
    AppConstants.sortBy: "Sorter etter",
    AppConstants.insights: "Innsikt",
    AppConstants.reflections: "Refleksjoner",
    AppConstants.settings: "Innstillinger",
    AppConstants.entryTime: "Tidspunkt for innlegg",
    AppConstants.bookmarkFirst: "Bokmerker først",
    AppConstants.reflectionFirst: "Refleksjoner først",
    AppConstants.withMediaFirst: "Med medier først",
    AppConstants.textOnlyFirst: "Kun tekst først",
    AppConstants.withLocationFirst: "Med sted først",
    AppConstants.withMoodFirst: "Med humør først",
    AppConstants.withTagsFirst: "Med tagger først",

    // Insights
    AppConstants.stats: "Statistikk",
    AppConstants.calendar: "Kalender",
    AppConstants.entriesSuffix: " innlegg",
    AppConstants.memoriesFromThisDay: "Minner fra denne dagen",
    AppConstants.standard: "Standard",
    AppConstants.media: "Medier",
    AppConstants.mood: "Humør",
    AppConstants.mostly: "Mest",
    AppConstants.averageForThisDay: "Gjennomsnitt for denne dagen",
    AppConstants.averageForThisYear: "Gjennomsnitt for i år",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Velkommen til OpenJot",
    AppConstants.feature1:
        "Skriv fritt, legg til bilder og steder, og hold alt trygt på enheten din.",
    AppConstants.feature2:
        "Forstå følelsene dine over tid med innebygd humørsporing.",
    AppConstants.feature3:
        "Dataene dine blir på telefonen – ingen sky, bare lokal lagring og fullt personvern.",
    AppConstants.continueButton: "Fortsett",

    // Notifications
    AppConstants.notificationTitle: "Tid for dagbok!",
    AppConstants.notificationBody:
        "Ikke glem å skrive ned dagens tanker.",
    AppConstants.notificationChannelName: "Daglige dagbokpåminnelser",
    AppConstants.notificationChannelDescription:
        "Kanal for daglige dagbokpåminnelser",
    AppConstants.onThisDayChannelName: "Minner på denne dagen",
    AppConstants.onThisDayChannelDescription:
        "Varsler for minner fra tidligere år.",
    AppConstants.onThisDayNotificationTitle: "Et minne fra dagboken din",
    AppConstants.onThisDaySingleEntry:
        "For ett år siden i dag skrev du noe spesielt. Trykk for å lese tankene dine på nytt.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "På denne dagen i fjor delte du dette minnet. Trykk for å gjenoppleve det.",
    AppConstants.onThisDayMultipleEntries:
        "Du har minner fra denne dagen fra tidligere år. Trykk for å se dem.",
    AppConstants.onThisDayGroupedNotification:
        "Du har %d minner fra denne dagen",

    // Exclude Entries
    AppConstants.excludeEntries: "Ekskluder innlegg",
    AppConstants.saveExclusions: "Lagre utelukkelser",
    AppConstants.excludeUnsavedChangesMessage:
        "Du har ulagrede endringer. Er du sikker på at du vil forkaste dem og avslutte?",
    AppConstants.sortDefault: "Standard",
    AppConstants.sortMutedFirst: "Dempede først",
    AppConstants.sortUnmutedFirst: "Ikke-dempede først",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "I dag",
    AppConstants.yesterday: "I går",
    AppConstants.contentForQuote: "Innhold til sitat",
    AppConstants.noContentSelected: "Ikke noe innhold valgt.",
    AppConstants.photos: "Bilder",
    AppConstants.video: "Video",
    AppConstants.audio: "Lyd",
    AppConstants.add: "Legg til",
    AppConstants.noMediaFound: "Ingen %s funnet.",
    AppConstants.permissionRequired:
        "Tilgangstillatelse til %s kreves for å vise dem.",
    AppConstants.openSettings: "Åpne innstillinger",
    AppConstants.videos: "Videoer",
    AppConstants.audios: "Lydfiler",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Slette opptak?",
    AppConstants.deleteRecordingMessage:
        "Er du sikker på at du vil slette dette opptaket?",
    AppConstants.listen: "Lytt",
    AppConstants.tapAndHold: "trykk og hold",
    AppConstants.clear: "Tøm",
    AppConstants.all: "Alle",
    AppConstants.folder: "Mappe",
    AppConstants.browse: "Bla gjennom",
    AppConstants.tiles: "Fliser",
    AppConstants.graph: "Graf",
    AppConstants.recording: "Tar opp...",
    AppConstants.recordingLabel: "Opptak",
    AppConstants.startAudioRecording: "Start lydopptak",
    AppConstants.howAreYouFeeling: "Hvordan føler du deg?",
    AppConstants.paused: "Satt på pause",
    AppConstants.stop: "Stopp",
    AppConstants.tapOrHoldToResume: "Trykk eller hold for å gjenoppta",
    AppConstants.tapOrReleaseToPause: "Trykk eller slipp for å pause",
    AppConstants.unsupportedImageType: "Bildeformatet støttes ikke",
    AppConstants.couldNotLoadVideo: "Kunne ikke laste inn video",
    AppConstants.couldNotOpenMap: "Kunne ikke åpne kartkoblingen.",
    AppConstants.dismiss: "Lukk",
    AppConstants.selectTime: "Velg klokkeslett",
    AppConstants.now: "Nå",
    AppConstants.searchPlacesHint: "Søk etter steder, butikker...",
    AppConstants.locationPermissionDenied: "Stedstillatelse avslått.",
    AppConstants.failedGetCurrentLocation:
        "Kunne ikke hente gjeldende posisjon.",

    // Search
    AppConstants.searchJournalsHint: "Søk i dagbøker...",
    AppConstants.textOnly: "Kun tekst",
    AppConstants.withMedia: "Med medier",
    AppConstants.withMood: "Med humør",
    AppConstants.withLocation: "Med sted",
    AppConstants.withTags: "Med tagger",
    AppConstants.noResultsFound: "Ingen resultater funnet",
    AppConstants.searchHintText: "Søk i innlegg...",

    // Settings
    AppConstants.language: "Språk",
    AppConstants.selectLanguage: "Velg språk",
    AppConstants.systemDefault: "Systemstandard",
    AppConstants.searchLanguagesHint: "Søk etter språk...",
    AppConstants.languageChanged: "Språk endret til %s.",
    AppConstants.dailyReminder: "Påminnelser",
    AppConstants.addReminder: "Legg til påminnelse",
    AppConstants.deleteReminder: "Slett påminnelse",
    AppConstants.noRemindersSet: "Ingen påminnelser satt.",
    AppConstants.onThisDay: "På denne dagen",
    AppConstants.appLock: "Applås",
    AppConstants.backup: "Sikkerhetskopi",
    AppConstants.restore: "Gjenopprett",
    AppConstants.importFromAnotherApp: "Importer fra en annen app",
    AppConstants.importFromDailyYou: "Importer fra Daily You",
    AppConstants.selectDailyYouBackup:
        "Velg Daily You zip-fil for sikkerhetskopi",
    AppConstants.importingEntries: "Importerer innlegg...",
    AppConstants.importSuccess:
        "Importerte %d innlegg fra Daily You!",
    AppConstants.importFailed: "Import mislyktes: %s",
    AppConstants.noEntriesToImport: "Ingen nye innlegg funnet å importere.",
    AppConstants.askSupport: "Be om hjelp",
    AppConstants.importSupportNote:
        "Andre appformater støtter kanskje ikke alle funksjoner. Hvis du opplever problemer eller formater endres, vennligst send inn en feilrapport.",
    AppConstants.extractingBackup: "Pakker ut sikkerhetskopi...",
    AppConstants.parsingDatabase: "Leser database...",
    AppConstants.dailyYouDbNotFound:
        "Daily You-databasen ble ikke funnet i sikkerhetskopien.",
    AppConstants.privacyPolicy: "Personvernerklæring",
    AppConstants.termsNConditions: "Vilkår og betingelser",
    AppConstants.about: "Om appen",
    AppConstants.changeTheme: "Bytt tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Bekmørk",
    AppConstants.themeLight: "Lyst",
    AppConstants.themeDark: "Mørkt",
    AppConstants.themeSystem: "System",
    AppConstants.changePin: "Endre PIN",
    AppConstants.loading: "Laster...",
    AppConstants.confirmRestoreTitle: "Bekreft gjenoppretting",
    AppConstants.confirmRestoreMessage:
        "Gjenoppretting fra sikkerhetskopi vil overskrive alle nåværende data. Dette kan ikke angres. Er du sikker på at du vil fortsette?",
    AppConstants.notificationScheduled: "Varsel planlagt til %s",
    AppConstants.notificationCanceled: "Varsel avbrutt",
    AppConstants.notificationRescheduled: "Varsel flyttet til %s",
    AppConstants.notificationPermissionRequired:
        "Varslingstillatelse kreves for å angi påminnelser.",
    AppConstants.pinChangedSuccess: "PIN ble endret",
    AppConstants.onThisDayOn: "Du får nå minner fra denne dagen.",
    AppConstants.onThisDayOff:
        "Påminnelser for «På denne dagen» er slått av.",
    AppConstants.themeChanged: "Tema %s valgt.",
    AppConstants.hideStats: "Skjul statistikk",
    AppConstants.hideHomeStats: "Skjul statistikk på hjemskjermen",
    AppConstants.hideInsightsStats: "Skjul statistikk i innsikt",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEKSJON",
    AppConstants.reflectButton: "Reflekter",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Feil PIN",
    AppConstants.verifyYourPin: "Bekreft PIN-koden din",
    AppConstants.setAPin: "Angi en PIN",
    AppConstants.confirmPin: "Bekreft PIN",
    AppConstants.pinsDoNotMatch: "PIN-kodene samsvarer ikke",
    AppConstants.setPin: "Angi PIN",
    AppConstants.hello: "Hei!",
    AppConstants.enterYourPin: "Skriv inn PIN-koden din",
    AppConstants.useBiometrics: "Bruk biometri",
    AppConstants.authenticateToUnlock:
        "Autentiser for å låse opp appen",
    AppConstants.databaseEncryption: "Databasekryptering",
    AppConstants.databaseEncryptionDesc: "Lokal AES-256-GCM-kryptering",
    AppConstants.changeMasterPassword: "Endre hovedpassord",
    AppConstants.biometricUnlock: "Biometrisk opplåsing",
    AppConstants.enterMasterPassword: "Skriv inn hovedpassord",
    AppConstants.enterMasterPasswordHint:
        "Skriv inn hovedpassordet for å dekryptere dagboken din.",
    AppConstants.unlockButton: "Lås opp",
    AppConstants.unlockWithBiometrics: "Lås opp med biometri",
    AppConstants.incorrectMasterPassword:
        "Feil hovedpassord. Prøv igjen.",
    AppConstants.databaseEncryptedSuccess:
        "Dagbokdatabase kryptert med AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Dagbokdatabase dekryptert og applås slått av.",
    AppConstants.masterPasswordChangedSuccess: "Hovedpassord oppdatert.",
    AppConstants.encryptedBackupPasswordRequired:
        "Det kreves et passord for å åpne en kryptert sikkerhetskopi.",
    AppConstants.incorrectBackupPassword:
        "Feil passord for sikkerhetskopi.",
    AppConstants.invalidBackupFile:
        "Valgt fil er ikke en gyldig OpenJot-sikkerhetskopi.",
    AppConstants.encryptedBackup: "Kryptert sikkerhetskopi (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Beskyttet med AES-256-GCM og et passord for sikkerhetskopi",
    AppConstants.standardBackup: "Standard sikkerhetskopi (.zip)",
    AppConstants.standardBackupDesc:
        "Ukryptert arkiv kompatibelt med alle versjoner",
    AppConstants.takingBackup: "Tar sikkerhetskopi...",
    AppConstants.encryptingBackup: "Krypterer sikkerhetskopi...",
    AppConstants.savingBackup: "Lagrer sikkerhetskopi...",
    AppConstants.preparingBackup: "Forbereder sikkerhetskopi...",
    AppConstants.decryptingBackup: "Dekrypterer sikkerhetskopi...",
    AppConstants.restoringBackup: "Gjenoppretter sikkerhetskopi...",
    AppConstants.backupEncodingFailed:
        "Kunne ikke kode sikkerhetskopifilen.",
    AppConstants.backupCreatedSuccess: "Sikkerhetskopi opprettet!",
    AppConstants.backupFailed: "Kunne ikke opprette sikkerhetskopi: %s",
    AppConstants.restorePermissionsRequired:
        "Lagrings- og medietillatelser kreves for å gjenopprette data.",
    AppConstants.databaseRestoredNoMedia:
        "Database gjenopprettet. Ingen medier funnet i sikkerhetskopien.",
    AppConstants.restoreSuccess: "Gjenoppretting vellykket!",
    AppConstants.restoreSuccessRestartRecommended:
        "Gjenoppretting vellykket. En omstart anbefales for å ta i bruk alle endringer.",
    AppConstants.restoreFailed: "Kunne ikke gjenopprette data: %s",
    AppConstants.storagePermissionsRequired:
        "Lagrings- og medietillatelser kreves for å opprette en sikkerhetskopi.",
    AppConstants.selectBackupFolder:
        "Velg en mappe for å lagre sikkerhetskopien",
    AppConstants.encryptDatabase: "Krypter database",
    AppConstants.disableEncryption: "Deaktiver kryptering",
    AppConstants.backupPasswordTitle: "Passord for sikkerhetskopi",
    AppConstants.changeMasterPasswordDesc:
        "Skriv inn ditt nåværende hovedpassord og velg et nytt passord (minimum 6 tegn).",
    AppConstants.disableEncryptionDesc:
        "Skriv inn hovedpassordet for å dekryptere databasen på disken og slå av kryptering.",
    AppConstants.enableEncryptionDesc:
        "Beskytt alle dagboknotater lokalt med AES-256-GCM-kryptering. Hvis du glemmer hovedpassordet, kan ikke krypterte data gjenopprettes.",
    AppConstants.verifyForBiometricsDesc:
        "Skriv inn hovedpassordet én gang for å lagre en nøkkel i sikker maskinvarelagring for rask biometrisk opplåsing.",
    AppConstants.createBackupPasswordDesc:
        "Angi et sterkt passord for å kryptere denne .openjot-sikkerhetskopien. Du trenger dette passordet for å gjenopprette den på hvilken som helst enhet.",
    AppConstants.enterBackupPasswordDesc:
        "Skriv inn passordet som ble brukt da denne .openjot-sikkerhetskopien ble opprettet.",
    AppConstants.updatePasswordAction: "Oppdater passord",
    AppConstants.decryptAndDisable: "Dekrypter og deaktiver",
    AppConstants.enableBiometricsAction: "Aktiver biometri",
    AppConstants.createBackupAction: "Opprett sikkerhetskopi",
    AppConstants.decryptBackupAction: "Dekrypter sikkerhedskopi",
    AppConstants.newMasterPasswordHint: "Nytt hovedpassord",
    AppConstants.backupPasswordHint: "Passord for sikkerhetskopi",
    AppConstants.masterPasswordHint: "Hovedpassord",
    AppConstants.enterCurrentMasterPasswordError:
        "Vennligst skriv inn ditt nåværende hovedpassord.",
    AppConstants.passwordEmptyError: "Passordet kan ikke være tomt.",
    AppConstants.passwordMinLengthError:
        "Passordet må være minst 6 tegn langt.",
    AppConstants.passwordsDoNotMatchError: "Passordene samsvarer ikke.",
    AppConstants.currentMasterPasswordHint: "Nåværende hovedpassord",
    AppConstants.confirmPasswordHint: "Bekreft passord",

    // About & Terms
    AppConstants.aboutApp: "Om OpenJot",
    AppConstants.versionPrefix: "Versjon: %s",
    AppConstants.aboutSubtitle:
        "En minimalistisk dagbok med åpen kildekode for å logge tanker, humør og minner. Alle dataene dine forblir på enheten din.",
    AppConstants.keyFeatures: "Hovedfunksjoner",
    AppConstants.aboutFeature1: "• Ren, distraksjonsfri skriveopplevelse.",
    AppConstants.aboutFeature2:
        "• Legg til bilder, talenotater og musikk i innleggene dine.",
    AppConstants.aboutFeature3:
        "• Registrer humøret ditt sammen med dagboken.",
    AppConstants.aboutFeature4: "• Tilpass med ulike tekststiler.",
    AppConstants.aboutFeature5:
        "• Fungerer helt frakoblet, dataene dine blir på enheten din.",
    AppConstants.openSource: "Åpen kildekode",
    AppConstants.openSourceDesc:
        "OpenJot er en app med åpen kildekode. Kildekoden er offentlig tilgjengelig for alle å inspisere, endre og bidra til. Vi tror på åpenhet og fellesskap.",
    AppConstants.dataPrivacy: "Personvern for data",
    AppConstants.dataPrivacyDesc:
        "Vi verdsetter personvernet ditt. OpenJot samler ikke inn, lagrer eller overfører noen personlige data. Alle innlegg, bilder og lydfiler lagres utelukkende på enheten din.",
    AppConstants.linksTitle: "Lenker",
    AppConstants.sourceCodeOnGithub: "Kildekode på GitHub",
    AppConstants.sendFeedback: "Send tilbakemelding",
    AppConstants.couldNotLaunchUrl: "Kunne ikke åpne URL",
    AppConstants.termsIntro:
        "Velkommen til OpenJot! Dette dokumentet beskriver vilkårene og betingelsene for bruk av applikasjonen vår. Ved å bruke OpenJot godtar du disse vilkårene.",
    AppConstants.termsSectionDataPrivacy: "Datalagring og personvern",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot er utformet som et privat rom for tankene dine. Alle innlegg, inkludert tekst, bilder, lydfiler og andre medier, lagres utelukkende lokalt på enheten din. Appen sender ingen personopplysninger til eksterne servere.",
    AppConstants.termsSectionUserContent: "Brukergenerert innhold",
    AppConstants.termsSectionUserContentBody:
        "Du er eneansvarlig for innholdet du oppretter og lagrer i OpenJot, inkludert tekst, bilder og lydopptak. Du er ansvarlig for å sikre at du har nødvendige rettigheter til importert innhold.",
    AppConstants.termsSectionDisclaimer: "Ansvarsfraskrivelse for garanti",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot leveres «som den er» uten noen garantier, verken uttrykte eller underforståtte. Vi garanterer ikke at appen er feilfri eller uten avbrudd. Bruk skjer på eget ansvar.",
    AppConstants.termsSectionLiability: "Ansvarsbegrensning",
    AppConstants.termsSectionLiabilityBody:
        "Under ingen omstendigheter skal utviklerne av OpenJot være ansvarlige for direkte, indirekte, tilfeldige, spesielle eller følgeskader, inkludert tap av data, som følge av bruk eller manglende evne til å bruke appen.",
    AppConstants.termsSectionThirdParty: "Tredjepartsbiblioteker",
    AppConstants.termsSectionThirdPartyBody:
        "Denne applikasjonen bruker følgende tredjepartsbiblioteker, som hvert er underlagt sin egen lisens:",

    // Months
    'January': 'Januar',
    'February': 'Februar',
    'March': 'Mars',
    'April': 'April',
    'May': 'Mai',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'August',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'Desember',

    // Reflection Prompts (61)
    "What made you smile today?": "Hva fikk deg til å smile i dag?",
    "Who are you thankful for this week, and why?":
        "Hvem er du takknemlig for denne uken, og hvorfor?",
    "What is something small that brought you joy today?":
        "Hva var en liten ting som ga deg glede i dag?",
    "Which part of your day felt most comforting?":
        "Hvilken del av dagen føltes mest betryggende?",
    "What’s something you often take for granted but appreciate now?":
        "Hva tar du ofte for gitt, men setter pris på nå?",
    "What’s the best thing that happened today?":
        "Hva var det beste som skjedde i dag?",
    "Did someone make your day easier today?":
        "Gjorde noen dagen din enklere i dag?",
    "Who made a positive impact on you recently?":
        "Hvem har gjort et positivt inntrykk på deg nylig?",
    "What’s a quality you admire in someone close to you?":
        "Hvilken egenskap beundrer du hos noen som står deg nær?",
    "When did you last feel truly connected with someone?":
        "Når følte du deg sist virkelig knyttet til noen?",
    "Who do you want to reach out to soon?":
        "Hvem ønsker du å ta kontakt med snart?",
    "Did someone’s kindness stand out today?":
        "Merket du noens vennlighet ekstra godt i dag?",
    "How did you support someone else recently?":
        "Hvordan støttet du noen andre nylig?",
    "Who do you miss the most right now?": "Hvem savner du mest akkurat nå?",
    "What’s a moment from today you want to remember?":
        "Hvilket øyeblikk fra i dag ønsker du å huske?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Hvilken detalj om i dag kan du glemme hvis du ikke noterer den?",
    "What’s the most peaceful moment you had today?":
        "Hva var ditt mest fredfulle øyeblikk i dag?",
    "Did you see something beautiful today?": "Så du noe vakkert i dag?",
    "Which memory from this week stands out?":
        "Hvilket minne fra denne uken skiller seg ut?",
    "What song, photo, or place will always remind you of today?":
        "Hvilken sang, bilde eller sted vil alltid minne deg om i dag?",
    "What surprised you today?": "Hva overrasket deg i dag?",
    "What challenge did you overcome today?":
        "Hvilken utfordring overvant du i dag?",
    "What’s a small win you had today?":
        "Hvilken liten seier hadde du i dag?",
    "What new thing did you learn about yourself recently?":
        "Hva nytt har du lært om deg selv nylig?",
    "What are you proud of yourself for?":
        "Hva er du stolt av ved deg selv?",
    "What habit do you feel good about keeping?":
        "Hvilken vane føles det godt å holde fast ved?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Hvilken forbedring har du lagt merke til hos deg selv i år?",
    "How did you push yourself out of your comfort zone?":
        "Hvordan gikk du utenfor komfortsonen din?",
    "How are you truly feeling right now?":
        "Hvordan har du det egentlig akkurat nå?",
    "Which emotion stood out the most today?":
        "Hvilken følelse utmerket seg mest i dag?",
    "Did you feel present in any moment today?":
        "Følte du deg til stede i noe øyeblikk i dag?",
    "When did you feel the most at peace today?":
        "Når følte du deg mest i fred i dag?",
    "What gave you energy today?": "Hva ga deg energi i dag?",
    "What drained your energy today?": "Hva tappet deg for energi i dag?",
    "If your mood had a color today, what would it be?":
        "Hvis humøret ditt hadde hatt en farge i dag, hvilken ville det vært?",
    "What’s something you’re excited about tomorrow?":
        "Hva gleder du deg til i morgen?",
    "What’s one thing you want to improve tomorrow?":
        "Hva er én ting du ønsker å forbedre i morgen?",
    "What would make tomorrow feel successful?":
        "Hva ville fått morgendagen til å føles vellykket?",
    "What do you hope to achieve this week?":
        "Hva håper du å oppnå denne uken?",
    "What’s a habit you’d like to start tomorrow?":
        "Hvilken vane kunne du tenke deg å starte i morgen?",
    "What’s something you want to look forward to in the next month?":
        "Hva ønsker du å se frem til i den kommende måneden?",
    "What would your ideal tomorrow look like?":
        "Hvordan ville din ideelle morgendag sett ut?",
    "What’s one lesson you learned recently?":
        "Hvilken lærdom har du gjort nylig?",
    "If you could freeze one moment today, which would it be?":
        "Hvis du kunne fryse ett øyeblikk i dag, hvilket ville det vært?",
    "What makes your life feel meaningful right now?":
        "Hva får livet ditt til å føles meningsfylt akkurat nå?",
    "If you described today in one word, what would it be?":
        "Hvis du skulle beskrive dagen i dag med ett ord, hvilket ville det vært?",
    "What inspired you today?": "Hva inspirerte deg i dag?",
    "What did you notice today that you usually overlook?":
        "Hva la du merke til i dag som du vanligvis overser?",
    "How has today changed your perspective?":
        "Hvordan har denne dagen endret perspektivet ditt?",
    "What’s something you’ve been overthinking?":
        "Hva har du tenkt for mye på i det siste?",
    "What do you need to let go of?": "Hva trenger du å gi slipp på?",
    "What part of nature did you notice today?":
        "Hvilken del av naturen la du merke til i dag?",
    "Did the weather affect your mood today?":
        "Påvirket været humøret ditt i dag?",
    "What place felt most comforting today?":
        "Hvilket sted føltes mest trygt i dag?",
    "Where did you feel most at home today?":
        "Hvor følte du deg mest hjemme i dag?",
    "What sound or smell reminded you of something important?":
        "Hvilken lyd eller lukt minte deg om noe viktig?",
    "How did you take care of yourself today?":
        "Hvordan tok du vare på deg selv i dag?",
    "When did you feel most like yourself today?":
        "Når følte du deg mest som deg selv i dag?",
    "What’s something kind you can say to yourself right now?":
        "Hva snilt kan du si til deg selv akkurat nå?",
    "What do you want to forgive yourself for?":
        "Hva vil du tilgi deg selv for?",
    "What do you deserve more of in your life?":
        "Hva fortjener du mer av i livet ditt?",
  },
  'fi': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Päiväkirjani",
    AppConstants.noEntriesMessage:
        "Ei vielä päiväkirjamerkintöjä. Aloita kirjoittaminen!",
    AppConstants.noBookmarksYet: "Ei vielä kirjanmerkkejä.",
    AppConstants.noDraftsYet: "Ei vielä luonnoksia.",
    AppConstants.addEntryButton: "Lisää uusi merkintä",
    AppConstants.jotYourThoughts: "Kirjaa ajatuksesi ylös",
    AppConstants.tapToCreateJournal:
        "Napauta + luodaksesi henkilökohtaisen päiväkirjasi.",
    AppConstants.entriesThisYear: "Merkinnät tänä vuonna",
    AppConstants.wordsWritten: "Kirjoitetut sanat",
    AppConstants.daysJournaled: "Päiväkirjapäivät",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Uusi päiväkirjamerkintä",
    AppConstants.editEntryAppBarTitle: "Muokkaa merkintää",
    AppConstants.titleHintText:
        "Otsikko (esim. 'Päiväni', 'Ajatuksia...')",
    AppConstants.contentHintText: "Kirjoita ajatuksesi tähän...",
    AppConstants.saveButton: "Tallenna merkintä",
    AppConstants.updateButton: "Päivitä",
    AppConstants.deleteButton: "Poista merkintä",
    AppConstants.requiredFieldMessage: "Tämä kenttä ei voi olla tyhjä.",
    AppConstants.newEntry: "Uusi merkintä",
    AppConstants.todayDate: "Tämän päivän päivämäärä",
    AppConstants.customDate: "Mukautettu päivämäärä",
    AppConstants.done: "Valmis",
    AppConstants.startWriting: " Aloita kirjoittaminen...",
    AppConstants.tags: "Tunnisteet",
    AppConstants.addTags: "Lisää tunnisteita",
    AppConstants.openInMaps: "Avaa kartoissa",
    AppConstants.changeLocation: "Vaihda sijaintia",
    AppConstants.remove: "Poista",
    AppConstants.discardSelectionsTitle: "Hylätäänkö valinnat?",
    AppConstants.discardSelectionsMessage:
        "Olet valinnut mediaa tai käynnissä olevan äänityksen. Haluatko varmasti hylätä ne?",
    AppConstants.journalEntryEmpty:
        "Päiväkirjamerkintä ei voi olla tyhjä",
    AppConstants.discardDateConfirm:
        "Hylätäänkö tälle merkinnälle valittu päivämäärä/aika?",
    AppConstants.addMediaLocationMoodFirst:
        "Lisää ensin mediaa, sijainti tai mieliala",
    AppConstants.location: "Sijainti",
    AppConstants.record: "Äänitä",
    AppConstants.selectMomentsToJournal: "Valitse hetket päiväkirjaan",
    AppConstants.addMomentsFromMenu:
        "Lisää mediaa, sijainti, äänitys tai mieliala valikosta",
    AppConstants.writeSomething: "Kirjoita jotain",
    AppConstants.saveWithoutWriting: "Tallenna kirjoittamatta",
    AppConstants.oneLocation: "1 sijainti",
    AppConstants.mediaCount: "%d mediatiedostoa",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Vahvista poisto",
    AppConstants.confirmDeleteMessage:
        "Haluatko varmasti poistaa tämän merkinnän?",
    AppConstants.pleaseConfirm: "Vahvista",
    AppConstants.confirmDeleteJournalEntry:
        "Haluatko varmasti poistaa tämän päiväkirjamerkinnän? Toimintoa ei voi perua.",
    AppConstants.yes: "Kyllä",
    AppConstants.no: "Ei",
    AppConstants.cancel: "Peruuta",
    AppConstants.delete: "Poista",
    AppConstants.save: "Tallenna",
    AppConstants.entrySavedSuccess: "Merkintä tallennettu!",
    AppConstants.entryUpdatedSuccess: "Merkintä päivitetty!",
    AppConstants.entryDeletedSuccess: "Merkintä poistettu.",
    AppConstants.errorSavingEntry: "Virhe merkinnän tallennuksessa.",
    AppConstants.errorDeletingEntry: "Virhe merkinnän poistossa.",
    AppConstants.errorLoadingEntries: "Virhe merkintöjen latauksessa.",
    AppConstants.noEntriesForDate: "Ei merkintöjä tälle päivälle.",
    AppConstants.noEntriesForMonth: "Tälle kuukaudelle ei löytynyt merkintöjä.",
    AppConstants.selectMonthAndYear: "Valitse kuukausi ja vuosi",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Erittäin epämiellyttävä",
    AppConstants.unpleasant: "Epämiellyttävä",
    AppConstants.slightlyUnpleasant: "Hieman epämiellyttävä",
    AppConstants.neutral: "Neutraali",
    AppConstants.slightlyPleasant: "Hieman miellyttävä",
    AppConstants.pleasant: "Miellyttävä",
    AppConstants.veryPleasant: "Erittäin miellyttävä",
    AppConstants.reflection: "Pohdinta",
    AppConstants.edit: "Muokkaa",
    AppConstants.removeBookmark: "Poista kirjanmerkki",
    AppConstants.bookmark: "Kirjanmerkki",
    AppConstants.share: "Jaa",
    AppConstants.saveAsPdf: "Tallenna PDF-muodossa",
    AppConstants.audioTrack: "Ääniraita",
    AppConstants.generatingPdf: "Luodaan PDF-tiedostoa...",
    AppConstants.voiceRecording: "Äänitys",
    AppConstants.audioRecording: "Äänitallenne",
    AppConstants.couldNotLoadAudio: "Äänitiedostoa ei voitu ladata.",
    AppConstants.stateOfMind: "Mielentila",

    // Mood Colors
    AppConstants.moodColors: "Mielialan värit",
    AppConstants.customizeMoodColors: "Mukauta mielialan värejä",
    AppConstants.reset: "Palauta",
    AppConstants.resetMoodColors: "Palauta oletukset",
    AppConstants.resetMoodColorsConfirm:
        "Palautetaanko kaikki mielialan värit oletusarvoihin?",
    AppConstants.paletteThemes: "Väripalettiteemat",
    AppConstants.customColor: "Mukautettu väri",
    AppConstants.moodUnsavedChangesMessage:
        "Sinulla on tallentamattomia muutoksia mielialan väreihin. Haluatko tallentaa ne ennen sulkemista?",

    // Drafts & Auto-save
    AppConstants.drafts: "Luonnokset",
    AppConstants.draft: "Luonnos",
    AppConstants.draftSaved: "Tallennettu luonnoksiin",
    AppConstants.unsavedChanges: "Tallentamattomat muutokset",
    AppConstants.unsavedChangesMessage:
        "Sinulla on tallentamattomia muutoksia. Haluatko tallentaa ne luonnoksena vai hylätä ne?",
    AppConstants.saveAsDraft: "Tallenna luonnoksena",
    AppConstants.discardChanges: "Hylkää",
    AppConstants.autoDeleteDrafts: "Poista luonnokset automaattisesti",
    AppConstants.days7: "7 päivää",
    AppConstants.never: "Ei koskaan",
    AppConstants.custom: "Mukautettu...",
    AppConstants.enterCustomDays: "Anna mukautetut päivät",
    AppConstants.customDaysExample: "Esim. 14",
    AppConstants.days: "Päivää",
    AppConstants.draftsNeverDeleted: "Luonnoksia ei koskaan poisteta",
    AppConstants.draftsDeletedAfterDays:
        "Luonnokset poistetaan %d päivän kuluttua",

    // Home Menu & Sorting
    AppConstants.sortBy: "Lajitteluperuste",
    AppConstants.insights: "Oivallukset",
    AppConstants.reflections: "Pohdinnat",
    AppConstants.settings: "Asetukset",
    AppConstants.entryTime: "Merkinnän aika",
    AppConstants.bookmarkFirst: "Kirjanmerkit ensin",
    AppConstants.reflectionFirst: "Pohdinnat ensin",
    AppConstants.withMediaFirst: "Mediaa sisältävät ensin",
    AppConstants.textOnlyFirst: "Vain teksti ensin",
    AppConstants.withLocationFirst: "Sijainnin kanssa ensin",
    AppConstants.withMoodFirst: "Mielialan kanssa ensin",
    AppConstants.withTagsFirst: "Tunnisteiden kanssa ensin",

    // Insights
    AppConstants.stats: "Tilastot",
    AppConstants.calendar: "Kalenteri",
    AppConstants.entriesSuffix: " merkintää",
    AppConstants.memoriesFromThisDay: "Muistoja tältä päivältä",
    AppConstants.standard: "Vakio",
    AppConstants.media: "Media",
    AppConstants.mood: "Mieliala",
    AppConstants.mostly: "Enimmäkseen",
    AppConstants.averageForThisDay: "Tämän päivän keskiarvo",
    AppConstants.averageForThisYear: "Tämän vuoden keskiarvo",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Tervetuloa OpenJotiin",
    AppConstants.feature1:
        "Kirjoita vapaasti, lisää kuvia ja sijainteja ja pidä kaikki turvassa laitteellasi.",
    AppConstants.feature2:
        "Ymmärrä tunteitasi ajan myötä integroidun mielialanseurannan avulla.",
    AppConstants.feature3:
        "Tietosi pysyvät puhelimessasi – ei pilveä, vain paikallinen tallennus ja täydellinen yksityisyys.",
    AppConstants.continueButton: "Jatka",

    // Notifications
    AppConstants.notificationTitle: "Päiväkirjan aika!",
    AppConstants.notificationBody:
        "Muista kirjoittaa päivän ajatuksesi ylös.",
    AppConstants.notificationChannelName: "Päivittäiset päiväkirjamuistutukset",
    AppConstants.notificationChannelDescription:
        "Kanava päivittäisille päiväkirjamuistutuksille",
    AppConstants.onThisDayChannelName: "Muistot tänä päivänä",
    AppConstants.onThisDayChannelDescription:
        "Ilmoitukset menneiden vuosien muistoista.",
    AppConstants.onThisDayNotificationTitle: "Muisto päiväkirjastasi",
    AppConstants.onThisDaySingleEntry:
        "Vuosi sitten tänään kirjoitit jotain erityistä. Napauta palataksesi ajatuksiisi.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Tänä päivänä viime vuonna jaoit tämän muiston. Napauta kokeaksesi sen uudelleen.",
    AppConstants.onThisDayMultipleEntries:
        "Sinulla on muistoja tältä päivältä menneiltä vuosilta. Napauta nähdäksesi ne.",
    AppConstants.onThisDayGroupedNotification:
        "Sinulla on %d muistoa tältä päivältä",

    // Exclude Entries
    AppConstants.excludeEntries: "Sulje merkinnät pois",
    AppConstants.saveExclusions: "Tallenna poissulkemiset",
    AppConstants.excludeUnsavedChangesMessage:
        "Sinulla on tallentamattomia muutoksia. Haluatko varmasti hylätä ne ja poistua?",
    AppConstants.sortDefault: "Oletus",
    AppConstants.sortMutedFirst: "Mykistetyt ensin",
    AppConstants.sortUnmutedFirst: "Mykistämättömät ensin",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Tänään",
    AppConstants.yesterday: "Eilen",
    AppConstants.contentForQuote: "Lainauksen sisältö",
    AppConstants.noContentSelected: "Ei valittua sisältöä.",
    AppConstants.photos: "Kuvat",
    AppConstants.video: "Video",
    AppConstants.audio: "Ääni",
    AppConstants.add: "Lisää",
    AppConstants.noMediaFound: "Kohteita %s ei löytynyt.",
    AppConstants.permissionRequired:
        "Näyttämiseen tarvitaan käyttöoikeus kohteeseen %s.",
    AppConstants.openSettings: "Avaa asetukset",
    AppConstants.videos: "Videot",
    AppConstants.audios: "Äänitiedostot",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Poistetaanko äänitys?",
    AppConstants.deleteRecordingMessage:
        "Haluatko varmasti poistaa tämän äänityksen?",
    AppConstants.listen: "Kuuntele",
    AppConstants.tapAndHold: "paina ja pidä",
    AppConstants.clear: "Tyhjennä",
    AppConstants.all: "Kaikki",
    AppConstants.folder: "Kansio",
    AppConstants.browse: "Selaa",
    AppConstants.tiles: "Ruudut",
    AppConstants.graph: "Kaavio",
    AppConstants.recording: "Äänitetään...",
    AppConstants.recordingLabel: "Äänitys",
    AppConstants.startAudioRecording: "Aloita äänen tallennus",
    AppConstants.howAreYouFeeling: "Miltä sinusta tuntuu?",
    AppConstants.paused: "Keskeytetty",
    AppConstants.stop: "Lopeta",
    AppConstants.tapOrHoldToResume: "Napauta tai pidä pohjassa jatkaaksesi",
    AppConstants.tapOrReleaseToPause: "Napauta tai vapauta keskeyttääksesi",
    AppConstants.unsupportedImageType: "Kuvatyyppiä ei tueta",
    AppConstants.couldNotLoadVideo: "Videota ei voitu ladata",
    AppConstants.couldNotOpenMap: "Karttalinkkiä ei voitu avata.",
    AppConstants.dismiss: "Sulje",
    AppConstants.selectTime: "Valitse aika",
    AppConstants.now: "Nyt",
    AppConstants.searchPlacesHint: "Hae paikkoja, kauppoja...",
    AppConstants.locationPermissionDenied: "Sijaintilupa evätty.",
    AppConstants.failedGetCurrentLocation:
        "Nykyisen sijainnin hakeminen epäonnistui.",

    // Search
    AppConstants.searchJournalsHint: "Hae päiväkirjoista...",
    AppConstants.textOnly: "Vain teksti",
    AppConstants.withMedia: "Median kanssa",
    AppConstants.withMood: "Mielialan kanssa",
    AppConstants.withLocation: "Sijainnin kanssa",
    AppConstants.withTags: "Tunnisteiden kanssa",
    AppConstants.noResultsFound: "Tuloksia ei löytynyt",
    AppConstants.searchHintText: "Hae merkinnöistä...",

    // Settings
    AppConstants.language: "Kieli",
    AppConstants.selectLanguage: "Valitse kieli",
    AppConstants.systemDefault: "Järjestelmän oletus",
    AppConstants.searchLanguagesHint: "Hae kieliä...",
    AppConstants.languageChanged: "Kieli vaihdettu: %s.",
    AppConstants.dailyReminder: "Muistutukset",
    AppConstants.addReminder: "Lisää muistutus",
    AppConstants.deleteReminder: "Poista muistutus",
    AppConstants.noRemindersSet: "Ei asetettuja muistutuksia.",
    AppConstants.onThisDay: "Tänä päivänä",
    AppConstants.appLock: "Sovelluslukitus",
    AppConstants.backup: "Varmuuskopio",
    AppConstants.restore: "Palauta",
    AppConstants.importFromAnotherApp: "Tuo toisesta sovelluksesta",
    AppConstants.importFromDailyYou: "Tuo Daily Yousta",
    AppConstants.selectDailyYouBackup:
        "Valitse Daily You -varmuuskopion zip-tiedosto",
    AppConstants.importingEntries: "Tuodaan merkintöjä...",
    AppConstants.importSuccess:
        "Tuotiin %d merkintää Daily Yousta onnistuneesti!",
    AppConstants.importFailed: "Tuonti epäonnistui: %s",
    AppConstants.noEntriesToImport: "Uusia tuotavia merkintöjä ei löytynyt.",
    AppConstants.askSupport: "Pyydä tukea",
    AppConstants.importSupportNote:
        "Muiden sovellusten muodot eivät välttämättä tue kaikkia ominaisuuksia. Jos kohtaat ongelmia tai muodot muuttuvat, lähetä vikailmoitus.",
    AppConstants.extractingBackup: "Puretaan varmuuskopiota...",
    AppConstants.parsingDatabase: "Jäsennetään tietokantaa...",
    AppConstants.dailyYouDbNotFound:
        "Daily You -tietokantaa ei löytynyt varmuuskopiosta.",
    AppConstants.privacyPolicy: "Tietosuojakäytäntö",
    AppConstants.termsNConditions: "Käyttöehdot",
    AppConstants.about: "Tietoja sovelluksesta",
    AppConstants.changeTheme: "Vaihda teemaa",
    AppConstants.theme: "Teema",
    AppConstants.pitchBlack: "Sysimusta",
    AppConstants.themeLight: "Vaalea",
    AppConstants.themeDark: "Tumma",
    AppConstants.themeSystem: "Järjestelmä",
    AppConstants.changePin: "Vaihda PIN",
    AppConstants.loading: "Ladataan...",
    AppConstants.confirmRestoreTitle: "Vahvista palautus",
    AppConstants.confirmRestoreMessage:
        "Varmuuskopiosta palauttaminen korvaa kaikki nykyiset tiedot. Toimintoa ei voi perua. Haluatko varmasti jatkaa?",
    AppConstants.notificationScheduled: "Ilmoitus ajastettu aikaan %s",
    AppConstants.notificationCanceled: "Ilmoitus peruutettu",
    AppConstants.notificationRescheduled: "Ilmoitus ajastettu uudelleen: %s",
    AppConstants.notificationPermissionRequired:
        "Muistutusten asettaminen vaatii ilmoitusluvan.",
    AppConstants.pinChangedSuccess: "PIN vaihdettu onnistuneesti",
    AppConstants.onThisDayOn: "Saat nyt muistoja tältä päivältä.",
    AppConstants.onThisDayOff:
        "'Tänä päivänä' -muistutukset ovat pois päältä.",
    AppConstants.themeChanged: "Teema %s valittu.",
    AppConstants.hideStats: "Piilota tilastot",
    AppConstants.hideHomeStats: "Piilota aloitusnäytön tilastot",
    AppConstants.hideInsightsStats: "Piilota oivallusten tilastot",

    // Reflection Sheet
    AppConstants.reflectionTitle: "POHDINTA",
    AppConstants.reflectButton: "Pohdi",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Virheellinen PIN",
    AppConstants.verifyYourPin: "Vahvista PIN-koodisi",
    AppConstants.setAPin: "Aseta PIN",
    AppConstants.confirmPin: "Vahvista PIN",
    AppConstants.pinsDoNotMatch: "PIN-koodit eivät täsmää",
    AppConstants.setPin: "Aseta PIN",
    AppConstants.hello: "Hei!",
    AppConstants.enterYourPin: "Syötä PIN-koodisi",
    AppConstants.useBiometrics: "Käytä biometriikkaa",
    AppConstants.authenticateToUnlock:
        "Tunnistaudu avataksesi sovelluksen",
    AppConstants.databaseEncryption: "Tietokannan salaus",
    AppConstants.databaseEncryptionDesc: "Paikallinen AES-256-GCM-salaus",
    AppConstants.changeMasterPassword: "Vaihda pääsalasana",
    AppConstants.biometricUnlock: "Biometrinen lukituksen avaus",
    AppConstants.enterMasterPassword: "Syötä pääsalasana",
    AppConstants.enterMasterPasswordHint:
        "Syötä pääsalasanasi purkaaksesi päiväkirjasi salauksen.",
    AppConstants.unlockButton: "Avaa lukitus",
    AppConstants.unlockWithBiometrics: "Avaa biometriikalla",
    AppConstants.incorrectMasterPassword:
        "Virheellinen pääsalasana. Yritä uudelleen.",
    AppConstants.databaseEncryptedSuccess:
        "Päiväkirjatietokanta salattu AES-256-GCM:llä.",
    AppConstants.databaseDecryptedSuccess:
        "Päiväkirjatietokannan salaus purettu ja sovelluslukitus poistettu.",
    AppConstants.masterPasswordChangedSuccess:
        "Pääsalasana päivitetty onnistuneesti.",
    AppConstants.encryptedBackupPasswordRequired:
        "Salatun varmuuskopion avaaminen vaatii salasanan.",
    AppConstants.incorrectBackupPassword:
        "Virheellinen varmuuskopion salasana.",
    AppConstants.invalidBackupFile:
        "Valittu tiedosto ei ole kelvollinen OpenJot-varmuuskopio.",
    AppConstants.encryptedBackup: "Salattu varmuuskopio (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Suojattu AES-256-GCM-salauksella ja varmuuskopion salasanalla",
    AppConstants.standardBackup: "Tavallinen varmuuskopio (.zip)",
    AppConstants.standardBackupDesc:
        "Salaamaton arkisto, yhteensopiva kaikkien versioiden kanssa",
    AppConstants.takingBackup: "Luodaan varmuuskopiota...",
    AppConstants.encryptingBackup: "Salataan varmuuskopiota...",
    AppConstants.savingBackup: "Tallennetaan varmuuskopiota...",
    AppConstants.preparingBackup: "Valmistellaan varmuuskopiota...",
    AppConstants.decryptingBackup: "Puretaan varmuuskopion salausta...",
    AppConstants.restoringBackup: "Palautetaan varmuuskopiota...",
    AppConstants.backupEncodingFailed:
        "Varmuuskopiotiedoston koodaus epäonnistui.",
    AppConstants.backupCreatedSuccess: "Varmuuskopio luotu onnistuneesti!",
    AppConstants.backupFailed: "Varmuuskopion luonti epäonnistui: %s",
    AppConstants.restorePermissionsRequired:
        "Tietojen palauttaminen vaatii tallennus- ja mediaoikeudet.",
    AppConstants.databaseRestoredNoMedia:
        "Tietokanta palautettu. Varmuuskopiosta ei löytynyt mediaa.",
    AppConstants.restoreSuccess: "Palautus onnistui!",
    AppConstants.restoreSuccessRestartRecommended:
        "Palautus onnistui. Uudelleenkäynnistystä suositellaan kaikkien muutosten käyttöönottoon.",
    AppConstants.restoreFailed: "Tietojen palautus epäonnistui: %s",
    AppConstants.storagePermissionsRequired:
        "Varmuuskopion luominen vaatii tallennus- ja mediaoikeudet.",
    AppConstants.selectBackupFolder:
        "Valitse kansio varmuuskopion tallentamiseen",
    AppConstants.encryptDatabase: "Salaa tietokanta",
    AppConstants.disableEncryption: "Poista salaus käytöstä",
    AppConstants.backupPasswordTitle: "Varmuuskopion salasana",
    AppConstants.changeMasterPasswordDesc:
        "Syötä nykyinen pääsalasanasi ja valitse uusi salasana (vähintään 6 merkkiä).",
    AppConstants.disableEncryptionDesc:
        "Syötä pääsalasanasi purkaaksesi levyn tietokannan salauksen ja poistaaksesi salauksen käytöstä.",
    AppConstants.enableEncryptionDesc:
        "Suojaa kaikki päiväkirjamerkinnät paikallisesti AES-256-GCM-salauksella. Jos unohdat pääsalasanasi, salattuja tietoja ei voida palauttaa.",
    AppConstants.verifyForBiometricsDesc:
        "Syötä pääsalasanasi kerran tallentaaksesi avaimen suojattuun laitteistomuistiin nopeaa biometristä avausta varten.",
    AppConstants.createBackupPasswordDesc:
        "Aseta vahva salasana tämän .openjot-varmuuskopion salaamiseen. Tarvitset tätä salasanaa palauttaessasi sen millä tahansa laitteella.",
    AppConstants.enterBackupPasswordDesc:
        "Syötä salasana, jota käytettiin tämän .openjot-varmuuskopion luomisessa.",
    AppConstants.updatePasswordAction: "Päivitä salasana",
    AppConstants.decryptAndDisable: "Pura salaus ja poista käytöstä",
    AppConstants.enableBiometricsAction: "Ota biometriikka käyttöön",
    AppConstants.createBackupAction: "Luo varmuuskopio",
    AppConstants.decryptBackupAction: "Pura varmuuskopion salaus",
    AppConstants.newMasterPasswordHint: "Uusi pääsalasana",
    AppConstants.backupPasswordHint: "Varmuuskopion salasana",
    AppConstants.masterPasswordHint: "Pääsalasana",
    AppConstants.enterCurrentMasterPasswordError:
        "Syötä nykyinen pääsalasanasi.",
    AppConstants.passwordEmptyError: "Salasana ei voi olla tyhjä.",
    AppConstants.passwordMinLengthError:
        "Salasanassa on oltava vähintään 6 merkkiä.",
    AppConstants.passwordsDoNotMatchError: "Salasanat eivät täsmää.",
    AppConstants.currentMasterPasswordHint: "Nykyinen pääsalasana",
    AppConstants.confirmPasswordHint: "Vahvista salasana",

    // About & Terms
    AppConstants.aboutApp: "Tietoja OpenJotista",
    AppConstants.versionPrefix: "Versio: %s",
    AppConstants.aboutSubtitle:
        "Minimalistinen avoimen lähdekoodin päiväkirja ajatusten, mielialojen ja muistojen kirjaamiseen. Kaikki tietosi pysyvät laitteellasi.",
    AppConstants.keyFeatures: "Keskeiset ominaisuudet",
    AppConstants.aboutFeature1:
        "• Selkeä, häiriötön kirjoituskokemus.",
    AppConstants.aboutFeature2:
        "• Lisää kuvia, äänimuistiinpanoja ja musiikkia merkintöihisi.",
    AppConstants.aboutFeature3: "• Tallenna mielialasi päiväkirjan rinnalle.",
    AppConstants.aboutFeature4: "• Mukauta erilaisilla tekstityyleillä.",
    AppConstants.aboutFeature5:
        "• Toimii täysin offline-tilassa, tietosi pysyvät laitteellasi.",
    AppConstants.openSource: "Avoin lähdekoodi",
    AppConstants.openSourceDesc:
        "OpenJot on avoimen lähdekoodin sovellus. Lähdekoodi on julkisesti kaikkien tarkasteltavissa, muokattavissa ja kehitettävissä. Uskomme läpinäkyvyyteen ja yhteisöllisyyteen.",
    AppConstants.dataPrivacy: "Tietosuoja",
    AppConstants.dataPrivacyDesc:
        "Arvostamme yksityisyyttäsi. OpenJot ei kerää, tallenna eikä lähetä mitään henkilötietojasi. Kaikki merkinnät, kuvat ja äänitiedostot tallennetaan vain laitteellesi.",
    AppConstants.linksTitle: "Linkit",
    AppConstants.sourceCodeOnGithub: "Lähdekoodi GitHubissa",
    AppConstants.sendFeedback: "Lähetä palautetta",
    AppConstants.couldNotLaunchUrl: "URL-osoitetta ei voitu avata",
    AppConstants.termsIntro:
        "Tervetuloa OpenJotiin! Tässä asiakirjassa kuvataan sovelluksemme käyttöehdot. Käyttämällä OpenJotia hyväksyt nämä ehdot.",
    AppConstants.termsSectionDataPrivacy: "Tietojen tallennus ja tietosuoja",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot on suunniteltu yksityiseksi tilaksi ajatuksillesi. Kaikki merkinnät, mukaan lukien tekstit, kuvat, äänitiedostot ja muu media, tallennetaan yksinomaan paikalliselle laitteellesi. Sovellus ei lähetä tietoja ulkoisille palvelimille.",
    AppConstants.termsSectionUserContent: "Käyttäjän luoma sisältö",
    AppConstants.termsSectionUserContentBody:
        "Olet yksin vastuussa OpenJotiin luomastasi ja tallentamastasi sisällöstä, mukaan lukien tekstit, kuvat ja äänitykset. Vastaat siitä, että sinulla on tarvittavat oikeudet kaikkeen tuomaasi sisältöön.",
    AppConstants.termsSectionDisclaimer: "Takuuvastuun rajoitus",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot toimitetaan \"sellaisenaan\" ilman minkäänlaisia nimenomaisia tai oletettuja takuita. Emme takaa virheetöntä tai keskeytyksetöntä toimintaa. Käyttö tapahtuu omalla vastuullasi.",
    AppConstants.termsSectionLiability: "Vastuunrajoitus",
    AppConstants.termsSectionLiabilityBody:
        "OpenJotin kehittäjät eivät missään tapauksessa ole vastuussa välittömistä, välillisistä, satunnaisista, erityisistä tai seurannaisvahingoista, mukaan lukien tietojen menetys, jotka johtuvat sovelluksen käytöstä tai kyvyttömyydestä käyttää sitä.",
    AppConstants.termsSectionThirdParty: "Kolmannen osapuolen kirjastot",
    AppConstants.termsSectionThirdPartyBody:
        "Tämä sovellus käyttää seuraavia kolmannen osapuolen kirjastoja, joista jokaista koskee sen oma lisenssi:",

    // Months
    'January': 'Tammikuu',
    'February': 'Helmikuu',
    'March': 'Maaliskuu',
    'April': 'Huhtikuu',
    'May': 'Toukokuu',
    'June': 'Kesäkuu',
    'July': 'Heinäkuu',
    'August': 'Elokuu',
    'September': 'Syyskuu',
    'October': 'Lokakuu',
    'November': 'Marraskuu',
    'December': 'Joulukuu',

    // Reflection Prompts (61)
    "What made you smile today?": "Mikä sai sinut hymyilemään tänään?",
    "Who are you thankful for this week, and why?":
        "Kenelle olet kiitollinen tällä viikolla ja miksi?",
    "What is something small that brought you joy today?":
        "Mikä pieni asia toi sinulle iloa tänään?",
    "Which part of your day felt most comforting?":
        "Mikä osa päivästäsi tuntui lohdullisimmalta?",
    "What’s something you often take for granted but appreciate now?":
        "Mitä pidät usein itsestäänselvyytenä, mutta arvostat nyt?",
    "What’s the best thing that happened today?":
        "Mikä oli parasta, mitä tänään tapahtui?",
    "Did someone make your day easier today?":
        "Tekikö joku päivästäsi helpomman tänään?",
    "Who made a positive impact on you recently?":
        "Kuka teki sinuun myönteisen vaikutuksen hiljattain?",
    "What’s a quality you admire in someone close to you?":
        "Mitä ominaisuutta ihailet läheisessäsi?",
    "When did you last feel truly connected with someone?":
        "Milloin tunsit viimeksi todellista yhteyttä kehenkään?",
    "Who do you want to reach out to soon?":
        "Kehen haluaisit ottaa yhteyttä pian?",
    "Did someone’s kindness stand out today?":
        "Erottuiko jonkun ystävällisyys tänään?",
    "How did you support someone else recently?":
        "Miten tuit jotakuta toista äskettäin?",
    "Who do you miss the most right now?": "Ketä kaipaat eniten juuri nyt?",
    "What’s a moment from today you want to remember?":
        "Minkä hetken tältä päivältä haluat muistaa?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Minkä yksityiskohdan tästä päivästä saattaisit unohtaa, jos et kirjoita sitä ylös?",
    "What’s the most peaceful moment you had today?":
        "Mikä oli rauhallisin hetkesi tänään?",
    "Did you see something beautiful today?": "Näitkö tänään jotain kaunista?",
    "Which memory from this week stands out?":
        "Mikä muisto tältä viikolta erottuu joukosta?",
    "What song, photo, or place will always remind you of today?":
        "Mikä kappale, kuva tai paikka muistuttaa sinua aina tästä päivästä?",
    "What surprised you today?": "Mikä yllätti sinut tänään?",
    "What challenge did you overcome today?":
        "Minkä haasteen voitit tänään?",
    "What’s a small win you had today?":
        "Mikä pieni voitto sinulla oli tänään?",
    "What new thing did you learn about yourself recently?":
        "Mitä uutta olet oppinut itsestäsi viime aikoina?",
    "What are you proud of yourself for?": "Mistä olet ylpeä itsessäsi?",
    "What habit do you feel good about keeping?":
        "Minkä tavan ylläpitämisestä sinulla on hyvä olo?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Minkä parannuksen olet huomannut itsessäsi tänä vuonna?",
    "How did you push yourself out of your comfort zone?":
        "Miten astuit ulos mukavuusalueeltasi?",
    "How are you truly feeling right now?":
        "Miltä sinusta oikeasti tuntuu juuri nyt?",
    "Which emotion stood out the most today?":
        "Mikä tunne erottui tänään eniten?",
    "Did you feel present in any moment today?":
        "Tunsitko olevasi läsnä jossakin hetkessä tänään?",
    "When did you feel the most at peace today?":
        "Milloin tunsit olevasi eniten rauhassa tänään?",
    "What gave you energy today?": "Mikä antoi sinulle energiaa tänään?",
    "What drained your energy today?": "Mikä vei energiaasi tänään?",
    "If your mood had a color today, what would it be?":
        "Jos mielialallasi olisi tänään väri, mikä se olisi?",
    "What’s something you’re excited about tomorrow?":
        "Mistä olet innoissasi huomisen suhteen?",
    "What’s one thing you want to improve tomorrow?":
        "Mitä yhtä asiaa haluat parantaa huomenna?",
    "What would make tomorrow feel successful?":
        "Mikä saisi huomisen tuntumaan onnistuneelta?",
    "What do you hope to achieve this week?":
        "Mitä toivot saavuttavasi tällä viikolla?",
    "What’s a habit you’d like to start tomorrow?":
        "Minkä tavan haluaisit aloittaa huomenna?",
    "What’s something you want to look forward to in the next month?":
        "Mitä haluat odottaa innolla ensi kuussa?",
    "What would your ideal tomorrow look like?":
        "Millainen olisi ihanteellinen huomispäiväsi?",
    "What’s one lesson you learned recently?":
        "Minkä läksyn opit hiljattain?",
    "If you could freeze one moment today, which would it be?":
        "Jos voisit pysäyttää yhden hetken tänään, mikä se olisi?",
    "What makes your life feel meaningful right now?":
        "Mikä saa elämäsi tuntumaan merkitykselliseltä juuri nyt?",
    "If you described today in one word, what would it be?":
        "Jos kuvailisit tätä päivää yhdellä sanalla, mikä se olisi?",
    "What inspired you today?": "Mikä inspiroi sinua tänään?",
    "What did you notice today that you usually overlook?":
        "Mitä huomasit tänään sellaista, minkä yleensä ohitat?",
    "How has today changed your perspective?":
        "Miten tämä päivä on muuttanut näkökulmaasi?",
    "What’s something you’ve been overthinking?":
        "Mitä olet miettinyt liikaa?",
    "What do you need to let go of?": "Mistä sinun täytyy päästää irti?",
    "What part of nature did you notice today?":
        "Mitä osaa luonnosta huomasit tänään?",
    "Did the weather affect your mood today?":
        "Vaikuttiko sää mielialaasi tänään?",
    "What place felt most comforting today?":
        "Mikä paikka tuntui tänään kaikkein turvallisimmalta?",
    "Where did you feel most at home today?":
        "Missä tunsit olosi kotoisimmaksi tänään?",
    "What sound or smell reminded you of something important?":
        "Mikä ääni tai tuoksu muistutti sinua jostain tärkeästä?",
    "How did you take care of yourself today?":
        "Miten pidit huolta itsestäsi tänään?",
    "When did you feel most like yourself today?":
        "Milloin tunsit olevasi eniten oma itsesi tänään?",
    "What’s something kind you can say to yourself right now?":
        "Mitä ystävällistä voit sanoa itsellesi juuri nyt?",
    "What do you want to forgive yourself for?":
        "Mitä haluat antaa itsellesi anteeksi?",
    "What do you deserve more of in your life?":
        "Mitä ansaitset elämääsi enemmän?",
  },
};
