// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Plant Doctor';

  @override
  String get appSubtitle => 'Let\'s take care of your plants 🌿';

  @override
  String get splashSubtitle => 'AI-Powered Plant Care';

  @override
  String get searchPlaceholder => 'Search for a plant...';

  @override
  String get categories => 'Categories';

  @override
  String get scanPlantNow => 'Scan Plant Now';

  @override
  String get scanPlantDesc => 'Detect diseases instantly\nwith AI';

  @override
  String get openCamera => 'Open Camera';

  @override
  String get featured => 'Featured';

  @override
  String get recentScans => 'Recent Scans';

  @override
  String get seeAll => 'See all';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboarding1Title => 'Detect Plant\nDiseases Easily';

  @override
  String get onboarding1Desc => 'Use AI to identify plant problems\ninstantly';

  @override
  String get onboarding2Title => 'Scan with Your\nCamera';

  @override
  String get onboarding2Desc => 'Take a photo and let AI analyze\nyour plant';

  @override
  String get onboarding3Title => 'Get Smart\nTreatment Advice';

  @override
  String get onboarding3Desc => 'Receive detailed solutions\npowered by AI';

  @override
  String get featCommonDiseases => 'Common\nDiseases';

  @override
  String get featHealthyTips => 'Healthy\nTips';

  @override
  String get plantTomato => 'Tomato';

  @override
  String get plantPotato => 'Potato';

  @override
  String get plantCorn => 'Corn';

  @override
  String get plantPepper => 'Pepper';

  @override
  String get catApple => 'Apple';

  @override
  String get catGrape => 'Grape';

  @override
  String get catTomato => 'Tomato';

  @override
  String get catPotato => 'Potato';

  @override
  String get catCorn => 'Corn';

  @override
  String get catPepper => 'Bell Pepper';

  @override
  String get catCherry => 'Cherry';

  @override
  String get catStrawberry => 'Strawberry';

  @override
  String get catPeach => 'Peach';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsDarkModeOn => 'Enabled';

  @override
  String get settingsDarkModeOff => 'Disabled';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLangArabic => 'Arabic';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAppName => 'Plant Doctor';

  @override
  String get settingsVersion => 'Version 1.0.0';

  @override
  String get settingsTagline => 'Made with 💚 for your plants';

  @override
  String get hoursAgo => '2 hours ago';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get threeDaysAgo => '3 days ago';

  @override
  String get fiveDaysAgo => '5 days ago';

  @override
  String get chatTitle => 'Plant AI Assistant';

  @override
  String get chatSubtitle => 'Ask about plant diseases, treatments & care';

  @override
  String get chatInputHint => 'Ask about your plant...';

  @override
  String get chatWelcome =>
      'Hello! I\'m PlantDoc 🌿\nAsk me about plant diseases, treatments, or any agricultural question.';

  @override
  String get chatErrorRetry => 'Retry';

  @override
  String get chatClearConversation => 'Clear conversation';

  @override
  String get chatTyping => 'PlantDoc is thinking...';

  @override
  String get chatSuggestion1 => 'Why are my tomato leaves turning yellow?';

  @override
  String get chatSuggestion2 => 'How to treat powdery mildew?';

  @override
  String get chatSuggestion3 => 'Best fertilizer for potatoes?';

  @override
  String get commonDiseases => 'Common Diseases';

  @override
  String get seeAllDiseases => 'See All';

  @override
  String get cameraTitle => 'Disease Prediction';

  @override
  String get cameraCapture => 'Capture Image';

  @override
  String get cameraRetake => 'Retake Image';

  @override
  String get cameraGallery => 'Choose from Gallery';

  @override
  String get cameraPredicting => 'Predicting disease...';

  @override
  String get cameraPredictionResult => 'Prediction Result';

  @override
  String get cameraPredictionLabel => 'Prediction';

  @override
  String get cameraPredictionConfidence => 'Confidence';

  @override
  String get cameraViewImage => 'View Image';

  @override
  String get cameraRetryDiagnosis => 'Diagnose Again';

  @override
  String get cameraBackHome => 'Back to Home';

  @override
  String get cameraConfidenceVeryHigh => 'Very high confidence';

  @override
  String get cameraConfidenceHigh => 'High confidence';

  @override
  String get cameraConfidenceMedium => 'Medium confidence';

  @override
  String get cameraConfidenceLow => 'Low confidence';

  @override
  String get cameraConfidenceUnknown => 'Confidence unavailable';

  @override
  String get cameraPredictionUnknown => 'Unknown disease';

  @override
  String get cameraNoImage => 'No image captured yet';

  @override
  String get cameraTryAgain => 'Try Again';

  @override
  String get cameraSourceTitle => 'Select Image Source';

  @override
  String get cameraSourceTakePhoto => 'Take Photo (Camera)';

  @override
  String get cameraSourceGallery => 'Choose from Gallery';

  @override
  String get cameraGetTreatment => 'Get Treatment';

  @override
  String cameraTreatmentPrompt(Object diseaseName) {
    return 'The detected plant disease is: $diseaseName. Please explain:\n• Disease description\n• Causes\n• Treatment methods\n• Prevention tips';
  }

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorInvalidResponse => 'Unexpected response from server.';

  @override
  String get errorCameraPermissionDenied => 'Camera permission denied.';

  @override
  String get errorGalleryPermissionDenied => 'Gallery permission denied.';

  @override
  String get errorCameraCancelled => 'Image selection was cancelled.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';
}
