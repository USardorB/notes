import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'HaBIT Note'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'V1.0.0'**
  String get appVersion;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© Copyright HABIT 2021. All rights reserved'**
  String get copyright;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO'**
  String get welcomeTo;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Take Notes'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Quickly capture what’s on your mind'**
  String get onboardingSlide1Subtitle;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'To-dos'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'List out your day-to-day tasks'**
  String get onboardingSlide2Subtitle;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Image to Text Converter'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your images and convert to text'**
  String get onboardingSlide3Subtitle;

  /// No description provided for @createAccountUpper.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccountUpper;

  /// No description provided for @logInUpper.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get logInUpper;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgotPasswordQuestion;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back !'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please login with your credentials'**
  String get loginSubtitle;

  /// No description provided for @letsGetToKnowYou.
  ///
  /// In en, this message translates to:
  /// **'Let’s get to know you !'**
  String get letsGetToKnowYou;

  /// No description provided for @enterDetailsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your details to continue'**
  String get enterDetailsToContinue;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account yet ?'**
  String get dontHaveAccount;

  /// No description provided for @createAccountHere.
  ///
  /// In en, this message translates to:
  /// **'Create an account here'**
  String get createAccountHere;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @termsAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By clicking the “CREATE ACCOUNT” button, you agree to '**
  String get termsAgreementPrefix;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @andWord.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andWord;

  /// No description provided for @termsAgreementSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get termsAgreementSuffix;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @forgotPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter your account’s email address\nand we will send you a link\nto reset your password.'**
  String get forgotPasswordPrompt;

  /// No description provided for @submitUpper.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submitUpper;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email.'**
  String get resetLinkSent;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @navOcr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get navOcr;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @createFirstNote.
  ///
  /// In en, this message translates to:
  /// **'Create your first note !'**
  String get createFirstNote;

  /// No description provided for @noNotesMatchColour.
  ///
  /// In en, this message translates to:
  /// **'No notes match this colour'**
  String get noNotesMatchColour;

  /// No description provided for @filterByColour.
  ///
  /// In en, this message translates to:
  /// **'Filter by colour'**
  String get filterByColour;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newItem;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @addNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNoteTitle;

  /// No description provided for @addTodo.
  ///
  /// In en, this message translates to:
  /// **'Add to-do'**
  String get addTodo;

  /// No description provided for @addTodoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add To-do'**
  String get addTodoTitle;

  /// No description provided for @editTodoTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit To-do'**
  String get editTodoTitle;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleHint;

  /// No description provided for @noteBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Start typing...'**
  String get noteBodyHint;

  /// No description provided for @todoInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type something...'**
  String get todoInputHint;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNote;

  /// No description provided for @selectColour.
  ///
  /// In en, this message translates to:
  /// **'Select Colour'**
  String get selectColour;

  /// No description provided for @syncNotesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync notes'**
  String get syncNotesTooltip;

  /// No description provided for @imageToText.
  ///
  /// In en, this message translates to:
  /// **'Image to Text'**
  String get imageToText;

  /// No description provided for @uploadImagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Upload an image\nusing the “+”\nbutton'**
  String get uploadImagePrompt;

  /// No description provided for @clickScanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Click the “Scan Image”\nbutton to perform scan'**
  String get clickScanPrompt;

  /// No description provided for @noTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text detected in this image.'**
  String get noTextDetected;

  /// No description provided for @clearImage.
  ///
  /// In en, this message translates to:
  /// **'Clear Image'**
  String get clearImage;

  /// No description provided for @scanImage.
  ///
  /// In en, this message translates to:
  /// **'Scan Image'**
  String get scanImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @uploadImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload an image first.'**
  String get uploadImageFirst;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Scanned text copied to clipboard.'**
  String get copiedToClipboard;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @tapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get tapToView;

  /// No description provided for @localAccountNotSynced.
  ///
  /// In en, this message translates to:
  /// **'Local Account • Not Synced'**
  String get localAccountNotSynced;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @logOutUpper.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logOutUpper;

  /// No description provided for @editDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Edit Display Name'**
  String get editDisplayName;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutTitle;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirm;

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get exitAppTitle;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppConfirm;

  /// No description provided for @exitButton.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitButton;

  /// No description provided for @unsyncedDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsynced Data'**
  String get unsyncedDataTitle;

  /// No description provided for @syncAndLogOut.
  ///
  /// In en, this message translates to:
  /// **'Sync & Log out'**
  String get syncAndLogOut;

  /// No description provided for @logOutWithoutSync.
  ///
  /// In en, this message translates to:
  /// **'Log out without syncing'**
  String get logOutWithoutSync;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmailError;

  /// No description provided for @shortPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get shortPasswordError;

  /// No description provided for @emptyDisplayNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your display name.'**
  String get emptyDisplayNameError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatchError;

  /// No description provided for @emptyNoteError.
  ///
  /// In en, this message translates to:
  /// **'Cannot save an empty note.'**
  String get emptyNoteError;

  /// No description provided for @emptyTodoError.
  ///
  /// In en, this message translates to:
  /// **'Cannot save an empty to-do list.'**
  String get emptyTodoError;

  /// No description provided for @loginRequiresInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet connection is required to log in. Please check your connection and try again.'**
  String get loginRequiresInternet;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidCredentials;

  /// No description provided for @skipTour.
  ///
  /// In en, this message translates to:
  /// **'Skip Tour'**
  String get skipTour;

  /// No description provided for @tourStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String tourStepLabel(int step, int total);

  /// No description provided for @tourStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Note'**
  String get tourStep1Title;

  /// No description provided for @tourStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to choose between creating a Note or a To-do list.'**
  String get tourStep1Desc;

  /// No description provided for @tourStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Choose Add Note'**
  String get tourStep2Title;

  /// No description provided for @tourStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add note\" to open the note editor with a sample note.'**
  String get tourStep2Desc;

  /// No description provided for @tourStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Note'**
  String get tourStep3Title;

  /// No description provided for @tourStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'We’ve prefilled a sample title and note. Feel free to change them to whatever you want, then tap Next.'**
  String get tourStep3Desc;

  /// No description provided for @tourStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Colours & Delete Menu'**
  String get tourStep4Title;

  /// No description provided for @tourStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the ⋮ button to change your note’s colour or delete it.'**
  String get tourStep4Desc;

  /// No description provided for @tourStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Colours & Delete'**
  String get tourStep5Title;

  /// No description provided for @tourStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Pick a colour to organize your note or use Delete note above. Tap a colour or press \"Done\" to close.'**
  String get tourStep5Desc;

  /// No description provided for @tourStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Auto-Save on Back'**
  String get tourStep6Title;

  /// No description provided for @tourStep6Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap Back (or your device’s back button). Your note is saved automatically—no Save button needed!'**
  String get tourStep6Desc;

  /// No description provided for @ocrTourStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Upload an Image'**
  String get ocrTourStep1Title;

  /// No description provided for @ocrTourStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to take a photo or pick an image from your gallery.'**
  String get ocrTourStep1Desc;

  /// No description provided for @ocrTourStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Pick Image Source'**
  String get ocrTourStep2Title;

  /// No description provided for @ocrTourStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose \"Take photo\" or \"Choose from gallery\" to load an image for scanning.'**
  String get ocrTourStep2Desc;

  /// No description provided for @ocrTourStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Scan Image Offline'**
  String get ocrTourStep3Title;

  /// No description provided for @ocrTourStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Scan Image\" to extract text directly on your device—no internet required.'**
  String get ocrTourStep3Desc;

  /// No description provided for @ocrTourStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Copy or Clear'**
  String get ocrTourStep4Title;

  /// No description provided for @ocrTourStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the Copy icon to copy the extracted text to your clipboard, or Clear Image to start over.'**
  String get ocrTourStep4Desc;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @oneDayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get oneDayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
