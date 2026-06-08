# 🌿 Plant Doctor — Project Memory

> **Purpose of this file**: Complete reference for any AI assistant continuing work on this project. Read this first before touching any file.

---

## 📌 Project Identity

| Field | Value |
|---|---|
| **App Name** | Plant Doctor (طبيب النبات) |
| **Package Name** | `plantdoctor` |
| **Flutter SDK** | `>=3.0.0 <4.0.0` |
| **Platform** | Android (primary), iOS |
| **Root Path** | `c:\Users\Admin\Desktop\New folder (7)\New folder\plantdoctor\` |

---

## 📦 Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter_localizations: sdk: flutter
  intl: any                     # required for gen-l10n
  flutter_bloc: ^8.1.3          # state management
  go_router: ^12.1.3            # navigation
  get_it: ^7.6.4                # dependency injection
  equatable: ^2.0.5             # value equality
  shared_preferences: ^2.2.2    # persist theme + locale
  dio: ^5.4.0                   # HTTP client for Gemini API

flutter:
  generate: true                # required for gen-l10n
```

---

## 🏗️ Architecture

**Pattern**: Clean Architecture + BLoC (Cubit variant)

```
lib/
├── core/                         # Shared infrastructure
│   ├── constants/
│   │   ├── api_keys.dart         # 🔑 PUT GEMINI API KEY HERE
│   │   ├── app_assets.dart
│   │   └── app_strings.dart      # ⚠️ DEPRECATED — use AppLocalizations
│   ├── dependency_injection/
│   │   └── injection_container.dart   # GetIt wiring (all features)
│   ├── errors/
│   │   └── failures.dart         # ServerFailure, NetworkFailure, UnknownFailure
│   ├── network/
│   │   ├── gemini_api_constants.dart  # baseUrl, model name, endpoint builder, system prompt
│   │   └── gemini_dio_client.dart     # Singleton Dio with LogInterceptor
│   ├── routes/
│   │   ├── app_router.dart       # GoRouter — all routes defined here
│   │   └── route_constants.dart  # Static route path strings
│   ├── theme/
│   │   ├── app_colors.dart       # All color tokens
│   │   ├── app_spacing.dart
│   │   └── app_text_styles.dart  # fontFamily = 'Cairo'
│   └── (services/, storage/, utils/, widgets/ — empty stubs)
│
├── features/
│   ├── splash/                   # ✅ Implemented
│   ├── onboarding/               # ✅ Implemented
│   ├── home/                     # ✅ Implemented
│   ├── settings/                 # ✅ Implemented
│   ├── gemini_chat/              # ✅ Implemented
│   ├── camera_inspection/        # 🔲 Empty stub
│   ├── disease_detection/        # 🔲 Empty stub
│   ├── history/                  # 🔲 Empty stub
│   └── result/                   # 🔲 Empty stub
│
├── l10n/                         # Localization
│   ├── app_en.arb                # English strings (source of truth)
│   ├── app_ar.arb                # Arabic strings
│   ├── app_localizations.dart    # ✨ AUTO-GENERATED — do not edit
│   ├── app_localizations_en.dart # ✨ AUTO-GENERATED
│   └── app_localizations_ar.dart # ✨ AUTO-GENERATED
│
└── main.dart                     # App entry point
```

---

## 🔑 Critical Configuration

### API Key
```dart
// lib/core/constants/api_keys.dart
class ApiKeys {
  static const String gemini = 'YOUR_GEMINI_API_KEY_HERE'; // ← Replace this!
}
```
Get a key at: https://aistudio.google.com/app/apikey

### l10n.yaml (project root)
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n
```

### Run after every ARB change:
```bash
flutter gen-l10n
```

### Correct import for AppLocalizations in every file:
```dart
import 'package:plantdoctor/l10n/app_localizations.dart';
// NOT: package:flutter_gen/gen_l10n/app_localizations.dart  ← WRONG
```

---

## 🗺️ Routes (`route_constants.dart`)

| Constant | Path | Screen |
|---|---|---|
| `splash` | `/` | `SplashScreen` |
| `onboarding` | `/onboarding` | `OnboardingScreen` |
| `home` | `/home` | `HomeScreen` |
| `camera` | `/camera` | Stub |
| `result` | `/result` | Stub |
| `chat` | `/chat` | `ChatScreen` (Gemini AI) |
| `settings` | `/settings` | `SettingsScreen` |

### Navigation pattern used:
```dart
context.go(RouteConstants.home);    // replace stack
context.push(RouteConstants.chat);  // push on stack
context.pop();                      // go back
```

---

## ⚙️ Dependency Injection (`injection_container.dart`)

```
GetIt (sl)
├── SharedPreferences           → lazySingleton
├── Dio (GeminiDioClient)       → lazySingleton
│
├── SplashCubit                 → factory
├── OnboardingCubit             → factory
├── SettingsCubit               → lazySingleton  ← singleton because it drives the whole app
│
└── GeminiRemoteDataSource      → lazySingleton
    └── ChatRepository          → lazySingleton
        └── SendMessageUseCase  → lazySingleton
            └── ChatCubit       → factory (fresh per screen visit)
```

### Usage pattern:
```dart
sl<SettingsCubit>()    // get from container
sl<ChatCubit>()        // get new instance (factory)
```

---

## 🎨 Theme System

### App Colors (`app_colors.dart`) — key tokens:
```
AppColors.primary        → main green
AppColors.primaryDark    → dark green
AppColors.gradientStart  → gradient top
AppColors.gradientEnd    → gradient bottom
AppColors.background     → page background
AppColors.white
AppColors.textGrey
AppColors.red
AppColors.statusRed / statusYellow / statusGreen
AppColors.surfaceLeaf / surfacePink / iconLeaf / iconPink
```

### Font: `Cairo` (Arabic-friendly, used for both RTL and LTR)

### Theme is controlled by `SettingsCubit` in `main.dart`:
```dart
BlocBuilder<SettingsCubit, SettingsState>(
  builder: (context, settings) => MaterialApp.router(
    themeMode: settings.themeMode,  // light / dark
    locale: settings.locale,        // Locale('ar') / Locale('en')
    ...
  )
)
```

---

## 🌍 Localization

### How it works:
1. Edit `lib/l10n/app_en.arb` (add new key + English value + @metadata)
2. Edit `lib/l10n/app_ar.arb` (add same key with Arabic value — no @metadata)
3. Run `flutter gen-l10n`
4. Use in any widget:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.myNewKey)
```

### ARB key naming conventions used:
| Prefix | Category |
|---|---|
| `app` | App-wide (title, subtitle) |
| `splash` | Splash screen |
| `onboarding1/2/3` | Onboarding pages |
| `cat` | Plant categories |
| `plant` | Plant names |
| `feat` | Featured section |
| `settings` | Settings screen |
| `chat` | Chat screen |
| (none) | Home general (categories, recentScans, etc.) |

### Default locale: **Arabic** (`Locale('ar', 'AE')`) — set in `SettingsState` default constructor

---

## 🤖 Gemini AI Integration

### Stack:
```
ChatScreen (UI)
  └── ChatCubit (Presentation)
        └── SendMessageUseCase (Domain)
              └── ChatRepository interface (Domain)
                    └── ChatRepositoryImpl (Data)
                          └── GeminiRemoteDataSourceImpl (Data)
                                └── Dio → Gemini REST API
```

### API Details:
```
Base URL : https://generativelanguage.googleapis.com/
Model    : gemini-2.5-flash
Version  : v1beta
Endpoint : v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}
Method   : POST
```

### Request format (built by `GeminiRequestModel`):
```json
{
  "system_instruction": { "parts": [{ "text": "<agricultural system prompt>" }] },
  "contents": [
    { "role": "user",  "parts": [{ "text": "..." }] },
    { "role": "model", "parts": [{ "text": "..." }] }
  ],
  "generationConfig": { "temperature": 0.7, "maxOutputTokens": 2048 }
}
```

### System prompt (in `GeminiApiConstants.systemPrompt`):
> PlantDoc — expert in plant disease diagnosis, treatments (organic & chemical), seasonal advice, pest management. Always reply in the user's language. Structured: Diagnosis → Cause → Treatment → Prevention.

### ChatMessage entity:
```dart
class ChatMessage {
  final String text;
  final MessageRole role;  // user | model
  final DateTime timestamp;
  final bool isLoading;
}
```

### ChatCubit states:
```
ChatInitial  → no messages yet, shows welcome + suggestion chips
ChatLoaded   → messages list + isLoading flag (true = typing indicator shown)
ChatError    → error message + previousMessages preserved (user can dismiss/retry)
```

---

## ✅ Features Status

### Splash Screen
- Gradient background (green)
- Logo + "Plant Doctor" / "طبيب النبات" (localized)
- 3-dot loading indicator
- Auto-navigates: → Onboarding (first run) | → Home (returning user)
- Checked via `SharedPreferences` key `onboarding_complete`

### Onboarding Screen
- 3 pages with PageView
- Skip button (pages 1–2), Get Started (page 3)
- `OnboardingCubit` manages current page
- On complete: sets `onboarding_complete = true`, navigates to Home

### Home Screen
- Green header with app title, subtitle, search bar
- Horizontally scrollable categories (9 plants, localized names)
- Scan card → navigates to `/camera`
- Featured cards (Common Diseases, Healthy Tips)
- Recent scans list (4 static items, localized)
- **FAB**: `Icons.chat_rounded` → opens `/chat` (Gemini AI)
- Settings icon in header → opens `/settings`

### Settings Screen
- SliverAppBar with green gradient
- **Appearance section**: Dark Mode toggle (Switch.adaptive)
- **Language section**: Arabic 🇸🇦 / English 🇺🇸 radio-style tiles
- **About section**: App name + version tile
- Footer tagline
- All changes persist via `SharedPreferences` and rebuild the entire app instantly

### Gemini Chat Screen
- App bar: PlantDoc avatar + title/subtitle + clear button
- **Welcome view** (ChatInitial): bot avatar, welcome bubble, 3 suggestion chips (tap to send)
- **Message bubbles**: green (user) / white-dark (AI), rounded corners, long-press to copy
- **Typing indicator**: 3 animated pulsing dots + "PlantDoc is thinking…"
- **Error tile**: red border, error message, Retry button
- **Input bar**: multi-line TextField + animated send button (spins while loading)
- Sends full conversation history to Gemini on every message
- Fully localized EN/AR

---

## 🔄 Key Patterns to Follow

### Adding a new feature:
```
lib/features/my_feature/
├── data/
│   ├── datasource/my_remote_datasource.dart
│   ├── models/my_request_model.dart
│   ├── models/my_response_model.dart
│   └── repositories/my_repository_impl.dart
├── domain/
│   ├── entities/my_entity.dart
│   ├── repositories/my_repository.dart   ← abstract
│   └── usecases/my_usecase.dart
└── presentation/
    ├── cubit/my_cubit.dart
    ├── cubit/my_state.dart
    └── pages/my_screen.dart
```

Then wire it in:
1. `injection_container.dart` — register datasource → repo → usecase → cubit
2. `app_router.dart` — add GoRoute with BlocProvider
3. `route_constants.dart` — add path constant
4. `app_en.arb` + `app_ar.arb` — add string keys, run `flutter gen-l10n`

### Adding a new string:
```jsonc
// app_en.arb
"myKey": "English text",
"@myKey": { "description": "What this string is for" },

// app_ar.arb  (no @metadata needed)
"myKey": "النص العربي",
```
Then run `flutter gen-l10n`.

### Checking dark mode / locale in a widget:
```dart
// From state
final isDark = state.isDarkMode;       // SettingsState
final isArabic = state.isArabic;

// From context
final isDark = Theme.of(context).brightness == Brightness.dark;
final l10n = AppLocalizations.of(context)!;
```

### Navigating with SettingsCubit (it's a singleton):
```dart
// In a route builder
BlocProvider.value(
  value: di.sl<SettingsCubit>(),
  child: const SettingsScreen(),
)
// In other screens, access it from the tree:
context.read<SettingsCubit>().toggleDarkMode(true);
```

---

## ⚠️ Known Issues / Things to Watch

| Issue | Detail |
|---|---|
| Asset warnings | `assets/icons/` and `assets/images/` directories don't exist on disk — add actual image/icon files to fix |
| `AppStrings` retired | `lib/core/constants/app_strings.dart` is now just a comment. Do NOT re-add content there |
| gen-l10n output | Files go to `lib/l10n/` (not `.dart_tool/`). Import as `package:plantdoctor/l10n/app_localizations.dart` |
| `withOpacity` warnings | Several pre-existing uses in `home_widgets.dart` and `onboarding_page_content.dart`. Safe to ignore or replace with `.withValues(alpha: x)` |
| Stub screens | `/camera`, `/result` routes show placeholder `Text` widgets — not implemented yet |
| Static chat data | Home recent scans are hardcoded static data — not from real scan history |

---

## 🏃 Quick Commands

```bash
# Install/update packages
flutter pub get

# Regenerate localization after ARB changes
flutter gen-l10n

# Check for errors (show only errors + warnings, hide info)
flutter analyze

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# List devices
flutter devices
```

---

## 📁 Most Important Files at a Glance

| File | Why Important |
|---|---|
| [`lib/main.dart`](lib/main.dart) | App root, BlocProvider for SettingsCubit, MaterialApp.router config |
| [`lib/core/dependency_injection/injection_container.dart`](lib/core/dependency_injection/injection_container.dart) | ALL dependency wiring — add new features here |
| [`lib/core/routes/app_router.dart`](lib/core/routes/app_router.dart) | ALL routes — add new screens here |
| [`lib/core/constants/api_keys.dart`](lib/core/constants/api_keys.dart) | 🔑 Gemini API key lives here |
| [`lib/core/network/gemini_api_constants.dart`](lib/core/network/gemini_api_constants.dart) | Model, API version, endpoint, system prompt |
| [`lib/l10n/app_en.arb`](lib/l10n/app_en.arb) | Source of truth for all strings |
| [`lib/l10n/app_ar.arb`](lib/l10n/app_ar.arb) | Arabic translations |
| [`lib/features/settings/presentation/cubit/settings_cubit.dart`](lib/features/settings/presentation/cubit/settings_cubit.dart) | Theme + locale toggle + persistence |
| [`lib/features/gemini_chat/data/datasource/gemini_remote_datasource.dart`](lib/features/gemini_chat/data/datasource/gemini_remote_datasource.dart) | Dio call to Gemini API |
| [`lib/features/gemini_chat/presentation/pages/chat_screen.dart`](lib/features/gemini_chat/presentation/pages/chat_screen.dart) | Full chat UI |
