import 'package:flutter/material.dart';
import 'package:notes/core/l10n/locale_controller.dart';

/// Centralized localization strings for **English (`en`)**, **Russian (`ru`)**,
/// and **Uzbek (`uz`)**.
///
/// Uses [rootNavigatorKey] when available (with an explicit [_language] fallback
/// for pure-Dart UseCases/Repositories), eliminating `BuildContext` boilerplate.
abstract final class AppTexts {
  static AppLanguage _language = AppLanguage.en;

  static void setLanguage(AppLanguage language) => _language = language;

  static String get _lang {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      final code = Localizations.maybeLocaleOf(ctx)?.languageCode;
      if (code == 'ru' || code == 'uz' || code == 'en') {
        return code!;
      }
    }
    return _language.locale.languageCode;
  }

  static String _t({
    required String en,
    required String ru,
    required String uz,
  }) {
    return switch (_lang) {
      'ru' => ru,
      'uz' => uz,
      _ => en,
    };
  }

  // Brand & Common
  static String get appName => 'HaBIT Note';
  static String get appVersion => 'V1.0.0';
  static String get copyright =>
      _t(
        en: '© Copyright HABIT 2021. All rights reserved',
        ru: '© HABIT 2021. Все права защищены',
        uz: '© HABIT 2021. Barcha huquqlar himoyalangan',
      );
  static String get cancel => _t(en: 'Cancel', ru: 'Отмена', uz: 'Bekor qilish');
  static String get no => _t(en: 'No', ru: 'Нет', uz: "Yo'q");
  static String get done => _t(en: 'Done', ru: 'Готово', uz: 'Tayyor');
  static String get next => _t(en: 'Next', ru: 'Далее', uz: 'Keyingi');
  static String get reset => _t(en: 'Reset', ru: 'Сбросить', uz: 'Tiklash');
  static String get save => _t(en: 'Save', ru: 'Сохранить', uz: 'Saqlash');

  // Onboarding
  static String get welcomeTo =>
      _t(en: 'WELCOME TO', ru: 'ДОБРО ПОЖАЛОВАТЬ В', uz: 'XUSH KELIBSIZ');
  static String get onboardingSlide1Title =>
      _t(en: 'Take Notes', ru: 'Создавайте заметки', uz: 'Qaydlar oling');
  static String get onboardingSlide1Subtitle => _t(
        en: 'Quickly capture what’s on your mind',
        ru: 'Быстро записывайте свои мысли',
        uz: 'Fikrlaringizni tezda yozib oling',
      );
  static String get onboardingSlide2Title =>
      _t(en: 'To-dos', ru: 'Списки дел', uz: 'Vazifalar');
  static String get onboardingSlide2Subtitle => _t(
        en: 'List out your day-to-day tasks',
        ru: 'Планируйте повседневные задачи',
        uz: 'Kundalik vazifalaringizni tartiblang',
      );
  static String get onboardingSlide3Title => _t(
        en: 'Image to Text Converter',
        ru: 'Фото в текст',
        uz: 'Rasmni matnga aylantirish',
      );
  static String get onboardingSlide3Subtitle => _t(
        en: 'Upload your images and convert to text',
        ru: 'Загружайте фото и извлекайте текст',
        uz: 'Rasmlarni yuklang va matnga aylantiring',
      );
  static String get createAccountUpper => _t(
        en: 'CREATE ACCOUNT',
        ru: 'СОЗДАТЬ АККАУНТ',
        uz: 'HISOB YARATISH',
      );
  static String get logInUpper =>
      _t(en: 'LOG IN', ru: 'ВОЙТИ', uz: 'KIRISH');

  // Auth Screens
  static String get logIn =>
      _t(en: 'Log In', ru: 'Вход', uz: 'Kirish');
  static String get createAccount =>
      _t(en: 'Create Account', ru: 'Регистрация', uz: 'Hisob yaratish');
  static String get forgotPassword =>
      _t(en: 'Forgot Password', ru: 'Забыли пароль', uz: 'Parolni unutdingizmi');
  static String get forgotPasswordQuestion => _t(
        en: 'Forgot Password ?',
        ru: 'Забыли пароль?',
        uz: 'Parolni unutdingizmi?',
      );
  static String get welcomeBack =>
      _t(en: 'Welcome back !', ru: 'С возвращением!', uz: 'Qaytganingiz bilan!');
  static String get loginSubtitle => _t(
        en: 'Please login with your credentials',
        ru: 'Войдите, используя свои данные',
        uz: 'Kirish uchun ma’lumotlaringizni kiriting',
      );
  static String get letsGetToKnowYou => _t(
        en: 'Let’s get to know you !',
        ru: 'Давайте познакомимся!',
        uz: 'Keling, tanishamiz!',
      );
  static String get enterDetailsToContinue => _t(
        en: 'Enter your details to continue',
        ru: 'Введите данные для продолжения',
        uz: 'Davom etish uchun ma’lumotlarni kiriting',
      );
  static String get displayName =>
      _t(en: 'Display Name', ru: 'Имя', uz: 'Ism');
  static String get emailAddress =>
      _t(en: 'Email Address', ru: 'Эл. почта', uz: 'Elektron pochta');
  static String get email => _t(en: 'Email', ru: 'Эл. почта', uz: 'Pochta');
  static String get password =>
      _t(en: 'Password', ru: 'Пароль', uz: 'Parol');
  static String get confirmPassword => _t(
        en: 'Confirm Password',
        ru: 'Подтвердите пароль',
        uz: 'Parolni tasdiqlang',
      );
  static String get dontHaveAccount => _t(
        en: 'Don’t have an account yet ?',
        ru: 'Нет аккаунта?',
        uz: 'Hali hisobingiz yo‘qmi?',
      );
  static String get createAccountHere => _t(
        en: 'Create an account here',
        ru: 'Создать аккаунт',
        uz: 'Bu yerda hisob yarating',
      );
  static String get alreadyHaveAccount => _t(
        en: 'Already have an account?',
        ru: 'Уже есть аккаунт?',
        uz: 'Hisobingiz bormi?',
      );
  static String get loginHere =>
      _t(en: 'Login here', ru: 'Войти', uz: 'Bu yerda kiring');
  static String get termsAgreementPrefix => _t(
        en: 'By clicking the “CREATE ACCOUNT” button, you agree to ',
        ru: 'Нажимая «СОЗДАТЬ АККАУНТ», вы соглашаетесь с ',
        uz: '“HISOB YARATISH” tugmasini bosish orqali siz ',
      );
  static String get termsOfUse => _t(
        en: 'Terms of use',
        ru: 'Условиями использования',
        uz: 'Foydalanish shartlari',
      );
  static String get andWord => _t(en: ' and ', ru: ' и ', uz: ' va ');
  static String get termsAgreementSuffix => _t(
        en: '',
        ru: '',
        uz: 'ga rozilik bildirasiz',
      );
  static String get privacyPolicy => _t(
        en: 'Privacy Policy',
        ru: 'Политикой конфиденциальности',
        uz: 'Maxfiylik siyosati',
      );
  static String get forgotPasswordPrompt => _t(
        en: 'Please enter your account’s email address\nand we will send you a link\nto reset your password.',
        ru: 'Введите адрес электронной почты,\nи мы отправим ссылку\nдля сброса пароля.',
        uz: 'Hisobingiz elektron pochtasini kiriting,\nbiz parolni tiklash havolasini\nyuboramiz.',
      );
  static String get submitUpper =>
      _t(en: 'SUBMIT', ru: 'ОТПРАВИТЬ', uz: 'YUBORISH');
  static String get resetLinkSent => _t(
        en: 'Password reset link sent to your email.',
        ru: 'Ссылка для сброса пароля отправлена на вашу почту.',
        uz: 'Parolni tiklash havolasi pochtangizga yuborildi.',
      );

  // Bottom Navigation & Tabs
  static String get navNotes => _t(en: 'Notes', ru: 'Заметки', uz: 'Qaydlar');
  static String get navOcr => _t(en: 'OCR', ru: 'OCR', uz: 'OCR');
  static String get navHelp => _t(en: 'Help', ru: 'Помощь', uz: 'Yordam');
  static String get navMe => _t(en: 'Me', ru: 'Профиль', uz: 'Men');

  // Notes Home & Editors
  static String get notesTitle => _t(en: 'Notes', ru: 'Заметки', uz: 'Qaydlar');
  static String get createFirstNote => _t(
        en: 'Create your first note !',
        ru: 'Создайте свою первую заметку!',
        uz: 'Birinchi qaydingizni yarating!',
      );
  static String get noNotesMatchColour => _t(
        en: 'No notes match this colour',
        ru: 'Нет заметок с этим цветом',
        uz: 'Bu rangdagi qaydlar topilmadi',
      );
  static String get filterByColour => _t(
        en: 'Filter by colour',
        ru: 'Фильтр по цвету',
        uz: 'Rang bo‘yicha saralash',
      );
  static String get newItem => _t(en: 'New', ru: 'Создать', uz: 'Yangi');
  static String get addNote =>
      _t(en: 'Add note', ru: 'Добавить заметку', uz: 'Qayd qo‘shish');
  static String get editNote =>
      _t(en: 'Edit Note', ru: 'Редактировать', uz: 'Qaydni tahrirlash');
  static String get addNoteTitle =>
      _t(en: 'Add Note', ru: 'Новая заметка', uz: 'Qayd qo‘shish');
  static String get addTodo =>
      _t(en: 'Add to-do', ru: 'Добавить список дел', uz: 'Vazifa qo‘shish');
  static String get addTodoTitle =>
      _t(en: 'Add To-do', ru: 'Новый список дел', uz: 'Vazifa qo‘shish');
  static String get editTodoTitle =>
      _t(en: 'Edit To-do', ru: 'Редактировать список', uz: 'Vazifani tahrirlash');
  static String get noteTitleHint =>
      _t(en: 'Title', ru: 'Заголовок', uz: 'Sarlavha');
  static String get noteBodyHint =>
      _t(en: 'Start typing...', ru: 'Начните писать...', uz: 'Yozishni boshlang...');
  static String get todoInputHint =>
      _t(en: 'Type something...', ru: 'Введите задачу...', uz: 'Biror narsa yozing...');
  static String get deleteNote =>
      _t(en: 'Delete note', ru: 'Удалить заметку', uz: 'Qaydni o‘chirish');
  static String get selectColour =>
      _t(en: 'Select Colour', ru: 'Выберите цвет', uz: 'Rangni tanlang');
  static String get syncNotesTooltip =>
      _t(en: 'Sync notes', ru: 'Синхронизировать', uz: 'Sinxronlash');

  // OCR Tab
  static String get imageToText =>
      _t(en: 'Image to Text', ru: 'Фото в текст', uz: 'Rasmdan matnga');
  static String get uploadImagePrompt => _t(
        en: 'Upload an image\nusing the “+”\nbutton',
        ru: 'Загрузите фото\nс помощью кнопки\n«+»',
        uz: '«+» tugmasi orqali\nrasm yuklang',
      );
  static String get clickScanPrompt => _t(
        en: 'Click the “Scan Image”\nbutton to perform scan',
        ru: 'Нажмите «Сканировать»,\nчтобы распознать текст',
        uz: 'Matnni o‘qish uchun\n«Skanerlash» tugmasini bosing',
      );
  static String get noTextDetected => _t(
        en: 'No text detected in this image.',
        ru: 'Текст на изображении не найден.',
        uz: 'Rasmda matn aniqlanmadi.',
      );
  static String get clearImage =>
      _t(en: 'Clear Image', ru: 'Очистить', uz: 'Tozalash');
  static String get scanImage =>
      _t(en: 'Scan Image', ru: 'Сканировать', uz: 'Skanerlash');
  static String get takePhoto =>
      _t(en: 'Take photo', ru: 'Сделать фото', uz: 'Rasmga olish');
  static String get chooseFromGallery => _t(
        en: 'Choose from gallery',
        ru: 'Выбрать из галереи',
        uz: 'Galereyadan tanlash',
      );
  static String get uploadImageFirst => _t(
        en: 'Please upload an image first.',
        ru: 'Сначала загрузите изображение.',
        uz: 'Avval rasm yuklang.',
      );
  static String get copiedToClipboard => _t(
        en: 'Scanned text copied to clipboard.',
        ru: 'Текст скопирован в буфер обмена.',
        uz: 'Matn buferga nusxalandi.',
      );

  // Help Tab
  static String get userGuide =>
      _t(en: 'User Guide', ru: 'Руководство', uz: 'Qo‘llanma');
  static String get tapToView =>
      _t(en: 'Tap to view', ru: 'Нажмите для просмотра', uz: 'Ko‘rish uchun bosing');

  // Me (Profile) Tab & About
  static String get localAccountNotSynced => _t(
        en: 'Local Account • Not Synced',
        ru: 'Локальный аккаунт • Не синхронизирован',
        uz: 'Mahalliy hisob • Sinxronlanmagan',
      );
  static String get darkMode =>
      _t(en: 'Dark Mode', ru: 'Тёмная тема', uz: 'Tungi rejim');
  static String get languageLabel =>
      _t(en: 'Language', ru: 'Язык', uz: 'Til');
  static String get resetPassword =>
      _t(en: 'Reset Password', ru: 'Сбросить пароль', uz: 'Parolni tiklash');
  static String get about =>
      _t(en: 'About', ru: 'О приложении', uz: 'Ilova haqida');
  static String get application =>
      _t(en: 'Application', ru: 'Приложение', uz: 'Ilova');
  static String get version =>
      _t(en: 'Version', ru: 'Версия', uz: 'Versiya');
  static String get logOutUpper =>
      _t(en: 'LOG OUT', ru: 'ВЫЙТИ', uz: 'CHIQISH');
  static String get editDisplayName => _t(
        en: 'Edit Display Name',
        ru: 'Изменить имя',
        uz: 'Ismni tahrirlash',
      );

  // Dialogs
  static String get logOutTitle =>
      _t(en: 'Log out', ru: 'Выход', uz: 'Chiqish');
  static String get logOutConfirm => _t(
        en: 'Are you sure you want to log out?',
        ru: 'Вы уверены, что хотите выйти?',
        uz: 'Hisobdan chiqmoqchimisiz?',
      );
  static String get exitAppTitle =>
      _t(en: 'Exit app', ru: 'Выход из приложения', uz: 'Ilovadan chiqish');
  static String get exitAppConfirm => _t(
        en: 'Are you sure you want to exit the app?',
        ru: 'Вы уверены, что хотите закрыть приложение?',
        uz: 'Ilovadan chiqmoqchimisiz?',
      );
  static String get exitButton =>
      _t(en: 'Exit', ru: 'Выйти', uz: 'Chiqish');
  static String get unsyncedDataTitle => _t(
        en: 'Unsynced Data',
        ru: 'Несинхронизированные данные',
        uz: 'Sinxronlanmagan ma’lumotlar',
      );
  static String get syncAndLogOut => _t(
        en: 'Sync & Log out',
        ru: 'Синхр. и выйти',
        uz: 'Sinxronlab chiqish',
      );
  static String get logOutWithoutSync => _t(
        en: 'Log out without syncing',
        ru: 'Выйти без синхронизации',
        uz: 'Sinxronlamasdan chiqish',
      );

  // Validation & Errors (No BuildContext needed!)
  static String get invalidEmailError => _t(
        en: 'Please enter a valid email address.',
        ru: 'Введите корректный адрес эл. почты.',
        uz: 'To‘g‘ri elektron pochta manzilini kiriting.',
      );
  static String get shortPasswordError => _t(
        en: 'Password must be at least 6 characters long.',
        ru: 'Пароль должен содержать не менее 6 символов.',
        uz: 'Parol kamida 6 ta belgidan iborat bo‘lishi kerak.',
      );
  static String get emptyDisplayNameError => _t(
        en: 'Please enter your display name.',
        ru: 'Пожалуйста, введите ваше имя.',
        uz: 'Iltimos, ismingizni kiriting.',
      );
  static String get passwordMismatchError => _t(
        en: 'Passwords do not match.',
        ru: 'Пароли не совпадают.',
        uz: 'Parollar mos kelmadi.',
      );
  static String get emptyNoteError => _t(
        en: 'Cannot save an empty note.',
        ru: 'Нельзя сохранить пустую заметку.',
        uz: 'Bo‘sh qayd saqlab bo‘lmaydi.',
      );
  static String get emptyTodoError => _t(
        en: 'Cannot save an empty to-do list.',
        ru: 'Нельзя сохранить пустой список дел.',
        uz: 'Bo‘sh vazifalar ro‘yxatini saqlab bo‘lmaydi.',
      );
  static String get loginRequiresInternet => _t(
        en: 'Internet connection is required to log in. Please check your connection and try again.',
        ru: 'Для входа требуется подключение к интернету. Проверьте сеть и повторите попытку.',
        uz: 'Kirish uchun internet aloqasi kerak. Tarmoqni tekshirib qayta urinib ko‘ring.',
      );
  static String get invalidCredentials => _t(
        en: 'Invalid email or password.',
        ru: 'Неверная эл. почта или пароль.',
        uz: 'Elektron pochta yoki parol noto‘g‘ri.',
      );

  // Guided Tour
  static String get skipTour =>
      _t(en: 'Skip Tour', ru: 'Пропустить', uz: 'O‘tkazib yuborish');
  static String tourStepLabel(int step, int total) =>
      _t(en: 'Step $step of $total', ru: 'Шаг $step из $total', uz: '$step / $total-qadam');
  static String get tourStep1Title => _t(
        en: 'Create Your First Note',
        ru: 'Создайте первую заметку',
        uz: 'Birinchi qaydingizni yarating',
      );
  static String get tourStep1Desc => _t(
        en: 'Tap the + button to choose between creating a Note or a To-do list.',
        ru: 'Нажмите кнопку +, чтобы создать заметку или список дел.',
        uz: 'Qayd yoki vazifalar ro‘yxatini yaratish uchun + tugmasini bosing.',
      );
  static String get tourStep2Title => _t(
        en: 'Choose Add Note',
        ru: 'Выберите «Добавить заметку»',
        uz: '«Qayd qo‘shish»ni tanlang',
      );
  static String get tourStep2Desc => _t(
        en: 'Tap "Add note" to open the note editor with a sample note.',
        ru: 'Нажмите «Добавить заметку», чтобы открыть редактор.',
        uz: 'Namuna qayd bilan muharrirni ochish uchun «Qayd qo‘shish»ni bosing.',
      );
  static String get tourStep3Title => _t(
        en: 'Edit Your Note',
        ru: 'Измените заметку',
        uz: 'Qaydingizni tahrirlang',
      );
  static String get tourStep3Desc => _t(
        en: 'We’ve prefilled a sample title and note. Feel free to change them to whatever you want, then tap Next.',
        ru: 'Мы добавили пример заголовка и текста. Измените их по своему усмотрению и нажмите «Далее».',
        uz: 'Namuna sarlavha va matn kiritildi. Ularni xohlagancha o‘zgartiring va «Keyingi»ni bosing.',
      );
  static String get tourStep4Title => _t(
        en: 'Colours & Delete Menu',
        ru: 'Цвета и удаление',
        uz: 'Ranglar va o‘chirish menyusi',
      );
  static String get tourStep4Desc => _t(
        en: 'Tap the ⋮ button to change your note’s colour or delete it.',
        ru: 'Нажмите ⋮, чтобы выбрать цвет заметки или удалить её.',
        uz: 'Qayd rangini o‘zgartirish yoki o‘chirish uchun ⋮ tugmasini bosing.',
      );
  static String get tourStep5Title => _t(
        en: 'Colours & Delete',
        ru: 'Цвета и удаление',
        uz: 'Ranglar va o‘chirish',
      );
  static String get tourStep5Desc => _t(
        en: 'Pick a colour to organize your note or use Delete note above. Tap a colour or press "Done" to close.',
        ru: 'Выберите цвет для заметки или нажмите «Удалить». Нажмите «Готово», чтобы закрыть.',
        uz: 'Qaydni tartiblash uchun rang tanlang yoki o‘chirishdan foydalaning. Yopish uchun «Tayyor»ni bosing.',
      );
  static String get tourStep6Title => _t(
        en: 'Auto-Save on Back',
        ru: 'Автосохранение',
        uz: 'Orqaga qaytganda avtomatik saqlash',
      );
  static String get tourStep6Desc => _t(
        en: 'Tap Back (or your device’s back button). Your note is saved automatically—no Save button needed!',
        ru: 'Нажмите «Назад» (или системную кнопку назад). Заметка сохранится автоматически!',
        uz: 'Orqaga tugmasini bosing. Qaydingiz «Saqlash» tugmasisiz avtomatik saqlanadi!',
      );

  // OCR Guided Tour
  static String get ocrTourStep1Title => _t(
        en: 'Upload an Image',
        ru: 'Загрузите изображение',
        uz: 'Rasm yuklang',
      );
  static String get ocrTourStep1Desc => _t(
        en: 'Tap the + button to take a photo or pick an image from your gallery.',
        ru: 'Нажмите кнопку +, чтобы сделать фото или выбрать его из галереи.',
        uz: 'Rasmga olish yoki galereyadan tanlash uchun + tugmasini bosing.',
      );
  static String get ocrTourStep2Title => _t(
        en: 'Pick Image Source',
        ru: 'Выберите источник',
        uz: 'Manbani tanlang',
      );
  static String get ocrTourStep2Desc => _t(
        en: 'Choose "Take photo" or "Choose from gallery" to load an image for scanning.',
        ru: 'Выберите «Сделать фото» или «Выбрать из галереи» для загрузки изображения.',
        uz: 'Skanerlash uchun «Rasmga olish» yoki «Galereyadan tanlash»ni bosing.',
      );
  static String get ocrTourStep3Title => _t(
        en: 'Scan Image Offline',
        ru: 'Сканируйте офлайн',
        uz: 'Oflayn skanerlang',
      );
  static String get ocrTourStep3Desc => _t(
        en: 'Tap "Scan Image" to extract text directly on your device—no internet required.',
        ru: 'Нажмите «Сканировать», чтобы распознать текст на устройстве без интернета.',
        uz: 'Matnni internetsiz qurilmada o‘qish uchun «Skanerlash» tugmasini bosing.',
      );
  static String get ocrTourStep4Title => _t(
        en: 'Copy or Clear',
        ru: 'Скопируйте или очистите',
        uz: 'Nusxalang yoki tozalang',
      );
  static String get ocrTourStep4Desc => _t(
        en: 'Tap the Copy icon to copy the extracted text to your clipboard, or Clear Image to start over.',
        ru: 'Нажмите значок копирования, чтобы сохранить текст в буфер обмена.',
        uz: 'Matnni buferga nusxalash uchun nusxalash belgisini bosing.',
      );

  static String formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) {
      return _t(en: 'Just now', ru: 'Только что', uz: 'Hozirgina');
    }
    if (diff.inMinutes < 60) {
      return _t(
        en: '${diff.inMinutes}m ago',
        ru: '${diff.inMinutes} мин назад',
        uz: '${diff.inMinutes} daq oldin',
      );
    }
    if (diff.inHours < 24) {
      return _t(
        en: '${diff.inHours}h ago',
        ru: '${diff.inHours} ч назад',
        uz: '${diff.inHours} soat oldin',
      );
    }
    if (diff.inDays == 1) {
      return _t(en: '1 day ago', ru: '1 день назад', uz: '1 kun oldin');
    }
    return _t(
      en: '${diff.inDays} days ago',
      ru: '${diff.inDays} дн. назад',
      uz: '${diff.inDays} kun oldin',
    );
  }
}
