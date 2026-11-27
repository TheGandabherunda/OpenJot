import '../constants.dart';

/// Complete Western & Northern European translations (Part 2):
/// Portuguese (`pt`), Dutch (`nl`), Catalan (`ca`), Swedish (`sv`).
final Map<String, Map<String, String>> europeWest2Translations =
    <String, Map<String, String>>{
  'pt': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Meu diário",
    AppConstants.noEntriesMessage:
        "Nenhuma entrada no diário ainda. Comece a escrever!",
    AppConstants.noBookmarksYet: "Nenhum favorito ainda.",
    AppConstants.noDraftsYet: "Nenhum rascunho ainda.",
    AppConstants.addEntryButton: "Adicionar nova entrada",
    AppConstants.jotYourThoughts: "Anote seus pensamentos",
    AppConstants.tapToCreateJournal:
        "Toque em + para criar seu diário pessoal.",
    AppConstants.entriesThisYear: "Entradas este ano",
    AppConstants.wordsWritten: "Palavras escritas",
    AppConstants.daysJournaled: "Dias registrados",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nova entrada no diário",
    AppConstants.editEntryAppBarTitle: "Editar entrada do diário",
    AppConstants.titleHintText: "Título (ex.: 'Meu dia', 'Reflexões...')",
    AppConstants.contentHintText: "Escreva seus pensamentos aqui...",
    AppConstants.saveButton: "Salvar entrada",
    AppConstants.updateButton: "Atualizar",
    AppConstants.deleteButton: "Excluir entrada",
    AppConstants.requiredFieldMessage: "Este campo não pode ficar vazio.",
    AppConstants.newEntry: "Nova entrada",
    AppConstants.todayDate: "Data de hoje",
    AppConstants.customDate: "Data personalizada",
    AppConstants.done: "Concluído",
    AppConstants.startWriting: " Comece a escrever...",
    AppConstants.tags: "Tags",
    AppConstants.addTags: "Adicionar tags",
    AppConstants.openInMaps: "Abrir no Mapas",
    AppConstants.changeLocation: "Alterar local",
    AppConstants.remove: "Remover",
    AppConstants.discardSelectionsTitle: "Descartar seleções?",
    AppConstants.discardSelectionsMessage:
        "Você selecionou mídia ou uma gravação ativa. Tem certeza de que deseja descartá-las?",
    AppConstants.journalEntryEmpty:
        "A entrada do diário não pode ficar vazia",
    AppConstants.discardDateConfirm:
        "Descartar a data/hora selecionada para esta entrada?",
    AppConstants.addMediaLocationMoodFirst:
        "Adicione primeiro mídia, local ou humor",
    AppConstants.location: "Localização",
    AppConstants.record: "Gravar",
    AppConstants.selectMomentsToJournal:
        "Selecione momentos para registrar",
    AppConstants.addMomentsFromMenu:
        "Adicione mídia, local, gravação ou humor pelo menu",
    AppConstants.writeSomething: "Escreva algo",
    AppConstants.saveWithoutWriting: "Salvar sem escrever",
    AppConstants.oneLocation: "1 local",
    AppConstants.mediaCount: "%d mídias",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Confirmar exclusão",
    AppConstants.confirmDeleteMessage:
        "Tem certeza de que deseja excluir esta entrada?",
    AppConstants.pleaseConfirm: "Confirme",
    AppConstants.confirmDeleteJournalEntry:
        "Tem certeza de que deseja excluir esta entrada do diário? Esta ação é irreversível.",
    AppConstants.yes: "Sim",
    AppConstants.no: "Não",
    AppConstants.cancel: "Cancelar",
    AppConstants.delete: "Excluir",
    AppConstants.save: "Salvar",
    AppConstants.entrySavedSuccess: "Entrada salva com sucesso!",
    AppConstants.entryUpdatedSuccess: "Entrada atualizada com sucesso!",
    AppConstants.entryDeletedSuccess: "Entrada excluída.",
    AppConstants.errorSavingEntry: "Erro ao salvar a entrada.",
    AppConstants.errorDeletingEntry: "Erro ao excluir a entrada.",
    AppConstants.errorLoadingEntries: "Erro ao carregar entradas do diário.",
    AppConstants.noEntriesForDate: "Nenhuma entrada para esta data.",
    AppConstants.noEntriesForMonth:
        "Nenhuma entrada encontrada para este mês.",
    AppConstants.selectMonthAndYear: "Selecionar mês e ano",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Muito desagradável",
    AppConstants.unpleasant: "Desagradável",
    AppConstants.slightlyUnpleasant: "Um pouco desagradável",
    AppConstants.neutral: "Neutro",
    AppConstants.slightlyPleasant: "Um pouco agradável",
    AppConstants.pleasant: "Agradável",
    AppConstants.veryPleasant: "Muito agradável",
    AppConstants.reflection: "Reflexão",
    AppConstants.edit: "Editar",
    AppConstants.removeBookmark: "Remover favorito",
    AppConstants.bookmark: "Favorito",
    AppConstants.share: "Compartilhar",
    AppConstants.saveAsPdf: "Salvar como PDF",
    AppConstants.audioTrack: "Faixa de áudio",
    AppConstants.generatingPdf: "Gerando PDF...",
    AppConstants.voiceRecording: "Gravação de voz",
    AppConstants.audioRecording: "Gravação de áudio",
    AppConstants.couldNotLoadAudio:
        "Não foi possível carregar o arquivo de áudio.",
    AppConstants.stateOfMind: "Estado de espírito",

    // Mood Colors
    AppConstants.moodColors: "Cores de humor",
    AppConstants.customizeMoodColors: "Personalizar cores de humor",
    AppConstants.reset: "Redefinir",
    AppConstants.resetMoodColors: "Redefinir padrão",
    AppConstants.resetMoodColorsConfirm:
        "Redefinir todas as cores de humor para o padrão?",
    AppConstants.paletteThemes: "Temas de paleta",
    AppConstants.customColor: "Cor personalizada",
    AppConstants.moodUnsavedChangesMessage:
        "Você tem alterações não salvas nas cores de humor. Deseja salvá-las antes de fechar?",

    // Drafts & Auto-save
    AppConstants.drafts: "Rascunhos",
    AppConstants.draft: "Rascunho",
    AppConstants.draftSaved: "Salvo nos rascunhos",
    AppConstants.unsavedChanges: "Alterações não salvas",
    AppConstants.unsavedChangesMessage:
        "Você tem alterações não salvas. Deseja salvá-las como rascunho ou descartá-las?",
    AppConstants.saveAsDraft: "Salvar como rascunho",
    AppConstants.discardChanges: "Descartar",
    AppConstants.autoDeleteDrafts: "Excluir rascunhos automaticamente",
    AppConstants.days7: "7 dias",
    AppConstants.never: "Nunca",
    AppConstants.custom: "Personalizado...",
    AppConstants.enterCustomDays: "Inserir dias personalizados",
    AppConstants.customDaysExample: "Ex.: 14",
    AppConstants.days: "Dias",
    AppConstants.draftsNeverDeleted: "Os rascunhos nunca serão excluídos",
    AppConstants.draftsDeletedAfterDays:
        "Os rascunhos serão excluídos após %d dias",

    // Home Menu & Sorting
    AppConstants.sortBy: "Ordenar por",
    AppConstants.insights: "Estatísticas",
    AppConstants.reflections: "Reflexões",
    AppConstants.settings: "Configurações",
    AppConstants.entryTime: "Hora da entrada",
    AppConstants.bookmarkFirst: "Favoritos primeiro",
    AppConstants.reflectionFirst: "Reflexões primeiro",
    AppConstants.withMediaFirst: "Com mídia primeiro",
    AppConstants.textOnlyFirst: "Somente texto primeiro",
    AppConstants.withLocationFirst: "Com local primeiro",
    AppConstants.withMoodFirst: "Com humor primeiro",
    AppConstants.withTagsFirst: "Com tags primeiro",

    // Insights
    AppConstants.stats: "Estatísticas",
    AppConstants.calendar: "Calendário",
    AppConstants.entriesSuffix: " entradas",
    AppConstants.memoriesFromThisDay: "Memórias deste dia",
    AppConstants.standard: "Padrão",
    AppConstants.media: "Mídia",
    AppConstants.mood: "Humor",
    AppConstants.mostly: "Principalmente",
    AppConstants.averageForThisDay: "Média para este dia",
    AppConstants.averageForThisYear: "Média para este ano",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Bem-vindo ao OpenJot",
    AppConstants.feature1:
        "Escreva livremente, adicione fotos e locais e mantenha tudo seguro no seu dispositivo.",
    AppConstants.feature2:
        "Compreenda suas emoções ao longo do tempo com o acompanhamento integrado de humor.",
    AppConstants.feature3:
        "Seus dados ficam no seu telefone – sem nuvem, apenas armazenamento local e total privacidade.",
    AppConstants.continueButton: "Continuar",

    // Notifications
    AppConstants.notificationTitle: "Hora de escrever no diário!",
    AppConstants.notificationBody:
        "Não se esqueça de anotar seus pensamentos do dia.",
    AppConstants.notificationChannelName: "Lembretes diários do diário",
    AppConstants.notificationChannelDescription:
        "Canal para notificações diárias de lembrete",
    AppConstants.onThisDayChannelName: "Memórias neste dia",
    AppConstants.onThisDayChannelDescription:
        "Notificações de memórias de anos anteriores.",
    AppConstants.onThisDayNotificationTitle: "Uma lembrança do seu diário",
    AppConstants.onThisDaySingleEntry:
        "Há um ano hoje você escreveu algo especial. Toque para revisitar seus pensamentos.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Neste dia no ano passado você compartilhou esta lembrança. Toque para revivê-la.",
    AppConstants.onThisDayMultipleEntries:
        "Você tem memórias deste dia em anos anteriores. Toque para revê-las.",
    AppConstants.onThisDayGroupedNotification:
        "Você tem %d memórias deste dia",

    // Exclude Entries
    AppConstants.excludeEntries: "Excluir entradas",
    AppConstants.saveExclusions: "Salvar exclusões",
    AppConstants.excludeUnsavedChangesMessage:
        "Você tem alterações não salvas. Tem certeza de que deseja descartá-las e sair?",
    AppConstants.sortDefault: "Padrão",
    AppConstants.sortMutedFirst: "Silenciadas primeiro",
    AppConstants.sortUnmutedFirst: "Ativas primeiro",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Hoje",
    AppConstants.yesterday: "Ontem",
    AppConstants.contentForQuote: "Conteúdo para citação",
    AppConstants.noContentSelected: "Nenhum conteúdo selecionado.",
    AppConstants.photos: "Fotos",
    AppConstants.video: "Vídeo",
    AppConstants.audio: "Áudio",
    AppConstants.add: "Adicionar",
    AppConstants.noMediaFound: "Nenhum %s encontrado.",
    AppConstants.permissionRequired:
        "É necessária permissão para acessar %s para exibi-los.",
    AppConstants.openSettings: "Abrir configurações",
    AppConstants.videos: "Vídeos",
    AppConstants.audios: "Áudios",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Excluir gravação?",
    AppConstants.deleteRecordingMessage:
        "Tem certeza de que deseja excluir esta gravação?",
    AppConstants.listen: "Ouvir",
    AppConstants.tapAndHold: "toque e segure",
    AppConstants.clear: "Limpar",
    AppConstants.all: "Tudo",
    AppConstants.folder: "Pasta",
    AppConstants.browse: "Explorar",
    AppConstants.tiles: "Blocos",
    AppConstants.graph: "Gráfico",
    AppConstants.recording: "Gravando...",
    AppConstants.recordingLabel: "Gravação",
    AppConstants.startAudioRecording: "Iniciar gravação de áudio",
    AppConstants.howAreYouFeeling: "Como você está se sentindo?",
    AppConstants.paused: "Pausado",
    AppConstants.stop: "Parar",
    AppConstants.tapOrHoldToResume: "Toque ou segure para retomar",
    AppConstants.tapOrReleaseToPause: "Toque ou solte para pausar",
    AppConstants.unsupportedImageType: "Tipo de imagem não compatível",
    AppConstants.couldNotLoadVideo: "Não foi possível carregar o vídeo",
    AppConstants.couldNotOpenMap: "Não foi possível abrir o link do mapa.",
    AppConstants.dismiss: "Fechar",
    AppConstants.selectTime: "Selecionar hora",
    AppConstants.now: "Agora",
    AppConstants.searchPlacesHint: "Buscar lugares, lojas...",
    AppConstants.locationPermissionDenied:
        "Permissão de localização negada.",
    AppConstants.failedGetCurrentLocation:
        "Falha ao obter a localização atual.",

    // Search
    AppConstants.searchJournalsHint: "Pesquisar diários...",
    AppConstants.textOnly: "Somente texto",
    AppConstants.withMedia: "Com mídia",
    AppConstants.withMood: "Com humor",
    AppConstants.withLocation: "Com local",
    AppConstants.withTags: "Com tags",
    AppConstants.noResultsFound: "Nenhum resultado encontrado",
    AppConstants.searchHintText: "Pesquisar entradas...",

    // Settings
    AppConstants.language: "Idioma",
    AppConstants.selectLanguage: "Selecionar idioma",
    AppConstants.systemDefault: "Padrão do sistema",
    AppConstants.searchLanguagesHint: "Pesquisar idiomas...",
    AppConstants.languageChanged: "Idioma alterado para %s.",
    AppConstants.dailyReminder: "Lembretes",
    AppConstants.addReminder: "Adicionar lembrete",
    AppConstants.deleteReminder: "Excluir lembrete",
    AppConstants.noRemindersSet: "Nenhum lembrete definido.",
    AppConstants.onThisDay: "Neste dia",
    AppConstants.appLock: "Bloqueio do app",
    AppConstants.backup: "Backup",
    AppConstants.restore: "Restaurar",
    AppConstants.importFromAnotherApp: "Importar de outro app",
    AppConstants.importFromDailyYou: "Importar do Daily You",
    AppConstants.selectDailyYouBackup:
        "Selecione o arquivo zip de backup do Daily You",
    AppConstants.importingEntries: "Importando entradas...",
    AppConstants.importSuccess:
        "%d entradas importadas do Daily You com sucesso!",
    AppConstants.importFailed: "Falha na importação: %s",
    AppConstants.noEntriesToImport:
        "Nenhuma nova entrada encontrada para importar.",
    AppConstants.askSupport: "Pedir suporte",
    AppConstants.importSupportNote:
        "Outros formatos de aplicativos podem não suportar todos os recursos. Se encontrar problemas ou os formatos mudarem, envie um relatório de problema.",
    AppConstants.extractingBackup: "Extraindo backup...",
    AppConstants.parsingDatabase: "Analisando banco de dados...",
    AppConstants.dailyYouDbNotFound:
        "Banco de dados do Daily You não encontrado no backup.",
    AppConstants.privacyPolicy: "Política de privacidade",
    AppConstants.termsNConditions: "Termos e condições",
    AppConstants.about: "Sobre o app",
    AppConstants.changeTheme: "Alterar tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Preto absoluto",
    AppConstants.themeLight: "Claro",
    AppConstants.themeDark: "Escuro",
    AppConstants.themeSystem: "Sistema",
    AppConstants.changePin: "Alterar PIN",
    AppConstants.loading: "Carregando...",
    AppConstants.confirmRestoreTitle: "Confirmar restauração",
    AppConstants.confirmRestoreMessage:
        "Restaurar de um backup substituirá todos os dados atuais. Esta ação não pode ser desfeita. Deseja continuar?",
    AppConstants.notificationScheduled: "Notificação agendada para %s",
    AppConstants.notificationCanceled: "Notificação cancelada",
    AppConstants.notificationRescheduled: "Notificação reagendada para %s",
    AppConstants.notificationPermissionRequired:
        "A permissão de notificação é necessária para definir lembretes.",
    AppConstants.pinChangedSuccess: "PIN alterado com sucesso",
    AppConstants.onThisDayOn: "Agora você receberá memórias deste dia.",
    AppConstants.onThisDayOff:
        "Os lembretes de 'Neste dia' estão desativados.",
    AppConstants.themeChanged: "Tema %s selecionado.",
    AppConstants.hideStats: "Ocultar estatísticas",
    AppConstants.hideHomeStats: "Ocultar estatísticas da tela inicial",
    AppConstants.hideInsightsStats: "Ocultar estatísticas de análises",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEXÃO",
    AppConstants.reflectButton: "Refletir",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "PIN incorreto",
    AppConstants.verifyYourPin: "Verifique seu PIN",
    AppConstants.setAPin: "Definir um PIN",
    AppConstants.confirmPin: "Confirmar PIN",
    AppConstants.pinsDoNotMatch: "Os PINs não coincidem",
    AppConstants.setPin: "Definir PIN",
    AppConstants.hello: "Olá!",
    AppConstants.enterYourPin: "Digite seu PIN",
    AppConstants.useBiometrics: "Usar biometria",
    AppConstants.authenticateToUnlock:
        "Autentique-se para desbloquear o app",
    AppConstants.databaseEncryption: "Criptografia do banco de dados",
    AppConstants.databaseEncryptionDesc: "Criptografia local AES-256-GCM",
    AppConstants.changeMasterPassword: "Alterar senha mestra",
    AppConstants.biometricUnlock: "Desbloqueio biométrico",
    AppConstants.enterMasterPassword: "Digite a senha mestra",
    AppConstants.enterMasterPasswordHint:
        "Digite sua senha mestra para descriptografar seu diário.",
    AppConstants.unlockButton: "Desbloquear",
    AppConstants.unlockWithBiometrics: "Desbloquear com biometria",
    AppConstants.incorrectMasterPassword:
        "Senha mestra incorreta. Tente novamente.",
    AppConstants.databaseEncryptedSuccess:
        "Banco de dados criptografado com AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Banco de dados descriptografado e bloqueio desativado.",
    AppConstants.masterPasswordChangedSuccess:
        "Senha mestra atualizada com sucesso.",
    AppConstants.encryptedBackupPasswordRequired:
        "É necessária uma senha para abrir um backup criptografado.",
    AppConstants.incorrectBackupPassword: "Senha de backup incorreta.",
    AppConstants.invalidBackupFile:
        "O arquivo selecionado não é um backup OpenJot válido.",
    AppConstants.encryptedBackup: "Backup criptografado (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Protegido com AES-256-GCM e senha de backup",
    AppConstants.standardBackup: "Backup padrão (.zip)",
    AppConstants.standardBackupDesc:
        "Arquivo não criptografado compatível com todas as versões",
    AppConstants.takingBackup: "Fazendo backup...",
    AppConstants.encryptingBackup: "Criptografando backup...",
    AppConstants.savingBackup: "Salvando backup...",
    AppConstants.preparingBackup: "Preparando backup...",
    AppConstants.decryptingBackup: "Descriptografando backup...",
    AppConstants.restoringBackup: "Restaurando backup...",
    AppConstants.backupEncodingFailed:
        "Falha ao codificar o arquivo de backup.",
    AppConstants.backupCreatedSuccess: "Backup criado com sucesso!",
    AppConstants.backupFailed: "Falha ao criar backup: %s",
    AppConstants.restorePermissionsRequired:
        "Permissões de armazenamento e mídia são necessárias para restaurar dados.",
    AppConstants.databaseRestoredNoMedia:
        "Banco de dados restaurado. Nenhuma mídia encontrada no backup.",
    AppConstants.restoreSuccess: "Restauração concluída!",
    AppConstants.restoreSuccessRestartRecommended:
        "Restauração concluída. Recomenda-se reiniciar para aplicar todas as alterações.",
    AppConstants.restoreFailed: "Falha ao restaurar dados: %s",
    AppConstants.storagePermissionsRequired:
        "Permissões de armazenamento e mídia são necessárias para criar um backup.",
    AppConstants.selectBackupFolder:
        "Selecione uma pasta para salvar o backup",
    AppConstants.encryptDatabase: "Criptografar banco de dados",
    AppConstants.disableEncryption: "Desativar criptografia",
    AppConstants.backupPasswordTitle: "Senha do backup",
    AppConstants.changeMasterPasswordDesc:
        "Digite sua senha mestra atual e escolha uma nova senha (mínimo 6 caracteres).",
    AppConstants.disableEncryptionDesc:
        "Digite sua senha mestra para descriptografar o banco de dados no disco e desativar a criptografia.",
    AppConstants.enableEncryptionDesc:
        "Proteja todas as notas localmente com criptografia AES-256-GCM. Se você esquecer a senha mestra, seus dados criptografados não poderão ser recuperados.",
    AppConstants.verifyForBiometricsDesc:
        "Digite sua senha mestra uma vez para armazenar uma chave no armazenamento seguro de hardware para desbloqueio biométrico rápido.",
    AppConstants.createBackupPasswordDesc:
        "Defina uma senha forte para criptografar este backup .openjot. Você precisará dela para restaurá-lo em qualquer dispositivo.",
    AppConstants.enterBackupPasswordDesc:
        "Digite a senha usada ao criar este backup .openjot.",
    AppConstants.updatePasswordAction: "Atualizar senha",
    AppConstants.decryptAndDisable: "Descriptografar e desativar",
    AppConstants.enableBiometricsAction: "Ativar biometria",
    AppConstants.createBackupAction: "Criar backup",
    AppConstants.decryptBackupAction: "Descriptografar backup",
    AppConstants.newMasterPasswordHint: "Nova senha mestra",
    AppConstants.backupPasswordHint: "Senha do backup",
    AppConstants.masterPasswordHint: "Senha mestra",
    AppConstants.enterCurrentMasterPasswordError:
        "Por favor, digite sua senha mestra atual.",
    AppConstants.passwordEmptyError: "A senha não pode ficar vazia.",
    AppConstants.passwordMinLengthError:
        "A senha deve ter pelo menos 6 caracteres.",
    AppConstants.passwordsDoNotMatchError: "As senhas não coincidem.",
    AppConstants.currentMasterPasswordHint: "Senha mestra atual",
    AppConstants.confirmPasswordHint: "Confirmar senha",

    // About & Terms
    AppConstants.aboutApp: "Sobre o OpenJot",
    AppConstants.versionPrefix: "Versão: %s",
    AppConstants.aboutSubtitle:
        "Um diário minimalista e de código aberto para registrar seus pensamentos, humores e memórias. Todos os seus dados ficam no seu dispositivo.",
    AppConstants.keyFeatures: "Principais recursos",
    AppConstants.aboutFeature1:
        "• Experiência de escrita limpa e sem distrações.",
    AppConstants.aboutFeature2:
        "• Adicione fotos, notas de voz e música às suas entradas.",
    AppConstants.aboutFeature3: "• Registre seu humor junto ao diário.",
    AppConstants.aboutFeature4:
        "• Personalize com diferentes estilos de texto.",
    AppConstants.aboutFeature5:
        "• Funciona totalmente offline; seus dados ficam no seu dispositivo.",
    AppConstants.openSource: "Código aberto",
    AppConstants.openSourceDesc:
        "OpenJot é um aplicativo de código aberto. O código-fonte está disponível publicamente para qualquer pessoa inspecionar, modificar e contribuir. Acreditamos em transparência e colaboração.",
    AppConstants.dataPrivacy: "Privacidade dos dados",
    AppConstants.dataPrivacyDesc:
        "Valorizamos sua privacidade. O OpenJot não coleta, armazena nem transmite nenhum dado pessoal. Todas as suas entradas, imagens e áudios são salvos exclusivamente no seu dispositivo.",
    AppConstants.linksTitle: "Links",
    AppConstants.sourceCodeOnGithub: "Código-fonte no GitHub",
    AppConstants.sendFeedback: "Enviar feedback",
    AppConstants.couldNotLaunchUrl: "Não foi possível abrir a URL",
    AppConstants.termsIntro:
        "Bem-vindo ao OpenJot! Este documento descreve os termos e condições de uso do nosso aplicativo. Ao usar o OpenJot, você concorda com estes termos.",
    AppConstants.termsSectionDataPrivacy:
        "Armazenamento de dados e privacidade",
    AppConstants.termsSectionDataPrivacyBody:
        "O OpenJot foi projetado como um espaço privado para seus pensamentos. Todas as entradas, incluindo textos, imagens, arquivos de áudio e outras mídias, ficam armazenadas exclusivamente no dispositivo local. O app não coleta nem envia dados pessoais a servidores externos.",
    AppConstants.termsSectionUserContent: "Conteúdo gerado pelo usuário",
    AppConstants.termsSectionUserContentBody:
        "Você é o único responsável pelo conteúdo criado e armazenado no OpenJot, incluindo textos, imagens e gravações de áudio. É sua responsabilidade garantir os direitos necessários sobre qualquer conteúdo importado.",
    AppConstants.termsSectionDisclaimer: "Isenção de garantia",
    AppConstants.termsSectionDisclaimerBody:
        "O OpenJot é fornecido \"como está\", sem garantias de qualquer tipo, expressas ou implícitas. Não garantimos que o app seja livre de erros ou interrupções. O uso é por sua conta e risco.",
    AppConstants.termsSectionLiability: "Limitação de responsabilidade",
    AppConstants.termsSectionLiabilityBody:
        "Em nenhuma hipótese os desenvolvedores do OpenJot serão responsáveis por danos diretos, indiretos, incidentais, especiais ou consequenciais, incluindo perda de dados, decorrentes do uso ou incapacidade de uso deste aplicativo.",
    AppConstants.termsSectionThirdParty: "Bibliotecas de terceiros",
    AppConstants.termsSectionThirdPartyBody:
        "Este aplicativo utiliza as seguintes bibliotecas de terceiros, cada uma regida por sua própria licença:",

    // Months
    'January': 'Janeiro',
    'February': 'Fevereiro',
    'March': 'Março',
    'April': 'Abril',
    'May': 'Maio',
    'June': 'Junho',
    'July': 'Julho',
    'August': 'Agosto',
    'September': 'Setembro',
    'October': 'Outubro',
    'November': 'Novembro',
    'December': 'Dezembro',

    // Reflection Prompts (61)
    "What made you smile today?": "O que fez você sorrir hoje?",
    "Who are you thankful for this week, and why?":
        "Por quem você é grato esta semana e por quê?",
    "What is something small that brought you joy today?":
        "Que pequena coisa trouxe alegria a você hoje?",
    "Which part of your day felt most comforting?":
        "Qual parte do seu dia pareceu mais reconfortante?",
    "What’s something you often take for granted but appreciate now?":
        "O que você costuma considerar garantido, mas agora valoriza?",
    "What’s the best thing that happened today?":
        "Qual foi a melhor coisa que aconteceu hoje?",
    "Did someone make your day easier today?":
        "Alguém tornou o seu dia mais fácil hoje?",
    "Who made a positive impact on you recently?":
        "Quem teve um impacto positivo em você recentemente?",
    "What’s a quality you admire in someone close to you?":
        "Que qualidade você admira em alguém próximo a você?",
    "When did you last feel truly connected with someone?":
        "Quando foi a última vez que você se sentiu realmente conectado a alguém?",
    "Who do you want to reach out to soon?":
        "Com quem você gostaria de falar em breve?",
    "Did someone’s kindness stand out today?":
        "A gentileza de alguém se destacou hoje?",
    "How did you support someone else recently?":
        "Como você apoiou outra pessoa recentemente?",
    "Who do you miss the most right now?":
        "De quem você sente mais falta neste momento?",
    "What’s a moment from today you want to remember?":
        "Qual momento de hoje você quer lembrar?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Qual detalhe de hoje você pode esquecer se não anotar?",
    "What’s the most peaceful moment you had today?":
        "Qual foi o momento mais tranquilo que você teve hoje?",
    "Did you see something beautiful today?": "Você viu algo bonito hoje?",
    "Which memory from this week stands out?":
        "Qual lembrança desta semana se destaca?",
    "What song, photo, or place will always remind you of today?":
        "Qual música, foto ou lugar sempre lembrará você de hoje?",
    "What surprised you today?": "O que surpreendeu você hoje?",
    "What challenge did you overcome today?": "Que desafio você superou hoje?",
    "What’s a small win you had today?":
        "Qual pequena vitória você teve hoje?",
    "What new thing did you learn about yourself recently?":
        "O que você aprendeu de novo sobre si mesmo recentemente?",
    "What are you proud of yourself for?":
        "Do que você se orgulha em si mesmo?",
    "What habit do you feel good about keeping?":
        "Qual hábito faz você se sentir bem em manter?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Qual melhoria você notou em si mesmo este ano?",
    "How did you push yourself out of your comfort zone?":
        "Como você saiu da sua zona de conforto?",
    "How are you truly feeling right now?":
        "Como você está realmente se sentindo agora?",
    "Which emotion stood out the most today?":
        "Qual emoção se destacou mais hoje?",
    "Did you feel present in any moment today?":
        "Você se sentiu presente em algum momento hoje?",
    "When did you feel the most at peace today?":
        "Quando você se sentiu mais em paz hoje?",
    "What gave you energy today?": "O que deu energia a você hoje?",
    "What drained your energy today?": "O que drenou sua energia hoje?",
    "If your mood had a color today, what would it be?":
        "Se o seu humor hoje tivesse uma cor, qual seria?",
    "What’s something you’re excited about tomorrow?":
        "O que deixa você animado para amanhã?",
    "What’s one thing you want to improve tomorrow?":
        "O que você quer melhorar amanhã?",
    "What would make tomorrow feel successful?":
        "O que faria o dia de amanhã parecer bem-sucedido?",
    "What do you hope to achieve this week?":
        "O que você espera alcançar esta semana?",
    "What’s a habit you’d like to start tomorrow?":
        "Que hábito você gostaria de começar amanhã?",
    "What’s something you want to look forward to in the next month?":
        "O que você quer esperar com entusiasmo no próximo mês?",
    "What would your ideal tomorrow look like?":
        "Como seria o seu amanhã ideal?",
    "What’s one lesson you learned recently?":
        "Qual lição você aprendeu recentemente?",
    "If you could freeze one moment today, which would it be?":
        "Se pudesse congelar um momento de hoje, qual seria?",
    "What makes your life feel meaningful right now?":
        "O que faz sua vida parecer significativa agora?",
    "If you described today in one word, what would it be?":
        "Se você descrevesse hoje em uma palavra, qual seria?",
    "What inspired you today?": "O que inspirou você hoje?",
    "What did you notice today that you usually overlook?":
        "O que você notou hoje que costuma deixar passar?",
    "How has today changed your perspective?":
        "Como o dia de hoje mudou sua perspectiva?",
    "What’s something you’ve been overthinking?":
        "Sobre o que você tem pensado demais?",
    "What do you need to let go of?": "O que você precisa deixar ir?",
    "What part of nature did you notice today?":
        "Que parte da natureza você notou hoje?",
    "Did the weather affect your mood today?":
        "O clima afetou seu humor hoje?",
    "What place felt most comforting today?":
        "Qual lugar pareceu mais acolhedor hoje?",
    "Where did you feel most at home today?":
        "Onde você se sentiu mais em casa hoje?",
    "What sound or smell reminded you of something important?":
        "Que som ou cheiro lembrou você de algo importante?",
    "How did you take care of yourself today?":
        "Como você cuidou de si hoje?",
    "When did you feel most like yourself today?":
        "Quando você se sentiu mais você mesmo hoje?",
    "What’s something kind you can say to yourself right now?":
        "O que de gentil você pode dizer a si mesmo agora?",
    "What do you want to forgive yourself for?":
        "Pelo que você quer se perdoar?",
    "What do you deserve more of in your life?":
        "Do que você merece mais na sua vida?",
  },
  'nl': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Mijn dagboek",
    AppConstants.noEntriesMessage:
        "Nog geen dagboekberichten. Begin met schrijven!",
    AppConstants.noBookmarksYet: "Nog geen bladwijzers.",
    AppConstants.noDraftsYet: "Nog geen concepten.",
    AppConstants.addEntryButton: "Nieuw bericht toevoegen",
    AppConstants.jotYourThoughts: "Noteer je gedachten",
    AppConstants.tapToCreateJournal:
        "Tik op + om je persoonlijke dagboek te maken.",
    AppConstants.entriesThisYear: "Berichten dit jaar",
    AppConstants.wordsWritten: "Geschreven woorden",
    AppConstants.daysJournaled: "Dagen geschreven",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nieuw dagboekbericht",
    AppConstants.editEntryAppBarTitle: "Dagboekbericht bewerken",
    AppConstants.titleHintText: "Titel (bijv. 'Mijn dag', 'Gedachten over...')",
    AppConstants.contentHintText: "Schrijf hier je gedachten...",
    AppConstants.saveButton: "Bericht opslaan",
    AppConstants.updateButton: "Bijwerken",
    AppConstants.deleteButton: "Bericht verwijderen",
    AppConstants.requiredFieldMessage: "Dit veld mag niet leeg zijn.",
    AppConstants.newEntry: "Nieuw bericht",
    AppConstants.todayDate: "Datum van vandaag",
    AppConstants.customDate: "Aangepaste datum",
    AppConstants.done: "Gereed",
    AppConstants.startWriting: " Begin met schrijven...",
    AppConstants.tags: "Labels",
    AppConstants.addTags: "Labels toevoegen",
    AppConstants.openInMaps: "Openen in Kaarten",
    AppConstants.changeLocation: "Locatie wijzigen",
    AppConstants.remove: "Verwijderen",
    AppConstants.discardSelectionsTitle: "Selecties verwijderen?",
    AppConstants.discardSelectionsMessage:
        "Je hebt media of een actieve opname geselecteerd. Weet je zeker dat je ze wilt verwijderen?",
    AppConstants.journalEntryEmpty: "Dagboekbericht mag niet leeg zijn",
    AppConstants.discardDateConfirm:
        "Geselecteerde datum/tijd voor dit bericht verwijderen?",
    AppConstants.addMediaLocationMoodFirst:
        "Voeg eerst media, locatie of stemming toe",
    AppConstants.location: "Locatie",
    AppConstants.record: "Opnemen",
    AppConstants.selectMomentsToJournal: "Kies momenten voor je dagboek",
    AppConstants.addMomentsFromMenu:
        "Voeg media, locatie, opname of stemming toe via het menu",
    AppConstants.writeSomething: "Iets schrijven",
    AppConstants.saveWithoutWriting: "Opslaan zonder tekst",
    AppConstants.oneLocation: "1 locatie",
    AppConstants.mediaCount: "%d media",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Verwijderen bevestigen",
    AppConstants.confirmDeleteMessage:
        "Weet je zeker dat je dit bericht wilt verwijderen?",
    AppConstants.pleaseConfirm: "Bevestig",
    AppConstants.confirmDeleteJournalEntry:
        "Weet je zeker dat je dit dagboekbericht wilt verwijderen? Dit kan niet ongedaan worden gemaakt.",
    AppConstants.yes: "Ja",
    AppConstants.no: "Nee",
    AppConstants.cancel: "Annuleren",
    AppConstants.delete: "Verwijderen",
    AppConstants.save: "Opslaan",
    AppConstants.entrySavedSuccess: "Dagboekbericht opgeslagen!",
    AppConstants.entryUpdatedSuccess: "Dagboekbericht bijgewerkt!",
    AppConstants.entryDeletedSuccess: "Dagboekbericht verwijderd.",
    AppConstants.errorSavingEntry: "Fout bij opslaan van bericht.",
    AppConstants.errorDeletingEntry: "Fout bij verwijderen van bericht.",
    AppConstants.errorLoadingEntries: "Fout bij laden van dagboekberichten.",
    AppConstants.noEntriesForDate: "Geen berichten voor deze datum.",
    AppConstants.noEntriesForMonth: "Geen berichten gevonden voor deze maand.",
    AppConstants.selectMonthAndYear: "Maand en jaar selecteren",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Zeer onaangenaam",
    AppConstants.unpleasant: "Onaangenaam",
    AppConstants.slightlyUnpleasant: "Enigszins onaangenaam",
    AppConstants.neutral: "Neutraal",
    AppConstants.slightlyPleasant: "Enigszins aangenaam",
    AppConstants.pleasant: "Aangenaam",
    AppConstants.veryPleasant: "Zeer aangenaam",
    AppConstants.reflection: "Reflectie",
    AppConstants.edit: "Bewerken",
    AppConstants.removeBookmark: "Bladwijzer verwijderen",
    AppConstants.bookmark: "Bladwijzer",
    AppConstants.share: "Delen",
    AppConstants.saveAsPdf: "Opslaan als PDF",
    AppConstants.audioTrack: "Audiospoor",
    AppConstants.generatingPdf: "PDF genereren...",
    AppConstants.voiceRecording: "Spraakopname",
    AppConstants.audioRecording: "Audio-opname",
    AppConstants.couldNotLoadAudio: "Kan audiobestand niet laden.",
    AppConstants.stateOfMind: "Gemoedstoestand",

    // Mood Colors
    AppConstants.moodColors: "Stemmingskleuren",
    AppConstants.customizeMoodColors: "Stemmingskleuren aanpassen",
    AppConstants.reset: "Herstellen",
    AppConstants.resetMoodColors: "Standaard herstellen",
    AppConstants.resetMoodColorsConfirm:
        "Alle stemmingskleuren terugzetten naar standaard?",
    AppConstants.paletteThemes: "Paletthema's",
    AppConstants.customColor: "Aangepaste kleur",
    AppConstants.moodUnsavedChangesMessage:
        "Je hebt niet-opgeslagen wijzigingen in stemmingskleuren. Opslaan voor het sluiten?",

    // Drafts & Auto-save
    AppConstants.drafts: "Concepten",
    AppConstants.draft: "Concept",
    AppConstants.draftSaved: "Opgeslagen in concepten",
    AppConstants.unsavedChanges: "Niet-opgeslagen wijzigingen",
    AppConstants.unsavedChangesMessage:
        "Je hebt niet-opgeslagen wijzigingen. Wil je ze opslaan als concept of negeren?",
    AppConstants.saveAsDraft: "Opslaan als concept",
    AppConstants.discardChanges: "Negeren",
    AppConstants.autoDeleteDrafts: "Concepten automatisch verwijderen",
    AppConstants.days7: "7 dagen",
    AppConstants.never: "Nooit",
    AppConstants.custom: "Aangepast...",
    AppConstants.enterCustomDays: "Aangepast aantal dagen",
    AppConstants.customDaysExample: "Bijv. 14",
    AppConstants.days: "Dagen",
    AppConstants.draftsNeverDeleted: "Concepten worden nooit verwijderd",
    AppConstants.draftsDeletedAfterDays:
        "Concepten worden na %d dagen verwijderd",

    // Home Menu & Sorting
    AppConstants.sortBy: "Sorteren op",
    AppConstants.insights: "Inzichten",
    AppConstants.reflections: "Reflecties",
    AppConstants.settings: "Instellingen",
    AppConstants.entryTime: "Tijdstip van bericht",
    AppConstants.bookmarkFirst: "Bladwijzers eerst",
    AppConstants.reflectionFirst: "Reflecties eerst",
    AppConstants.withMediaFirst: "Met media eerst",
    AppConstants.textOnlyFirst: "Alleen tekst eerst",
    AppConstants.withLocationFirst: "Met locatie eerst",
    AppConstants.withMoodFirst: "Met stemming eerst",
    AppConstants.withTagsFirst: "Met labels eerst",

    // Insights
    AppConstants.stats: "Statistieken",
    AppConstants.calendar: "Kalender",
    AppConstants.entriesSuffix: " berichten",
    AppConstants.memoriesFromThisDay: "Herinneringen van deze dag",
    AppConstants.standard: "Standaard",
    AppConstants.media: "Media",
    AppConstants.mood: "Stemming",
    AppConstants.mostly: "Meestal",
    AppConstants.averageForThisDay: "Gemiddelde voor deze dag",
    AppConstants.averageForThisYear: "Gemiddelde voor dit jaar",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Welkom bij OpenJot",
    AppConstants.feature1:
        "Schrijf vrijuit, voeg foto's en locaties toe en houd alles veilig op je apparaat.",
    AppConstants.feature2:
        "Begrijp je emoties door de tijd heen met ingebouwde stemmingsregistratie.",
    AppConstants.feature3:
        "Je gegevens blijven op je telefoon – geen cloud, alleen lokale opslag en volledige privacy.",
    AppConstants.continueButton: "Doorgaan",

    // Notifications
    AppConstants.notificationTitle: "Tijd om te schrijven!",
    AppConstants.notificationBody:
        "Vergeet niet je gedachten van vandaag op te schrijven.",
    AppConstants.notificationChannelName: "Dagelijkse dagboekherinneringen",
    AppConstants.notificationChannelDescription:
        "Kanaal voor dagelijkse dagboekherinneringen",
    AppConstants.onThisDayChannelName: "Herinneringen op deze dag",
    AppConstants.onThisDayChannelDescription:
        "Meldingen voor herinneringen uit voorgaande jaren.",
    AppConstants.onThisDayNotificationTitle: "Een herinnering uit je dagboek",
    AppConstants.onThisDaySingleEntry:
        "Een jaar geleden schreef je iets bijzonders. Tik om je gedachten terug te lezen.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Op deze dag vorig jaar deelde je deze herinnering. Tik om hem opnieuw te beleven.",
    AppConstants.onThisDayMultipleEntries:
        "Je hebt herinneringen van deze dag uit voorgaande jaren. Tik om ze te bekijken.",
    AppConstants.onThisDayGroupedNotification:
        "Je hebt %d herinneringen van deze dag",

    // Exclude Entries
    AppConstants.excludeEntries: "Berichten uitsluiten",
    AppConstants.saveExclusions: "Uitsluitingen opslaan",
    AppConstants.excludeUnsavedChangesMessage:
        "Je hebt niet-opgeslagen wijzigingen. Weet je zeker dat je ze wilt negeren en afsluiten?",
    AppConstants.sortDefault: "Standaard",
    AppConstants.sortMutedFirst: "Gedempt eerst",
    AppConstants.sortUnmutedFirst: "Niet gedempt eerst",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Vandaag",
    AppConstants.yesterday: "Gisteren",
    AppConstants.contentForQuote: "Inhoud voor citaat",
    AppConstants.noContentSelected: "Geen inhoud geselecteerd.",
    AppConstants.photos: "Foto's",
    AppConstants.video: "Video",
    AppConstants.audio: "Audio",
    AppConstants.add: "Toevoegen",
    AppConstants.noMediaFound: "Geen %s gevonden.",
    AppConstants.permissionRequired:
        "Toestemming voor toegang tot %s is vereist om ze weer te geven.",
    AppConstants.openSettings: "Instellingen openen",
    AppConstants.videos: "Video's",
    AppConstants.audios: "Audio's",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Opname verwijderen?",
    AppConstants.deleteRecordingMessage:
        "Weet je zeker dat je deze opname wilt verwijderen?",
    AppConstants.listen: "Luisteren",
    AppConstants.tapAndHold: "tik en houd vast",
    AppConstants.clear: "Wissen",
    AppConstants.all: "Alles",
    AppConstants.folder: "Map",
    AppConstants.browse: "Bladeren",
    AppConstants.tiles: "Tegels",
    AppConstants.graph: "Grafiek",
    AppConstants.recording: "Opnemen...",
    AppConstants.recordingLabel: "Opname",
    AppConstants.startAudioRecording: "Audio-opname starten",
    AppConstants.howAreYouFeeling: "Hoe voel je je?",
    AppConstants.paused: "Gepauzeerd",
    AppConstants.stop: "Stoppen",
    AppConstants.tapOrHoldToResume: "Tik of houd vast om te hervatten",
    AppConstants.tapOrReleaseToPause: "Tik of laat los om te pauzeren",
    AppConstants.unsupportedImageType: "Niet-ondersteund afbeeldingstype",
    AppConstants.couldNotLoadVideo: "Kan video niet laden",
    AppConstants.couldNotOpenMap: "Kan kaartlink niet openen.",
    AppConstants.dismiss: "Sluiten",
    AppConstants.selectTime: "Tijd selecteren",
    AppConstants.now: "Nu",
    AppConstants.searchPlacesHint: "Zoek plaatsen, winkels...",
    AppConstants.locationPermissionDenied: "Locatietoestemming geweigerd.",
    AppConstants.failedGetCurrentLocation:
        "Kan huidige locatie niet ophalen.",

    // Search
    AppConstants.searchJournalsHint: "Dagboeken doorzoeken...",
    AppConstants.textOnly: "Alleen tekst",
    AppConstants.withMedia: "Met media",
    AppConstants.withMood: "Met stemming",
    AppConstants.withLocation: "Met locatie",
    AppConstants.withTags: "Met labels",
    AppConstants.noResultsFound: "Geen resultaten gevonden",
    AppConstants.searchHintText: "Berichten zoeken...",

    // Settings
    AppConstants.language: "Taal",
    AppConstants.selectLanguage: "Selecteer taal",
    AppConstants.systemDefault: "Systeemstandaard",
    AppConstants.searchLanguagesHint: "Talen zoeken...",
    AppConstants.languageChanged: "Taal gewijzigd naar %s.",
    AppConstants.dailyReminder: "Herinneringen",
    AppConstants.addReminder: "Herinnering toevoegen",
    AppConstants.deleteReminder: "Herinnering verwijderen",
    AppConstants.noRemindersSet: "Geen herinneringen ingesteld.",
    AppConstants.onThisDay: "Op deze dag",
    AppConstants.appLock: "App-vergrendeling",
    AppConstants.backup: "Back-up",
    AppConstants.restore: "Herstellen",
    AppConstants.importFromAnotherApp: "Importeren uit andere app",
    AppConstants.importFromDailyYou: "Importeren uit Daily You",
    AppConstants.selectDailyYouBackup:
        "Selecteer Daily You back-up zip-bestand",
    AppConstants.importingEntries: "Berichten importeren...",
    AppConstants.importSuccess:
        "%d berichten uit Daily You geïmporteerd!",
    AppConstants.importFailed: "Importeren mislukt: %s",
    AppConstants.noEntriesToImport:
        "Geen nieuwe berichten om te importeren.",
    AppConstants.askSupport: "Hulp vragen",
    AppConstants.importSupportNote:
        "Andere app-indelingen ondersteunen mogelijk niet alle functies. Als je problemen ondervindt of indelingen veranderen, dien dan een melding in.",
    AppConstants.extractingBackup: "Back-up uitpakken...",
    AppConstants.parsingDatabase: "Database verwerken...",
    AppConstants.dailyYouDbNotFound:
        "Daily You-database niet gevonden in back-up.",
    AppConstants.privacyPolicy: "Privacybeleid",
    AppConstants.termsNConditions: "Algemene voorwaarden",
    AppConstants.about: "Over de app",
    AppConstants.changeTheme: "Thema wijzigen",
    AppConstants.theme: "Thema",
    AppConstants.pitchBlack: "Pikzwart",
    AppConstants.themeLight: "Licht",
    AppConstants.themeDark: "Donker",
    AppConstants.themeSystem: "Systeem",
    AppConstants.changePin: "PIN wijzigen",
    AppConstants.loading: "Laden...",
    AppConstants.confirmRestoreTitle: "Herstellen bevestigen",
    AppConstants.confirmRestoreMessage:
        "Herstellen vanuit een back-up overschrijft alle huidige gegevens. Dit kan niet ongedaan worden gemaakt. Weet je zeker dat je wilt doorgaan?",
    AppConstants.notificationScheduled: "Melding gepland voor %s",
    AppConstants.notificationCanceled: "Melding geannuleerd",
    AppConstants.notificationRescheduled: "Melding opnieuw gepland voor %s",
    AppConstants.notificationPermissionRequired:
        "Meldingstoestemming is vereist om herinneringen in te stellen.",
    AppConstants.pinChangedSuccess: "PIN succesvol gewijzigd",
    AppConstants.onThisDayOn:
        "Je ontvangt nu herinneringen van deze dag.",
    AppConstants.onThisDayOff:
        "Herinneringen voor 'Op deze dag' zijn uitgeschakeld.",
    AppConstants.themeChanged: "Thema %s geselecteerd.",
    AppConstants.hideStats: "Statistieken verbergen",
    AppConstants.hideHomeStats: "Statistieken op startscherm verbergen",
    AppConstants.hideInsightsStats: "Statistieken in inzichten verbergen",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLECTIE",
    AppConstants.reflectButton: "Reflecteren",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Onjuiste PIN",
    AppConstants.verifyYourPin: "Verifieer je PIN",
    AppConstants.setAPin: "PIN instellen",
    AppConstants.confirmPin: "PIN bevestigen",
    AppConstants.pinsDoNotMatch: "PINs komen niet overeen",
    AppConstants.setPin: "PIN instellen",
    AppConstants.hello: "Hallo!",
    AppConstants.enterYourPin: "Voer je PIN in",
    AppConstants.useBiometrics: "Biometrie gebruiken",
    AppConstants.authenticateToUnlock:
        "Verifieer jezelf om de app te ontgrendelen",
    AppConstants.databaseEncryption: "Databaseversleuteling",
    AppConstants.databaseEncryptionDesc: "Lokale AES-256-GCM-versleuteling",
    AppConstants.changeMasterPassword: "Hoofdwachtwoord wijzigen",
    AppConstants.biometricUnlock: "Biometrisch ontgrendelen",
    AppConstants.enterMasterPassword: "Hoofdwachtwoord invoeren",
    AppConstants.enterMasterPasswordHint:
        "Voer je hoofdwachtwoord in om je dagboek te ontsleutelen.",
    AppConstants.unlockButton: "Ontgrendelen",
    AppConstants.unlockWithBiometrics: "Ontgrendelen met biometrie",
    AppConstants.incorrectMasterPassword:
        "Onjuist hoofdwachtwoord. Probeer het opnieuw.",
    AppConstants.databaseEncryptedSuccess:
        "Dagboekdatabase versleuteld met AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Dagboekdatabase ontsleuteld en app-vergrendeling uitgeschakeld.",
    AppConstants.masterPasswordChangedSuccess:
        "Hoofdwachtwoord succesvol bijgewerkt.",
    AppConstants.encryptedBackupPasswordRequired:
        "Er is een wachtwoord vereist om een versleutelde back-up te openen.",
    AppConstants.incorrectBackupPassword: "Onjuist back-upwachtwoord.",
    AppConstants.invalidBackupFile:
        "Het geselecteerde bestand is geen geldige OpenJot-back-up.",
    AppConstants.encryptedBackup: "Versleutelde back-up (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Beveiligd met AES-256-GCM en een back-upwachtwoord",
    AppConstants.standardBackup: "Standaardback-up (.zip)",
    AppConstants.standardBackupDesc:
        "Onversleuteld archief compatibel met alle versies",
    AppConstants.takingBackup: "Back-up maken...",
    AppConstants.encryptingBackup: "Back-up versleutelen...",
    AppConstants.savingBackup: "Back-up opslaan...",
    AppConstants.preparingBackup: "Back-up voorbereiden...",
    AppConstants.decryptingBackup: "Back-up ontsleutelen...",
    AppConstants.restoringBackup: "Back-up herstellen...",
    AppConstants.backupEncodingFailed:
        "Kan back-upbestand niet coderen.",
    AppConstants.backupCreatedSuccess: "Back-up succesvol gemaakt!",
    AppConstants.backupFailed: "Back-up maken mislukt: %s",
    AppConstants.restorePermissionsRequired:
        "Opslag- en mediatoestemming zijn vereist om gegevens te herstellen.",
    AppConstants.databaseRestoredNoMedia:
        "Database hersteld. Geen media gevonden in back-up.",
    AppConstants.restoreSuccess: "Herstel geslaagd!",
    AppConstants.restoreSuccessRestartRecommended:
        "Herstel geslaagd. Opnieuw opstarten wordt aanbevolen om alle wijzigingen toe te passen.",
    AppConstants.restoreFailed: "Gegevens herstellen mislukt: %s",
    AppConstants.storagePermissionsRequired:
        "Opslag- en mediatoestemming zijn vereist om een back-up te maken.",
    AppConstants.selectBackupFolder:
        "Selecteer een map om de back-up op te slaan",
    AppConstants.encryptDatabase: "Database versleutelen",
    AppConstants.disableEncryption: "Versleuteling uitschakelen",
    AppConstants.backupPasswordTitle: "Back-upwachtwoord",
    AppConstants.changeMasterPasswordDesc:
        "Voer je huidige hoofdwachtwoord in en kies een nieuw wachtwoord (minimaal 6 tekens).",
    AppConstants.disableEncryptionDesc:
        "Voer je hoofdwachtwoord in om je database op schijf te ontsleutelen en versleuteling uit te schakelen.",
    AppConstants.enableEncryptionDesc:
        "Bescherm alle dagboeknotities lokaal met AES-256-GCM-versleuteling. Als je je hoofdwachtwoord vergeet, kunnen versleutelde gegevens niet worden hersteld.",
    AppConstants.verifyForBiometricsDesc:
        "Voer je hoofdwachtwoord eenmalig in om een sleutel op te slaan in beveiligde hardwareopslag voor snel biometrisch ontgrendelen.",
    AppConstants.createBackupPasswordDesc:
        "Stel een sterk wachtwoord in om deze .openjot-back-up te versleutelen. Je hebt dit wachtwoord nodig om op elk apparaat te herstellen.",
    AppConstants.enterBackupPasswordDesc:
        "Voer het wachtwoord in dat is gebruikt bij het maken van deze .openjot-back-up.",
    AppConstants.updatePasswordAction: "Wachtwoord bijwerken",
    AppConstants.decryptAndDisable: "Ontsleutelen & uitschakelen",
    AppConstants.enableBiometricsAction: "Biometrie inschakelen",
    AppConstants.createBackupAction: "Back-up maken",
    AppConstants.decryptBackupAction: "Back-up ontsleutelen",
    AppConstants.newMasterPasswordHint: "Nieuw hoofdwachtwoord",
    AppConstants.backupPasswordHint: "Back-upwachtwoord",
    AppConstants.masterPasswordHint: "Hoofdwachtwoord",
    AppConstants.enterCurrentMasterPasswordError:
        "Voer je huidige hoofdwachtwoord in.",
    AppConstants.passwordEmptyError: "Wachtwoord mag niet leeg zijn.",
    AppConstants.passwordMinLengthError:
        "Wachtwoord moet minimaal 6 tekens lang zijn.",
    AppConstants.passwordsDoNotMatchError:
        "Wachtwoorden komen niet overeen.",
    AppConstants.currentMasterPasswordHint: "Huidig hoofdwachtwoord",
    AppConstants.confirmPasswordHint: "Wachtwoord bevestigen",

    // About & Terms
    AppConstants.aboutApp: "Over OpenJot",
    AppConstants.versionPrefix: "Versie: %s",
    AppConstants.aboutSubtitle:
        "Een minimalistisch, open-source dagboek om je gedachten, stemmingen en herinneringen vast te leggen. Al je gegevens blijven op je apparaat.",
    AppConstants.keyFeatures: "Belangrijkste functies",
    AppConstants.aboutFeature1:
        "• Strakke schrijfervaring zonder afleiding.",
    AppConstants.aboutFeature2:
        "• Voeg foto's, spraaknotities en muziek toe aan je berichten.",
    AppConstants.aboutFeature3:
        "• Leg je stemming vast naast je dagboek.",
    AppConstants.aboutFeature4:
        "• Personaliseer met verschillende tekststijlen.",
    AppConstants.aboutFeature5:
        "• Werkt volledig offline, je gegevens blijven op je apparaat.",
    AppConstants.openSource: "Open Source",
    AppConstants.openSourceDesc:
        "OpenJot is een open-source applicatie. De broncode is openbaar beschikbaar om te bekijken, aan te passen en aan bij te dragen. Wij geloven in transparantie en samenwerking.",
    AppConstants.dataPrivacy: "Gegevensprivacy",
    AppConstants.dataPrivacyDesc:
        "Wij waarderen je privacy. OpenJot verzamelt, bewaart of verzendt geen persoonlijke gegevens. Alle berichten, inclusief afbeeldingen en audio, worden uitsluitend op je apparaat opgeslagen.",
    AppConstants.linksTitle: "Links",
    AppConstants.sourceCodeOnGithub: "Broncode op GitHub",
    AppConstants.sendFeedback: "Feedback sturen",
    AppConstants.couldNotLaunchUrl: "Kan URL niet openen",
    AppConstants.termsIntro:
        "Welkom bij OpenJot! Dit document beschrijft de algemene voorwaarden voor het gebruik van onze applicatie. Door OpenJot te gebruiken, ga je akkoord met deze voorwaarden.",
    AppConstants.termsSectionDataPrivacy: "Gegevensopslag en privacy",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot is ontworpen als een privéplek voor je gedachten. Alle berichten, inclusief tekst, afbeeldingen, audiobestanden en andere media, worden uitsluitend lokaal op je apparaat opgeslagen. De app stuurt geen persoonlijke gegevens naar externe servers.",
    AppConstants.termsSectionUserContent: "Door gebruiker gemaakte inhoud",
    AppConstants.termsSectionUserContentBody:
        "Jij bent als enige verantwoordelijk voor de inhoud die je in OpenJot maakt en opslaat. Je bent zelf verantwoordelijk voor het hebben van de benodigde rechten voor geïmporteerde inhoud.",
    AppConstants.termsSectionDisclaimer: "Uitsluiting van garantie",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot wordt geleverd \"zoals het is\", zonder enige garantie. We garanderen niet dat de app foutloos of ononderbroken werkt. Gebruik is op eigen risico.",
    AppConstants.termsSectionLiability: "Beperking van aansprakelijkheid",
    AppConstants.termsSectionLiabilityBody:
        "In geen geval zijn de ontwikkelaars van OpenJot aansprakelijk voor directe, indirecte, incidentele, bijzondere of gevolgschade, inclusief gegevensverlies, voortvloeiend uit het gebruik of het niet kunnen gebruiken van deze applicatie.",
    AppConstants.termsSectionThirdParty: "Bibliotheken van derden",
    AppConstants.termsSectionThirdPartyBody:
        "Deze applicatie maakt gebruik van de volgende bibliotheken van derden, elk onderworpen aan zijn eigen licentie:",

    // Months
    'January': 'Januari',
    'February': 'Februari',
    'March': 'Maart',
    'April': 'April',
    'May': 'Mei',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'Augustus',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'December',

    // Reflection Prompts (61)
    "What made you smile today?": "Waarom moest je vandaag glimlachen?",
    "Who are you thankful for this week, and why?":
        "Voor wie ben je deze week dankbaar en waarom?",
    "What is something small that brought you joy today?":
        "Wat was iets kleins dat je vandaag vreugde bracht?",
    "Which part of your day felt most comforting?":
        "Welk deel van je dag voelde het meest geruststellend?",
    "What’s something you often take for granted but appreciate now?":
        "Wat vind je vaak vanzelfsprekend, maar waardeer je nu?",
    "What’s the best thing that happened today?":
        "Wat is het mooiste dat vandaag is gebeurd?",
    "Did someone make your day easier today?":
        "Heeft iemand je dag vandaag makkelijker gemaakt?",
    "Who made a positive impact on you recently?":
        "Wie heeft onlangs een positieve indruk op je gemaakt?",
    "What’s a quality you admire in someone close to you?":
        "Welke eigenschap bewonder je in iemand die dicht bij je staat?",
    "When did you last feel truly connected with someone?":
        "Wanneer voelde je je voor het laatst echt verbonden met iemand?",
    "Who do you want to reach out to soon?":
        "Met wie wil je binnenkort contact opnemen?",
    "Did someone’s kindness stand out today?":
        "Viel iemands vriendelijkheid vandaag op?",
    "How did you support someone else recently?":
        "Hoe heb je onlangs iemand anders gesteund?",
    "Who do you miss the most right now?": "Wie mis je nu het meest?",
    "What’s a moment from today you want to remember?":
        "Welk moment van vandaag wil je onthouden?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Welk detail van vandaag vergeet je misschien als je het niet opschrijft?",
    "What’s the most peaceful moment you had today?":
        "Wat was het rustigste moment dat je vandaag had?",
    "Did you see something beautiful today?":
        "Heb je vandaag iets moois gezien?",
    "Which memory from this week stands out?":
        "Welke herinnering van deze week springt eruit?",
    "What song, photo, or place will always remind you of today?":
        "Welk liedje, welke foto of welke plek zal je altijd aan vandaag herinneren?",
    "What surprised you today?": "Wat heeft je vandaag verrast?",
    "What challenge did you overcome today?":
        "Welke uitdaging heb je vandaag overwonnen?",
    "What’s a small win you had today?":
        "Wat was een kleine overwinning vandaag?",
    "What new thing did you learn about yourself recently?":
        "Wat heb je onlangs over jezelf geleerd?",
    "What are you proud of yourself for?":
        "Waar ben je trots op bij jezelf?",
    "What habit do you feel good about keeping?":
        "Welke gewoonte geeft je een goed gevoel om vol te houden?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Welke verbetering heb je dit jaar bij jezelf opgemerkt?",
    "How did you push yourself out of your comfort zone?":
        "Hoe ben je uit je comfortzone gestapt?",
    "How are you truly feeling right now?": "Hoe voel je je nu echt?",
    "Which emotion stood out the most today?":
        "Welke emotie viel vandaag het meest op?",
    "Did you feel present in any moment today?":
        "Voelde je je vandaag op enig moment echt aanwezig?",
    "When did you feel the most at peace today?":
        "Wanneer voelde je je vandaag het meest vredig?",
    "What gave you energy today?": "Wat gaf je vandaag energie?",
    "What drained your energy today?": "Wat kostte je vandaag energie?",
    "If your mood had a color today, what would it be?":
        "Als je stemming vandaag een kleur had, welke zou het zijn?",
    "What’s something you’re excited about tomorrow?":
        "Waar kijk je morgen naar uit?",
    "What’s one thing you want to improve tomorrow?":
        "Wat wil je morgen verbeteren?",
    "What would make tomorrow feel successful?":
        "Wat zou morgen als een succes laten voelen?",
    "What do you hope to achieve this week?":
        "Wat hoop je deze week te bereiken?",
    "What’s a habit you’d like to start tomorrow?":
        "Welke gewoonte zou je morgen willen beginnen?",
    "What’s something you want to look forward to in the next month?":
        "Waar wil je de komende maand naar uitkijken?",
    "What would your ideal tomorrow look like?":
        "Hoe zou jouw ideale dag morgen eruitzien?",
    "What’s one lesson you learned recently?":
        "Welke les heb je onlangs geleerd?",
    "If you could freeze one moment today, which would it be?":
        "Als je vandaag één moment kon stilzetten, welk zou dat zijn?",
    "What makes your life feel meaningful right now?":
        "Wat maakt je leven op dit moment zinvol?",
    "If you described today in one word, what would it be?":
        "Als je vandaag in één woord zou beschrijven, welk woord zou het zijn?",
    "What inspired you today?": "Wat heeft je vandaag geïnspireerd?",
    "What did you notice today that you usually overlook?":
        "Wat viel je vandaag op dat je normaal over het hoofd ziet?",
    "How has today changed your perspective?":
        "Hoe heeft vandaag je perspectief veranderd?",
    "What’s something you’ve been overthinking?":
        "Waar heb je te veel over nagedacht?",
    "What do you need to let go of?": "Wat moet je loslaten?",
    "What part of nature did you notice today?":
        "Welk deel van de natuur viel je vandaag op?",
    "Did the weather affect your mood today?":
        "Had het weer vandaag invloed op je stemming?",
    "What place felt most comforting today?":
        "Welke plek voelde vandaag het meest vertrouwd?",
    "Where did you feel most at home today?":
        "Waar voelde je je vandaag het meest thuis?",
    "What sound or smell reminded you of something important?":
        "Welk geluid of welke geur herinnerde je aan iets belangrijks?",
    "How did you take care of yourself today?":
        "Hoe heb je vandaag voor jezelf gezorgd?",
    "When did you feel most like yourself today?":
        "Wanneer voelde je je vandaag het meest jezelf?",
    "What’s something kind you can say to yourself right now?":
        "Wat voor aardigs kun je nu tegen jezelf zeggen?",
    "What do you want to forgive yourself for?":
        "Waar wil je jezelf voor vergeven?",
    "What do you deserve more of in your life?":
        "Waar verdien je meer van in je leven?",
  },
  'ca': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "El meu diari",
    AppConstants.noEntriesMessage:
        "Encara no hi ha entrades al diari. Comença a escriure!",
    AppConstants.noBookmarksYet: "Encara no hi ha marcadors.",
    AppConstants.noDraftsYet: "Encara no hi ha esborranys.",
    AppConstants.addEntryButton: "Afegeix una entrada nova",
    AppConstants.jotYourThoughts: "Anota els teus pensaments",
    AppConstants.tapToCreateJournal: "Toca + per crear el teu diari personal.",
    AppConstants.entriesThisYear: "Entrades aquest any",
    AppConstants.wordsWritten: "Paraules escrites",
    AppConstants.daysJournaled: "Dies amb diari",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nova entrada al diari",
    AppConstants.editEntryAppBarTitle: "Edita l'entrada del diari",
    AppConstants.titleHintText: "Títol (p. ex., 'El meu dia', 'Pensaments...')",
    AppConstants.contentHintText: "Escriu els teus pensaments aquí...",
    AppConstants.saveButton: "Desa l'entrada",
    AppConstants.updateButton: "Actualitza",
    AppConstants.deleteButton: "Suprimeix l'entrada",
    AppConstants.requiredFieldMessage: "Aquest camp no pot estar buit.",
    AppConstants.newEntry: "Nova entrada",
    AppConstants.todayDate: "Data d'avui",
    AppConstants.customDate: "Data personalitzada",
    AppConstants.done: "Fet",
    AppConstants.startWriting: " Comença a escriure...",
    AppConstants.tags: "Etiquetes",
    AppConstants.addTags: "Afegeix etiquetes",
    AppConstants.openInMaps: "Obre a Mapes",
    AppConstants.changeLocation: "Canvia la ubicació",
    AppConstants.remove: "Treu",
    AppConstants.discardSelectionsTitle: "Descarta les seleccions?",
    AppConstants.discardSelectionsMessage:
        "Has seleccionat multimèdia o una gravació activa. Segur que vols descartar-ho?",
    AppConstants.journalEntryEmpty:
        "L'entrada del diari no pot estar buida",
    AppConstants.discardDateConfirm:
        "Vols descartar la data/hora seleccionada per a aquesta entrada?",
    AppConstants.addMediaLocationMoodFirst:
        "Afegeix primer multimèdia, ubicació o estat d'ànim",
    AppConstants.location: "Ubicació",
    AppConstants.record: "Grava",
    AppConstants.selectMomentsToJournal: "Selecciona moments per anotar",
    AppConstants.addMomentsFromMenu:
        "Afegeix multimèdia, ubicació, gravació o estat d'ànim des del menú",
    AppConstants.writeSomething: "Escriu alguna cosa",
    AppConstants.saveWithoutWriting: "Desa sense escriure",
    AppConstants.oneLocation: "1 ubicació",
    AppConstants.mediaCount: "%d fitxers",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Confirma la supressió",
    AppConstants.confirmDeleteMessage:
        "Segur que vols suprimir aquesta entrada?",
    AppConstants.pleaseConfirm: "Confirma",
    AppConstants.confirmDeleteJournalEntry:
        "Segur que vols suprimir aquesta entrada del diari? Aquesta acció és irreversible.",
    AppConstants.yes: "Sí",
    AppConstants.no: "No",
    AppConstants.cancel: "Cancel·la",
    AppConstants.delete: "Suprimeix",
    AppConstants.save: "Desa",
    AppConstants.entrySavedSuccess: "Entrada desada correctament!",
    AppConstants.entryUpdatedSuccess: "Entrada actualitzada correctament!",
    AppConstants.entryDeletedSuccess: "Entrada suprimida.",
    AppConstants.errorSavingEntry: "Error en desar l'entrada.",
    AppConstants.errorDeletingEntry: "Error en suprimir l'entrada.",
    AppConstants.errorLoadingEntries: "Error en carregar les entrades.",
    AppConstants.noEntriesForDate: "No hi ha entrades per a aquesta data.",
    AppConstants.noEntriesForMonth:
        "No s'han trobat entrades per a aquest mes.",
    AppConstants.selectMonthAndYear: "Selecciona mes i any",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Molt desagradable",
    AppConstants.unpleasant: "Desagradable",
    AppConstants.slightlyUnpleasant: "Una mica desagradable",
    AppConstants.neutral: "Neutre",
    AppConstants.slightlyPleasant: "Una mica agradable",
    AppConstants.pleasant: "Agradable",
    AppConstants.veryPleasant: "Molt agradable",
    AppConstants.reflection: "Reflexió",
    AppConstants.edit: "Edita",
    AppConstants.removeBookmark: "Treu el marcador",
    AppConstants.bookmark: "Marcador",
    AppConstants.share: "Comparteix",
    AppConstants.saveAsPdf: "Desa com a PDF",
    AppConstants.audioTrack: "Pista d'àudio",
    AppConstants.generatingPdf: "Generant PDF...",
    AppConstants.voiceRecording: "Gravació de veu",
    AppConstants.audioRecording: "Gravació d'àudio",
    AppConstants.couldNotLoadAudio:
        "No s'ha pogut carregar el fitxer d'àudio.",
    AppConstants.stateOfMind: "Estat d'ànim",

    // Mood Colors
    AppConstants.moodColors: "Colors d'ànim",
    AppConstants.customizeMoodColors: "Personalitza els colors d'ànim",
    AppConstants.reset: "Restableix",
    AppConstants.resetMoodColors: "Restableix els valors per defecte",
    AppConstants.resetMoodColorsConfirm:
        "Vols restablir tots els colors d'ànim als valors per defecte?",
    AppConstants.paletteThemes: "Temes de paleta",
    AppConstants.customColor: "Color personalitzat",
    AppConstants.moodUnsavedChangesMessage:
        "Tens canvis sense desar als colors d'ànim. Vols desar-los abans de tancar?",

    // Drafts & Auto-save
    AppConstants.drafts: "Esborranys",
    AppConstants.draft: "Esborrany",
    AppConstants.draftSaved: "Desat als esborranys",
    AppConstants.unsavedChanges: "Canvis sense desar",
    AppConstants.unsavedChangesMessage:
        "Tens canvis sense desar. Vols desar-los com a esborrany o descartar-los?",
    AppConstants.saveAsDraft: "Desa com a esborrany",
    AppConstants.discardChanges: "Descarta",
    AppConstants.autoDeleteDrafts: "Suprimeix esborranys automàticament",
    AppConstants.days7: "7 dies",
    AppConstants.never: "Mai",
    AppConstants.custom: "Personalitzat...",
    AppConstants.enterCustomDays: "Introdueix dies personalitzats",
    AppConstants.customDaysExample: "P. ex., 14",
    AppConstants.days: "Dies",
    AppConstants.draftsNeverDeleted: "Els esborranys no se suprimiran mai",
    AppConstants.draftsDeletedAfterDays:
        "Els esborranys se suprimiran al cap de %d dies",

    // Home Menu & Sorting
    AppConstants.sortBy: "Ordena per",
    AppConstants.insights: "Estadístiques",
    AppConstants.reflections: "Reflexions",
    AppConstants.settings: "Configuració",
    AppConstants.entryTime: "Hora de l'entrada",
    AppConstants.bookmarkFirst: "Marcadors primer",
    AppConstants.reflectionFirst: "Reflexions primer",
    AppConstants.withMediaFirst: "Amb multimèdia primer",
    AppConstants.textOnlyFirst: "Només text primer",
    AppConstants.withLocationFirst: "Amb ubicació primer",
    AppConstants.withMoodFirst: "Amb estat d'ànim primer",
    AppConstants.withTagsFirst: "Amb etiquetes primer",

    // Insights
    AppConstants.stats: "Estadístiques",
    AppConstants.calendar: "Calendari",
    AppConstants.entriesSuffix: " entrades",
    AppConstants.memoriesFromThisDay: "Records d'aquest dia",
    AppConstants.standard: "Estàndard",
    AppConstants.media: "Multimèdia",
    AppConstants.mood: "Ànim",
    AppConstants.mostly: "Sobretot",
    AppConstants.averageForThisDay: "Mitjana d'aquest dia",
    AppConstants.averageForThisYear: "Mitjana d'aquest any",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Benvingut a OpenJot",
    AppConstants.feature1:
        "Escriu lliurement, afegeix fotos i ubicacions i mantén-ho tot segur al teu dispositiu.",
    AppConstants.feature2:
        "Comprèn les teves emocions al llarg del temps amb el seguiment integrat de l'estat d'ànim.",
    AppConstants.feature3:
        "Les teves dades es queden al telèfon: sense núvol, només emmagatzematge local i privadesa total.",
    AppConstants.continueButton: "Continua",

    // Notifications
    AppConstants.notificationTitle: "Hora d'escriure al diari!",
    AppConstants.notificationBody:
        "No oblidis anotar els teus pensaments d'avui.",
    AppConstants.notificationChannelName: "Recordatoris diaris del diari",
    AppConstants.notificationChannelDescription:
        "Canal per a notificacions diàries de recordatori",
    AppConstants.onThisDayChannelName: "Records d'un dia com avui",
    AppConstants.onThisDayChannelDescription:
        "Notificacions de records d'anys anteriors.",
    AppConstants.onThisDayNotificationTitle: "Un record del teu diari",
    AppConstants.onThisDaySingleEntry:
        "Avui fa un any vas escriure quelcom especial. Toca per rellegir els teus pensaments.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Aquest dia l'any passat vas compartir aquest record. Toca per reviure'l.",
    AppConstants.onThisDayMultipleEntries:
        "Tens records d'aquest dia d'anys anteriors. Toca per revisar-los.",
    AppConstants.onThisDayGroupedNotification:
        "Tens %d records d'aquest dia",

    // Exclude Entries
    AppConstants.excludeEntries: "Exclou entrades",
    AppConstants.saveExclusions: "Desa exclusions",
    AppConstants.excludeUnsavedChangesMessage:
        "Tens canvis sense desar. Segur que vols descartar-los i sortir?",
    AppConstants.sortDefault: "Per defecte",
    AppConstants.sortMutedFirst: "Silenciades primer",
    AppConstants.sortUnmutedFirst: "No silenciades primer",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Avui",
    AppConstants.yesterday: "Ahir",
    AppConstants.contentForQuote: "Contingut per a la cita",
    AppConstants.noContentSelected: "No hi ha contingut seleccionat.",
    AppConstants.photos: "Fotos",
    AppConstants.video: "Vídeo",
    AppConstants.audio: "Àudio",
    AppConstants.add: "Afegeix",
    AppConstants.noMediaFound: "No s'ha trobat cap %s.",
    AppConstants.permissionRequired:
        "Cal permís per accedir a %s per mostrar-los.",
    AppConstants.openSettings: "Obre la configuració",
    AppConstants.videos: "Vídeos",
    AppConstants.audios: "Àudios",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Vols suprimir la gravació?",
    AppConstants.deleteRecordingMessage:
        "Segur que vols suprimir aquesta gravació?",
    AppConstants.listen: "Escolta",
    AppConstants.tapAndHold: "prem i mantén",
    AppConstants.clear: "Neteja",
    AppConstants.all: "Tot",
    AppConstants.folder: "Carpeta",
    AppConstants.browse: "Explora",
    AppConstants.tiles: "Targetes",
    AppConstants.graph: "Gràfic",
    AppConstants.recording: "Gravant...",
    AppConstants.recordingLabel: "Gravació",
    AppConstants.startAudioRecording: "Inicia la gravació d'àudio",
    AppConstants.howAreYouFeeling: "Com et sents?",
    AppConstants.paused: "En pausa",
    AppConstants.stop: "Atura",
    AppConstants.tapOrHoldToResume: "Toca o mantén premut per reprendre",
    AppConstants.tapOrReleaseToPause: "Toca o deixa anar per pausar",
    AppConstants.unsupportedImageType: "Tipus d'imatge no compatible",
    AppConstants.couldNotLoadVideo: "No s'ha pogut carregar el vídeo",
    AppConstants.couldNotOpenMap: "No s'ha pogut obrir l'enllaç del mapa.",
    AppConstants.dismiss: "Tanca",
    AppConstants.selectTime: "Selecciona l'hora",
    AppConstants.now: "Ara",
    AppConstants.searchPlacesHint: "Cerca llocs, botigues...",
    AppConstants.locationPermissionDenied: "Permís d'ubicació denegat.",
    AppConstants.failedGetCurrentLocation:
        "No s'ha pogut obtenir la ubicació actual.",

    // Search
    AppConstants.searchJournalsHint: "Cerca als diaris...",
    AppConstants.textOnly: "Només text",
    AppConstants.withMedia: "Amb multimèdia",
    AppConstants.withMood: "Amb estat d'ànim",
    AppConstants.withLocation: "Amb ubicació",
    AppConstants.withTags: "Amb etiquetes",
    AppConstants.noResultsFound: "No s'han trobat resultats",
    AppConstants.searchHintText: "Cerca entrades...",

    // Settings
    AppConstants.language: "Idioma",
    AppConstants.selectLanguage: "Selecciona l'idioma",
    AppConstants.systemDefault: "Per defecte del sistema",
    AppConstants.searchLanguagesHint: "Cerca idiomes...",
    AppConstants.languageChanged: "Idioma canviat a %s.",
    AppConstants.dailyReminder: "Recordatoris",
    AppConstants.addReminder: "Afegeix un recordatori",
    AppConstants.deleteReminder: "Suprimeix el recordatori",
    AppConstants.noRemindersSet: "No hi ha recordatoris configurats.",
    AppConstants.onThisDay: "Un dia com avui",
    AppConstants.appLock: "Bloqueig de l'app",
    AppConstants.backup: "Còpia de seguretat",
    AppConstants.restore: "Restaura",
    AppConstants.importFromAnotherApp: "Importa d'una altra app",
    AppConstants.importFromDailyYou: "Importa des de Daily You",
    AppConstants.selectDailyYouBackup:
        "Selecciona el fitxer zip de còpia de Daily You",
    AppConstants.importingEntries: "Important entrades...",
    AppConstants.importSuccess:
        "S'han importat %d entrades de Daily You correctament!",
    AppConstants.importFailed: "Error en importar: %s",
    AppConstants.noEntriesToImport:
        "No s'han trobat entrades noves per importar.",
    AppConstants.askSupport: "Demana ajuda",
    AppConstants.importSupportNote:
        "Altres formats d'aplicacions poden no admetre totes les funcions. Si trobes problemes o canvien els formats, envia un informe d'error.",
    AppConstants.extractingBackup: "Extraient la còpia de seguretat...",
    AppConstants.parsingDatabase: "Analitzant la base de dades...",
    AppConstants.dailyYouDbNotFound:
        "No s'ha trobat la base de dades de Daily You a la còpia.",
    AppConstants.privacyPolicy: "Política de privadesa",
    AppConstants.termsNConditions: "Termes i condicions",
    AppConstants.about: "Quant a l'app",
    AppConstants.changeTheme: "Canvia el tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Negre pur",
    AppConstants.themeLight: "Clar",
    AppConstants.themeDark: "Fosc",
    AppConstants.themeSystem: "Sistema",
    AppConstants.changePin: "Canvia el PIN",
    AppConstants.loading: "Carregant...",
    AppConstants.confirmRestoreTitle: "Confirma la restauració",
    AppConstants.confirmRestoreMessage:
        "Restaurar des d'una còpia de seguretat sobreescriurà totes les dades actuals. Aquesta acció no es pot desfer. Vols continuar?",
    AppConstants.notificationScheduled: "Notificació programada per a les %s",
    AppConstants.notificationCanceled: "Notificació cancel·lada",
    AppConstants.notificationRescheduled:
        "Notificació reprogramada per a les %s",
    AppConstants.notificationPermissionRequired:
        "Cal permís de notificacions per configurar recordatoris.",
    AppConstants.pinChangedSuccess: "PIN canviat correctament",
    AppConstants.onThisDayOn: "Ara rebràs records d'aquest dia.",
    AppConstants.onThisDayOff:
        "Els recordatoris de «Un dia com avui» estan desactivats.",
    AppConstants.themeChanged: "Tema %s seleccionat.",
    AppConstants.hideStats: "Amaga estadístiques",
    AppConstants.hideHomeStats: "Amaga estadístiques d'inici",
    AppConstants.hideInsightsStats: "Amaga estadístiques d'anàlisi",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEXIÓ",
    AppConstants.reflectButton: "Reflexiona",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "PIN incorrecte",
    AppConstants.verifyYourPin: "Verifica el teu PIN",
    AppConstants.setAPin: "Defineix un PIN",
    AppConstants.confirmPin: "Confirma el PIN",
    AppConstants.pinsDoNotMatch: "Els PIN no coincideixen",
    AppConstants.setPin: "Defineix el PIN",
    AppConstants.hello: "Hola!",
    AppConstants.enterYourPin: "Introdueix el teu PIN",
    AppConstants.useBiometrics: "Fes servir biometria",
    AppConstants.authenticateToUnlock:
        "Autentica't per desbloquejar l'aplicació",
    AppConstants.databaseEncryption: "Xifratge de la base de dades",
    AppConstants.databaseEncryptionDesc: "Xifratge local AES-256-GCM",
    AppConstants.changeMasterPassword: "Canvia la contrasenya mestra",
    AppConstants.biometricUnlock: "Desbloqueig biomètric",
    AppConstants.enterMasterPassword: "Introdueix la contrasenya mestra",
    AppConstants.enterMasterPasswordHint:
        "Introdueix la teva contrasenya mestra per desxifrar el diari.",
    AppConstants.unlockButton: "Desbloqueja",
    AppConstants.unlockWithBiometrics: "Desbloqueja amb biometria",
    AppConstants.incorrectMasterPassword:
        "Contrasenya mestra incorrecta. Torna-ho a provar.",
    AppConstants.databaseEncryptedSuccess:
        "Base de dades del diari xifrada amb AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Base de dades desxifrada i bloqueig de l'app desactivat.",
    AppConstants.masterPasswordChangedSuccess:
        "Contrasenya mestra actualitzada correctament.",
    AppConstants.encryptedBackupPasswordRequired:
        "Cal una contrasenya per obrir una còpia de seguretat xifrada.",
    AppConstants.incorrectBackupPassword:
        "Contrasenya de la còpia incorrecta.",
    AppConstants.invalidBackupFile:
        "El fitxer seleccionat no és una còpia d'OpenJot vàlida.",
    AppConstants.encryptedBackup: "Còpia xifrada (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Protegida amb AES-256-GCM i contrasenya de còpia",
    AppConstants.standardBackup: "Còpia estàndard (.zip)",
    AppConstants.standardBackupDesc:
        "Arxiu sense xifrar compatible amb totes les versions",
    AppConstants.takingBackup: "Creant còpia de seguretat...",
    AppConstants.encryptingBackup: "Xifrant còpia de seguretat...",
    AppConstants.savingBackup: "Desant còpia de seguretat...",
    AppConstants.preparingBackup: "Preparant còpia de seguretat...",
    AppConstants.decryptingBackup: "Desxifrant còpia de seguretat...",
    AppConstants.restoringBackup: "Restaurant còpia de seguretat...",
    AppConstants.backupEncodingFailed:
        "No s'ha pogut codificar el fitxer de còpia.",
    AppConstants.backupCreatedSuccess:
        "Còpia de seguretat creada correctament!",
    AppConstants.backupFailed: "Error en crear la còpia: %s",
    AppConstants.restorePermissionsRequired:
        "Calen permisos d'emmagatzematge i multimèdia per restaurar dades.",
    AppConstants.databaseRestoredNoMedia:
        "Base de dades restaurada. No s'ha trobat multimèdia a la còpia.",
    AppConstants.restoreSuccess: "Restauració completada!",
    AppConstants.restoreSuccessRestartRecommended:
        "Restauració completada. Es recomana reiniciar per aplicar tots els canvis.",
    AppConstants.restoreFailed: "Error en restaurar les dades: %s",
    AppConstants.storagePermissionsRequired:
        "Calen permisos d'emmagatzematge i multimèdia per crear una còpia.",
    AppConstants.selectBackupFolder:
        "Selecciona una carpeta per desar la còpia",
    AppConstants.encryptDatabase: "Xifra la base de dades",
    AppConstants.disableEncryption: "Desactiva el xifratge",
    AppConstants.backupPasswordTitle: "Contrasenya de la còpia",
    AppConstants.changeMasterPasswordDesc:
        "Introdueix la contrasenya mestra actual i tria una nova contrasenya (mínim 6 caràcters).",
    AppConstants.disableEncryptionDesc:
        "Introdueix la contrasenya mestra per desxifrar la base de dades al disc i desactivar el xifratge.",
    AppConstants.enableEncryptionDesc:
        "Protegeix totes les notes localment amb xifratge AES-256-GCM. Si oblides la contrasenya mestra, les dades xifrades no es podran recuperar.",
    AppConstants.verifyForBiometricsDesc:
        "Introdueix la contrasenya mestra una vegada per desar una clau a l'emmagatzematge segur de maquinari per al desbloqueig biomètric ràpid.",
    AppConstants.createBackupPasswordDesc:
        "Defineix una contrasenya segura per xifrar aquesta còpia .openjot. La necessitaràs per restaurar-la en qualsevol dispositiu.",
    AppConstants.enterBackupPasswordDesc:
        "Introdueix la contrasenya utilitzada en crear aquesta còpia .openjot.",
    AppConstants.updatePasswordAction: "Actualitza contrasenya",
    AppConstants.decryptAndDisable: "Desxifra i desactiva",
    AppConstants.enableBiometricsAction: "Activa biometria",
    AppConstants.createBackupAction: "Crea còpia",
    AppConstants.decryptBackupAction: "Desxifra còpia",
    AppConstants.newMasterPasswordHint: "Nova contrasenya mestra",
    AppConstants.backupPasswordHint: "Contrasenya de la còpia",
    AppConstants.masterPasswordHint: "Contrasenya mestra",
    AppConstants.enterCurrentMasterPasswordError:
        "Introdueix la teva contrasenya mestra actual.",
    AppConstants.passwordEmptyError: "La contrasenya no pot estar buida.",
    AppConstants.passwordMinLengthError:
        "La contrasenya ha de tenir almenys 6 caràcters.",
    AppConstants.passwordsDoNotMatchError:
        "Les contrasenyes no coincideixen.",
    AppConstants.currentMasterPasswordHint: "Contrasenya mestra actual",
    AppConstants.confirmPasswordHint: "Confirma la contrasenya",

    // About & Terms
    AppConstants.aboutApp: "Quant a OpenJot",
    AppConstants.versionPrefix: "Versió: %s",
    AppConstants.aboutSubtitle:
        "Un diari minimalista i de codi obert per anotar pensaments, estats d'ànim i records. Totes les teves dades es queden al teu dispositiu.",
    AppConstants.keyFeatures: "Característiques principals",
    AppConstants.aboutFeature1:
        "• Experiència d'escriptura neta i sense distraccions.",
    AppConstants.aboutFeature2:
        "• Afegeix fotos, notes de veu i música a les teves entrades.",
    AppConstants.aboutFeature3:
        "• Registra el teu estat d'ànim juntament amb el diari.",
    AppConstants.aboutFeature4:
        "• Personalitza amb diferents estils de text.",
    AppConstants.aboutFeature5:
        "• Funciona totalment fora de línia; les dades queden al dispositiu.",
    AppConstants.openSource: "Codi obert",
    AppConstants.openSourceDesc:
        "OpenJot és una aplicació de codi obert. El codi font és disponible públicament perquè qualsevol el pugui revisar, modificar i col·laborar-hi. Creiem en la transparència i la comunitat.",
    AppConstants.dataPrivacy: "Privadesa de les dades",
    AppConstants.dataPrivacyDesc:
        "Valorem la teva privadesa. OpenJot no recull, emmagatzema ni transmet cap dada personal. Totes les entrades, imatges i àudios es guarden exclusivament al teu dispositiu.",
    AppConstants.linksTitle: "Enllaços",
    AppConstants.sourceCodeOnGithub: "Codi font a GitHub",
    AppConstants.sendFeedback: "Envia comentaris",
    AppConstants.couldNotLaunchUrl: "No s'ha pogut obrir l'URL",
    AppConstants.termsIntro:
        "Benvingut a OpenJot! Aquest document detalla els termes i condicions d'ús de la nostra aplicació. En utilitzar OpenJot, acceptes aquests termes.",
    AppConstants.termsSectionDataPrivacy:
        "Emmagatzematge de dades i privadesa",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot està dissenyat com un espai privat per als teus pensaments. Totes les entrades, inclosos textos, imatges, àudios i altres fitxers, s'emmagatzemen exclusivament al teu dispositiu local. No s'envia cap dada a servidors externs.",
    AppConstants.termsSectionUserContent: "Contingut generat per l'usuari",
    AppConstants.termsSectionUserContentBody:
        "Ets l'únic responsable del contingut que crees i deses dins d'OpenJot. És la teva responsabilitat assegurar-te que tens els drets necessaris sobre qualsevol contingut importat.",
    AppConstants.termsSectionDisclaimer: "Exempció de garantia",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot es proporciona \"tal com és\" sense cap garantia expressa o implícita. No garantim que l'aplicació estigui lliure d'errors o interrupcions. L'ús és sota la teva responsabilitat.",
    AppConstants.termsSectionLiability: "Limitació de responsabilitat",
    AppConstants.termsSectionLiabilityBody:
        "En cap cas els desenvolupadors d'OpenJot seran responsables de danys directes, indirectes, incidentals, especials o conseqüents, inclosa la pèrdua de dades, derivats de l'ús o impossibilitat d'ús d'aquesta aplicació.",
    AppConstants.termsSectionThirdParty: "Biblioteques de tercers",
    AppConstants.termsSectionThirdPartyBody:
        "Aquesta aplicació utilitza les biblioteques de tercers següents, cadascuna regida per la seva pròpia llicència:",

    // Months
    'January': 'Gener',
    'February': 'Febrer',
    'March': 'Març',
    'April': 'Abril',
    'May': 'Maig',
    'June': 'Juny',
    'July': 'Juliol',
    'August': 'Agost',
    'September': 'Setembre',
    'October': 'Octubre',
    'November': 'Novembre',
    'December': 'Desembre',

    // Reflection Prompts (61)
    "What made you smile today?": "Què t'ha fet somriure avui?",
    "Who are you thankful for this week, and why?":
        "A qui estàs agraït aquesta setmana i per què?",
    "What is something small that brought you joy today?":
        "Quina petita cosa t'ha portat alegria avui?",
    "Which part of your day felt most comforting?":
        "Quina part del dia t'ha semblat més reconfortant?",
    "What’s something you often take for granted but appreciate now?":
        "Què acostumes a donar per fet però ara aprecies?",
    "What’s the best thing that happened today?":
        "Quina és la millor cosa que ha passat avui?",
    "Did someone make your day easier today?":
        "Algú t'ha fet el dia més fàcil avui?",
    "Who made a positive impact on you recently?":
        "Qui ha tingut un impacte positiu en tu recentment?",
    "What’s a quality you admire in someone close to you?":
        "Quina qualitat admires en algú proper?",
    "When did you last feel truly connected with someone?":
        "Quan va ser l'última vegada que et vas sentir realment connectat amb algú?",
    "Who do you want to reach out to soon?":
        "Amb qui et vols posar en contacte aviat?",
    "Did someone’s kindness stand out today?":
        "Ha destacat avui l'amabilitat d'algú?",
    "How did you support someone else recently?":
        "Com has donat suport a algú recentment?",
    "Who do you miss the most right now?": "Qui trobes més a faltar ara mateix?",
    "What’s a moment from today you want to remember?":
        "Quin moment d'avui vols recordar?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Quin detall d'avui podries oblidar si no l'anotes?",
    "What’s the most peaceful moment you had today?":
        "Quin ha estat el moment més tranquil que has tingut avui?",
    "Did you see something beautiful today?": "Has vist alguna cosa bonica avui?",
    "Which memory from this week stands out?":
        "Quin record d'aquesta setmana destaca?",
    "What song, photo, or place will always remind you of today?":
        "Quina cançó, foto o lloc et recordarà sempre a avui?",
    "What surprised you today?": "Què t'ha sorprès avui?",
    "What challenge did you overcome today?": "Quin repte has superat avui?",
    "What’s a small win you had today?": "Quina petita victòria has tingut avui?",
    "What new thing did you learn about yourself recently?":
        "Què has après de nou sobre tu recentment?",
    "What are you proud of yourself for?": "De què estàs orgullós de tu mateix?",
    "What habit do you feel good about keeping?":
        "Quin hàbit et fa sentir bé mantenir?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Quina millora has notat en tu aquest any?",
    "How did you push yourself out of your comfort zone?":
        "Com has sortit de la teva zona de confort?",
    "How are you truly feeling right now?": "Com et sents realment ara mateix?",
    "Which emotion stood out the most today?":
        "Quina emoció ha destacat més avui?",
    "Did you feel present in any moment today?":
        "T'has sentit present en algun moment avui?",
    "When did you feel the most at peace today?":
        "Quan t'has sentit més en pau avui?",
    "What gave you energy today?": "Què t'ha donat energia avui?",
    "What drained your energy today?": "Què t'ha esgotat l'energia avui?",
    "If your mood had a color today, what would it be?":
        "Si el teu estat d'ànim tingués un color avui, quin seria?",
    "What’s something you’re excited about tomorrow?":
        "Què t'il·lusiona de demà?",
    "What’s one thing you want to improve tomorrow?":
        "Quina cosa vols millorar demà?",
    "What would make tomorrow feel successful?":
        "Què faria que demà fos un dia reeixit?",
    "What do you hope to achieve this week?":
        "Què esperes aconseguir aquesta setmana?",
    "What’s a habit you’d like to start tomorrow?":
        "Quin hàbit t'agradaria començar demà?",
    "What’s something you want to look forward to in the next month?":
        "Què esperes amb il·lusió durant el mes vinent?",
    "What would your ideal tomorrow look like?":
        "Com seria el teu demà ideal?",
    "What’s one lesson you learned recently?":
        "Quina lliçó has après recentment?",
    "If you could freeze one moment today, which would it be?":
        "Si poguessis congelar un moment d'avui, quin seria?",
    "What makes your life feel meaningful right now?":
        "Què fa que la teva vida tingui sentit ara mateix?",
    "If you described today in one word, what would it be?":
        "Si descrivissis avui en una paraula, quina seria?",
    "What inspired you today?": "Què t'ha inspirat avui?",
    "What did you notice today that you usually overlook?":
        "Què has notat avui que normalment passes per alt?",
    "How has today changed your perspective?":
        "Com ha canviat avui la teva perspectiva?",
    "What’s something you’ve been overthinking?":
        "A què li has estat donant massa voltes?",
    "What do you need to let go of?": "Què necessites deixar anar?",
    "What part of nature did you notice today?":
        "Quina part de la natura has notat avui?",
    "Did the weather affect your mood today?":
        "El temps ha afectat el teu estat d'ànim avui?",
    "What place felt most comforting today?":
        "Quin lloc t'ha resultat més reconfortant avui?",
    "Where did you feel most at home today?":
        "On t'has sentit més com a casa avui?",
    "What sound or smell reminded you of something important?":
        "Quin so o olor t'ha recordat alguna cosa important?",
    "How did you take care of yourself today?":
        "Com t'has cuidat avui?",
    "When did you feel most like yourself today?":
        "Quan t'has sentit més tu mateix avui?",
    "What’s something kind you can say to yourself right now?":
        "Quina cosa amable et pots dir ara mateix?",
    "What do you want to forgive yourself for?":
        "Per què et vols perdonar?",
    "What do you deserve more of in your life?":
        "De què mereixes més a la teva vida?",
  },
  'sv': <String, String>{
    // Home & Core
    AppConstants.journalTitle: "Min dagbok",
    AppConstants.noEntriesMessage: "Inga dagboksinlägg ännu. Börja skriva!",
    AppConstants.noBookmarksYet: "Inga bokmärken ännu.",
    AppConstants.noDraftsYet: "Inga utkast ännu.",
    AppConstants.addEntryButton: "Lägg till nytt inlägg",
    AppConstants.jotYourThoughts: "Skriv ner dina tankar",
    AppConstants.tapToCreateJournal:
        "Tryck på + för att skapa din personliga dagbok.",
    AppConstants.entriesThisYear: "Inlägg i år",
    AppConstants.wordsWritten: "Skrivna ord",
    AppConstants.daysJournaled: "Dagar med inlägg",

    // Write / Edit Journal
    AppConstants.addEntryAppBarTitle: "Nytt dagboksinlägg",
    AppConstants.editEntryAppBarTitle: "Redigera dagboksinlägg",
    AppConstants.titleHintText: "Titel (t.ex. 'Min dag', 'Tankar om...')",
    AppConstants.contentHintText: "Skriv dina tankar här...",
    AppConstants.saveButton: "Spara inlägg",
    AppConstants.updateButton: "Uppdatera",
    AppConstants.deleteButton: "Ta bort inlägg",
    AppConstants.requiredFieldMessage: "Detta fält får inte vara tomt.",
    AppConstants.newEntry: "Nytt inlägg",
    AppConstants.todayDate: "Dagens datum",
    AppConstants.customDate: "Anpassat datum",
    AppConstants.done: "Klar",
    AppConstants.startWriting: " Börja skriva...",
    AppConstants.tags: "Taggar",
    AppConstants.addTags: "Lägg till taggar",
    AppConstants.openInMaps: "Öppna i Kartor",
    AppConstants.changeLocation: "Byt plats",
    AppConstants.remove: "Ta bort",
    AppConstants.discardSelectionsTitle: "Kassera val?",
    AppConstants.discardSelectionsMessage:
        "Du har valt media eller en aktiv inspelning. Är du säker på att du vill kassera dem?",
    AppConstants.journalEntryEmpty: "Dagboksinlägget får inte vara tomt",
    AppConstants.discardDateConfirm:
        "Kassera valt datum/tid för detta inlägg?",
    AppConstants.addMediaLocationMoodFirst:
        "Lägg till media, plats eller humör först",
    AppConstants.location: "Plats",
    AppConstants.record: "Spela in",
    AppConstants.selectMomentsToJournal: "Välj ögonblick att spara",
    AppConstants.addMomentsFromMenu:
        "Lägg till media, plats, inspelning eller humör från menyn",
    AppConstants.writeSomething: "Skriv något",
    AppConstants.saveWithoutWriting: "Spara utan text",
    AppConstants.oneLocation: "1 plats",
    AppConstants.mediaCount: "%d media",

    // Dialogs & Toasts
    AppConstants.confirmDeleteTitle: "Bekräfta borttagning",
    AppConstants.confirmDeleteMessage:
        "Är du säker på att du vill ta bort detta inlägg?",
    AppConstants.pleaseConfirm: "Bekräfta",
    AppConstants.confirmDeleteJournalEntry:
        "Är du säker på att du vill ta bort detta dagboksinlägg? Åtgärden kan inte ångras.",
    AppConstants.yes: "Ja",
    AppConstants.no: "Nej",
    AppConstants.cancel: "Avbryt",
    AppConstants.delete: "Ta bort",
    AppConstants.save: "Spara",
    AppConstants.entrySavedSuccess: "Dagboksinlägg sparat!",
    AppConstants.entryUpdatedSuccess: "Dagboksinlägg uppdaterat!",
    AppConstants.entryDeletedSuccess: "Dagboksinlägg borttaget.",
    AppConstants.errorSavingEntry: "Kunde inte spara inlägget.",
    AppConstants.errorDeletingEntry: "Kunde inte ta bort inlägget.",
    AppConstants.errorLoadingEntries: "Kunde inte läsa in dagboksinlägg.",
    AppConstants.noEntriesForDate: "Inga inlägg för detta datum.",
    AppConstants.noEntriesForMonth: "Inga inlägg hittades för denna månad.",
    AppConstants.selectMonthAndYear: "Välj månad och år",

    // Moods & Tile Actions
    AppConstants.veryUnpleasant: "Mycket obehaglig",
    AppConstants.unpleasant: "Obehaglig",
    AppConstants.slightlyUnpleasant: "Något obehaglig",
    AppConstants.neutral: "Neutral",
    AppConstants.slightlyPleasant: "Något behaglig",
    AppConstants.pleasant: "Behaglig",
    AppConstants.veryPleasant: "Mycket behaglig",
    AppConstants.reflection: "Reflektion",
    AppConstants.edit: "Redigera",
    AppConstants.removeBookmark: "Ta bort bokmärke",
    AppConstants.bookmark: "Bokmärke",
    AppConstants.share: "Dela",
    AppConstants.saveAsPdf: "Spara som PDF",
    AppConstants.audioTrack: "Ljudspår",
    AppConstants.generatingPdf: "Skapar PDF...",
    AppConstants.voiceRecording: "Röstinspelning",
    AppConstants.audioRecording: "Ljudinspelning",
    AppConstants.couldNotLoadAudio: "Kunde inte ladda ljudfilen.",
    AppConstants.stateOfMind: "Sinnesstämning",

    // Mood Colors
    AppConstants.moodColors: "Humörfärger",
    AppConstants.customizeMoodColors: "Anpassa humörfärger",
    AppConstants.reset: "Återställ",
    AppConstants.resetMoodColors: "Återställ till standard",
    AppConstants.resetMoodColorsConfirm:
        "Återställa alla humörfärger till standard?",
    AppConstants.paletteThemes: "Paletteman",
    AppConstants.customColor: "Egen färg",
    AppConstants.moodUnsavedChangesMessage:
        "Du har osparade ändringar av humörfärger. Vill du spara dem innan du stänger?",

    // Drafts & Auto-save
    AppConstants.drafts: "Utkast",
    AppConstants.draft: "Utkast",
    AppConstants.draftSaved: "Sparat i utkast",
    AppConstants.unsavedChanges: "Osparade ändringar",
    AppConstants.unsavedChangesMessage:
        "Du har osparade ändringar. Vill du spara dem som utkast eller kasta dem?",
    AppConstants.saveAsDraft: "Spara som utkast",
    AppConstants.discardChanges: "Kasta",
    AppConstants.autoDeleteDrafts: "Radera utkast automatiskt",
    AppConstants.days7: "7 dagar",
    AppConstants.never: "Aldrig",
    AppConstants.custom: "Anpassad...",
    AppConstants.enterCustomDays: "Ange antal dagar",
    AppConstants.customDaysExample: "T.ex. 14",
    AppConstants.days: "Dagar",
    AppConstants.draftsNeverDeleted: "Utkast tas aldrig bort",
    AppConstants.draftsDeletedAfterDays: "Utkast tas bort efter %d dagar",

    // Home Menu & Sorting
    AppConstants.sortBy: "Sortera efter",
    AppConstants.insights: "Insikter",
    AppConstants.reflections: "Reflektioner",
    AppConstants.settings: "Inställningar",
    AppConstants.entryTime: "Inläggstid",
    AppConstants.bookmarkFirst: "Bokmärken först",
    AppConstants.reflectionFirst: "Reflektioner först",
    AppConstants.withMediaFirst: "Med media först",
    AppConstants.textOnlyFirst: "Endast text först",
    AppConstants.withLocationFirst: "Med plats först",
    AppConstants.withMoodFirst: "Med humör först",
    AppConstants.withTagsFirst: "Med taggar först",

    // Insights
    AppConstants.stats: "Statistik",
    AppConstants.calendar: "Kalender",
    AppConstants.entriesSuffix: " inlägg",
    AppConstants.memoriesFromThisDay: "Minnen från denna dag",
    AppConstants.standard: "Standard",
    AppConstants.media: "Media",
    AppConstants.mood: "Humör",
    AppConstants.mostly: "Mestadels",
    AppConstants.averageForThisDay: "Genomsnitt för denna dag",
    AppConstants.averageForThisYear: "Genomsnitt för i år",

    // Onboarding
    AppConstants.welcomeToOpenJot: "Välkommen till OpenJot",
    AppConstants.feature1:
        "Skriv fritt, lägg till foton och platser och håll allt säkert på din enhet.",
    AppConstants.feature2:
        "Förstå dina känslor över tid med inbyggd humörspårning.",
    AppConstants.feature3:
        "Dina data stannar på din telefon – inget moln, bara lokal lagring och fullständig integritet.",
    AppConstants.continueButton: "Fortsätt",

    // Notifications
    AppConstants.notificationTitle: "Dags att skriva dagbok!",
    AppConstants.notificationBody:
        "Glöm inte att skriva ner dagens tankar.",
    AppConstants.notificationChannelName: "Dagliga dagbokspåminnelser",
    AppConstants.notificationChannelDescription:
        "Kanal för dagliga dagbokspåminnelser",
    AppConstants.onThisDayChannelName: "Minnen på denna dag",
    AppConstants.onThisDayChannelDescription:
        "Aviseringar om minnen från tidigare år.",
    AppConstants.onThisDayNotificationTitle: "Ett minne från din dagbok",
    AppConstants.onThisDaySingleEntry:
        "För ett år sedan idag skrev du något speciellt. Tryck för att läsa dina tankar igen.",
    AppConstants.onThisDaySingleEntryWithMedia:
        "Denna dag förra året delade du detta minne. Tryck för att återuppleva det.",
    AppConstants.onThisDayMultipleEntries:
        "Du har minnen från denna dag från tidigare år. Tryck för att se dem.",
    AppConstants.onThisDayGroupedNotification:
        "Du har %d minnen från denna dag",

    // Exclude Entries
    AppConstants.excludeEntries: "Exkludera inlägg",
    AppConstants.saveExclusions: "Spara undantag",
    AppConstants.excludeUnsavedChangesMessage:
        "Du har osparade ändringar. Är du säker på att du vill kasta dem och avsluta?",
    AppConstants.sortDefault: "Standard",
    AppConstants.sortMutedFirst: "Tystade först",
    AppConstants.sortUnmutedFirst: "Aktiva först",

    // Toolbar & Media & Map & DatePicker
    AppConstants.today: "Idag",
    AppConstants.yesterday: "Igår",
    AppConstants.contentForQuote: "Innehåll för citat",
    AppConstants.noContentSelected: "Inget innehåll valt.",
    AppConstants.photos: "Foton",
    AppConstants.video: "Video",
    AppConstants.audio: "Ljud",
    AppConstants.add: "Lägg till",
    AppConstants.noMediaFound: "Inga %s hittades.",
    AppConstants.permissionRequired:
        "Åtkomstbehörighet till %s krävs för att visa dem.",
    AppConstants.openSettings: "Öppna inställningar",
    AppConstants.videos: "Videor",
    AppConstants.audios: "Ljudfiler",
    AppConstants.gif: "GIF",
    AppConstants.deleteRecordingTitle: "Ta bort inspelning?",
    AppConstants.deleteRecordingMessage:
        "Är du säker på att du vill ta bort denna inspelning?",
    AppConstants.listen: "Lyssna",
    AppConstants.tapAndHold: "tryck och håll",
    AppConstants.clear: "Rensa",
    AppConstants.all: "Alla",
    AppConstants.folder: "Mapp",
    AppConstants.browse: "Bläddra",
    AppConstants.tiles: "Rutor",
    AppConstants.graph: "Graf",
    AppConstants.recording: "Spelar in...",
    AppConstants.recordingLabel: "Inspelning",
    AppConstants.startAudioRecording: "Starta ljudinspelning",
    AppConstants.howAreYouFeeling: "Hur mår du?",
    AppConstants.paused: "Pausad",
    AppConstants.stop: "Stoppa",
    AppConstants.tapOrHoldToResume: "Tryck eller håll för att återuppta",
    AppConstants.tapOrReleaseToPause: "Tryck eller släpp för att pausa",
    AppConstants.unsupportedImageType: "Bildtyp stöds inte",
    AppConstants.couldNotLoadVideo: "Kunde inte ladda video",
    AppConstants.couldNotOpenMap: "Kunde inte öppna kartlänken.",
    AppConstants.dismiss: "Stäng",
    AppConstants.selectTime: "Välj tid",
    AppConstants.now: "Nu",
    AppConstants.searchPlacesHint: "Sök platser, butiker...",
    AppConstants.locationPermissionDenied: "Platsbehörighet nekad.",
    AppConstants.failedGetCurrentLocation:
        "Kunde inte hämta nuvarande plats.",

    // Search
    AppConstants.searchJournalsHint: "Sök i dagböcker...",
    AppConstants.textOnly: "Endast text",
    AppConstants.withMedia: "Med media",
    AppConstants.withMood: "Med humör",
    AppConstants.withLocation: "Med plats",
    AppConstants.withTags: "Med taggar",
    AppConstants.noResultsFound: "Inga resultat hittades",
    AppConstants.searchHintText: "Sök inlägg...",

    // Settings
    AppConstants.language: "Språk",
    AppConstants.selectLanguage: "Välj språk",
    AppConstants.systemDefault: "Systemstandard",
    AppConstants.searchLanguagesHint: "Sök språk...",
    AppConstants.languageChanged: "Språk ändrat till %s.",
    AppConstants.dailyReminder: "Påminnelser",
    AppConstants.addReminder: "Lägg till påminnelse",
    AppConstants.deleteReminder: "Ta bort påminnelse",
    AppConstants.noRemindersSet: "Inga påminnelser inställda.",
    AppConstants.onThisDay: "På denna dag",
    AppConstants.appLock: "Applås",
    AppConstants.backup: "Säkerhetskopia",
    AppConstants.restore: "Återställ",
    AppConstants.importFromAnotherApp: "Importera från annan app",
    AppConstants.importFromDailyYou: "Importera från Daily You",
    AppConstants.selectDailyYouBackup:
        "Välj Daily You-zip-fil för säkerhetskopia",
    AppConstants.importingEntries: "Importerar inlägg...",
    AppConstants.importSuccess:
        "Importerade %d inlägg från Daily You!",
    AppConstants.importFailed: "Import misslyckades: %s",
    AppConstants.noEntriesToImport: "Inga nya inlägg att importera.",
    AppConstants.askSupport: "Be om hjälp",
    AppConstants.importSupportNote:
        "Andra appformat kanske inte stöder alla funktioner. Om du stöter på problem eller formaten ändras, vänligen skicka en felrapport.",
    AppConstants.extractingBackup: "Packar upp säkerhetskopia...",
    AppConstants.parsingDatabase: "Läser databas...",
    AppConstants.dailyYouDbNotFound:
        "Daily You-databasen hittades inte i säkerhetskopian.",
    AppConstants.privacyPolicy: "Integritetspolicy",
    AppConstants.termsNConditions: "Användarvillkor",
    AppConstants.about: "Om appen",
    AppConstants.changeTheme: "Byt tema",
    AppConstants.theme: "Tema",
    AppConstants.pitchBlack: "Kolsvart",
    AppConstants.themeLight: "Ljust",
    AppConstants.themeDark: "Mörkt",
    AppConstants.themeSystem: "System",
    AppConstants.changePin: "Byt PIN",
    AppConstants.loading: "Laddar...",
    AppConstants.confirmRestoreTitle: "Bekräfta återställning",
    AppConstants.confirmRestoreMessage:
        "Att återställa från en säkerhetskopia skriver över alla nuvarande data. Detta går inte att ångra. Vill du fortsätta?",
    AppConstants.notificationScheduled: "Avisering schemalagd till %s",
    AppConstants.notificationCanceled: "Avisering avbruten",
    AppConstants.notificationRescheduled: "Avisering ombokad till %s",
    AppConstants.notificationPermissionRequired:
        "Aviseringsbehörighet krävs för att ställa in påminnelser.",
    AppConstants.pinChangedSuccess: "PIN har ändrats",
    AppConstants.onThisDayOn: "Du får nu minnen från denna dag.",
    AppConstants.onThisDayOff:
        "Påminnelser för 'På denna dag' är avstängda.",
    AppConstants.themeChanged: "Tema %s valt.",
    AppConstants.hideStats: "Dölj statistik",
    AppConstants.hideHomeStats: "Dölj statistik på startsidan",
    AppConstants.hideInsightsStats: "Dölj statistik i insikter",

    // Reflection Sheet
    AppConstants.reflectionTitle: "REFLEKTION",
    AppConstants.reflectButton: "Reflektera",

    // PIN & Encryption & Backup
    AppConstants.incorrectPin: "Fel PIN",
    AppConstants.verifyYourPin: "Bekräfta din PIN",
    AppConstants.setAPin: "Ange en PIN",
    AppConstants.confirmPin: "Bekräfta PIN",
    AppConstants.pinsDoNotMatch: "PIN-koderna stämmer inte överens",
    AppConstants.setPin: "Ange PIN",
    AppConstants.hello: "Hej!",
    AppConstants.enterYourPin: "Ange din PIN",
    AppConstants.useBiometrics: "Använd biometri",
    AppConstants.authenticateToUnlock:
        "Autentisera för att låsa upp appen",
    AppConstants.databaseEncryption: "Databaskryptering",
    AppConstants.databaseEncryptionDesc: "Lokal AES-256-GCM-kryptering",
    AppConstants.changeMasterPassword: "Byt huvudlösenord",
    AppConstants.biometricUnlock: "Biometrisk upplåsning",
    AppConstants.enterMasterPassword: "Ange huvudlösenord",
    AppConstants.enterMasterPasswordHint:
        "Ange ditt huvudlösenord för att dekryptera din dagbok.",
    AppConstants.unlockButton: "Lås upp",
    AppConstants.unlockWithBiometrics: "Lås upp med biometri",
    AppConstants.incorrectMasterPassword:
        "Fel huvudlösenord. Försök igen.",
    AppConstants.databaseEncryptedSuccess:
        "Dagboksdatabas krypterad med AES-256-GCM.",
    AppConstants.databaseDecryptedSuccess:
        "Dagboksdatabas dekrypterad och applås avstängt.",
    AppConstants.masterPasswordChangedSuccess:
        "Huvudlösenordet har uppdaterats.",
    AppConstants.encryptedBackupPasswordRequired:
        "Ett lösenord krävs för att öppna en krypterad säkerhetskopia.",
    AppConstants.incorrectBackupPassword:
        "Fel lösenord för säkerhetskopian.",
    AppConstants.invalidBackupFile:
        "Den valda filen är inte en giltig OpenJot-säkerhetskopia.",
    AppConstants.encryptedBackup: "Krypterad säkerhetskopia (.openjot)",
    AppConstants.encryptedBackupDesc:
        "Skyddad med AES-256-GCM och ett säkerhetskopialösenord",
    AppConstants.standardBackup: "Standardsäkerhetskopia (.zip)",
    AppConstants.standardBackupDesc:
        "Okrypterat arkiv kompatibelt med alla versioner",
    AppConstants.takingBackup: "Skapar säkerhetskopia...",
    AppConstants.encryptingBackup: "Krypterar säkerhetskopia...",
    AppConstants.savingBackup: "Sparar säkerhetskopia...",
    AppConstants.preparingBackup: "Förbereder säkerhetskopia...",
    AppConstants.decryptingBackup: "Dekrypterar säkerhetskopia...",
    AppConstants.restoringBackup: "Återställer säkerhetskopia...",
    AppConstants.backupEncodingFailed:
        "Kunde inte koda säkerhetskopiefilen.",
    AppConstants.backupCreatedSuccess: "Säkerhetskopia skapad!",
    AppConstants.backupFailed: "Kunde inte skapa säkerhetskopia: %s",
    AppConstants.restorePermissionsRequired:
        "Lagrings- och mediebehörighet krävs för att återställa data.",
    AppConstants.databaseRestoredNoMedia:
        "Databas återställd. Ingen media hittades i säkerhetskopian.",
    AppConstants.restoreSuccess: "Återställning lyckades!",
    AppConstants.restoreSuccessRestartRecommended:
        "Återställning lyckades. Omstart rekommenderas för att tillämpa alla ändringar.",
    AppConstants.restoreFailed: "Kunde inte återställa data: %s",
    AppConstants.storagePermissionsRequired:
        "Lagrings- och mediebehörighet krävs för att skapa en säkerhetskopia.",
    AppConstants.selectBackupFolder:
        "Välj en mapp för att spara säkerhetskopian",
    AppConstants.encryptDatabase: "Kryptera databas",
    AppConstants.disableEncryption: "Inaktivera kryptering",
    AppConstants.backupPasswordTitle: "Säkerhetskopialösenord",
    AppConstants.changeMasterPasswordDesc:
        "Ange ditt nuvarande huvudlösenord och välj ett nytt lösenord (minst 6 tecken).",
    AppConstants.disableEncryptionDesc:
        "Ange ditt huvudlösenord för att dekryptera databasen på disken och stänga av kryptering.",
    AppConstants.enableEncryptionDesc:
        "Skydda alla dagboksanteckningar lokalt med AES-256-GCM-kryptering. Om du glömmer ditt huvudlösenord kan krypterad data inte återställas.",
    AppConstants.verifyForBiometricsDesc:
        "Ange ditt huvudlösenord en gång för att lagra en upplåsningsnyckel i säker hårdvarulagring för snabb biometrisk upplåsning.",
    AppConstants.createBackupPasswordDesc:
        "Ange ett starkt lösenord för att kryptera denna .openjot-säkerhetskopia. Du behöver detta lösenord för att återställa den på valfri enhet.",
    AppConstants.enterBackupPasswordDesc:
        "Ange lösenordet som användes när denna .openjot-säkerhetskopia skapades.",
    AppConstants.updatePasswordAction: "Uppdatera lösenord",
    AppConstants.decryptAndDisable: "Dekryptera och inaktivera",
    AppConstants.enableBiometricsAction: "Aktivera biometri",
    AppConstants.createBackupAction: "Skapa säkerhetskopia",
    AppConstants.decryptBackupAction: "Dekryptera säkerhetskopia",
    AppConstants.newMasterPasswordHint: "Nytt huvudlösenord",
    AppConstants.backupPasswordHint: "Säkerhetskopialösenord",
    AppConstants.masterPasswordHint: "Huvudlösenord",
    AppConstants.enterCurrentMasterPasswordError:
        "Ange ditt nuvarande huvudlösenord.",
    AppConstants.passwordEmptyError: "Lösenordet får inte vara tomt.",
    AppConstants.passwordMinLengthError:
        "Lösenordet måste vara minst 6 tecken långt.",
    AppConstants.passwordsDoNotMatchError:
        "Lösenorden stämmer inte överens.",
    AppConstants.currentMasterPasswordHint: "Nuvarande huvudlösenord",
    AppConstants.confirmPasswordHint: "Bekräfta lösenord",

    // About & Terms
    AppConstants.aboutApp: "Om OpenJot",
    AppConstants.versionPrefix: "Version: %s",
    AppConstants.aboutSubtitle:
        "En minimalistisk dagbok med öppen källkod för att skriva ner dina tankar, humör och minnen. All din data stannar på din enhet.",
    AppConstants.keyFeatures: "Huvudfunktioner",
    AppConstants.aboutFeature1: "• Ren, distraktionsfri skrivupplevelse.",
    AppConstants.aboutFeature2:
        "• Lägg till foton, röstanteckningar och musik i dina inlägg.",
    AppConstants.aboutFeature3: "• Registrera ditt humör med dina inlägg.",
    AppConstants.aboutFeature4: "• Anpassa med olika textstilar.",
    AppConstants.aboutFeature5:
        "• Fungerar helt offline, din data stannar på din enhet.",
    AppConstants.openSource: "Öppen källkod",
    AppConstants.openSourceDesc:
        "OpenJot är en applikation med öppen källkod. Källkoden är offentligt tillgänglig för alla att granska, ändra och bidra till. Vi tror på transparens och gemenskap.",
    AppConstants.dataPrivacy: "Datasekretess",
    AppConstants.dataPrivacyDesc:
        "Vi värnar om din integritet. OpenJot samlar inte in, lagrar eller överför någon personlig data. Alla dina inlägg, inklusive bilder och ljud, lagras enbart på din enhet.",
    AppConstants.linksTitle: "Länkar",
    AppConstants.sourceCodeOnGithub: "Källkod på GitHub",
    AppConstants.sendFeedback: "Skicka feedback",
    AppConstants.couldNotLaunchUrl: "Kunde inte öppna URL",
    AppConstants.termsIntro:
        "Välkommen till OpenJot! Detta dokument beskriver villkoren för att använda vår applikation. Genom att använda OpenJot godkänner du dessa villkor.",
    AppConstants.termsSectionDataPrivacy: "Datalagring och integritet",
    AppConstants.termsSectionDataPrivacyBody:
        "OpenJot är utformad som en privat plats för dina tankar. Alla inlägg, inklusive text, bilder, ljudfiler och annan media, lagras enbart lokalt på din enhet. Appen skickar inga personuppgifter till externa servrar.",
    AppConstants.termsSectionUserContent: "Användarskapat innehåll",
    AppConstants.termsSectionUserContentBody:
        "Du är ensam ansvarig för innehållet du skapar och sparar i OpenJot, inklusive text, bilder och ljudinspelningar. Du ansvarar för att du har nödvändiga rättigheter för allt importerat innehåll.",
    AppConstants.termsSectionDisclaimer: "Garantifriskrivning",
    AppConstants.termsSectionDisclaimerBody:
        "OpenJot tillhandahålls \"i befintligt skick\" utan några uttryckliga eller underförstådda garantier. Vi garanterar inte att appen är felfri eller avbrottsfri. Användning sker på egen risk.",
    AppConstants.termsSectionLiability: "Ansvarsbegränsning",
    AppConstants.termsSectionLiabilityBody:
        "Under inga omständigheter ska utvecklarna av OpenJot hållas ansvariga för direkta, indirekta, tillfälliga, särskilda skador eller följdskador, inklusive dataförlust, som uppstår genom användning eller oförmåga att använda appen.",
    AppConstants.termsSectionThirdParty: "Tredjepartsbibliotek",
    AppConstants.termsSectionThirdPartyBody:
        "Denna applikation använder följande tredjepartsbibliotek, som vart och ett styrs av sin egen licens:",

    // Months
    'January': 'Januari',
    'February': 'Februari',
    'March': 'Mars',
    'April': 'April',
    'May': 'Maj',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'Augusti',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'December',

    // Reflection Prompts (61)
    "What made you smile today?": "Vad fick dig att le idag?",
    "Who are you thankful for this week, and why?":
        "Vem är du tacksam för den här veckan, och varför?",
    "What is something small that brought you joy today?":
        "Vad var något litet som gav dig glädje idag?",
    "Which part of your day felt most comforting?":
        "Vilken del av din dag kändes mest trösterik?",
    "What’s something you often take for granted but appreciate now?":
        "Vad tar du ofta för givet men uppskattar nu?",
    "What’s the best thing that happened today?":
        "Vad var det bästa som hände idag?",
    "Did someone make your day easier today?":
        "Gjorde någon din dag lättare idag?",
    "Who made a positive impact on you recently?":
        "Vem har gjort ett positivt intryck på dig nyligen?",
    "What’s a quality you admire in someone close to you?":
        "Vilken egenskap beundrar du hos någon nära dig?",
    "When did you last feel truly connected with someone?":
        "När kände du dig senast riktigt nära förbunden med någon?",
    "Who do you want to reach out to soon?":
        "Vem vill du höra av dig till snart?",
    "Did someone’s kindness stand out today?":
        "Utmärkte sig någons vänlighet idag?",
    "How did you support someone else recently?":
        "Hur stöttade du någon annan nyligen?",
    "Who do you miss the most right now?": "Vem saknar du mest just nu?",
    "What’s a moment from today you want to remember?":
        "Vilket ögonblick från idag vill du minnas?",
    "What’s a detail about today you might forget if you don’t note it?":
        "Vilken detalj från idag kan du glömma om du inte skriver ner den?",
    "What’s the most peaceful moment you had today?":
        "Vilket var ditt mest fridfulla ögonblick idag?",
    "Did you see something beautiful today?": "Såg du något vackert idag?",
    "Which memory from this week stands out?":
        "Vilket minne från den här veckan sticker ut?",
    "What song, photo, or place will always remind you of today?":
        "Vilken låt, vilket foto eller vilken plats kommer alltid påminna dig om idag?",
    "What surprised you today?": "Vad överraskade dig idag?",
    "What challenge did you overcome today?":
        "Vilken utmaning övervann du idag?",
    "What’s a small win you had today?":
        "Vilken liten seger hade du idag?",
    "What new thing did you learn about yourself recently?":
        "Vad nytt har du lärt dig om dig själv nyligen?",
    "What are you proud of yourself for?": "Vad är du stolt över hos dig själv?",
    "What habit do you feel good about keeping?":
        "Vilken vana känns det bra att behålla?",
    "What’s one improvement you’ve noticed in yourself this year?":
        "Vilken förbättring har du märkt hos dig själv i år?",
    "How did you push yourself out of your comfort zone?":
        "Hur tog du dig utanför din bekvämlighetszon?",
    "How are you truly feeling right now?":
        "Hur mår du egentligen just nu?",
    "Which emotion stood out the most today?":
        "Vilken känsla var starkast idag?",
    "Did you feel present in any moment today?":
        "Kände du dig närvarande i något ögonblick idag?",
    "When did you feel the most at peace today?":
        "När kände du dig som mest tillfreds idag?",
    "What gave you energy today?": "Vad gav dig energi idag?",
    "What drained your energy today?": "Vad tog din energi idag?",
    "If your mood had a color today, what would it be?":
        "Om ditt humör hade en färg idag, vilken skulle det vara?",
    "What’s something you’re excited about tomorrow?":
        "Vad ser du fram emot imorgon?",
    "What’s one thing you want to improve tomorrow?":
        "Vad vill du förbättra imorgon?",
    "What would make tomorrow feel successful?":
        "Vad skulle få morgondagen att kännas lyckad?",
    "What do you hope to achieve this week?":
        "Vad hoppas du uppnå denna vecka?",
    "What’s a habit you’d like to start tomorrow?":
        "Vilken vana skulle du vilja börja med imorgon?",
    "What’s something you want to look forward to in the next month?":
        "Vad vill du se fram emot under nästa månad?",
    "What would your ideal tomorrow look like?":
        "Hur skulle din ideala morgondag se ut?",
    "What’s one lesson you learned recently?":
        "Vilken lärdom har du dragit nyligen?",
    "If you could freeze one moment today, which would it be?":
        "Om du kunde frysa ett ögonblick idag, vilket skulle det vara?",
    "What makes your life feel meaningful right now?":
        "Vad får ditt liv att kännas meningsfullt just nu?",
    "If you described today in one word, what would it be?":
        "Om du skulle beskriva idag med ett ord, vilket skulle det vara?",
    "What inspired you today?": "Vad inspirerade dig idag?",
    "What did you notice today that you usually overlook?":
        "Vad lade du märke till idag som du annars brukar missa?",
    "How has today changed your perspective?":
        "Hur har dagen idag förändrat ditt perspektiv?",
    "What’s something you’ve been overthinking?":
        "Vad har du övertänkt på sistone?",
    "What do you need to let go of?": "Vad behöver du släppa taget om?",
    "What part of nature did you notice today?":
        "Vilken del av naturen lade du märke till idag?",
    "Did the weather affect your mood today?":
        "Påverkade vädret ditt humör idag?",
    "What place felt most comforting today?":
        "Vilken plats kändes mest trygg idag?",
    "Where did you feel most at home today?":
        "Var kände du dig mest hemma idag?",
    "What sound or smell reminded you of something important?":
        "Vilket ljud eller vilken doft påminde dig om något viktigt?",
    "How did you take care of yourself today?":
        "Hur tog du hand om dig själv idag?",
    "When did you feel most like yourself today?":
        "När kände du dig som mest som dig själv idag?",
    "What’s something kind you can say to yourself right now?":
        "Vad kan du säga som är snällt mot dig själv just nu?",
    "What do you want to forgive yourself for?":
        "Vad vill du förlåta dig själv för?",
    "What do you deserve more of in your life?":
        "Vad förtjänar du mer av i ditt liv?",
  },
};
