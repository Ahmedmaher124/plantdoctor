import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en')
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Plant Doctor'**
  String get appTitle;

  /// Home header subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s take care of your plants 🌿'**
  String get appSubtitle;

  /// Splash screen tagline
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Plant Care'**
  String get splashSubtitle;

  /// Search bar hint text
  ///
  /// In en, this message translates to:
  /// **'Search for a plant...'**
  String get searchPlaceholder;

  /// Home section label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Scan card title
  ///
  /// In en, this message translates to:
  /// **'Scan Plant Now'**
  String get scanPlantNow;

  /// Scan card subtitle
  ///
  /// In en, this message translates to:
  /// **'Detect diseases instantly\nwith AI'**
  String get scanPlantDesc;

  /// Scan card button label
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get openCamera;

  /// Home featured section label
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// Home recent scans section label
  ///
  /// In en, this message translates to:
  /// **'Recent Scans'**
  String get recentScans;

  /// See all link text
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Onboarding skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Onboarding next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Onboarding final button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Onboarding page 1 title
  ///
  /// In en, this message translates to:
  /// **'Detect Plant\nDiseases Easily'**
  String get onboarding1Title;

  /// Onboarding page 1 description
  ///
  /// In en, this message translates to:
  /// **'Use AI to identify plant problems\ninstantly'**
  String get onboarding1Desc;

  /// Onboarding page 2 title
  ///
  /// In en, this message translates to:
  /// **'Scan with Your\nCamera'**
  String get onboarding2Title;

  /// Onboarding page 2 description
  ///
  /// In en, this message translates to:
  /// **'Take a photo and let AI analyze\nyour plant'**
  String get onboarding2Desc;

  /// Onboarding page 3 title
  ///
  /// In en, this message translates to:
  /// **'Get Smart\nTreatment Advice'**
  String get onboarding3Title;

  /// Onboarding page 3 description
  ///
  /// In en, this message translates to:
  /// **'Receive detailed solutions\npowered by AI'**
  String get onboarding3Desc;

  /// Featured card - common diseases
  ///
  /// In en, this message translates to:
  /// **'Common\nDiseases'**
  String get featCommonDiseases;

  /// Featured card - healthy tips
  ///
  /// In en, this message translates to:
  /// **'Healthy\nTips'**
  String get featHealthyTips;

  /// Plant name: tomato
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get plantTomato;

  /// Plant name: potato
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get plantPotato;

  /// Plant name: corn
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get plantCorn;

  /// Plant name: pepper
  ///
  /// In en, this message translates to:
  /// **'Pepper'**
  String get plantPepper;

  /// Category: apple
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get catApple;

  /// Category: grape
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get catGrape;

  /// Category: tomato
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get catTomato;

  /// Category: potato
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get catPotato;

  /// Category: corn
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get catCorn;

  /// Category: bell pepper
  ///
  /// In en, this message translates to:
  /// **'Bell Pepper'**
  String get catPepper;

  /// Category: cherry
  ///
  /// In en, this message translates to:
  /// **'Cherry'**
  String get catCherry;

  /// Category: strawberry
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get catStrawberry;

  /// Category: peach
  ///
  /// In en, this message translates to:
  /// **'Peach'**
  String get catPeach;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section: appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Settings: dark mode label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// Dark mode status: on
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsDarkModeOn;

  /// Dark mode status: off
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsDarkModeOff;

  /// Settings section: language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language option label for Arabic
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsLangArabic;

  /// Language option label for English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// Settings section: about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// App name shown in about tile
  ///
  /// In en, this message translates to:
  /// **'Plant Doctor'**
  String get settingsAppName;

  /// App version shown in about tile
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get settingsVersion;

  /// Footer tagline in settings
  ///
  /// In en, this message translates to:
  /// **'Made with 💚 for your plants'**
  String get settingsTagline;

  /// Recent scan time label
  ///
  /// In en, this message translates to:
  /// **'2 hours ago'**
  String get hoursAgo;

  /// Recent scan time label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Recent scan time label
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get threeDaysAgo;

  /// Recent scan time label
  ///
  /// In en, this message translates to:
  /// **'5 days ago'**
  String get fiveDaysAgo;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
