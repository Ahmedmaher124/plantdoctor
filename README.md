<div align="center">

# 🌿 Plant Doctor

### AI-Powered Plant Disease Detection App using Flutter & TensorFlow Lite

<img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
<img src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart" />
<img src="https://img.shields.io/badge/TensorFlow-Lite-orange?logo=tensorflow" />
<img src="https://img.shields.io/badge/Gemini-AI-green" />

</div>

---

# 📱 Overview

Plant Doctor is an AI-powered Flutter application that helps users detect plant diseases using a TensorFlow Lite model and provides intelligent treatment recommendations with Gemini AI.

---

# ✨ Features

- 🌱 Select supported plant
- 📸 Capture plant image using camera
- 🧠 AI disease detection using TensorFlow Lite
- 📊 Confidence score for predictions
- 🤖 Gemini AI assistant
- 💊 Treatment recommendations
- 🌿 Prevention tips
- 🕘 Scan history
- 🌍 Arabic RTL support
- 🎨 Modern responsive UI

---

# 🚀 Application Flow

```text
Splash Screen
   ↓
Onboarding
   ↓
Home Screen
   ↓
Select Plant
   ↓
Open Camera
   ↓
Capture Image
   ↓
AI Detection
   ↓
Result Screen
   ↓
Gemini AI Chat
```

---

# 🧠 AI Architecture

## Disease Detection

The application uses a TensorFlow Lite model for disease classification.

### Input
- Plant name
- Captured image

### Output
- Disease name
- Confidence score

---

## 🤖 Gemini AI Role

Gemini AI is NOT responsible for disease detection.

It is used only for:

- Disease explanation
- Treatment suggestions
- Prevention tips
- AI chat assistance

---

# 🌿 Supported Plants

| Plant | Supported |
|------|------|
| 🍅 Tomato | ✅ |
| 🥔 Potato | ✅ |
| 🌽 Corn | ✅ |
| 🫑 Pepper | ✅ |

---

# 🏗️ Project Architecture

The project follows:

- Clean Architecture
- Feature-first structure
- Cubit State Management
- Dependency Injection using `get_it`

---

# 📂 Project Structure

```bash
lib/
│
├── core/
│   ├── constants/
│   ├── dependency_injection/
│   ├── network/
│   ├── routes/
│   ├── services/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── camera_inspection/
│   ├── disease_detection/
│   ├── result/
│   ├── gemini_chat/
│   └── history/
│
└── main.dart
```

---

# 🛠️ Tech Stack

## Flutter Packages

- flutter_bloc
- get_it
- go_router
- dio
- hive
- image_picker
- camera
- tflite_flutter

---

# 🎨 UI/UX

- Modern UI
- RTL Arabic support
- Responsive design
- Reusable widgets
- Centralized theme system

---

# 📦 Installation

## 1️⃣ Clone Repository

```bash
git clone https://github.com/your-username/plant-doctor.git
```

## 2️⃣ Install Dependencies

```bash
flutter pub get
```

## 3️⃣ Run Application

```bash
flutter run
```

---

# 🔑 Environment Setup

Add your Gemini API key inside:

```text
lib/core/constants/app_constants.dart
```

Example:

```dart
const String geminiApiKey = "YOUR_API_KEY";
```

---

# 📸 Screenshots

<div align="center">

| Splash | Home |
|---|---|
| <img src="https://github.com/user-attachments/assets/b1e3eca5-accd-40d8-9eb9-5428b8d39057" width="250"/> | <img src="https://github.com/user-attachments/assets/993873c4-6e2b-4283-9f87-b5018bff0237" width="250"/> |

| Detection | Result |
|---|---|
| <img src="https://github.com/user-attachments/assets/bdbce27d-3fa0-4457-8fcd-571eeacb56ef" width="250"/> | <img src="https://github.com/user-attachments/assets/ca548983-32d4-44d2-ac0f-edb32dadf4df" width="250"/> |

| AI Chat | History |
|---|---|
| <img src="https://github.com/user-attachments/assets/9f59cbc8-cc31-4ca4-a21c-d7755e64b902" width="250"/> | <img src="https://github.com/user-attachments/assets/2af09208-52fb-4a59-b759-e6338e1ff02d" width="250"/> |

</div>

---

# 👨‍💻 Author

## Ahmed Maher

Flutter Developer 🚀


# ⭐ Support

If you like this project, give it a ⭐ on GitHub!
