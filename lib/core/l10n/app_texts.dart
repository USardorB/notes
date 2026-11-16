import 'package:notes/core/l10n/generated/app_localizations.dart';
import 'package:notes/core/l10n/locale_controller.dart';

/// Context-free facade over Flutter's generated [AppLocalizations] (`.arb`).
///
/// Uses [rootNavigatorKey] when the widget tree is mounted, with a fallback to
/// [lookupAppLocalizations] so pure-Dart UseCases and Repositories can read
/// localized strings without passing `BuildContext`.
abstract final class AppTexts {
  static AppLanguage _language = AppLanguage.en;

  static void setLanguage(AppLanguage language) => _language = language;

  static AppLocalizations get _l10n {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      return AppLocalizations.of(ctx);
    }
    return lookupAppLocalizations(_language.locale);
  }

  // Brand & Common
  static String get appName => _l10n.appName;
  static String get appVersion => _l10n.appVersion;
  static String get copyright => _l10n.copyright;
  static String get cancel => _l10n.cancel;
  static String get no => _l10n.no;
  static String get done => _l10n.done;
  static String get next => _l10n.next;
  static String get reset => _l10n.reset;
  static String get save => _l10n.save;

  // Onboarding
  static String get welcomeTo => _l10n.welcomeTo;
  static String get onboardingSlide1Title => _l10n.onboardingSlide1Title;
  static String get onboardingSlide1Subtitle => _l10n.onboardingSlide1Subtitle;
  static String get onboardingSlide2Title => _l10n.onboardingSlide2Title;
  static String get onboardingSlide2Subtitle => _l10n.onboardingSlide2Subtitle;
  static String get onboardingSlide3Title => _l10n.onboardingSlide3Title;
  static String get onboardingSlide3Subtitle => _l10n.onboardingSlide3Subtitle;
  static String get createAccountUpper => _l10n.createAccountUpper;
  static String get logInUpper => _l10n.logInUpper;

  // Auth Screens
  static String get logIn => _l10n.logIn;
  static String get createAccount => _l10n.createAccount;
  static String get forgotPassword => _l10n.forgotPassword;
  static String get forgotPasswordQuestion => _l10n.forgotPasswordQuestion;
  static String get welcomeBack => _l10n.welcomeBack;
  static String get loginSubtitle => _l10n.loginSubtitle;
  static String get letsGetToKnowYou => _l10n.letsGetToKnowYou;
  static String get enterDetailsToContinue => _l10n.enterDetailsToContinue;
  static String get displayName => _l10n.displayName;
  static String get emailAddress => _l10n.emailAddress;
  static String get email => _l10n.email;
  static String get password => _l10n.password;
  static String get confirmPassword => _l10n.confirmPassword;
  static String get dontHaveAccount => _l10n.dontHaveAccount;
  static String get createAccountHere => _l10n.createAccountHere;
  static String get alreadyHaveAccount => _l10n.alreadyHaveAccount;
  static String get loginHere => _l10n.loginHere;
  static String get termsAgreementPrefix => _l10n.termsAgreementPrefix;
  static String get termsOfUse => _l10n.termsOfUse;
  static String get andWord => _l10n.andWord;
  static String get termsAgreementSuffix => _l10n.termsAgreementSuffix;
  static String get privacyPolicy => _l10n.privacyPolicy;
  static String get forgotPasswordPrompt => _l10n.forgotPasswordPrompt;
  static String get submitUpper => _l10n.submitUpper;
  static String get resetLinkSent => _l10n.resetLinkSent;

  // Bottom Navigation & Tabs
  static String get navNotes => _l10n.navNotes;
  static String get navOcr => _l10n.navOcr;
  static String get navHelp => _l10n.navHelp;
  static String get navMe => _l10n.navMe;

  // Notes Home & Editors
  static String get notesTitle => _l10n.notesTitle;
  static String get createFirstNote => _l10n.createFirstNote;
  static String get noNotesMatchColour => _l10n.noNotesMatchColour;
  static String get filterByColour => _l10n.filterByColour;
  static String get newItem => _l10n.newItem;
  static String get addNote => _l10n.addNote;
  static String get editNote => _l10n.editNote;
  static String get addNoteTitle => _l10n.addNoteTitle;
  static String get addTodo => _l10n.addTodo;
  static String get addTodoTitle => _l10n.addTodoTitle;
  static String get editTodoTitle => _l10n.editTodoTitle;
  static String get noteTitleHint => _l10n.noteTitleHint;
  static String get noteBodyHint => _l10n.noteBodyHint;
  static String get todoInputHint => _l10n.todoInputHint;
  static String get deleteNote => _l10n.deleteNote;
  static String get selectColour => _l10n.selectColour;
  static String get syncNotesTooltip => _l10n.syncNotesTooltip;

  // OCR Tab
  static String get imageToText => _l10n.imageToText;
  static String get uploadImagePrompt => _l10n.uploadImagePrompt;
  static String get clickScanPrompt => _l10n.clickScanPrompt;
  static String get noTextDetected => _l10n.noTextDetected;
  static String get clearImage => _l10n.clearImage;
  static String get scanImage => _l10n.scanImage;
  static String get takePhoto => _l10n.takePhoto;
  static String get chooseFromGallery => _l10n.chooseFromGallery;
  static String get uploadImageFirst => _l10n.uploadImageFirst;
  static String get copiedToClipboard => _l10n.copiedToClipboard;

  // Help & Profile
  static String get userGuide => _l10n.userGuide;
  static String get tapToView => _l10n.tapToView;
  static String get localAccountNotSynced => _l10n.localAccountNotSynced;
  static String get darkMode => _l10n.darkMode;
  static String get languageLabel => _l10n.languageLabel;
  static String get resetPassword => _l10n.resetPassword;
  static String get about => _l10n.about;
  static String get application => _l10n.application;
  static String get version => _l10n.version;
  static String get logOutUpper => _l10n.logOutUpper;
  static String get editDisplayName => _l10n.editDisplayName;

  // Dialogs
  static String get logOutTitle => _l10n.logOutTitle;
  static String get logOutConfirm => _l10n.logOutConfirm;
  static String get exitAppTitle => _l10n.exitAppTitle;
  static String get exitAppConfirm => _l10n.exitAppConfirm;
  static String get exitButton => _l10n.exitButton;
  static String get unsyncedDataTitle => _l10n.unsyncedDataTitle;
  static String get syncAndLogOut => _l10n.syncAndLogOut;
  static String get logOutWithoutSync => _l10n.logOutWithoutSync;

  // Validation & Errors
  static String get invalidEmailError => _l10n.invalidEmailError;
  static String get shortPasswordError => _l10n.shortPasswordError;
  static String get emptyDisplayNameError => _l10n.emptyDisplayNameError;
  static String get passwordMismatchError => _l10n.passwordMismatchError;
  static String get emptyNoteError => _l10n.emptyNoteError;
  static String get emptyTodoError => _l10n.emptyTodoError;
  static String get loginRequiresInternet => _l10n.loginRequiresInternet;
  static String get invalidCredentials => _l10n.invalidCredentials;

  // Guided Tours
  static String get skipTour => _l10n.skipTour;
  static String tourStepLabel(int step, int total) =>
      _l10n.tourStepLabel(step, total);
  static String get tourStep1Title => _l10n.tourStep1Title;
  static String get tourStep1Desc => _l10n.tourStep1Desc;
  static String get tourStep2Title => _l10n.tourStep2Title;
  static String get tourStep2Desc => _l10n.tourStep2Desc;
  static String get tourStep3Title => _l10n.tourStep3Title;
  static String get tourStep3Desc => _l10n.tourStep3Desc;
  static String get tourStep4Title => _l10n.tourStep4Title;
  static String get tourStep4Desc => _l10n.tourStep4Desc;
  static String get tourStep5Title => _l10n.tourStep5Title;
  static String get tourStep5Desc => _l10n.tourStep5Desc;
  static String get tourStep6Title => _l10n.tourStep6Title;
  static String get tourStep6Desc => _l10n.tourStep6Desc;

  static String get ocrTourStep1Title => _l10n.ocrTourStep1Title;
  static String get ocrTourStep1Desc => _l10n.ocrTourStep1Desc;
  static String get ocrTourStep2Title => _l10n.ocrTourStep2Title;
  static String get ocrTourStep2Desc => _l10n.ocrTourStep2Desc;
  static String get ocrTourStep3Title => _l10n.ocrTourStep3Title;
  static String get ocrTourStep3Desc => _l10n.ocrTourStep3Desc;
  static String get ocrTourStep4Title => _l10n.ocrTourStep4Title;
  static String get ocrTourStep4Desc => _l10n.ocrTourStep4Desc;

  static String formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return _l10n.justNow;
    if (diff.inMinutes < 60) return _l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return _l10n.hoursAgo(diff.inHours);
    if (diff.inDays == 1) return _l10n.oneDayAgo;
    return _l10n.daysAgo(diff.inDays);
  }
}
