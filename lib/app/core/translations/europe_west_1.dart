import '../constants.dart';

/// Complete Western & Northern European translations (Part 1):
/// Spanish (`es`), French (`fr`), German (`de`), Italian (`it`).
final Map<String, Map<String, String>> europeWest1Translations =
    <String, Map<String, String>>{
  'es': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Mi diario",
    AppConstants.noEntriesMessage:
        "Aún no hay entradas en el diario. ¡Empieza a escribir!",
    AppConstants.noBookmarksYet: "Aún no hay marcadores.",
    AppConstants.noDraftsYet: "Aún no hay borradores.",
    AppConstants.addEntryButton: "Añadir nueva entrada",
    AppConstants.jotYourThoughts: "Anota tus pensamientos",
    AppConstants.tapToCreateJournal: "Toca + para crear tu diario personal.",
    AppConstants.entriesThisYear: "Entradas este año",
    AppConstants.wordsWritten: "Palabras escritas",
    AppConstants.daysJournaled: "Días con diario",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nueva entrada de diario",
    AppConstants.editEntryAppBarTitle: "Editar entrada de diario",
    AppConstants.titleHintText: "Título (p. ej., 'Mi día', 'Reflexiones...')",
    AppConstants.contentHintText: "Escribe tus pensamientos aquí...",
    AppConstants.saveButton: "Guardar entrada",
    AppConstants.updateButton: "Actualizar",
    AppConstants.deleteButton: "Eliminar entrada",
    AppConstants.requiredFieldMessage: "Este campo no puede estar vacío.",
    AppConstants.newEntry: "Nueva entrada",
    AppConstants.todayDate: "Fecha de hoy",
    AppConstants.customDate: "Fecha personalizada",
    AppConstants.done: "Listo",
    AppConstants.startWriting: " Empieza a escribir...",
    AppConstants.tags: "Etiquetas",
    AppConstants.addTags: "Añadir etiquetas",
    AppConstants.openInMaps: "Abrir en Mapas",
    AppConstants.changeLocation: "Cambiar ubicación",
    AppConstants.remove: "Quitar",
    AppConstants.discardSelectionsTitle: "¿Descartar selecciones?",
    AppConstants.discardSelectionsMessage:
        "Has seleccionado contenido multimedia o una grabación activa. ¿Seguro que quieres descartarlos?",
    AppConstants.journalEntryEmpty: "La entrada del diario no puede estar vacía",
    AppConstants.discardDateConfirm:
        "¿Descartar la fecha/hora seleccionada para esta entrada?",
    AppConstants.addMediaLocationMoodFirst:
        "Añade primero contenido multimedia, ubicación o estado de ánimo",
    AppConstants.location: "Ubicación",
    AppConstants.record: "Grabar",
    AppConstants.selectMomentsToJournal: "Elige momentos para tu diario",
    AppConstants.addMomentsFromMenu:
        "Añade multimedia, ubicación, grabación o estado de ánimo desde el menú",
    AppConstants.writeSomething: "Escribe algo",
    AppConstants.saveWithoutWriting: "Guardar sin escribir",
    AppConstants.oneLocation: "1 ubicación",
    AppConstants.mediaCount: "%d archivos",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Confirmar eliminación",
    AppConstants.confirmDeleteMessage:
        "¿Seguro que quieres eliminar esta entrada?",
    AppConstants.pleaseConfirm: "Por favor, confirma",
    AppConstants.confirmDeleteJournalEntry:
        "¿Seguro que quieres eliminar esta entrada del diario? Esta acción es irreversible.",
    AppConstants.yes: "Sí",
    AppConstants.no: "No",
    AppConstants.cancel: "Cancelar",
    AppConstants.delete: "Eliminar",
    AppConstants.save: "Guardar",
    AppConstants.entrySavedSuccess: "¡Entrada del diario guardada con éxito!",
    AppConstants.entryUpdatedSuccess:
        "¡Entrada del diario actualizada con éxito!",
    AppConstants.entryDeletedSuccess: "Entrada del diario eliminada.",
    AppConstants.errorSavingEntry: "Error al guardar la entrada.",
    AppConstants.errorDeletingEntry: "Error al eliminar la entrada.",
    AppConstants.errorLoadingEntries:
        "Error al cargar las entradas del diario.",
    AppConstants.noEntriesForDate: "No hay entradas para esta fecha.",
    AppConstants.noEntriesForMonth: "No se encontraron entradas para este mes.",
    AppConstants.selectMonthAndYear: "Seleccionar mes y año",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Muy desagradable",
    AppConstants.unpleasant: "Desagradable",
    AppConstants.slightlyUnpleasant: "Algo desagradable",
    AppConstants.neutral: "Neutral",
    AppConstants.slightlyPleasant: "Algo agradable",
    AppConstants.pleasant: "Agradable",
    AppConstants.veryPleasant: "Muy agradable",
    AppConstants.reflection: "Reflexión",
    AppConstants.edit: "Editar",
    AppConstants.removeBookmark: "Quitar marcador",
    AppConstants.bookmark: "Marcador",
    AppConstants.share: "Compartir",
    AppConstants.saveAsPdf: "Guardar como PDF",
    AppConstants.audioTrack: "Pista de audio",
    AppConstants.generatingPdf: "Generando PDF...",
    AppConstants.voiceRecording: "Grabación de voz",
    AppConstants.audioRecording: "Grabación de audio",
    AppConstants.couldNotLoadAudio: "No se pudo cargar el archivo de audio.",
    AppConstants.stateOfMind: "Estado de ánimo",

    // Mood Colors
    AppConstants.moodColors: "Colores de ánimo",
    AppConstants.customizeMoodColors: "Personalizar colores de ánimo",
    AppConstants.reset: "Restablecer",
    AppConstants.resetMoodColors: "Restablecer valores predeterminados",
    AppConstants.resetMoodColorsConfirm:
        "¿Restablecer todos los colores de ánimo a los valores predeterminados?",
    AppConstants.paletteThemes: "Temas de paleta",
    AppConstants.customColor: "Color personalizado",
    AppConstants.moodUnsavedChangesMessage:
        "Tienes cambios sin guardar en los colores de ánimo. ¿Quieres guardarlos antes de cerrar?",

    // Drafts & Auto-save
    AppConstants.drafts: "Borradores",
    AppConstants.draft: "Borrador",
    AppConstants.draftSaved: "Guardado en borradores",
    AppConstants.unsavedChanges: "Cambios sin guardar",
    AppConstants.unsavedChangesMessage:
        "Tienes cambios sin guardar. ¿Quieres guardarlos como borrador o descartarlos?",
    AppConstants.saveAsDraft: "Guardar como borrador",
    AppConstants.discardChanges: "Descartar",
    AppConstants.autoDeleteDrafts: "Autoeliminar borradores",
    AppConstants.days7: "7 días",
    AppConstants.never: "Nunca",
    AppConstants.custom: "Personalizado...",
    AppConstants.enterCustomDays: "Introducir días personalizados",
    AppConstants.customDaysExample: "P. ej., 14",
    AppConstants.days: "Días",
    AppConstants.draftsNeverDeleted: "Los borradores nunca se eliminarán",
    AppConstants.draftsDeletedAfterDays:
        "Los borradores se eliminarán después de %d días",

    // Home Menu & Sorting
    AppConstants.sortBy: "Ordenar por",
    AppConstants.insights: "Estadísticas",
    AppConstants.reflections: "Reflexiones",
    AppConstants.settings: "Ajustes",
    AppConstants.entryTime: "Hora de la entrada",
    AppConstants.bookmarkFirst: "Marcadores primero",
    AppConstants.reflectionFirst: "Reflexiones primero",
    AppConstants.withMediaFirst: "Con multimedia primero",
    AppConstants.textOnlyFirst: "Solo texto primero",
    AppConstants.withLocationFirst: "Con ubicación primero",
    AppConstants.withMoodFirst: "Con estado de ánimo primero",
    AppConstants.withTagsFirst: "Con etiquetas primero",

    // Insights
    AppConstants.stats: "Estadísticas",
    AppConstants.calendar: "Calendario",
    AppConstants.entriesSuffix: " entradas",
    AppConstants.memoriesFromThisDay: "Recuerdos de este día",
    AppConstants.standard: "Estándar",
    AppConstants.media: "Multimedia",
    AppConstants.mood: "Ánimo",
    AppConstants.mostly: "Principalmente",
    AppConstants.averageForThisDay: "Promedio de este día",
    AppConstants.averageForThisYear: "Promedio de este año",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Bienvenido a OpenJot",
    AppConstants.feature1:
        "Escribe libremente, añade fotos y ubicaciones, y mantén todo seguro en tu dispositivo.",
    AppConstants.feature2:
        "Comprende tus emociones a lo largo del tiempo con el seguimiento integrado del estado de ánimo.",
    AppConstants.feature3:
        "Tus datos permanecen en tu teléfono: sin nube, solo almacenamiento local y privacidad total.",
    AppConstants.continueButton: "Continuar",

    // Notifications
    AppConstants.notificationTitle: "¡Hora de escribir en tu diario!",
    AppConstants.notificationBody: "No olvides anotar tus pensamientos de hoy.",
    AppConstants.notificationChannelName: "Recordatorios diarios del diario",
    AppConstants.notificationChannelDescription:
        "Canal para notificaciones de recordatorio diario",
    AppConstants.onThisDayChannelName: "Recuerdos de un día como hoy",
    AppConstants.onThisDayChannelDescription:
        "Notificaciones de recuerdos de años anteriores.",
    AppConstants.onThisDayNotificationTitle: "Un recuerdo de tu diario",
    AppConstants.onThisDaySingleEntry:
        "Hoy hace un año escribiste algo especial. Toca para volver a leer tus pensamientos.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Un día como hoy el año pasado compartiste este recuerdo. Toca para revivirlo.",
    AppConstants.onThisDayMultipleEntries:
        "Tienes recuerdos de este día en años pasados. Toca para revisarlos.",
    AppConstants.onThisDayGroupedNotification:
        "Tienes %d recuerdos de este día",

    // Exclude Entries
    AppConstants.excludeEntries: "Excluir entradas",
    AppConstants.saveExclusions: "Guardar exclusiones",
    AppConstants.excludeUnsavedChangesMessage:
        "Tienes cambios sin guardar. ¿Seguro que quieres descartarlos y salir?",
    AppConstants.sortDefault: "Predeterminado",
    AppConstants.sortMutedFirst: "Silenciados primero",
    AppConstants.sortUnmutedFirst: "No silenciados primero",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Hoy",
    AppConstants.yesterday: "Ayer",
    AppConstants.contentForQuote: "Contenido para la cita",
    AppConstants.noContentSelected: "No hay contenido seleccionado.",
    AppConstants.photos: "Fotos",
    AppConstants.video: "Vídeo",
    AppConstants.audio: "Audio",
    AppConstants.add: "Añadir",
    AppConstants.noMediaFound: "No se encontraron %s.",
    AppConstants.permissionRequired:
        "Se requiere permiso para acceder a %s para mostrarlos.",
    AppConstants.openSettings: "Abrir ajustes",
    AppConstants.videos: "Vídeos",
    AppConstants.audios: "Audios",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "¿Eliminar grabación?",
    AppConstants.deleteRecordingMessage:
        "¿Seguro que quieres eliminar esta grabación?",
    AppConstants.listen: "Escuchar",
    AppConstants.tapAndHold: "mantén pulsado",
    AppConstants.clear: "Borrar",
    AppConstants.all: "Todo",
    AppConstants.folder: "Carpeta",
    AppConstants.browse: "Explorar",
    AppConstants.tiles: "Tarjetas",
    AppConstants.graph: "Gráfico",
    AppConstants.recording: "Grabando...",
    AppConstants.recordingLabel: "Grabación",
    AppConstants.startAudioRecording: "Iniciar grabación de audio",
    AppConstants.howAreYouFeeling: "¿Cómo te sientes?",
    AppConstants.paused: "En pausa",
    AppConstants.stop: "Detener",
    AppConstants.tapOrHoldToResume: "Toca o mantén pulsado para reanudar",
    AppConstants.tapOrReleaseToPause: "Toca o suelta para pausar",
    AppConstants.unsupportedImageType: "Tipo de imagen no compatible",
    AppConstants.couldNotLoadVideo: "No se pudo cargar el vídeo",
    AppConstants.couldNotOpenMap: "No se pudo abrir el enlace del mapa.",
    AppConstants.dismiss: "Cerrar",
    AppConstants.selectTime: "Seleccionar hora",
    AppConstants.now: "Ahora",
    AppConstants.searchPlacesHint: "Buscar lugares, tiendas...",
    AppConstants.locationPermissionDenied: "Permiso de ubicación denegado.",
    AppConstants.failedGetCurrentLocation:
        "No se pudo obtener la ubicación actual.",

    // Search
    AppConstants.searchJournalsHint: "Buscar diarios...",
    AppConstants.textOnly: "Solo texto",
    AppConstants.withMedia: "Con multimedia",
    AppConstants.withMood: "Con estado de ánimo",
    AppConstants.withLocation: "Con ubicación",
    AppConstants.withTags: "Con etiquetas",
    AppConstants.noResultsFound: "No se encontraron resultados",
    AppConstants.searchHintText: "Buscar entradas...",

    // Settings
    AppConstants.language: "Idioma",
    AppConstants.selectLanguage: "Seleccionar idioma",
    AppConstants.systemDefault: "Predeterminado del sistema",
    AppConstants.searchLanguagesHint: "Buscar idiomas...",
    AppConstants.languageChanged: "Idioma cambiado a %s.",
    AppConstants.dailyReminder: "Recordatorios",
    AppConstants.addReminder: "Añadir recordatorio",
    AppConstants.deleteReminder: "Eliminar recordatorio",
    AppConstants.noRemindersSet: "No hay recordatorios configurados.",
    AppConstants.onThisDay: "Un día como hoy",
    AppConstants.appLock: "Bloqueo de la app",
    AppConstants.backup: "Copia de seguridad",
    AppConstants.restore: "Restaurar",
    AppConstants.importFromAnotherApp: "Importar de otra app",
    AppConstants.importFromDailyYou: "Importar desde Daily You",
    AppConstants.selectDailyYouBackup:
        "Selecciona el archivo zip de copia de Daily You",
    AppConstants.importingEntries: "Importando entradas...",
    AppConstants.importSuccess:
        "¡Se importaron %d entradas de Daily You con éxito!",
    AppConstants.importFailed: "Error al importar: %s",
    AppConstants.noEntriesToImport:
        "No se encontraron entradas nuevas para importar.",
    AppConstants.askSupport: "Pedir ayuda",
    AppConstants.importSupportNote:
        "Es posible que otros formatos de aplicaciones no admitan todas las funciones. Si tienes problemas o cambian los formatos, abre un informe de problema para que podamos solucionarlo.",
    AppConstants.extractingBackup: "Extrayendo copia de seguridad...",
    AppConstants.parsingDatabase: "Analizando base de datos...",
    AppConstants.dailyYouDbNotFound:
        "No se encontró la base de datos de Daily You en la copia.",
    AppConstants.privacyPolicy: "Política de privacidad",
    AppConstants.termsNConditions: "Términos y condiciones",
    AppConstants.about: "Acerca de la app",
    AppConstants.changeTheme: "Cambiar tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Negro puro",
    AppConstants.themeLight: "Claro",
    AppConstants.themeDark: "Oscuro",
    AppConstants.themeSystem: "Sistema",
    AppConstants.changePin: "Cambiar PIN",
    AppConstants.loading: "Cargando...",
    AppConstants.confirmRestoreTitle: "Confirmar restauración",
    AppConstants.confirmRestoreMessage:
        "Restaurar desde una copia de seguridad sobrescribirá todos los datos actuales. Esta acción no se puede deshacer. ¿Seguro que quieres continuar?",
    AppConstants.notificationScheduled: "Notificación programada para las %s",
    AppConstants.notificationCanceled: "Notificación cancelada",
    AppConstants.notificationRescheduled:
        "Notificación reprogramada para las %s",
    AppConstants.notificationPermissionRequired:
        "Se requiere permiso de notificaciones para configurar recordatorios.",
    AppConstants.pinChangedSuccess: "PIN cambiado con éxito",
    AppConstants.onThisDayOn: "Ahora recibirás recuerdos de este día.",
    AppConstants.onThisDayOff:
        "Los recordatorios de 'Un día como hoy' están desactivados.",
    AppConstants.themeChanged: "Tema %s seleccionado.",
    AppConstants.hideStats: "Ocultar estadísticas",
    AppConstants.hideHomeStats: "Ocultar estadísticas de inicio",
    AppConstants.hideInsightsStats: "Ocultar estadísticas de análisis",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEXIÓN",
    AppConstants.reflectButton: "Reflexionar",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "PIN incorrecto",
    AppConstants.verifyYourPin: "Verifica tu PIN",
    AppConstants.setAPin: "Establecer un PIN",
    AppConstants.confirmPin: "Confirmar PIN",
    AppConstants.pinsDoNotMatch: "Los PIN no coinciden",
    AppConstants.setPin: "Establecer PIN",
    AppConstants.hello: "¡Hola!",
    AppConstants.enterYourPin: "Introduce tu PIN",
    AppConstants.useBiometrics: "Usar biometría",
    AppConstants.authenticateToUnlock:
        "Autentícate para desbloquear la aplicación",
    AppConstants.databaseEncryption: "Cifrado de base de datos",
    AppConstants.databaseEncryptionDesc: "Cifrado local AES-256-GCM",
    AppConstants.changeMasterPassword: "Cambiar contraseña maestra",
    AppConstants.biometricUnlock: "Desbloqueo biométrico",
    AppConstants.enterMasterPassword: "Introducir contraseña maestra",
    AppConstants.enterMasterPasswordHint:
        "Introduce tu contraseña maestra para descifrar tu diario.",
    AppConstants.unlockButton: "Desbloquear",
    AppConstants.unlockWithBiometrics: "Desbloquear con biometría",
    AppConstants.incorrectMasterPassword:
        "Contraseña maestra incorrecta. Inténtalo de nuevo.",
    AppConstants.databaseEncryptedSuccess:
        "Base de datos del diario cifrada con AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Base de datos del diario descifrada y bloqueo desactivado.",
    AppConstants.masterPasswordChangedSuccess:
        "Contraseña maestra actualizada con éxito.",
    AppConstants.encryptedBackupPasswordRequired:
        "Se requiere una contraseña para abrir una copia de seguridad cifrada.",
    AppConstants.incorrectBackupPassword:
        "Contraseña de copia de seguridad incorrecta.",
    AppConstants.invalidBackupFile:
        "El archivo seleccionado no es una copia de seguridad válida de OpenJot.",
    AppConstants.encryptedBackup: "Copia cifrada (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Protegida con AES-256-GCM y una contraseña de copia",
    AppConstants.standardBackup: "Copia estándar (.zip)",
    AppConstants.standardBackupDesc:
        "Archivo sin cifrar compatible con todas las versiones",
    AppConstants.takingBackup: "Creando copia de seguridad...",
    AppConstants.encryptingBackup: "Cifrando copia de seguridad...",
    AppConstants.savingBackup: "Guardando copia de seguridad...",
    AppConstants.preparingBackup: "Preparando copia de seguridad...",
    AppConstants.decryptingBackup: "Descifrando copia de seguridad...",
    AppConstants.restoringBackup: "Restaurando copia de seguridad...",
    AppConstants.backupEncodingFailed:
        "No se pudo codificar el archivo de copia de seguridad.",
    AppConstants.backupCreatedSuccess: "¡Copia de seguridad creada con éxito!",
    AppConstants.backupFailed: "Error al crear la copia de seguridad: %s",
    AppConstants.restorePermissionsRequired:
        "Se requieren permisos de almacenamiento y multimedia para restaurar los datos.",
    AppConstants.databaseRestoredNoMedia:
        "Base de datos restaurada. No se encontró multimedia en la copia.",
    AppConstants.restoreSuccess: "¡Restauración completada!",
    AppConstants.restoreSuccessRestartRecommended:
        "Restauración completada. Se recomienda reiniciar para aplicar todos los cambios.",
    AppConstants.restoreFailed: "Error al restaurar los datos: %s",
    AppConstants.storagePermissionsRequired:
        "Se requieren permisos de almacenamiento y multimedia para crear una copia.",
    AppConstants.selectBackupFolder:
        "Selecciona una carpeta para guardar la copia",
    AppConstants.encryptDatabase: "Cifrar base de datos",
    AppConstants.disableEncryption: "Desactivar cifrado",
    AppConstants.backupPasswordTitle: "Contraseña de la copia",
    AppConstants.changeMasterPasswordDesc:
        "Introduce tu contraseña maestra actual y elige una nueva (mínimo 6 caracteres).",
    AppConstants.disableEncryptionDesc:
        "Introduce tu contraseña maestra para descifrar la base de datos en disco y desactivar el cifrado.",
    AppConstants.enableEncryptionDesc:
        "Protege todas las notas del diario localmente con cifrado AES-256-GCM. Si olvidas tu contraseña maestra, no podrás recuperar los datos cifrados.",
    AppConstants.verifyForBiometricsDesc:
        "Introduce tu contraseña maestra una vez para guardar una clave en el almacenamiento seguro de hardware para el desbloqueo biométrico rápido.",
    AppConstants.createBackupPasswordDesc:
        "Establece una contraseña segura para cifrar esta copia .openjot. La necesitarás para restaurarla en cualquier dispositivo.",
    AppConstants.enterBackupPasswordDesc:
        "Introduce la contraseña usada al crear esta copia .openjot.",
    AppConstants.updatePasswordAction: "Actualizar contraseña",
    AppConstants.decryptAndDisable: "Descifrar y desactivar",
    AppConstants.enableBiometricsAction: "Activar biometría",
    AppConstants.createBackupAction: "Crear copia",
    AppConstants.decryptBackupAction: "Descifrar copia",
    AppConstants.newMasterPasswordHint: "Nueva contraseña maestra",
    AppConstants.backupPasswordHint: "Contraseña de la copia",
    AppConstants.masterPasswordHint: "Contraseña maestra",
    AppConstants.enterCurrentMasterPasswordError:
        "Por favor, introduce tu contraseña maestra actual.",
    AppConstants.passwordEmptyError: "La contraseña no puede estar vacía.",
    AppConstants.passwordMinLengthError:
        "La contraseña debe tener al menos 6 caracteres.",
    AppConstants.passwordsDoNotMatchError: "Las contraseñas no coinciden.",
    AppConstants.currentMasterPasswordHint: "Contraseña maestra actual",
    AppConstants.confirmPasswordHint: "Confirmar contraseña",

    // About & Terms
    AppConstants.aboutApp: "Acerca de OpenJot",
    AppConstants.versionPrefix: "Versión: %s",
    AppConstants.aboutSubtitle:
        "Un diario minimalista y de código abierto para registrar tus pensamientos, estados de ánimo y recuerdos. Todos tus datos permanecen en tu dispositivo.",
    AppConstants.keyFeatures: "Funciones principales",
    AppConstants.aboutFeature1:
        "• Experiencia de escritura limpia y sin distracciones.",
    AppConstants.aboutFeature2:
        "• Añade fotos, notas de voz y música a tus entradas.",
    AppConstants.aboutFeature3:
        "• Registra tu estado de ánimo junto con tus diarios.",
    AppConstants.aboutFeature4: "• Personaliza con distintos estilos de texto.",
    AppConstants.aboutFeature5:
        "• Funciona totalmente sin conexión; tus datos quedan en tu dispositivo.",
    AppConstants.openSource: "Código abierto",
    AppConstants.openSourceDesc:
        "OpenJot es una aplicación de código abierto. El código fuente está disponible públicamente para que cualquiera lo inspeccione, modifique y colabore. Creemos en la transparencia y la colaboración comunitaria.",
    AppConstants.dataPrivacy: "Privacidad de datos",
    AppConstants.dataPrivacyDesc:
        "Valoramos tu privacidad. OpenJot no recopila, almacena ni transmite ninguno de tus datos personales. Todas tus entradas, incluidas las imágenes y audios, se guardan exclusivamente en tu dispositivo.",
    AppConstants.linksTitle: "Enlaces",
    AppConstants.sourceCodeOnGithub: "Código fuente en GitHub",
    AppConstants.sendFeedback: "Enviar comentarios",
    AppConstants.couldNotLaunchUrl: "No se pudo abrir la URL",
    AppConstants.termsIntro:
        "¡Bienvenido a OpenJot! Este documento describe los términos y condiciones de uso de nuestra aplicación. Al usar OpenJot, aceptas estos términos.",
    AppConstants.termsSectionDataPrivacy: "Almacenamiento de datos y privacidad",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot está diseñado como un espacio privado para tus pensamientos. Todas las entradas, incluidos textos, imágenes, audios y otros archivos multimedia, se almacenan exclusivamente en tu dispositivo local. La aplicación no recopila ni envía datos personales a servidores externos. No tenemos acceso a tu contenido.",
    AppConstants.termsSectionUserContent: "Contenido generado por el usuario",
    AppConstants.termsSectionUserContentBody:
        "Eres el único responsable del contenido que creas y almacenas en OpenJot, incluidos textos, imágenes, grabaciones de audio y otros archivos. Debes asegurarte de contar con los derechos necesarios para usar cualquier contenido que importes a la app.",
    AppConstants.termsSectionDisclaimer: "Exención de garantía",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot se proporciona \"tal cual\", sin garantías de ningún tipo, expresas o implícitas. No garantizamos que la app esté libre de errores o interrupciones. Usas la aplicación bajo tu propia responsabilidad.",
    AppConstants.termsSectionLiability: "Limitación de responsabilidad",
    AppConstants.termsSectionLiabilityBody:
        "En ningún caso los desarrolladores de OpenJot serán responsables de daños directos, indirectos, incidentales, especiales o consecuentes, incluida la pérdida de datos, derivados del uso o la imposibilidad de uso de esta aplicación.",
    AppConstants.termsSectionThirdParty: "Bibliotecas de terceros",
    AppConstants.termsSectionThirdPartyBody:
        "Esta aplicación utiliza las siguientes bibliotecas de terceros, cada una regida por su propia licencia:",

    // Months
    'January': 'Enero',
    'February': 'Febrero',
    'March': 'Marzo',
    'April': 'Abril',
    'May': 'Mayo',
    'June': 'Junio',
    'July': 'Julio',
    'August': 'Agosto',
    'September': 'Septiembre',
    'October': 'Octubre',
    'November': 'Noviembre',
    'December': 'Diciembre',

    // Reflection Prompts (61)
    "What made you smile today?": "¿Qué te hizo sonreír hoy?",
    "Who are you thankful for this week, and why?":
        "¿A quién agradeces esta semana y por qué?",
    "What is something small that brought you joy today?":
        "¿Qué pequeña cosa te trajo alegría hoy?",
    "Which part of your day felt most comforting?":
        "¿Qué parte de tu día te resultó más reconfortante?",
    "What’s something you often take for granted but appreciate now?":
        "¿Qué sueles dar por sentado pero ahora valoras?",
    "What’s the best thing that happened today?":
        "¿Qué es lo mejor que pasó hoy?",
    "Did someone make your day easier today?":
        "¿Alguien te hizo el día más fácil hoy?",
    "Who made a positive impact on you recently?":
        "¿Quién tuvo un impacto positivo en ti recientemente?",
    "What’s a quality you admire in someone close to you?":
        "¿Qué cualidad admiras en alguien cercano a ti?",
    "When did you last feel truly connected with someone?":
        "¿Cuándo fue la última vez que te sentiste realmente conectado con alguien?",
    "Who do you want to reach out to soon?":
        "¿Con quién quieres ponerte en contacto pronto?",
    "Did someone’s kindness stand out today?":
        "¿Destacó hoy la amabilidad de alguien?",
    "How did you support someone else recently?":
        "¿Cómo apoyaste a alguien recientemente?",
    "Who do you miss the most right now?":
        "¿A quién echas más de menos ahora mismo?",
    "What’s a moment from today you want to remember?":
        "¿Qué momento de hoy quieres recordar?",
    "What’s a detail about today you might forget if you don’t note it?":
        "¿Qué detalle de hoy podrías olvidar si no lo anotas?",
    "What’s the most peaceful moment you had today?":
        "¿Cuál fue el momento más tranquilo que tuviste hoy?",
    "Did you see something beautiful today?": "¿Viste algo hermoso hoy?",
    "Which memory from this week stands out?":
        "¿Qué recuerdo de esta semana destaca?",
    "What song, photo, or place will always remind you of today?":
        "¿Qué canción, foto o lugar te recordará siempre a hoy?",
    "What surprised you today?": "¿Qué te sorprendió hoy?",
    "What challenge did you overcome today?": "¿Qué reto superaste hoy?",
    "What’s a small win you had today?":
        "¿Qué pequeño logro tuviste hoy?",
    "What new thing did you learn about yourself recently?":
        "¿Qué cosa nueva aprendiste sobre ti recientemente?",
    "What are you proud of yourself for?":
        "¿De qué te sientes orgulloso de ti mismo?",
    "What habit do you feel good about keeping?":
        "¿Qué hábito te hace sentir bien mantener?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "¿Qué mejora has notado en ti este año?",
    "How did you push yourself out of your comfort zone?":
        "¿Cómo saliste de tu zona de confort?",
    "How are you truly feeling right now?":
        "¿Cómo te sientes realmente en este momento?",
    "Which emotion stood out the most today?":
        "¿Qué emoción destacó más hoy?",
    "Did you feel present in any moment today?":
        "¿Te sentiste presente en algún momento hoy?",
    "When did you feel the most at peace today?":
        "¿Cuándo te sentiste más en paz hoy?",
    "What gave you energy today?": "¿Qué te dio energía hoy?",
    "What drained your energy today?": "¿Qué agotó tu energía hoy?",
    "If your mood had a color today, what would it be?":
        "Si tu estado de ánimo tuviera un color hoy, ¿cuál sería?",
    "What’s something you’re excited about tomorrow?":
        "¿Qué es algo que te ilusiona de mañana?",
    "What’s one thing you want to improve tomorrow?":
        "¿Qué te gustaría mejorar mañana?",
    "What would make tomorrow feel successful?":
        "¿Qué haría que mañana se sintiera como un éxito?",
    "What do you hope to achieve this week?":
        "¿Qué esperas lograr esta semana?",
    "What’s a habit you’d like to start tomorrow?":
        "¿Qué hábito te gustaría empezar mañana?",
    "What’s something you want to look forward to in the next month?":
        "¿Qué te gustaría esperar con ilusión el próximo mes?",
    "What would your ideal tomorrow look like?":
        "¿Cómo sería tu día de mañana ideal?",
    "What’s one lesson you learned recently?":
        "¿Qué lección aprendiste recientemente?",
    "If you could freeze one moment today, which would it be?":
        "Si pudieras congelar un momento de hoy, ¿cuál sería?",
    "What makes your life feel meaningful right now?":
        "¿Qué hace que tu vida tenga sentido ahora mismo?",
    "If you described today in one word, what would it be?":
        "Si describieras hoy en una palabra, ¿cuál sería?",
    "What inspired you today?": "¿Qué te inspiró hoy?",
    "What did you notice today that you usually overlook?":
        "¿Qué notaste hoy que normalmente pasas por alto?",
    "How has today changed your perspective?":
        "¿Cómo ha cambiado hoy tu perspectiva?",
    "What’s something you’ve been overthinking?":
        "¿A qué le has estado dando demasiadas vueltas?",
    "What do you need to let go of?": "¿Qué necesitas dejar ir?",
    "What part of nature did you notice today?":
        "¿Qué parte de la naturaleza notaste hoy?",
    "Did the weather affect your mood today?":
        "¿El clima afectó tu estado de ánimo hoy?",
    "What place felt most comforting today?":
        "¿Qué lugar te resultó más reconfortante hoy?",
    "Where did you feel most at home today?":
        "¿Dónde te sentiste más como en casa hoy?",
    "What sound or smell reminded you of something important?":
        "¿Qué sonido u olor te recordó algo importante?",
    "How did you take care of yourself today?":
        "¿Cómo cuidaste de ti hoy?",
    "When did you feel most like yourself today?":
        "¿Cuándo te sentiste más tú mismo hoy?",
    "What’s something kind you can say to yourself right now?":
        "¿Qué algo amable puedes decirte ahora mismo?",
    "What do you want to forgive yourself for?":
        "¿Por qué te gustaría perdonarte?",
    "What do you deserve more of in your life?":
        "¿De qué mereces tener más en tu vida?",
  },
  'fr': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Mon journal",
    AppConstants.noEntriesMessage:
        "Aucune entrée pour le moment. Commencez à écrire !",
    AppConstants.noBookmarksYet: "Aucun favori pour le moment.",
    AppConstants.noDraftsYet: "Aucun brouillon pour le moment.",
    AppConstants.addEntryButton: "Ajouter une entrée",
    AppConstants.jotYourThoughts: "Notez vos pensées",
    AppConstants.tapToCreateJournal:
        "Appuyez sur + pour créer votre journal personnel.",
    AppConstants.entriesThisYear: "Entrées cette année",
    AppConstants.wordsWritten: "Mots écrits",
    AppConstants.daysJournaled: "Jours écrits",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nouvelle entrée",
    AppConstants.editEntryAppBarTitle: "Modifier l'entrée",
    AppConstants.titleHintText: "Titre (ex. : 'Ma journée', 'Réflexions...')",
    AppConstants.contentHintText: "Écrivez vos pensées ici...",
    AppConstants.saveButton: "Enregistrer",
    AppConstants.updateButton: "Mettre à jour",
    AppConstants.deleteButton: "Supprimer l'entrée",
    AppConstants.requiredFieldMessage: "Ce champ ne peut pas être vide.",
    AppConstants.newEntry: "Nouvelle entrée",
    AppConstants.todayDate: "Date du jour",
    AppConstants.customDate: "Date personnalisée",
    AppConstants.done: "Terminé",
    AppConstants.startWriting: " Commencez à écrire...",
    AppConstants.tags: "Étiquettes",
    AppConstants.addTags: "Ajouter des étiquettes",
    AppConstants.openInMaps: "Ouvrir dans Maps",
    AppConstants.changeLocation: "Changer le lieu",
    AppConstants.remove: "Retirer",
    AppConstants.discardSelectionsTitle: "Abandonner la sélection ?",
    AppConstants.discardSelectionsMessage:
        "Vous avez sélectionné des médias ou un enregistrement actif. Voulez-vous vraiment les abandonner ?",
    AppConstants.journalEntryEmpty: "L'entrée du journal ne peut pas être vide",
    AppConstants.discardDateConfirm:
        "Abandonner la date/l'heure sélectionnée pour cette entrée ?",
    AppConstants.addMediaLocationMoodFirst:
        "Ajoutez d'abord un média, un lieu ou une humeur",
    AppConstants.location: "Lieu",
    AppConstants.record: "Enregistrer",
    AppConstants.selectMomentsToJournal: "Choisissez des moments à noter",
    AppConstants.addMomentsFromMenu:
        "Ajoutez un média, un lieu, un audio ou une humeur depuis le menu",
    AppConstants.writeSomething: "Écrire quelque chose",
    AppConstants.saveWithoutWriting: "Enregistrer sans écrire",
    AppConstants.oneLocation: "1 lieu",
    AppConstants.mediaCount: "%d médias",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Confirmer la suppression",
    AppConstants.confirmDeleteMessage:
        "Voulez-vous vraiment supprimer cette entrée ?",
    AppConstants.pleaseConfirm: "Veuillez confirmer",
    AppConstants.confirmDeleteJournalEntry:
        "Voulez-vous vraiment supprimer cette entrée du journal ? Cette action est irréversible.",
    AppConstants.yes: "Oui",
    AppConstants.no: "Non",
    AppConstants.cancel: "Annuler",
    AppConstants.delete: "Supprimer",
    AppConstants.save: "Enregistrer",
    AppConstants.entrySavedSuccess: "Entrée enregistrée avec succès !",
    AppConstants.entryUpdatedSuccess: "Entrée mise à jour avec succès !",
    AppConstants.entryDeletedSuccess: "Entrée supprimée.",
    AppConstants.errorSavingEntry: "Erreur lors de l'enregistrement.",
    AppConstants.errorDeletingEntry: "Erreur lors de la suppression.",
    AppConstants.errorLoadingEntries:
        "Erreur lors du chargement des entrées.",
    AppConstants.noEntriesForDate: "Aucune entrée pour cette date.",
    AppConstants.noEntriesForMonth: "Aucune entrée trouvée pour ce mois.",
    AppConstants.selectMonthAndYear: "Choisir le mois et l'année",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Très désagréable",
    AppConstants.unpleasant: "Désagréable",
    AppConstants.slightlyUnpleasant: "Un peu désagréable",
    AppConstants.neutral: "Neutre",
    AppConstants.slightlyPleasant: "Un peu agréable",
    AppConstants.pleasant: "Agréable",
    AppConstants.veryPleasant: "Très agréable",
    AppConstants.reflection: "Réflexion",
    AppConstants.edit: "Modifier",
    AppConstants.removeBookmark: "Retirer des favoris",
    AppConstants.bookmark: "Favori",
    AppConstants.share: "Partager",
    AppConstants.saveAsPdf: "Enregistrer en PDF",
    AppConstants.audioTrack: "Piste audio",
    AppConstants.generatingPdf: "Génération du PDF...",
    AppConstants.voiceRecording: "Enregistrement vocal",
    AppConstants.audioRecording: "Enregistrement audio",
    AppConstants.couldNotLoadAudio: "Impossible de charger le fichier audio.",
    AppConstants.stateOfMind: "État d'esprit",

    // Mood Colors
    AppConstants.moodColors: "Couleurs d'humeur",
    AppConstants.customizeMoodColors: "Personnaliser les couleurs d'humeur",
    AppConstants.reset: "Réinitialiser",
    AppConstants.resetMoodColors: "Rétablir par défaut",
    AppConstants.resetMoodColorsConfirm:
        "Rétablir toutes les couleurs d'humeur par défaut ?",
    AppConstants.paletteThemes: "Thèmes de palette",
    AppConstants.customColor: "Couleur personnalisée",
    AppConstants.moodUnsavedChangesMessage:
        "Vous avez des modifications non enregistrées des couleurs d'humeur. Voulez-vous les enregistrer avant de fermer ?",

    // Drafts & Auto-save
    AppConstants.drafts: "Brouillons",
    AppConstants.draft: "Brouillon",
    AppConstants.draftSaved: "Enregistré dans les brouillons",
    AppConstants.unsavedChanges: "Modifications non enregistrées",
    AppConstants.unsavedChangesMessage:
        "Vous avez des modifications non enregistrées. Voulez-vous les enregistrer comme brouillon ou les abandonner ?",
    AppConstants.saveAsDraft: "Enregistrer en brouillon",
    AppConstants.discardChanges: "Abandonner",
    AppConstants.autoDeleteDrafts: "Suppression auto des brouillons",
    AppConstants.days7: "7 jours",
    AppConstants.never: "Jamais",
    AppConstants.custom: "Personnalisé...",
    AppConstants.enterCustomDays: "Entrer le nombre de jours",
    AppConstants.customDaysExample: "Ex. : 14",
    AppConstants.days: "Jours",
    AppConstants.draftsNeverDeleted:
        "Les brouillons ne seront jamais supprimés",
    AppConstants.draftsDeletedAfterDays:
        "Les brouillons seront supprimés après %d jours",

    // Home Menu & Sorting
    AppConstants.sortBy: "Trier par",
    AppConstants.insights: "Statistiques",
    AppConstants.reflections: "Réflexions",
    AppConstants.settings: "Paramètres",
    AppConstants.entryTime: "Heure de l'entrée",
    AppConstants.bookmarkFirst: "Favoris d'abord",
    AppConstants.reflectionFirst: "Réflexions d'abord",
    AppConstants.withMediaFirst: "Avec médias d'abord",
    AppConstants.textOnlyFirst: "Texte seul d'abord",
    AppConstants.withLocationFirst: "Avec lieu d'abord",
    AppConstants.withMoodFirst: "Avec humeur d'abord",
    AppConstants.withTagsFirst: "Avec étiquettes d'abord",

    // Insights
    AppConstants.stats: "Statistiques",
    AppConstants.calendar: "Calendrier",
    AppConstants.entriesSuffix: " entrées",
    AppConstants.memoriesFromThisDay: "Souvenirs de ce jour",
    AppConstants.standard: "Standard",
    AppConstants.media: "Médias",
    AppConstants.mood: "Humeur",
    AppConstants.mostly: "Surtout",
    AppConstants.averageForThisDay: "Moyenne pour ce jour",
    AppConstants.averageForThisYear: "Moyenne pour cette année",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Bienvenue sur OpenJot",
    AppConstants.feature1:
        "Écrivez librement, ajoutez des photos et des lieux, et gardez tout en sécurité sur votre appareil.",
    AppConstants.feature2:
        "Comprenez vos émotions au fil du temps grâce au suivi d'humeur intégré.",
    AppConstants.feature3:
        "Vos données restent sur votre téléphone : aucun cloud, uniquement un stockage local et une confidentialité totale.",
    AppConstants.continueButton: "Continuer",

    // Notifications
    AppConstants.notificationTitle: "L'heure d'écrire !",
    AppConstants.notificationBody:
        "N'oubliez pas de noter vos pensées du jour.",
    AppConstants.notificationChannelName: "Rappels quotidiens du journal",
    AppConstants.notificationChannelDescription:
        "Canal pour les rappels quotidiens du journal",
    AppConstants.onThisDayChannelName: "Souvenirs de ce jour",
    AppConstants.onThisDayChannelDescription:
        "Notifications pour les souvenirs des années passées.",
    AppConstants.onThisDayNotificationTitle: "Un souvenir de votre journal",
    AppConstants.onThisDaySingleEntry:
        "Il y a un an aujourd'hui, vous avez écrit quelque chose de spécial. Appuyez pour relire vos pensées.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "À cette date l'an dernier, vous avez partagé ce souvenir. Appuyez pour le revivre.",
    AppConstants.onThisDayMultipleEntries:
        "Vous avez des souvenirs de ce jour des années précédentes. Appuyez pour les revoir.",
    AppConstants.onThisDayGroupedNotification:
        "Vous avez %d souvenirs de ce jour",

    // Exclude Entries
    AppConstants.excludeEntries: "Exclure des entrées",
    AppConstants.saveExclusions: "Enregistrer les exclusions",
    AppConstants.excludeUnsavedChangesMessage:
        "Vous avez des modifications non enregistrées. Voulez-vous vraiment les abandonner et quitter ?",
    AppConstants.sortDefault: "Par défaut",
    AppConstants.sortMutedFirst: "Masquées d'abord",
    AppConstants.sortUnmutedFirst: "Visibles d'abord",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Aujourd'hui",
    AppConstants.yesterday: "Hier",
    AppConstants.contentForQuote: "Contenu pour la citation",
    AppConstants.noContentSelected: "Aucun contenu sélectionné.",
    AppConstants.photos: "Photos",
    AppConstants.video: "Vidéo",
    AppConstants.audio: "Audio",
    AppConstants.add: "Ajouter",
    AppConstants.noMediaFound: "Aucun %s trouvé.",
    AppConstants.permissionRequired:
        "L'autorisation d'accéder à %s est requise pour les afficher.",
    AppConstants.openSettings: "Ouvrir les paramètres",
    AppConstants.videos: "Vidéos",
    AppConstants.audios: "Audios",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Supprimer l'enregistrement ?",
    AppConstants.deleteRecordingMessage:
        "Voulez-vous vraiment supprimer cet enregistrement ?",
    AppConstants.listen: "Écouter",
    AppConstants.tapAndHold: "appuyer et maintenir",
    AppConstants.clear: "Effacer",
    AppConstants.all: "Tout",
    AppConstants.folder: "Dossier",
    AppConstants.browse: "Parcourir",
    AppConstants.tiles: "Tuiles",
    AppConstants.graph: "Graphique",
    AppConstants.recording: "Enregistrement...",
    AppConstants.recordingLabel: "Enregistrement",
    AppConstants.startAudioRecording: "Démarrer l'enregistrement audio",
    AppConstants.howAreYouFeeling: "Comment vous sentez-vous ?",
    AppConstants.paused: "En pause",
    AppConstants.stop: "Arrêter",
    AppConstants.tapOrHoldToResume:
        "Appuyez ou maintenez pour reprendre",
    AppConstants.tapOrReleaseToPause:
        "Appuyez ou relâchez pour mettre en pause",
    AppConstants.unsupportedImageType: "Format d'image non pris en charge",
    AppConstants.couldNotLoadVideo: "Impossible de charger la vidéo",
    AppConstants.couldNotOpenMap: "Impossible d'ouvrir le lien de la carte.",
    AppConstants.dismiss: "Fermer",
    AppConstants.selectTime: "Choisir l'heure",
    AppConstants.now: "Maintenant",
    AppConstants.searchPlacesHint: "Rechercher des lieux, commerces...",
    AppConstants.locationPermissionDenied: "Autorisation de localisation refusée.",
    AppConstants.failedGetCurrentLocation:
        "Impossible d'obtenir la position actuelle.",

    // Search
    AppConstants.searchJournalsHint: "Rechercher dans le journal...",
    AppConstants.textOnly: "Texte seul",
    AppConstants.withMedia: "Avec médias",
    AppConstants.withMood: "Avec humeur",
    AppConstants.withLocation: "Avec lieu",
    AppConstants.withTags: "Avec étiquettes",
    AppConstants.noResultsFound: "Aucun résultat trouvé",
    AppConstants.searchHintText: "Rechercher des entrées...",

    // Settings
    AppConstants.language: "Langue",
    AppConstants.selectLanguage: "Choisir la langue",
    AppConstants.systemDefault: "Par défaut du système",
    AppConstants.searchLanguagesHint: "Rechercher une langue...",
    AppConstants.languageChanged: "Langue changée en %s.",
    AppConstants.dailyReminder: "Rappels",
    AppConstants.addReminder: "Ajouter un rappel",
    AppConstants.deleteReminder: "Supprimer le rappel",
    AppConstants.noRemindersSet: "Aucun rappel configuré.",
    AppConstants.onThisDay: "Ce jour-là",
    AppConstants.appLock: "Verrouillage de l'app",
    AppConstants.backup: "Sauvegarde",
    AppConstants.restore: "Restaurer",
    AppConstants.importFromAnotherApp: "Importer d'une autre app",
    AppConstants.importFromDailyYou: "Importer depuis Daily You",
    AppConstants.selectDailyYouBackup:
        "Sélectionner le fichier zip de sauvegarde Daily You",
    AppConstants.importingEntries: "Importation des entrées...",
    AppConstants.importSuccess:
        "%d entrées importées depuis Daily You avec succès !",
    AppConstants.importFailed: "Échec de l'importation : %s",
    AppConstants.noEntriesToImport: "Aucune nouvelle entrée à importer.",
    AppConstants.askSupport: "Demander de l'aide",
    AppConstants.importSupportNote:
        "Les formats d'autres applications peuvent ne pas prendre en charge toutes les fonctionnalités. En cas de problème ou de changement de format, veuillez signaler un bug.",
    AppConstants.extractingBackup: "Extraction de la sauvegarde...",
    AppConstants.parsingDatabase: "Analyse de la base de données...",
    AppConstants.dailyYouDbNotFound:
        "Base de données Daily You introuvable dans la sauvegarde.",
    AppConstants.privacyPolicy: "Politique de confidentialité",
    AppConstants.termsNConditions: "Conditions d'utilisation",
    AppConstants.about: "À propos",
    AppConstants.changeTheme: "Changer de thème",
    AppConstants.theme: "Thème",
    AppConstants.pitchBlack: "Noir absolu",
    AppConstants.themeLight: "Clair",
    AppConstants.themeDark: "Sombre",
    AppConstants.themeSystem: "Système",
    AppConstants.changePin: "Changer le PIN",
    AppConstants.loading: "Chargement...",
    AppConstants.confirmRestoreTitle: "Confirmer la restauration",
    AppConstants.confirmRestoreMessage:
        "La restauration depuis une sauvegarde écrasera toutes les données actuelles. Cette action est irréversible. Voulez-vous continuer ?",
    AppConstants.notificationScheduled: "Notification programmée pour %s",
    AppConstants.notificationCanceled: "Notification annulée",
    AppConstants.notificationRescheduled: "Notification reprogrammée pour %s",
    AppConstants.notificationPermissionRequired:
        "L'autorisation de notification est requise pour définir des rappels.",
    AppConstants.pinChangedSuccess: "PIN modifié avec succès",
    AppConstants.onThisDayOn:
        "Vous recevrez désormais des souvenirs de ce jour.",
    AppConstants.onThisDayOff:
        "Les rappels « Ce jour-là » sont désactivés.",
    AppConstants.themeChanged: "Thème %s sélectionné.",
    AppConstants.hideStats: "Masquer les statistiques",
    AppConstants.hideHomeStats: "Masquer les stats de l'accueil",
    AppConstants.hideInsightsStats: "Masquer les stats des analyses",

    // Reflection Sheet
    AppConstants.reflectionTitle: "RÉFLEXION",
    AppConstants.reflectButton: "Réfléchir",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "PIN incorrect",
    AppConstants.verifyYourPin: "Vérifiez votre PIN",
    AppConstants.setAPin: "Définir un PIN",
    AppConstants.confirmPin: "Confirmer le PIN",
    AppConstants.pinsDoNotMatch: "Les PIN ne correspondent pas",
    AppConstants.setPin: "Définir le PIN",
    AppConstants.hello: "Bonjour !",
    AppConstants.enterYourPin: "Saisissez votre PIN",
    AppConstants.useBiometrics: "Utiliser la biométrie",
    AppConstants.authenticateToUnlock:
        "Veuillez vous authentifier pour déverrouiller l'application",
    AppConstants.databaseEncryption: "Chiffrement de la base de données",
    AppConstants.databaseEncryptionDesc: "Chiffrement local AES-256-GCM",
    AppConstants.changeMasterPassword: "Changer le mot de passe principal",
    AppConstants.biometricUnlock: "Déverrouillage biométrique",
    AppConstants.enterMasterPassword: "Saisir le mot de passe principal",
    AppConstants.enterMasterPasswordHint:
        "Saisissez votre mot de passe principal pour déchiffrer votre journal.",
    AppConstants.unlockButton: "Déverrouiller",
    AppConstants.unlockWithBiometrics: "Déverrouiller par biométrie",
    AppConstants.incorrectMasterPassword:
        "Mot de passe principal incorrect. Veuillez réessayer.",
    AppConstants.databaseEncryptedSuccess:
        "Base de données du journal chiffrée avec AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Base de données déchiffrée et verrouillage désactivé.",
    AppConstants.masterPasswordChangedSuccess:
        "Mot de passe principal mis à jour avec succès.",
    AppConstants.encryptedBackupPasswordRequired:
        "Un mot de passe est requis pour ouvrir une sauvegarde chiffrée.",
    AppConstants.incorrectBackupPassword:
        "Mot de passe de sauvegarde incorrect.",
    AppConstants.invalidBackupFile:
        "Le fichier sélectionné n'est pas une sauvegarde OpenJot valide.",
    AppConstants.encryptedBackup: "Sauvegarde chiffrée (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Protégée par AES-256-GCM et un mot de passe de sauvegarde",
    AppConstants.standardBackup: "Sauvegarde standard (.zip)",
    AppConstants.standardBackupDesc:
        "Archive non chiffrée compatible avec toutes les versions",
    AppConstants.takingBackup: "Sauvegarde en cours...",
    AppConstants.encryptingBackup: "Chiffrement de la sauvegarde...",
    AppConstants.savingBackup: "Enregistrement de la sauvegarde...",
    AppConstants.preparingBackup: "Préparation de la sauvegarde...",
    AppConstants.decryptingBackup: "Déchiffrement de la sauvegarde...",
    AppConstants.restoringBackup: "Restauration de la sauvegarde...",
    AppConstants.backupEncodingFailed:
        "Échec de l'encodage du fichier de sauvegarde.",
    AppConstants.backupCreatedSuccess: "Sauvegarde créée avec succès !",
    AppConstants.backupFailed: "Échec de la création de la sauvegarde : %s",
    AppConstants.restorePermissionsRequired:
        "Les autorisations de stockage et de médias sont requises pour restaurer les données.",
    AppConstants.databaseRestoredNoMedia:
        "Base de données restaurée. Aucun média trouvé dans la sauvegarde.",
    AppConstants.restoreSuccess: "Restauration réussie !",
    AppConstants.restoreSuccessRestartRecommended:
        "Restauration réussie. Un redémarrage est recommandé pour appliquer tous les changements.",
    AppConstants.restoreFailed: "Échec de la restauration des données : %s",
    AppConstants.storagePermissionsRequired:
        "Les autorisations de stockage et de médias sont requises pour créer une sauvegarde.",
    AppConstants.selectBackupFolder:
        "Sélectionnez un dossier pour enregistrer la sauvegarde",
    AppConstants.encryptDatabase: "Chiffrer la base de données",
    AppConstants.disableEncryption: "Désactiver le chiffrement",
    AppConstants.backupPasswordTitle: "Mot de passe de sauvegarde",
    AppConstants.changeMasterPasswordDesc:
        "Saisissez votre mot de passe principal actuel et choisissez-en un nouveau (6 caractères minimum).",
    AppConstants.disableEncryptionDesc:
        "Saisissez votre mot de passe principal pour déchiffrer votre base de données sur le disque et désactiver le chiffrement.",
    AppConstants.enableEncryptionDesc:
        "Protégez toutes vos notes localement avec le chiffrement AES-256-GCM. Si vous oubliez votre mot de passe principal, vos données chiffrées seront irrécupérables.",
    AppConstants.verifyForBiometricsDesc:
        "Saisissez votre mot de passe principal une fois pour stocker une clé de déverrouillage dans le matériel sécurisé pour la biométrie.",
    AppConstants.createBackupPasswordDesc:
        "Définissez un mot de passe fort pour chiffrer cette sauvegarde .openjot. Il sera requis pour la restaurer sur tout appareil.",
    AppConstants.enterBackupPasswordDesc:
        "Saisissez le mot de passe utilisé lors de la création de cette sauvegarde .openjot.",
    AppConstants.updatePasswordAction: "Mettre à jour",
    AppConstants.decryptAndDisable: "Déchiffrer et désactiver",
    AppConstants.enableBiometricsAction: "Activer la biométrie",
    AppConstants.createBackupAction: "Créer la sauvegarde",
    AppConstants.decryptBackupAction: "Déchiffrer la sauvegarde",
    AppConstants.newMasterPasswordHint: "Nouveau mot de passe principal",
    AppConstants.backupPasswordHint: "Mot de passe de sauvegarde",
    AppConstants.masterPasswordHint: "Mot de passe principal",
    AppConstants.enterCurrentMasterPasswordError:
        "Veuillez saisir votre mot de passe principal actuel.",
    AppConstants.passwordEmptyError:
        "Le mot de passe ne peut pas être vide.",
    AppConstants.passwordMinLengthError:
        "Le mot de passe doit contenir au moins 6 caractères.",
    AppConstants.passwordsDoNotMatchError:
        "Les mots de passe ne correspondent pas.",
    AppConstants.currentMasterPasswordHint: "Mot de passe principal actuel",
    AppConstants.confirmPasswordHint: "Confirmer le mot de passe",

    // About & Terms
    AppConstants.aboutApp: "À propos d'OpenJot",
    AppConstants.versionPrefix: "Version : %s",
    AppConstants.aboutSubtitle:
        "Un journal minimaliste et open source pour noter vos pensées, humeurs et souvenirs. Toutes vos données restent sur votre appareil.",
    AppConstants.keyFeatures: "Fonctionnalités clés",
    AppConstants.aboutFeature1:
        "• Une écriture épurée, sans distraction.",
    AppConstants.aboutFeature2:
        "• Ajoutez photos, mémos vocaux et musique à vos entrées.",
    AppConstants.aboutFeature3:
        "• Suivez votre humeur en parallèle de vos notes.",
    AppConstants.aboutFeature4:
        "• Personnalisez avec différents styles de texte.",
    AppConstants.aboutFeature5:
        "• Fonctionne entièrement hors ligne, vos données restent sur votre appareil.",
    AppConstants.openSource: "Open Source",
    AppConstants.openSourceDesc:
        "OpenJot est une application open source. Le code source est accessible publiquement pour être consulté, modifié et amélioré. Nous croyons en la transparence et la collaboration.",
    AppConstants.dataPrivacy: "Confidentialité des données",
    AppConstants.dataPrivacyDesc:
        "Nous respectons votre vie privée. OpenJot ne collecte, ne stocke ni ne transmet aucune donnée personnelle. Toutes vos entrées, images et fichiers audio restent exclusivement sur votre appareil.",
    AppConstants.linksTitle: "Liens",
    AppConstants.sourceCodeOnGithub: "Code source sur GitHub",
    AppConstants.sendFeedback: "Envoyer des commentaires",
    AppConstants.couldNotLaunchUrl: "Impossible d'ouvrir l'URL",
    AppConstants.termsIntro:
        "Bienvenue sur OpenJot ! Ce document présente les conditions d'utilisation de notre application. En utilisant OpenJot, vous acceptez ces conditions.",
    AppConstants.termsSectionDataPrivacy:
        "Stockage des données et confidentialité",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot est conçu comme un espace privé pour vos pensées. Toutes les entrées, y compris textes, images, fichiers audio et autres médias, sont stockées exclusivement en local sur votre appareil. L'application ne collecte ni ne transmet aucune donnée personnelle à des serveurs externes.",
    AppConstants.termsSectionUserContent: "Contenu généré par l'utilisateur",
    AppConstants.termsSectionUserContentBody:
        "Vous êtes seul responsable du contenu que vous créez et stockez dans OpenJot, y compris textes, images et enregistrements audio. Il vous appartient de vous assurer que vous disposez des droits nécessaires pour tout contenu importé.",
    AppConstants.termsSectionDisclaimer: "Exclusion de garantie",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot est fourni « en l'état », sans aucune garantie expresse ou implicite. Nous ne garantissons pas que l'application soit exempte d'erreurs ou d'interruptions. Vous l'utilisez à vos propres risques.",
    AppConstants.termsSectionLiability: "Limitation de responsabilité",
    AppConstants.termsSectionLiabilityBody:
        "Les développeurs d'OpenJot ne pourront en aucun cas être tenus responsables de dommages directs, indirects, accessoires ou consécutifs, y compris la perte de données, liés à l'utilisation ou à l'impossibilité d'utiliser cette application.",
    AppConstants.termsSectionThirdParty: "Bibliothèques tierces",
    AppConstants.termsSectionThirdPartyBody:
        "Cette application utilise les bibliothèques tierces suivantes, chacune régie par sa propre licence :",

    // Months
    'January': 'Janvier',
    'February': 'Février',
    'March': 'Mars',
    'April': 'Avril',
    'May': 'Mai',
    'June': 'Juin',
    'July': 'Juillet',
    'August': 'Août',
    'September': 'Septembre',
    'October': 'Octobre',
    'November': 'Novembre',
    'December': 'Décembre',

    // Reflection Prompts (61)
    "What made you smile today?": "Qu'est-ce qui vous a fait sourire aujourd'hui ?",
    "Who are you thankful for this week, and why?":
        "Envers qui êtes-vous reconnaissant cette semaine, et pourquoi ?",
    "What is something small that brought you joy today?":
        "Quelle petite chose vous a apporté de la joie aujourd'hui ?",
    "Which part of your day felt most comforting?":
        "Quel moment de votre journée a été le plus réconfortant ?",
    "What’s something you often take for granted but appreciate now?":
        "Qu'est-ce que vous considérez souvent comme acquis mais que vous appréciez aujourd'hui ?",
    "What’s the best thing that happened today?":
        "Quelle est la meilleure chose qui soit arrivée aujourd'hui ?",
    "Did someone make your day easier today?":
        "Quelqu'un vous a-t-il facilité la journée aujourd'hui ?",
    "Who made a positive impact on you recently?":
        "Qui a eu un impact positif sur vous récemment ?",
    "What’s a quality you admire in someone close to you?":
        "Quelle qualité admirez-vous chez un proche ?",
    "When did you last feel truly connected with someone?":
        "Quand vous êtes-vous senti pour la dernière fois vraiment connecté à quelqu'un ?",
    "Who do you want to reach out to soon?":
        "À qui souhaitez-vous donner des nouvelles prochainement ?",
    "Did someone’s kindness stand out today?":
        "La gentillesse de quelqu'un vous a-t-elle marqué aujourd'hui ?",
    "How did you support someone else recently?":
        "Comment avez-vous soutenu quelqu'un récemment ?",
    "Who do you miss the most right now?":
        "Qui vous manque le plus en ce moment ?",
    "What’s a moment from today you want to remember?":
        "Quel moment d'aujourd'hui souhaitez-vous retenir ?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Quel détail d'aujourd'hui risquez-vous d'oublier si vous ne le notez pas ?",
    "What’s the most peaceful moment you had today?":
        "Quel a été votre moment le plus paisible aujourd'hui ?",
    "Did you see something beautiful today?":
        "Avez-vous vu quelque chose de beau aujourd'hui ?",
    "Which memory from this week stands out?":
        "Quel souvenir de cette semaine ressort le plus ?",
    "What song, photo, or place will always remind you of today?":
        "Quelle chanson, photo ou lieu vous rappellera toujours cette journée ?",
    "What surprised you today?": "Qu'est-ce qui vous a surpris aujourd'hui ?",
    "What challenge did you overcome today?":
        "Quel défi avez-vous surmonté aujourd'hui ?",
    "What’s a small win you had today?":
        "Quelle petite victoire avez-vous remportée aujourd'hui ?",
    "What new thing did you learn about yourself recently?":
        "Qu'avez-vous appris de nouveau sur vous-même récemment ?",
    "What are you proud of yourself for?": "De quoi êtes-vous fier de vous ?",
    "What habit do you feel good about keeping?":
        "Quelle habitude vous fait-il du bien de conserver ?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Quelle amélioration avez-vous remarquée chez vous cette année ?",
    "How did you push yourself out of your comfort zone?":
        "Comment êtes-vous sorti de votre zone de confort ?",
    "How are you truly feeling right now?":
        "Comment vous sentez-vous vraiment en ce moment ?",
    "Which emotion stood out the most today?":
        "Quelle émotion a dominé aujourd'hui ?",
    "Did you feel present in any moment today?":
        "Vous êtes-vous senti pleinement présent à un moment aujourd'hui ?",
    "When did you feel the most at peace today?":
        "À quel moment vous êtes-vous senti le plus en paix aujourd'hui ?",
    "What gave you energy today?":
        "Qu'est-ce qui vous a donné de l'énergie aujourd'hui ?",
    "What drained your energy today?":
        "Qu'est-ce qui a puisé votre énergie aujourd'hui ?",
    "If your mood had a color today, what would it be?":
        "Si votre humeur du jour avait une couleur, laquelle serait-ce ?",
    "What’s something you’re excited about tomorrow?":
        "Qu'est-ce qui vous enthousiasme pour demain ?",
    "What’s one thing you want to improve tomorrow?":
        "Quelle chose aimeriez-vous améliorer demain ?",
    "What would make tomorrow feel successful?":
        "Qu'est-ce qui ferait de demain une journée réussie ?",
    "What do you hope to achieve this week?":
        "Qu'espérez-vous accomplir cette semaine ?",
    "What’s a habit you’d like to start tomorrow?":
        "Quelle habitude aimeriez-vous commencer demain ?",
    "What’s something you want to look forward to in the next month?":
        "Qu'attendez-vous avec impatience au cours du mois prochain ?",
    "What would your ideal tomorrow look like?":
        "À quoi ressemblerait votre journée de demain idéale ?",
    "What’s one lesson you learned recently?":
        "Quelle leçon avez-vous apprise récemment ?",
    "If you could freeze one moment today, which would it be?":
        "Si vous pouviez figer un instant d'aujourd'hui, lequel choisiriez-vous ?",
    "What makes your life feel meaningful right now?":
        "Qu'est-ce qui donne du sens à votre vie en ce moment ?",
    "If you described today in one word, what would it be?":
        "Si vous deviez décrire cette journée en un mot, quel serait-il ?",
    "What inspired you today?": "Qu'est-ce qui vous a inspiré aujourd'hui ?",
    "What did you notice today that you usually overlook?":
        "Qu'avez-vous remarqué aujourd'hui que vous ignorez d'habitude ?",
    "How has today changed your perspective?":
        "Comment cette journée a-t-elle changé votre perspective ?",
    "What’s something you’ve been overthinking?":
        "À quoi avez-vous trop réfléchi dernièrement ?",
    "What do you need to let go of?": "De quoi avez-vous besoin de lâcher prise ?",
    "What part of nature did you notice today?":
        "Quel aspect de la nature avez-vous remarqué aujourd'hui ?",
    "Did the weather affect your mood today?":
        "La météo a-t-elle influencé votre humeur aujourd'hui ?",
    "What place felt most comforting today?":
        "Quel endroit vous a semblé le plus apaisant aujourd'hui ?",
    "Where did you feel most at home today?":
        "Où vous êtes-vous senti le plus chez vous aujourd'hui ?",
    "What sound or smell reminded you of something important?":
        "Quel son ou quelle odeur vous a rappelé quelque chose d'important ?",
    "How did you take care of yourself today?":
        "Comment avez-vous pris soin de vous aujourd'hui ?",
    "When did you feel most like yourself today?":
        "Quand vous êtes-vous senti le plus vous-même aujourd'hui ?",
    "What’s something kind you can say to yourself right now?":
        "Quelle parole bienveillante pouvez-vous vous dire maintenant ?",
    "What do you want to forgive yourself for?":
        "Que souhaitez-vous vous pardonner ?",
    "What do you deserve more of in your life?":
        "De quoi méritez-vous davantage dans votre vie ?",
  },
  'de': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Mein Tagebuch",
    AppConstants.noEntriesMessage:
        "Noch keine Tagebucheinträge. Fang an zu schreiben!",
    AppConstants.noBookmarksYet: "Noch keine Lesezeichen.",
    AppConstants.noDraftsYet: "Noch keine Entwürfe.",
    AppConstants.addEntryButton: "Neuen Eintrag hinzufügen",
    AppConstants.jotYourThoughts: "Halte deine Gedanken fest",
    AppConstants.tapToCreateJournal:
        "Tippe auf +, um dein persönliches Tagebuch zu erstellen.",
    AppConstants.entriesThisYear: "Einträge dieses Jahr",
    AppConstants.wordsWritten: "Geschriebene Wörter",
    AppConstants.daysJournaled: "Tage mit Eintrag",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Neuer Tagebucheintrag",
    AppConstants.editEntryAppBarTitle: "Tagebucheintrag bearbeiten",
    AppConstants.titleHintText: "Titel (z. B. 'Mein Tag', 'Gedanken zu...')",
    AppConstants.contentHintText: "Schreibe deine Gedanken hier...",
    AppConstants.saveButton: "Eintrag speichern",
    AppConstants.updateButton: "Aktualisieren",
    AppConstants.deleteButton: "Eintrag löschen",
    AppConstants.requiredFieldMessage: "Dieses Feld darf nicht leer sein.",
    AppConstants.newEntry: "Neuer Eintrag",
    AppConstants.todayDate: "Heutiges Datum",
    AppConstants.customDate: "Benutzerdefiniertes Datum",
    AppConstants.done: "Fertig",
    AppConstants.startWriting: " Schreib los...",
    AppConstants.tags: "Schlagwörter",
    AppConstants.addTags: "Schlagwörter hinzufügen",
    AppConstants.openInMaps: "In Karten öffnen",
    AppConstants.changeLocation: "Ort ändern",
    AppConstants.remove: "Entfernen",
    AppConstants.discardSelectionsTitle: "Auswahl verwerfen?",
    AppConstants.discardSelectionsMessage:
        "Du hast Medien oder eine aktive Aufnahme ausgewählt. Möchtest du sie wirklich verwerfen?",
    AppConstants.journalEntryEmpty: "Der Tagebucheintrag darf nicht leer sein",
    AppConstants.discardDateConfirm:
        "Ausgewähltes Datum/Uhrzeit für diesen Eintrag verwerfen?",
    AppConstants.addMediaLocationMoodFirst:
        "Füge zuerst Medien, einen Ort oder eine Stimmung hinzu",
    AppConstants.location: "Ort",
    AppConstants.record: "Aufnehmen",
    AppConstants.selectMomentsToJournal: "Momente zum Festhalten wählen",
    AppConstants.addMomentsFromMenu:
        "Medien, Ort, Aufnahme oder Stimmung über das Menü hinzufügen",
    AppConstants.writeSomething: "Etwas schreiben",
    AppConstants.saveWithoutWriting: "Ohne Text speichern",
    AppConstants.oneLocation: "1 Ort",
    AppConstants.mediaCount: "%d Medien",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Löschen bestätigen",
    AppConstants.confirmDeleteMessage:
        "Möchtest du diesen Eintrag wirklich löschen?",
    AppConstants.pleaseConfirm: "Bitte bestätigen",
    AppConstants.confirmDeleteJournalEntry:
        "Möchtest du diesen Tagebucheintrag wirklich löschen? Dies kann nicht rückgängig gemacht werden.",
    AppConstants.yes: "Ja",
    AppConstants.no: "Nein",
    AppConstants.cancel: "Abbrechen",
    AppConstants.delete: "Löschen",
    AppConstants.save: "Speichern",
    AppConstants.entrySavedSuccess: "Tagebucheintrag erfolgreich gespeichert!",
    AppConstants.entryUpdatedSuccess:
        "Tagebucheintrag erfolgreich aktualisiert!",
    AppConstants.entryDeletedSuccess: "Tagebucheintrag gelöscht.",
    AppConstants.errorSavingEntry: "Fehler beim Speichern des Eintrags.",
    AppConstants.errorDeletingEntry: "Fehler beim Löschen des Eintrags.",
    AppConstants.errorLoadingEntries:
        "Fehler beim Laden der Tagebucheinträge.",
    AppConstants.noEntriesForDate: "Keine Einträge für dieses Datum.",
    AppConstants.noEntriesForMonth: "Keine Einträge für diesen Monat gefunden.",
    AppConstants.selectMonthAndYear: "Monat & Jahr wählen",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Sehr unangenehm",
    AppConstants.unpleasant: "Unangenehm",
    AppConstants.slightlyUnpleasant: "Etwas unangenehm",
    AppConstants.neutral: "Neutral",
    AppConstants.slightlyPleasant: "Etwas angenehm",
    AppConstants.pleasant: "Angenehm",
    AppConstants.veryPleasant: "Sehr angenehm",
    AppConstants.reflection: "Reflexion",
    AppConstants.edit: "Bearbeiten",
    AppConstants.removeBookmark: "Lesezeichen entfernen",
    AppConstants.bookmark: "Lesezeichen",
    AppConstants.share: "Teilen",
    AppConstants.saveAsPdf: "Als PDF speichern",
    AppConstants.audioTrack: "Audiospur",
    AppConstants.generatingPdf: "PDF wird erstellt...",
    AppConstants.voiceRecording: "Sprachaufnahme",
    AppConstants.audioRecording: "Audioaufnahme",
    AppConstants.couldNotLoadAudio:
        "Audiodatei konnte nicht geladen werden.",
    AppConstants.stateOfMind: "Gemütszustand",

    // Mood Colors
    AppConstants.moodColors: "Stimmungsfarben",
    AppConstants.customizeMoodColors: "Stimmungsfarben anpassen",
    AppConstants.reset: "Zurücksetzen",
    AppConstants.resetMoodColors: "Auf Standard zurücksetzen",
    AppConstants.resetMoodColorsConfirm:
        "Alle Stimmungsfarben auf Standard zurücksetzen?",
    AppConstants.paletteThemes: "Palettendesigns",
    AppConstants.customColor: "Benutzerdefinierte Farbe",
    AppConstants.moodUnsavedChangesMessage:
        "Du hast ungespeicherte Änderungen an den Stimmungsfarben. Vor dem Schließen speichern?",

    // Drafts & Auto-save
    AppConstants.drafts: "Entwürfe",
    AppConstants.draft: "Entwurf",
    AppConstants.draftSaved: "In Entwürfen gespeichert",
    AppConstants.unsavedChanges: "Ungespeicherte Änderungen",
    AppConstants.unsavedChangesMessage:
        "Du hast ungespeicherte Änderungen. Als Entwurf speichern oder verwerfen?",
    AppConstants.saveAsDraft: "Als Entwurf speichern",
    AppConstants.discardChanges: "Verwerfen",
    AppConstants.autoDeleteDrafts: "Entwürfe automatisch löschen",
    AppConstants.days7: "7 Tage",
    AppConstants.never: "Nie",
    AppConstants.custom: "Benutzerdefiniert...",
    AppConstants.enterCustomDays: "Eigene Tage eingeben",
    AppConstants.customDaysExample: "Z. B. 14",
    AppConstants.days: "Tage",
    AppConstants.draftsNeverDeleted: "Entwürfe werden nie gelöscht",
    AppConstants.draftsDeletedAfterDays:
        "Entwürfe werden nach %d Tagen gelöscht",

    // Home Menu & Sorting
    AppConstants.sortBy: "Sortieren nach",
    AppConstants.insights: "Einblicke",
    AppConstants.reflections: "Reflexionen",
    AppConstants.settings: "Einstellungen",
    AppConstants.entryTime: "Eintragszeit",
    AppConstants.bookmarkFirst: "Lesezeichen zuerst",
    AppConstants.reflectionFirst: "Reflexionen zuerst",
    AppConstants.withMediaFirst: "Mit Medien zuerst",
    AppConstants.textOnlyFirst: "Nur Text zuerst",
    AppConstants.withLocationFirst: "Mit Ort zuerst",
    AppConstants.withMoodFirst: "Mit Stimmung zuerst",
    AppConstants.withTagsFirst: "Mit Schlagwörtern zuerst",

    // Insights
    AppConstants.stats: "Statistik",
    AppConstants.calendar: "Kalender",
    AppConstants.entriesSuffix: " Einträge",
    AppConstants.memoriesFromThisDay: "Erinnerungen an diesen Tag",
    AppConstants.standard: "Standard",
    AppConstants.media: "Medien",
    AppConstants.mood: "Stimmung",
    AppConstants.mostly: "Meistens",
    AppConstants.averageForThisDay: "Durchschnitt für diesen Tag",
    AppConstants.averageForThisYear: "Durchschnitt für dieses Jahr",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Willkommen bei OpenJot",
    AppConstants.feature1:
        "Schreibe frei, füge Fotos und Orte hinzu und bewahre alles sicher auf deinem Gerät auf.",
    AppConstants.feature2:
        "Verstehe deine Gefühle im Laufe der Zeit durch integriertes Stimmungstracking.",
    AppConstants.feature3:
        "Deine Daten bleiben auf deinem Telefon – keine Cloud, nur lokaler Speicher und volle Privatsphäre.",
    AppConstants.continueButton: "Weiter",

    // Notifications
    AppConstants.notificationTitle: "Zeit fürs Tagebuch!",
    AppConstants.notificationBody:
        "Vergiss nicht, deine Gedanken für heute aufzuschreiben.",
    AppConstants.notificationChannelName: "Tägliche Tagebuch-Erinnerungen",
    AppConstants.notificationChannelDescription:
        "Kanal für tägliche Tagebuch-Erinnerungen",
    AppConstants.onThisDayChannelName: "Erinnerungen an diesen Tag",
    AppConstants.onThisDayChannelDescription:
        "Benachrichtigungen für Erinnerungen aus vergangenen Jahren.",
    AppConstants.onThisDayNotificationTitle:
        "Eine Erinnerung aus deinem Tagebuch",
    AppConstants.onThisDaySingleEntry:
        "Heute vor einem Jahr hast du etwas Besonderes geschrieben. Tippe, um deine Gedanken erneut zu lesen.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "An diesem Tag im letzten Jahr hast du diese Erinnerung geteilt. Tippe, um sie wieder zu erleben.",
    AppConstants.onThisDayMultipleEntries:
        "Du hast Erinnerungen an diesen Tag aus vergangenen Jahren. Tippe, um sie anzusehen.",
    AppConstants.onThisDayGroupedNotification:
        "Du hast %d Erinnerungen an diesen Tag",

    // Exclude Entries
    AppConstants.excludeEntries: "Einträge ausschließen",
    AppConstants.saveExclusions: "Ausschlüsse speichern",
    AppConstants.excludeUnsavedChangesMessage:
        "Du hast ungespeicherte Änderungen. Wirklich verwerfen und beenden?",
    AppConstants.sortDefault: "Standard",
    AppConstants.sortMutedFirst: "Stummgeschaltete zuerst",
    AppConstants.sortUnmutedFirst: "Aktive zuerst",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Heute",
    AppConstants.yesterday: "Gestern",
    AppConstants.contentForQuote: "Inhalt für Zitat",
    AppConstants.noContentSelected: "Kein Inhalt ausgewählt.",
    AppConstants.photos: "Fotos",
    AppConstants.video: "Video",
    AppConstants.audio: "Audio",
    AppConstants.add: "Hinzufügen",
    AppConstants.noMediaFound: "Keine %s gefunden.",
    AppConstants.permissionRequired:
        "Zugriffsberechtigung für %s erforderlich, um sie anzuzeigen.",
    AppConstants.openSettings: "Einstellungen öffnen",
    AppConstants.videos: "Videos",
    AppConstants.audios: "Audios",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Aufnahme löschen?",
    AppConstants.deleteRecordingMessage:
        "Möchtest du diese Aufnahme wirklich löschen?",
    AppConstants.listen: "Anhören",
    AppConstants.tapAndHold: "gedrückt halten",
    AppConstants.clear: "Leeren",
    AppConstants.all: "Alle",
    AppConstants.folder: "Ordner",
    AppConstants.browse: "Durchsuchen",
    AppConstants.tiles: "Kacheln",
    AppConstants.graph: "Diagramm",
    AppConstants.recording: "Aufnahme läuft...",
    AppConstants.recordingLabel: "Aufnahme",
    AppConstants.startAudioRecording: "Audioaufnahme starten",
    AppConstants.howAreYouFeeling: "Wie fühlst du dich?",
    AppConstants.paused: "Pausiert",
    AppConstants.stop: "Stopp",
    AppConstants.tapOrHoldToResume:
        "Tippen oder gedrückt halten zum Fortsetzen",
    AppConstants.tapOrReleaseToPause:
        "Tippen oder loslassen zum Pausieren",
    AppConstants.unsupportedImageType: "Nicht unterstützter Bildtyp",
    AppConstants.couldNotLoadVideo: "Video konnte nicht geladen werden",
    AppConstants.couldNotOpenMap: "Kartenlink konnte nicht geöffnet werden.",
    AppConstants.dismiss: "Schließen",
    AppConstants.selectTime: "Uhrzeit wählen",
    AppConstants.now: "Jetzt",
    AppConstants.searchPlacesHint: "Orte, Geschäfte suchen...",
    AppConstants.locationPermissionDenied: "Standortberechtigung verweigert.",
    AppConstants.failedGetCurrentLocation:
        "Aktueller Standort konnte nicht ermittelt werden.",

    // Search
    AppConstants.searchJournalsHint: "Tagebücher durchsuchen...",
    AppConstants.textOnly: "Nur Text",
    AppConstants.withMedia: "Mit Medien",
    AppConstants.withMood: "Mit Stimmung",
    AppConstants.withLocation: "Mit Ort",
    AppConstants.withTags: "Mit Schlagwörtern",
    AppConstants.noResultsFound: "Keine Ergebnisse gefunden",
    AppConstants.searchHintText: "Einträge suchen...",

    // Settings
    AppConstants.language: "Sprache",
    AppConstants.selectLanguage: "Sprache wählen",
    AppConstants.systemDefault: "Systemstandard",
    AppConstants.searchLanguagesHint: "Sprachen suchen...",
    AppConstants.languageChanged: "Sprache auf %s geändert.",
    AppConstants.dailyReminder: "Erinnerungen",
    AppConstants.addReminder: "Erinnerung hinzufügen",
    AppConstants.deleteReminder: "Erinnerung löschen",
    AppConstants.noRemindersSet: "Keine Erinnerungen festgelegt.",
    AppConstants.onThisDay: "An diesem Tag",
    AppConstants.appLock: "App-Sperre",
    AppConstants.backup: "Backup",
    AppConstants.restore: "Wiederherstellen",
    AppConstants.importFromAnotherApp: "Aus anderer App importieren",
    AppConstants.importFromDailyYou: "Aus Daily You importieren",
    AppConstants.selectDailyYouBackup: "Daily You-Backup-Zip-Datei wählen",
    AppConstants.importingEntries: "Einträge werden importiert...",
    AppConstants.importSuccess:
        "%d Einträge erfolgreich aus Daily You importiert!",
    AppConstants.importFailed: "Import fehlgeschlagen: %s",
    AppConstants.noEntriesToImport: "Keine neuen Einträge zum Importieren.",
    AppConstants.askSupport: "Support fragen",
    AppConstants.importSupportNote:
        "Andere App-Formate unterstützen möglicherweise nicht alle Funktionen. Bei Problemen oder Formatänderungen erstelle bitte einen Fehlerbericht.",
    AppConstants.extractingBackup: "Backup wird entpackt...",
    AppConstants.parsingDatabase: "Datenbank wird gelesen...",
    AppConstants.dailyYouDbNotFound:
        "Daily You-Datenbank nicht im Backup gefunden.",
    AppConstants.privacyPolicy: "Datenschutzrichtlinie",
    AppConstants.termsNConditions: "Nutzungsbedingungen",
    AppConstants.about: "Über die App",
    AppConstants.changeTheme: "Design ändern",
    AppConstants.theme: "Design",
    AppConstants.pitchBlack: "Tiefschwarz",
    AppConstants.themeLight: "Hell",
    AppConstants.themeDark: "Dunkel",
    AppConstants.themeSystem: "System",
    AppConstants.changePin: "PIN ändern",
    AppConstants.loading: "Wird geladen...",
    AppConstants.confirmRestoreTitle: "Wiederherstellung bestätigen",
    AppConstants.confirmRestoreMessage:
        "Durch das Wiederherstellen werden alle aktuellen Daten überschrieben. Dies kann nicht rückgängig gemacht werden. Fortfahren?",
    AppConstants.notificationScheduled: "Benachrichtigung geplant für %s",
    AppConstants.notificationCanceled: "Benachrichtigung abgebrochen",
    AppConstants.notificationRescheduled:
        "Benachrichtigung neu geplant für %s",
    AppConstants.notificationPermissionRequired:
        "Für Erinnerungen ist die Benachrichtigungsberechtigung erforderlich.",
    AppConstants.pinChangedSuccess: "PIN erfolgreich geändert",
    AppConstants.onThisDayOn:
        "Du erhältst nun Erinnerungen an diesen Tag.",
    AppConstants.onThisDayOff:
        "„An diesem Tag“-Erinnerungen sind deaktiviert.",
    AppConstants.themeChanged: "Design %s ausgewählt.",
    AppConstants.hideStats: "Statistik ausblenden",
    AppConstants.hideHomeStats: "Startseiten-Statistik ausblenden",
    AppConstants.hideInsightsStats: "Einblicke-Statistik ausblenden",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEXION",
    AppConstants.reflectButton: "Reflektieren",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Falsche PIN",
    AppConstants.verifyYourPin: "PIN bestätigen",
    AppConstants.setAPin: "PIN festlegen",
    AppConstants.confirmPin: "PIN bestätigen",
    AppConstants.pinsDoNotMatch: "PINs stimmen nicht überein",
    AppConstants.setPin: "PIN festlegen",
    AppConstants.hello: "Hallo!",
    AppConstants.enterYourPin: "PIN eingeben",
    AppConstants.useBiometrics: "Biometrie verwenden",
    AppConstants.authenticateToUnlock:
        "Bitte authentifiziere dich, um die App zu entsperren",
    AppConstants.databaseEncryption: "Datenbankverschlüsselung",
    AppConstants.databaseEncryptionDesc: "Lokale AES-256-GCM-Verschlüsselung",
    AppConstants.changeMasterPassword: "Master-Passwort ändern",
    AppConstants.biometricUnlock: "Biometrische Entsperrung",
    AppConstants.enterMasterPassword: "Master-Passwort eingeben",
    AppConstants.enterMasterPasswordHint:
        "Gib dein Master-Passwort ein, um dein Tagebuch zu entschlüsseln.",
    AppConstants.unlockButton: "Entsperren",
    AppConstants.unlockWithBiometrics: "Mit Biometrie entsperren",
    AppConstants.incorrectMasterPassword:
        "Falsches Master-Passwort. Bitte erneut versuchen.",
    AppConstants.databaseEncryptedSuccess:
        "Tagebuch-Datenbank mit AES-256-GCM verschlüsselt.",
    AppConstants.databaseDecryptedSuccess:
        "Tagebuch-Datenbank entschlüsselt und App-Sperre deaktiviert.",
    AppConstants.masterPasswordChangedSuccess:
        "Master-Passwort erfolgreich aktualisiert.",
    AppConstants.encryptedBackupPasswordRequired:
        "Zum Öffnen eines verschlüsselten Backups ist ein Passwort erforderlich.",
    AppConstants.incorrectBackupPassword: "Falsches Backup-Passwort.",
    AppConstants.invalidBackupFile:
        "Die ausgewählte Datei ist kein gültiges OpenJot-Backup.",
    AppConstants.encryptedBackup: "Verschlüsseltes Backup (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Geschützt mit AES-256-GCM und einem Backup-Passwort",
    AppConstants.standardBackup: "Standard-Backup (.zip)",
    AppConstants.standardBackupDesc:
        "Unverschlüsseltes Archiv, mit allen Versionen kompatibel",
    AppConstants.takingBackup: "Backup wird erstellt...",
    AppConstants.encryptingBackup: "Backup wird verschlüsselt...",
    AppConstants.savingBackup: "Backup wird gespeichert...",
    AppConstants.preparingBackup: "Backup wird vorbereitet...",
    AppConstants.decryptingBackup: "Backup wird entschlüsselt...",
    AppConstants.restoringBackup: "Backup wird wiederhergestellt...",
    AppConstants.backupEncodingFailed:
        "Backup-Datei konnte nicht kodiert werden.",
    AppConstants.backupCreatedSuccess: "Backup erfolgreich erstellt!",
    AppConstants.backupFailed: "Backup fehlgeschlagen: %s",
    AppConstants.restorePermissionsRequired:
        "Speicher- und Medienberechtigungen sind zur Wiederherstellung erforderlich.",
    AppConstants.databaseRestoredNoMedia:
        "Datenbank wiederhergestellt. Keine Medien im Backup gefunden.",
    AppConstants.restoreSuccess: "Wiederherstellung erfolgreich!",
    AppConstants.restoreSuccessRestartRecommended:
        "Wiederherstellung erfolgreich. Ein Neustart wird empfohlen, um alle Änderungen anzuwenden.",
    AppConstants.restoreFailed: "Wiederherstellung fehlgeschlagen: %s",
    AppConstants.storagePermissionsRequired:
        "Speicher- und Medienberechtigungen sind zum Erstellen eines Backups erforderlich.",
    AppConstants.selectBackupFolder:
        "Ordner zum Speichern des Backups wählen",
    AppConstants.encryptDatabase: "Datenbank verschlüsseln",
    AppConstants.disableEncryption: "Verschlüsselung deaktivieren",
    AppConstants.backupPasswordTitle: "Backup-Passwort",
    AppConstants.changeMasterPasswordDesc:
        "Gib dein aktuelles Master-Passwort ein und wähle ein neues Passwort (mindestens 6 Zeichen).",
    AppConstants.disableEncryptionDesc:
        "Gib dein Master-Passwort ein, um deine Datenbank auf dem Gerät zu entschlüsseln und die Verschlüsselung auszuschalten.",
    AppConstants.enableEncryptionDesc:
        "Schütze alle Tagebuchnotizen lokal mit AES-256-GCM-Verschlüsselung. Wenn du dein Master-Passwort vergisst, können deine Daten nicht wiederhergestellt werden.",
    AppConstants.verifyForBiometricsDesc:
        "Gib dein Master-Passwort einmalig ein, um einen Entsperrschlüssel im sicheren Hardwarespeicher für schnelles biometrisches Entsperren abzulegen.",
    AppConstants.createBackupPasswordDesc:
        "Lege ein starkes Passwort fest, um dieses .openjot-Backup zu verschlüsseln. Du benötigst es zum Wiederherstellen auf jedem Gerät.",
    AppConstants.enterBackupPasswordDesc:
        "Gib das Passwort ein, das beim Erstellen dieses .openjot-Backups verwendet wurde.",
    AppConstants.updatePasswordAction: "Passwort aktualisieren",
    AppConstants.decryptAndDisable: "Entschlüsseln & deaktivieren",
    AppConstants.enableBiometricsAction: "Biometrie aktivieren",
    AppConstants.createBackupAction: "Backup erstellen",
    AppConstants.decryptBackupAction: "Backup entschlüsseln",
    AppConstants.newMasterPasswordHint: "Neues Master-Passwort",
    AppConstants.backupPasswordHint: "Backup-Passwort",
    AppConstants.masterPasswordHint: "Master-Passwort",
    AppConstants.enterCurrentMasterPasswordError:
        "Bitte gib dein aktuelles Master-Passwort ein.",
    AppConstants.passwordEmptyError: "Passwort darf nicht leer sein.",
    AppConstants.passwordMinLengthError:
        "Das Passwort muss mindestens 6 Zeichen lang sein.",
    AppConstants.passwordsDoNotMatchError:
        "Passwörter stimmen nicht überein.",
    AppConstants.currentMasterPasswordHint: "Aktuelles Master-Passwort",
    AppConstants.confirmPasswordHint: "Passwort bestätigen",

    // About & Terms
    AppConstants.aboutApp: "Über OpenJot",
    AppConstants.versionPrefix: "Version: %s",
    AppConstants.aboutSubtitle:
        "Ein minimalistisches Open-Source-Tagebuch für deine Gedanken, Stimmungen und Erinnerungen. Alle Daten bleiben auf deinem Gerät.",
    AppConstants.keyFeatures: "Hauptfunktionen",
    AppConstants.aboutFeature1:
        "• Klares, ablenkungsfreies Schreiberlebnis.",
    AppConstants.aboutFeature2:
        "• Füge Fotos, Sprachnotizen und Musik zu deinen Einträgen hinzu.",
    AppConstants.aboutFeature3:
        "• Halte deine Stimmung neben deinen Einträgen fest.",
    AppConstants.aboutFeature4:
        "• Personalisiere mit verschiedenen Textstilen.",
    AppConstants.aboutFeature5:
        "• Funktioniert komplett offline – deine Daten bleiben auf deinem Gerät.",
    AppConstants.openSource: "Open Source",
    AppConstants.openSourceDesc:
        "OpenJot ist eine Open-Source-Anwendung. Der Quellcode ist öffentlich einsehbar, veränderbar und offen für Beiträge. Wir glauben an Transparenz und Gemeinschaft.",
    AppConstants.dataPrivacy: "Datenschutz",
    AppConstants.dataPrivacyDesc:
        "Wir schätzen deine Privatsphäre. OpenJot erhebt, speichert und überträgt keinerlei persönliche Daten. Alle Einträge samt Bildern und Audios werden ausschließlich auf deinem Gerät gespeichert.",
    AppConstants.linksTitle: "Links",
    AppConstants.sourceCodeOnGithub: "Quellcode auf GitHub",
    AppConstants.sendFeedback: "Feedback senden",
    AppConstants.couldNotLaunchUrl: "URL konnte nicht geöffnet werden",
    AppConstants.termsIntro:
        "Willkommen bei OpenJot! Dieses Dokument beschreibt die Nutzungsbedingungen unserer App. Durch die Nutzung von OpenJot stimmst du diesen Bedingungen zu.",
    AppConstants.termsSectionDataPrivacy: "Datenspeicherung und Datenschutz",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot ist als privater Raum für deine Gedanken konzipiert. Alle Einträge inklusive Text, Bildern, Audios und weiteren Medien werden ausschließlich lokal auf deinem Gerät gespeichert. Die App überträgt keine Daten an externe Server.",
    AppConstants.termsSectionUserContent: "Nutzergenerierte Inhalte",
    AppConstants.termsSectionUserContentBody:
        "Du bist allein verantwortlich für die Inhalte, die du in OpenJot erstellst und speicherst. Du bist dafür verantwortlich sicherzustellen, dass du die nötigen Rechte an allen importierten Inhalten besitzt.",
    AppConstants.termsSectionDisclaimer: "Gewährleistungsausschluss",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot wird „wie besehen“ ohne ausdrückliche oder stillschweigende Gewährleistung bereitgestellt. Wir garantieren keinen fehlerfreien oder unterbrechungsfreien Betrieb. Die Nutzung erfolgt auf eigenes Risiko.",
    AppConstants.termsSectionLiability: "Haftungsbeschränkung",
    AppConstants.termsSectionLiabilityBody:
        "In keinem Fall haften die Entwickler von OpenJot für direkte, indirekte, zufällige, besondere oder Folgeschäden, einschließlich Datenverlust, die aus der Nutzung oder Unmöglichkeit der Nutzung entstehen.",
    AppConstants.termsSectionThirdParty: "Bibliotheken von Drittanbietern",
    AppConstants.termsSectionThirdPartyBody:
        "Diese App nutzt die folgenden Bibliotheken von Drittanbietern, die jeweils ihrer eigenen Lizenz unterliegen:",

    // Months
    'January': 'Januar',
    'February': 'Februar',
    'March': 'März',
    'April': 'April',
    'May': 'Mai',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'August',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'Dezember',

    // Reflection Prompts (61)
    "What made you smile today?": "Was hat dich heute zum Lächeln gebracht?",
    "Who are you thankful for this week, and why?":
        "Wem bist du diese Woche dankbar und warum?",
    "What is something small that brought you joy today?":
        "Welche Kleinigkeit hat dir heute Freude bereitet?",
    "Which part of your day felt most comforting?":
        "Welcher Teil deines Tages fühlte sich am tröstlichsten an?",
    "What’s something you often take for granted but appreciate now?":
        "Was nimmst du oft als selbstverständlich hin, schätzt es aber jetzt?",
    "What’s the best thing that happened today?":
        "Was war das Schönste, das heute passiert ist?",
    "Did someone make your day easier today?":
        "Hat dir heute jemand den Tag leichter gemacht?",
    "Who made a positive impact on you recently?":
        "Wer hat dich kürzlich positiv beeinflusst?",
    "What’s a quality you admire in someone close to you?":
        "Welche Eigenschaft bewunderst du an jemandem, der dir nahesteht?",
    "When did you last feel truly connected with someone?":
        "Wann hast du dich zuletzt jemandem wirklich verbunden gefühlt?",
    "Who do you want to reach out to soon?":
        "Bei wem möchtest du dich bald melden?",
    "Did someone’s kindness stand out today?":
        "Ist dir heute die Freundlichkeit von jemandem besonders aufgefallen?",
    "How did you support someone else recently?":
        "Wie hast du kürzlich jemand anderen unterstützt?",
    "Who do you miss the most right now?":
        "Wen vermisst du gerade am meisten?",
    "What’s a moment from today you want to remember?":
        "Welchen Moment von heute möchtest du in Erinnerung behalten?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Welches Detail von heute könntest du vergessen, wenn du es nicht notierst?",
    "What’s the most peaceful moment you had today?":
        "Was war dein friedlichster Moment heute?",
    "Did you see something beautiful today?":
        "Hast du heute etwas Schönes gesehen?",
    "Which memory from this week stands out?":
        "Welche Erinnerung aus dieser Woche sticht hervor?",
    "What song, photo, or place will always remind you of today?":
        "Welches Lied, Foto oder welcher Ort wird dich immer an heute erinnern?",
    "What surprised you today?": "Was hat dich heute überrascht?",
    "What challenge did you overcome today?":
        "Welche Herausforderung hast du heute gemeistert?",
    "What’s a small win you had today?":
        "Welchen kleinen Erfolg hattest du heute?",
    "What new thing did you learn about yourself recently?":
        "Was hast du kürzlich Neues über dich gelernt?",
    "What are you proud of yourself for?":
        "Worauf bist du bei dir selbst stolz?",
    "What habit do you feel good about keeping?":
        "Welche Gewohnheit tut dir gut beizubehalten?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Welche Verbesserung hast du dieses Jahr an dir bemerkt?",
    "How did you push yourself out of your comfort zone?":
        "Wie bist du aus deiner Komfortzone herausgekommen?",
    "How are you truly feeling right now?":
        "Wie fühlst du dich gerade wirklich?",
    "Which emotion stood out the most today?":
        "Welches Gefühl war heute am stärksten?",
    "Did you feel present in any moment today?":
        "Hast du dich heute in einem Moment ganz im Hier und Jetzt gefühlt?",
    "When did you feel the most at peace today?":
        "Wann hast du dich heute am meisten im Frieden gefühlt?",
    "What gave you energy today?": "Was hat dir heute Energie gegeben?",
    "What drained your energy today?": "Was hat dir heute Energie geraubt?",
    "If your mood had a color today, what would it be?":
        "Wenn deine Stimmung heute eine Farbe hätte, welche wäre es?",
    "What’s something you’re excited about tomorrow?":
        "Worauf freust du dich morgen?",
    "What’s one thing you want to improve tomorrow?":
        "Was möchtest du morgen verbessern?",
    "What would make tomorrow feel successful?":
        "Was würde den morgigen Tag erfolgreich wirken lassen?",
    "What do you hope to achieve this week?":
        "Was hoffst du diese Woche zu erreichen?",
    "What’s a habit you’d like to start tomorrow?":
        "Welche Gewohnheit möchtest du morgen beginnen?",
    "What’s something you want to look forward to in the next month?":
        "Worauf möchtest du dich im nächsten Monat freuen?",
    "What would your ideal tomorrow look like?":
        "Wie würde dein idealer morgiger Tag aussehen?",
    "What’s one lesson you learned recently?":
        "Welche Lektion hast du kürzlich gelernt?",
    "If you could freeze one moment today, which would it be?":
        "Wenn du heute einen Moment anhalten könntest, welcher wäre es?",
    "What makes your life feel meaningful right now?":
        "Was lässt dein Leben gerade sinnvoll erscheinen?",
    "If you described today in one word, what would it be?":
        "Wenn du den heutigen Tag in einem Wort beschreiben würdest, welches wäre es?",
    "What inspired you today?": "Was hat dich heute inspiriert?",
    "What did you notice today that you usually overlook?":
        "Was hast du heute bemerkt, das du sonst übersiehst?",
    "How has today changed your perspective?":
        "Wie hat der heutige Tag deine Sichtweise verändert?",
    "What’s something you’ve been overthinking?":
        "Worüber hast du zu viel nachgedacht?",
    "What do you need to let go of?": "Was musst du loslassen?",
    "What part of nature did you notice today?":
        "Welchen Teil der Natur hast du heute wahrgenommen?",
    "Did the weather affect your mood today?":
        "Hat das Wetter heute deine Stimmung beeinflusst?",
    "What place felt most comforting today?":
        "Welcher Ort fühlte sich heute am geborgensten an?",
    "Where did you feel most at home today?":
        "Wo hast du dich heute am meisten zu Hause gefühlt?",
    "What sound or smell reminded you of something important?":
        "Welches Geräusch oder welcher Geruch hat dich an etwas Wichtiges erinnert?",
    "How did you take care of yourself today?":
        "Wie hast du heute auf dich selbst geachtet?",
    "When did you feel most like yourself today?":
        "Wann hast du dich heute am meisten wie du selbst gefühlt?",
    "What’s something kind you can say to yourself right now?":
        "Was Liebes kannst du dir jetzt selbst sagen?",
    "What do you want to forgive yourself for?":
        "Was möchtest du dir selbst verzeihen?",
    "What do you deserve more of in your life?":
        "Wovon verdienst du mehr in deinem Leben?",
  },
  'it': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Il mio diario",
    AppConstants.noEntriesMessage:
        "Nessuna voce nel diario. Inizia a scrivere!",
    AppConstants.noBookmarksYet: "Nessun segnalibro ancora.",
    AppConstants.noDraftsYet: "Nessuna bozza ancora.",
    AppConstants.addEntryButton: "Aggiungi nuova voce",
    AppConstants.jotYourThoughts: "Annota i tuoi pensieri",
    AppConstants.tapToCreateJournal:
        "Tocca + per creare il tuo diario personale.",
    AppConstants.entriesThisYear: "Voci quest'anno",
    AppConstants.wordsWritten: "Parole scritte",
    AppConstants.daysJournaled: "Giorni di diario",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nuova voce di diario",
    AppConstants.editEntryAppBarTitle: "Modifica voce di diario",
    AppConstants.titleHintText:
        "Titolo (es. 'La mia giornata', 'Pensieri su...')",
    AppConstants.contentHintText: "Scrivi qui i tuoi pensieri...",
    AppConstants.saveButton: "Salva voce",
    AppConstants.updateButton: "Aggiorna",
    AppConstants.deleteButton: "Elimina voce",
    AppConstants.requiredFieldMessage: "Questo campo non può essere vuoto.",
    AppConstants.newEntry: "Nuova voce",
    AppConstants.todayDate: "Data di oggi",
    AppConstants.customDate: "Data personalizzata",
    AppConstants.done: "Fatto",
    AppConstants.startWriting: " Inizia a scrivere...",
    AppConstants.tags: "Tag",
    AppConstants.addTags: "Aggiungi tag",
    AppConstants.openInMaps: "Apri in Mappe",
    AppConstants.changeLocation: "Cambia posizione",
    AppConstants.remove: "Rimuovi",
    AppConstants.discardSelectionsTitle: "Scartare le selezioni?",
    AppConstants.discardSelectionsMessage:
        "Hai selezionato contenuti multimediali o una registrazione attiva. Sei sicuro di voler scartare tutto?",
    AppConstants.journalEntryEmpty:
        "La voce del diario non può essere vuota",
    AppConstants.discardDateConfirm:
        "Scartare la data/ora selezionata per questa voce?",
    AppConstants.addMediaLocationMoodFirst:
        "Aggiungi prima contenuti multimediali, posizione o umore",
    AppConstants.location: "Posizione",
    AppConstants.record: "Registra",
    AppConstants.selectMomentsToJournal: "Seleziona momenti da annotare",
    AppConstants.addMomentsFromMenu:
        "Aggiungi media, posizione, registrazione o umore dal menu",
    AppConstants.writeSomething: "Scrivi qualcosa",
    AppConstants.saveWithoutWriting: "Salva senza scrivere",
    AppConstants.oneLocation: "1 posizione",
    AppConstants.mediaCount: "%d file",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Conferma eliminazione",
    AppConstants.confirmDeleteMessage:
        "Sei sicuro di voler eliminare questa voce?",
    AppConstants.pleaseConfirm: "Conferma",
    AppConstants.confirmDeleteJournalEntry:
        "Sei sicuro di voler eliminare questa voce del diario? L'azione è irreversibile.",
    AppConstants.yes: "Sì",
    AppConstants.no: "No",
    AppConstants.cancel: "Annulla",
    AppConstants.delete: "Elimina",
    AppConstants.save: "Salva",
    AppConstants.entrySavedSuccess: "Voce del diario salvata con successo!",
    AppConstants.entryUpdatedSuccess:
        "Voce del diario aggiornata con successo!",
    AppConstants.entryDeletedSuccess: "Voce del diario eliminata.",
    AppConstants.errorSavingEntry: "Errore nel salvataggio della voce.",
    AppConstants.errorDeletingEntry: "Errore nell'eliminazione della voce.",
    AppConstants.errorLoadingEntries:
        "Errore nel caricamento delle voci del diario.",
    AppConstants.noEntriesForDate: "Nessuna voce per questa data.",
    AppConstants.noEntriesForMonth: "Nessuna voce trovata per questo mese.",
    AppConstants.selectMonthAndYear: "Seleziona mese e anno",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Molto spiacevole",
    AppConstants.unpleasant: "Spiacevole",
    AppConstants.slightlyUnpleasant: "Un po' spiacevole",
    AppConstants.neutral: "Neutro",
    AppConstants.slightlyPleasant: "Un po' piacevole",
    AppConstants.pleasant: "Piacevole",
    AppConstants.veryPleasant: "Molto piacevole",
    AppConstants.reflection: "Riflessione",
    AppConstants.edit: "Modifica",
    AppConstants.removeBookmark: "Rimuovi segnalibro",
    AppConstants.bookmark: "Segnalibro",
    AppConstants.share: "Condividi",
    AppConstants.saveAsPdf: "Salva come PDF",
    AppConstants.audioTrack: "Traccia audio",
    AppConstants.generatingPdf: "Generazione PDF...",
    AppConstants.voiceRecording: "Registrazione vocale",
    AppConstants.audioRecording: "Registrazione audio",
    AppConstants.couldNotLoadAudio: "Impossibile caricare il file audio.",
    AppConstants.stateOfMind: "Stato d'animo",

    // Mood Colors
    AppConstants.moodColors: "Colori dell'umore",
    AppConstants.customizeMoodColors: "Personalizza colori dell'umore",
    AppConstants.reset: "Ripristina",
    AppConstants.resetMoodColors: "Ripristina predefiniti",
    AppConstants.resetMoodColorsConfirm:
        "Ripristinare tutti i colori dell'umore ai valori predefiniti?",
    AppConstants.paletteThemes: "Temi tavolozza",
    AppConstants.customColor: "Colore personalizzato",
    AppConstants.moodUnsavedChangesMessage:
        "Hai modifiche non salvate ai colori dell'umore. Vuoi salvarle prima di chiudere?",

    // Drafts & Auto-save
    AppConstants.drafts: "Bozze",
    AppConstants.draft: "Bozza",
    AppConstants.draftSaved: "Salvato nelle bozze",
    AppConstants.unsavedChanges: "Modifiche non salvate",
    AppConstants.unsavedChangesMessage:
        "Hai modifiche non salvate. Vuoi salvarle come bozza o scartarle?",
    AppConstants.saveAsDraft: "Salva come bozza",
    AppConstants.discardChanges: "Scarta",
    AppConstants.autoDeleteDrafts: "Eliminazione auto bozze",
    AppConstants.days7: "7 giorni",
    AppConstants.never: "Mai",
    AppConstants.custom: "Personalizzato...",
    AppConstants.enterCustomDays: "Inserisci giorni personalizzati",
    AppConstants.customDaysExample: "Es. 14",
    AppConstants.days: "Giorni",
    AppConstants.draftsNeverDeleted: "Le bozze non verranno mai eliminate",
    AppConstants.draftsDeletedAfterDays:
        "Le bozze verranno eliminate dopo %d giorni",

    // Home Menu & Sorting
    AppConstants.sortBy: "Ordina per",
    AppConstants.insights: "Statistiche",
    AppConstants.reflections: "Riflessioni",
    AppConstants.settings: "Impostazioni",
    AppConstants.entryTime: "Ora della voce",
    AppConstants.bookmarkFirst: "Segnalibri prima",
    AppConstants.reflectionFirst: "Riflessioni prima",
    AppConstants.withMediaFirst: "Con media prima",
    AppConstants.textOnlyFirst: "Solo testo prima",
    AppConstants.withLocationFirst: "Con posizione prima",
    AppConstants.withMoodFirst: "Con umore prima",
    AppConstants.withTagsFirst: "Con tag prima",

    // Insights
    AppConstants.stats: "Statistiche",
    AppConstants.calendar: "Calendario",
    AppConstants.entriesSuffix: " voci",
    AppConstants.memoriesFromThisDay: "Ricordi di questo giorno",
    AppConstants.standard: "Standard",
    AppConstants.media: "Media",
    AppConstants.mood: "Umore",
    AppConstants.mostly: "Prevalentemente",
    AppConstants.averageForThisDay: "Media di questo giorno",
    AppConstants.averageForThisYear: "Media di quest'anno",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Benvenuto in OpenJot",
    AppConstants.feature1:
        "Scrivi liberamente, aggiungi foto e luoghi e tieni tutto al sicuro sul tuo dispositivo.",
    AppConstants.feature2:
        "Comprendi le tue emozioni nel tempo con il tracciamento integrato dell'umore.",
    AppConstants.feature3:
        "I tuoi dati restano sul telefono: niente cloud, solo archiviazione locale e massima privacy.",
    AppConstants.continueButton: "Continua",

    // Notifications
    AppConstants.notificationTitle: "È ora di scrivere!",
    AppConstants.notificationBody:
        "Non dimenticare di annotare i tuoi pensieri di oggi.",
    AppConstants.notificationChannelName: "Promemoria giornalieri del diario",
    AppConstants.notificationChannelDescription:
        "Canale per i promemoria giornalieri del diario",
    AppConstants.onThisDayChannelName: "Ricordi di questo giorno",
    AppConstants.onThisDayChannelDescription:
        "Notifiche per i ricordi degli anni passati.",
    AppConstants.onThisDayNotificationTitle: "Un ricordo dal tuo diario",
    AppConstants.onThisDaySingleEntry:
        "Un anno fa oggi hai scritto qualcosa di speciale. Tocca per rileggere i tuoi pensieri.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "In questo giorno l'anno scorso hai condiviso questo ricordo. Tocca per riviverlo.",
    AppConstants.onThisDayMultipleEntries:
        "Hai dei ricordi di questo giorno dagli anni passati. Tocca per rivederli.",
    AppConstants.onThisDayGroupedNotification:
        "Hai %d ricordi di questo giorno",

    // Exclude Entries
    AppConstants.excludeEntries: "Escludi voci",
    AppConstants.saveExclusions: "Salva esclusioni",
    AppConstants.excludeUnsavedChangesMessage:
        "Hai modifiche non salvate. Vuoi scartarle e uscire?",
    AppConstants.sortDefault: "Predefinito",
    AppConstants.sortMutedFirst: "Silenziati prima",
    AppConstants.sortUnmutedFirst: "Attivi prima",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Oggi",
    AppConstants.yesterday: "Ieri",
    AppConstants.contentForQuote: "Contenuto per citazione",
    AppConstants.noContentSelected: "Nessun contenuto selezionato.",
    AppConstants.photos: "Foto",
    AppConstants.video: "Video",
    AppConstants.audio: "Audio",
    AppConstants.add: "Aggiungi",
    AppConstants.noMediaFound: "Nessun %s trovato.",
    AppConstants.permissionRequired:
        "È richiesta l'autorizzazione per accedere a %s per mostrarli.",
    AppConstants.openSettings: "Apri impostazioni",
    AppConstants.videos: "Video",
    AppConstants.audios: "Audio",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Eliminare la registrazione?",
    AppConstants.deleteRecordingMessage:
        "Sei sicuro di voler eliminare questa registrazione?",
    AppConstants.listen: "Ascolta",
    AppConstants.tapAndHold: "tieni premuto",
    AppConstants.clear: "Cancella",
    AppConstants.all: "Tutto",
    AppConstants.folder: "Cartella",
    AppConstants.browse: "Sfoglia",
    AppConstants.tiles: "Riquadri",
    AppConstants.graph: "Grafico",
    AppConstants.recording: "Registrazione...",
    AppConstants.recordingLabel: "Registrazione",
    AppConstants.startAudioRecording: "Avvia registrazione audio",
    AppConstants.howAreYouFeeling: "Come ti senti?",
    AppConstants.paused: "In pausa",
    AppConstants.stop: "Ferma",
    AppConstants.tapOrHoldToResume: "Tocca o tieni premuto per riprendere",
    AppConstants.tapOrReleaseToPause: "Tocca o rilascia per mettere in pausa",
    AppConstants.unsupportedImageType: "Formato immagine non supportato",
    AppConstants.couldNotLoadVideo: "Impossibile caricare il video",
    AppConstants.couldNotOpenMap: "Impossibile aprire il link della mappa.",
    AppConstants.dismiss: "Chiudi",
    AppConstants.selectTime: "Seleziona ora",
    AppConstants.now: "Adesso",
    AppConstants.searchPlacesHint: "Cerca luoghi, negozi...",
    AppConstants.locationPermissionDenied: "Permesso posizione negato.",
    AppConstants.failedGetCurrentLocation:
        "Impossibile ottenere la posizione attuale.",

    // Search
    AppConstants.searchJournalsHint: "Cerca nei diari...",
    AppConstants.textOnly: "Solo testo",
    AppConstants.withMedia: "Con media",
    AppConstants.withMood: "Con umore",
    AppConstants.withLocation: "Con posizione",
    AppConstants.withTags: "Con tag",
    AppConstants.noResultsFound: "Nessun risultato trovato",
    AppConstants.searchHintText: "Cerca voci...",

    // Settings
    AppConstants.language: "Lingua",
    AppConstants.selectLanguage: "Seleziona lingua",
    AppConstants.systemDefault: "Predefinita di sistema",
    AppConstants.searchLanguagesHint: "Cerca lingue...",
    AppConstants.languageChanged: "Lingua cambiata in %s.",
    AppConstants.dailyReminder: "Promemoria",
    AppConstants.addReminder: "Aggiungi promemoria",
    AppConstants.deleteReminder: "Elimina promemoria",
    AppConstants.noRemindersSet: "Nessun promemoria impostato.",
    AppConstants.onThisDay: "In questo giorno",
    AppConstants.appLock: "Blocco app",
    AppConstants.backup: "Backup",
    AppConstants.restore: "Ripristina",
    AppConstants.importFromAnotherApp: "Importa da un'altra app",
    AppConstants.importFromDailyYou: "Importa da Daily You",
    AppConstants.selectDailyYouBackup:
        "Seleziona file zip di backup Daily You",
    AppConstants.importingEntries: "Importazione voci...",
    AppConstants.importSuccess:
        "Importate %d voci da Daily You con successo!",
    AppConstants.importFailed: "Importazione fallita: %s",
    AppConstants.noEntriesToImport: "Nessuna nuova voce da importare.",
    AppConstants.askSupport: "Chiedi supporto",
    AppConstants.importSupportNote:
        "I formati di altre app potrebbero non supportare tutte le funzionalità. Se riscontri problemi o i formati cambiano, invia una segnalazione.",
    AppConstants.extractingBackup: "Estrazione backup...",
    AppConstants.parsingDatabase: "Analisi database...",
    AppConstants.dailyYouDbNotFound:
        "Database Daily You non trovato nel backup.",
    AppConstants.privacyPolicy: "Informativa sulla privacy",
    AppConstants.termsNConditions: "Termini e condizioni",
    AppConstants.about: "Informazioni sull'app",
    AppConstants.changeTheme: "Cambia tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Nero assoluto",
    AppConstants.themeLight: "Chiaro",
    AppConstants.themeDark: "Scuro",
    AppConstants.themeSystem: "Sistema",
    AppConstants.changePin: "Cambia PIN",
    AppConstants.loading: "Caricamento...",
    AppConstants.confirmRestoreTitle: "Conferma ripristino",
    AppConstants.confirmRestoreMessage:
        "Il ripristino da un backup sovrascriverà tutti i dati attuali. Questa azione non può essere annullata. Vuoi continuare?",
    AppConstants.notificationScheduled: "Notifica programmata per le %s",
    AppConstants.notificationCanceled: "Notifica annullata",
    AppConstants.notificationRescheduled: "Notifica riprogrammata per le %s",
    AppConstants.notificationPermissionRequired:
        "Per impostare i promemoria è necessaria l'autorizzazione alle notifiche.",
    AppConstants.pinChangedSuccess: "PIN modificato con successo",
    AppConstants.onThisDayOn: "Ora riceverai i ricordi di questo giorno.",
    AppConstants.onThisDayOff:
        "I promemoria 'In questo giorno' sono disattivati.",
    AppConstants.themeChanged: "Tema %s selezionato.",
    AppConstants.hideStats: "Nascondi statistiche",
    AppConstants.hideHomeStats: "Nascondi statistiche home",
    AppConstants.hideInsightsStats: "Nascondi statistiche analisi",

    // Reflection Sheet
    AppConstants.reflectionTitle: "RIFLESSIONE",
    AppConstants.reflectButton: "Rifletti",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "PIN errato",
    AppConstants.verifyYourPin: "Verifica il tuo PIN",
    AppConstants.setAPin: "Imposta un PIN",
    AppConstants.confirmPin: "Conferma PIN",
    AppConstants.pinsDoNotMatch: "I PIN non corrispondono",
    AppConstants.setPin: "Imposta PIN",
    AppConstants.hello: "Ciao!",
    AppConstants.enterYourPin: "Inserisci il tuo PIN",
    AppConstants.useBiometrics: "Usa biometria",
    AppConstants.authenticateToUnlock:
        "Autenticati per sbloccare l'app",
    AppConstants.databaseEncryption: "Crittografia database",
    AppConstants.databaseEncryptionDesc: "Crittografia locale AES-256-GCM",
    AppConstants.changeMasterPassword: "Cambia password principale",
    AppConstants.biometricUnlock: "Sblocco biometrico",
    AppConstants.enterMasterPassword: "Inserisci password principale",
    AppConstants.enterMasterPasswordHint:
        "Inserisci la password principale per decifrare il tuo diario.",
    AppConstants.unlockButton: "Sblocca",
    AppConstants.unlockWithBiometrics: "Sblocca con biometria",
    AppConstants.incorrectMasterPassword:
        "Password principale errata. Riprova.",
    AppConstants.databaseEncryptedSuccess:
        "Database del diario cifrato con AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Database del diario decifrato e blocco app disattivato.",
    AppConstants.masterPasswordChangedSuccess:
        "Password principale aggiornata con successo.",
    AppConstants.encryptedBackupPasswordRequired:
        "È necessaria una password per aprire un backup cifrato.",
    AppConstants.incorrectBackupPassword: "Password del backup errata.",
    AppConstants.invalidBackupFile:
        "Il file selezionato non è un backup OpenJot valido.",
    AppConstants.encryptedBackup: "Backup cifrato (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Protetto con AES-256-GCM e password di backup",
    AppConstants.standardBackup: "Backup standard (.zip)",
    AppConstants.standardBackupDesc:
        "Archivio non cifrato compatibile con tutte le versioni",
    AppConstants.takingBackup: "Creazione backup...",
    AppConstants.encryptingBackup: "Crittografia backup...",
    AppConstants.savingBackup: "Salvataggio backup...",
    AppConstants.preparingBackup: "Preparazione backup...",
    AppConstants.decryptingBackup: "Decifratura backup...",
    AppConstants.restoringBackup: "Ripristino backup...",
    AppConstants.backupEncodingFailed:
        "Impossibile codificare il file di backup.",
    AppConstants.backupCreatedSuccess: "Backup creato con successo!",
    AppConstants.backupFailed: "Creazione backup non riuscita: %s",
    AppConstants.restorePermissionsRequired:
        "Per ripristinare i dati sono necessari i permessi di archiviazione e media.",
    AppConstants.databaseRestoredNoMedia:
        "Database ripristinato. Nessun contenuto multimediale trovato nel backup.",
    AppConstants.restoreSuccess: "Ripristino riuscito!",
    AppConstants.restoreSuccessRestartRecommended:
        "Ripristino riuscito. Si consiglia un riavvio per applicare tutte le modifiche.",
    AppConstants.restoreFailed: "Ripristino dati non riuscito: %s",
    AppConstants.storagePermissionsRequired:
        "Per creare un backup sono necessari i permessi di archiviazione e media.",
    AppConstants.selectBackupFolder:
        "Seleziona una cartella per salvare il backup",
    AppConstants.encryptDatabase: "Cifra database",
    AppConstants.disableEncryption: "Disattiva crittografia",
    AppConstants.backupPasswordTitle: "Password backup",
    AppConstants.changeMasterPasswordDesc:
        "Inserisci la password principale attuale e scegline una nuova (minimo 6 caratteri).",
    AppConstants.disableEncryptionDesc:
        "Inserisci la password principale per decifrare il database su disco e disattivare la crittografia.",
    AppConstants.enableEncryptionDesc:
        "Proteggi localmente tutte le note con crittografia AES-256-GCM. Se dimentichi la password principale, i dati cifrati non potranno essere recuperati.",
    AppConstants.verifyForBiometricsDesc:
        "Inserisci la password principale una volta per salvare una chiave nell'archiviazione sicura hardware per lo sblocco biometrico rapido.",
    AppConstants.createBackupPasswordDesc:
        "Imposta una password sicura per cifrare questo backup .openjot. Ti servirà per ripristinarlo su qualsiasi dispositivo.",
    AppConstants.enterBackupPasswordDesc:
        "Inserisci la password utilizzata alla creazione di questo backup .openjot.",
    AppConstants.updatePasswordAction: "Aggiorna password",
    AppConstants.decryptAndDisable: "Decifra e disattiva",
    AppConstants.enableBiometricsAction: "Attiva biometria",
    AppConstants.createBackupAction: "Crea backup",
    AppConstants.decryptBackupAction: "Decifra backup",
    AppConstants.newMasterPasswordHint: "Nuova password principale",
    AppConstants.backupPasswordHint: "Password backup",
    AppConstants.masterPasswordHint: "Password principale",
    AppConstants.enterCurrentMasterPasswordError:
        "Inserisci la password principale attuale.",
    AppConstants.passwordEmptyError: "La password non può essere vuota.",
    AppConstants.passwordMinLengthError:
        "La password deve contenere almeno 6 caratteri.",
    AppConstants.passwordsDoNotMatchError: "Le password non corrispondono.",
    AppConstants.currentMasterPasswordHint: "Password principale attuale",
    AppConstants.confirmPasswordHint: "Conferma password",

    // About & Terms
    AppConstants.aboutApp: "Informazioni su OpenJot",
    AppConstants.versionPrefix: "Versione: %s",
    AppConstants.aboutSubtitle:
        "Un diario minimalista e open source per annotare pensieri, stati d'animo e ricordi. Tutti i dati restano sul tuo dispositivo.",
    AppConstants.keyFeatures: "Funzionalità principali",
    AppConstants.aboutFeature1:
        "• Esperienza di scrittura pulita e senza distrazioni.",
    AppConstants.aboutFeature2:
        "• Aggiungi foto, note vocali e musica alle tue voci.",
    AppConstants.aboutFeature3:
        "• Registra il tuo umore insieme al diario.",
    AppConstants.aboutFeature4: "• Personalizza con diversi stili di testo.",
    AppConstants.aboutFeature5:
        "• Funziona completamente offline, i tuoi dati restano sul dispositivo.",
    AppConstants.openSource: "Open Source",
    AppConstants.openSourceDesc:
        "OpenJot è un'app open source. Il codice sorgente è pubblicamente disponibile per chiunque voglia ispezionarlo, modificarlo e contribuire. Crediamo nella trasparenza e nella collaborazione.",
    AppConstants.dataPrivacy: "Privacy dei dati",
    AppConstants.dataPrivacyDesc:
        "Teniamo alla tua privacy. OpenJot non raccoglie, archivia né trasmette alcun dato personale. Tutte le voci, incluse immagini e audio, restano esclusivamente sul tuo dispositivo.",
    AppConstants.linksTitle: "Collegamenti",
    AppConstants.sourceCodeOnGithub: "Codice sorgente su GitHub",
    AppConstants.sendFeedback: "Invia feedback",
    AppConstants.couldNotLaunchUrl: "Impossibile aprire l'URL",
    AppConstants.termsIntro:
        "Benvenuto in OpenJot! Questo documento descrive i termini e le condizioni d'uso della nostra applicazione. Utilizzando OpenJot, accetti questi termini.",
    AppConstants.termsSectionDataPrivacy:
        "Archiviazione dati e privacy",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot è progettato come spazio privato per i tuoi pensieri. Tutte le voci, inclusi testo, immagini, file audio e altri media, sono memorizzate esclusivamente sul dispositivo locale. L'app non raccoglie né invia dati a server esterni.",
    AppConstants.termsSectionUserContent: "Contenuti generati dall'utente",
    AppConstants.termsSectionUserContentBody:
        "Sei l'unico responsabile dei contenuti creati e salvati in OpenJot, inclusi testi, immagini e registrazioni audio. È tua responsabilità assicurarti di disporre dei diritti necessari per i contenuti importati.",
    AppConstants.termsSectionDisclaimer: "Esclusione di garanzia",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot è fornito \"così com'è\" senza garanzie di alcun tipo, espresse o implicite. Non garantiamo che l'app sia priva di errori o interruzioni. L'uso è a tuo rischio.",
    AppConstants.termsSectionLiability: "Limitazione di responsabilità",
    AppConstants.termsSectionLiabilityBody:
        "In nessun caso gli sviluppatori di OpenJot saranno responsabili per danni diretti, indiretti, incidentali, speciali o consequenziali, inclusa la perdita di dati, derivanti dall'uso o dall'impossibilità di usare l'app.",
    AppConstants.termsSectionThirdParty: "Librerie di terze parti",
    AppConstants.termsSectionThirdPartyBody:
        "Questa applicazione utilizza le seguenti librerie di terze parti, ciascuna regolata dalla propria licenza:",

    // Months
    'January': 'Gennaio',
    'February': 'Febbraio',
    'March': 'Marzo',
    'April': 'Aprile',
    'May': 'Maggio',
    'June': 'Giugno',
    'July': 'Luglio',
    'August': 'Agosto',
    'September': 'Settembre',
    'October': 'Ottobre',
    'November': 'Novembre',
    'December': 'Dicembre',

    // Reflection Prompts (61)
    "What made you smile today?": "Cosa ti ha fatto sorridere oggi?",
    "Who are you thankful for this week, and why?":
        "A chi sei grato questa settimana e perché?",
    "What is something small that brought you joy today?":
        "Quale piccola cosa ti ha portato gioia oggi?",
    "Which part of your day felt most comforting?":
        "Quale parte della giornata ti è sembrata più confortante?",
    "What’s something you often take for granted but appreciate now?":
        "Cosa dai spesso per scontato ma ora apprezzi?",
    "What’s the best thing that happened today?":
        "Qual è la cosa migliore successa oggi?",
    "Did someone make your day easier today?":
        "Qualcuno ti ha reso la giornata più semplice oggi?",
    "Who made a positive impact on you recently?":
        "Chi ha avuto un impatto positivo su di te di recente?",
    "What’s a quality you admire in someone close to you?":
        "Quale qualità ammiri in una persona a te vicina?",
    "When did you last feel truly connected with someone?":
        "Quando ti sei sentito l'ultima volta davvero connesso a qualcuno?",
    "Who do you want to reach out to soon?":
        "Chi vorresti contattare presto?",
    "Did someone’s kindness stand out today?":
        "Oggi ti ha colpito la gentilezza di qualcuno?",
    "How did you support someone else recently?":
        "Come hai sostenuto qualcun altro di recente?",
    "Who do you miss the most right now?":
        "Chi ti manca di più in questo momento?",
    "What’s a moment from today you want to remember?":
        "Quale momento di oggi vuoi ricordare?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Quale dettaglio di oggi potresti dimenticare se non lo annoti?",
    "What’s the most peaceful moment you had today?":
        "Qual è stato il momento più sereno della tua giornata?",
    "Did you see something beautiful today?":
        "Hai visto qualcosa di bello oggi?",
    "Which memory from this week stands out?":
        "Quale ricordo di questa settimana spicca?",
    "What song, photo, or place will always remind you of today?":
        "Quale canzone, foto o luogo ti ricorderà sempre oggi?",
    "What surprised you today?": "Cosa ti ha sorpreso oggi?",
    "What challenge did you overcome today?":
        "Quale sfida hai superato oggi?",
    "What’s a small win you had today?":
        "Quale piccola vittoria hai ottenuto oggi?",
    "What new thing did you learn about yourself recently?":
        "Cosa hai imparato di nuovo su di te di recente?",
    "What are you proud of yourself for?":
        "Di cosa sei fiero di te stesso?",
    "What habit do you feel good about keeping?":
        "Quale abitudine ti fa stare bene mantenere?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Quale miglioramento hai notato in te quest'anno?",
    "How did you push yourself out of your comfort zone?":
        "Come sei uscito dalla tua zona di comfort?",
    "How are you truly feeling right now?":
        "Come ti senti davvero in questo momento?",
    "Which emotion stood out the most today?":
        "Quale emozione ha prevalso oggi?",
    "Did you feel present in any moment today?":
        "Ti sei sentito presente in qualche momento oggi?",
    "When did you feel the most at peace today?":
        "Quando ti sei sentito più in pace oggi?",
    "What gave you energy today?": "Cosa ti ha dato energia oggi?",
    "What drained your energy today?": "Cosa ti ha tolto energia oggi?",
    "If your mood had a color today, what would it be?":
        "Se il tuo umore oggi avesse un colore, quale sarebbe?",
    "What’s something you’re excited about tomorrow?":
        "Per cosa sei entusiasta per domani?",
    "What’s one thing you want to improve tomorrow?":
        "Cosa vorresti migliorare domani?",
    "What would make tomorrow feel successful?":
        "Cosa renderebbe domani un giorno riuscito?",
    "What do you hope to achieve this week?":
        "Cosa speri di ottenere questa settimana?",
    "What’s a habit you’d like to start tomorrow?":
        "Quale abitudine vorresti iniziare domani?",
    "What’s something you want to look forward to in the next month?":
        "Cosa aspetti con piacere nel prossimo mese?",
    "What would your ideal tomorrow look like?":
        "Come sarebbe il tuo domani ideale?",
    "What’s one lesson you learned recently?":
        "Quale lezione hai imparato di recente?",
    "If you could freeze one moment today, which would it be?":
        "Se potessi fermare un momento di oggi, quale sarebbe?",
    "What makes your life feel meaningful right now?":
        "Cosa rende significativa la tua vita in questo momento?",
    "If you described today in one word, what would it be?":
        "Se descrivessi oggi in una parola, quale sarebbe?",
    "What inspired you today?": "Cosa ti ha ispirato oggi?",
    "What did you notice today that you usually overlook?":
        "Cosa hai notato oggi che di solito trascuri?",
    "How has today changed your perspective?":
        "In che modo oggi ha cambiato la tua prospettiva?",
    "What’s something you’ve been overthinking?":
        "Su cosa stai rimuginando troppo?",
    "What do you need to let go of?": "Cosa hai bisogno di lasciar andare?",
    "What part of nature did you notice today?":
        "Quale aspetto della natura hai notato oggi?",
    "Did the weather affect your mood today?":
        "Il meteo ha influenzato il tuo umore oggi?",
    "What place felt most comforting today?":
        "Quale luogo ti è sembrato più accogliente oggi?",
    "Where did you feel most at home today?":
        "Dove ti sei sentito più a casa oggi?",
    "What sound or smell reminded you of something important?":
        "Quale suono o odore ti ha ricordato qualcosa di importante?",
    "How did you take care of yourself today?":
        "Come ti sei preso cura di te oggi?",
    "When did you feel most like yourself today?":
        "Quando ti sei sentito più te stesso oggi?",
    "What’s something kind you can say to yourself right now?":
        "Qualcosa di gentile che puoi dirti proprio ora?",
    "What do you want to forgive yourself for?":
        "Per cosa vuoi perdonarti?",
    "What do you deserve more of in your life?":
        "Di cosa meriti di più nella tua vita?",
  },
};
