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

<h2>🚀 Getting Started</h2>

<table>
<tr>
<td align="center">
<b>Splash Screen</b><br>
<img src="https://github.com/user-attachments/assets/3a5eca84-3857-48d5-a55a-c9118c35dec3" width="250"/>
</td>
<td align="center">
<b>Onboarding</b><br>
<img src="https://github.com/user-attachments/assets/782b8011-a8bb-4cd6-9745-4f28ae9ef7ad" width="250"/>
</td>
</tr>

<tr>
<td align="center">
<b>Onboarding Step 2</b><br>
<img src="https://github.com/user-attachments/assets/d383615c-d0a4-41ab-8b6f-989bcef4652b" width="250"/>
</td>
<td align="center">
<b>Onboarding Step 3</b><br>
<img src="https://github.com/user-attachments/assets/cc9fe175-ee46-4dac-864a-306f9d8ee81e" width="250"/>
</td>
</tr>
</table>

<h2>🏠 Main Experience</h2>

<table>
<tr>
<td align="center">
<b>Home Screen</b><br>
<img src="https://github.com/user-attachments/assets/e2973013-3fe4-469f-a97a-9bb4b0b777d5" width="250"/>
</td>
<td align="center">
<b>Settings</b><br>
<img src="https://github.com/user-attachments/assets/e35847c1-cb3a-43a8-956f-a8f7a7558a95" width="250"/>
</td>
</tr>
</table>

<h2>🤖 AI Disease Detection</h2>

<table>
<tr>
<td align="center">
<b>Detection Result</b><br>
<img src="https://github.com/user-attachments/assets/af1b7fa5-f126-4852-b63f-e724bd2b582d" width="250"/>
</td>
<td align="center">
<b>Gemini AI Assistant</b><br>
<img src="https://github.com/user-attachments/assets/2107bd12-c75d-4b8e-881a-9457d617df32" width="250"/>
</td>
</tr>
</table>

<h2>🌱 Plant Knowledge</h2>

<table>
<tr>
<td align="center">
<b>Plant Care Tips</b><br>
<img src="https://github.com/user-attachments/assets/ea2b03a4-62bb-4eb1-bbfa-4e1aa76b51ee" width="250"/>
</td>
<td align="center">
<b>Common Diseases</b><br>
<img src="https://github.com/user-attachments/assets/13bbe681-8928-46c3-8220-d25be74db214" width="250"/>
</td>
</tr>

<tr>
<td colspan="2" align="center">
<b>Disease Information</b><br>
<img src="https://github.com/user-attachments/assets/7d3d0d1b-0bbc-45d7-98ce-b8f2aee6097d" width="250"/>
</td>
</tr>
</table>

<h2>📊 Scan History</h2>

<table>
<tr>
<td align="center">
<b>History Screen</b><br>
<img src="https://github.com/user-attachments/assets/8f63fae6-268b-457e-95e3-07ec448f2481" width="250"/>
</td>
</tr>
</table>

</div>

---

# 👨‍💻 Author

## Ahmed Maher

Flutter Developer 🚀


# ⭐ Support

If you like this project, give it a ⭐ on GitHub!
