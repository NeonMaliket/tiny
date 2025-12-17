# Tiny AI

A mobile application for communicating with artificial intelligence with document support and voice messages.

## 📱 Description

Tiny AI is a modern Flutter application that allows users to interact with various AI models through a convenient cyberpunk-style interface. The application supports text and voice messages, document processing, and personalized settings.

## ✨ Key Features

### 💬 AI Chat
- Intelligent dialogues with AI assistant
- Markdown formatting support in messages
- Chat history with ability to continue conversations
- AI behavior settings (temperature, model, system prompts)

### 🎤 Voice Messages
- Record voice messages to send to AI
- Playback audio responses from AI
- Support for various audio formats

### 📄 Document Management
- Upload and view documents (PDF, text files)
- Contextual document analysis through AI
- Document integration in dialogues to get answers based on content

### 🔐 Authentication and Synchronization
- Secure authentication via Supabase
- Data synchronization between devices
- Cloud storage for chats and settings

### 🎨 Interface
- Unique cyberpunk-style design
- Dark theme with neon accents
- Animations and visual effects
- Adaptive interface for different screen sizes

### ⚙️ Settings
- Personalization of AI parameters
- Document and context management
- Notification and interface settings

## 🛠️ Technologies

- **Framework:** Flutter 3.10+
- **State Management:** Flutter Bloc/Cubit
- **Backend:** Supabase (authentication and database)
- **AI Integration:** Custom API integration
- **Audio:** Record, Audioplayers, Waved Audio Player
- **Routing:** GoRouter
- **UI Components:** Custom cyberpunk components
- **File Management:** File Picker, Flutter File Reader
- **Error Tracking:** Firebase Crashlytics

## 📋 Requirements

- Flutter SDK 3.10.0 or higher
- Dart SDK compatible with Flutter
- Android Studio / Xcode for mobile platform builds
- Supabase account for backend services
- Firebase project for analytics and crash reports

## 🚀 Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Create a `.env` file in the project root with necessary API keys
4. Configure Firebase and Supabase configurations
5. Run the application:
   ```bash
   flutter run
   ```

## 📁 Project Structure

- `lib/features/` - Main screens and functions
  - `chat_window/` - AI chat interface
  - `document_window/` - Document viewing and management
  - `login_window/` - Authentication screen
  - `main_window/` - Main application screen
  - `chat_settings_window/` - Chat and AI settings
- `lib/bloc/` - Application state management
- `lib/components/` - Reusable UI components
- `lib/repository/` - Data access layer
- `lib/theme/` - Cyberpunk design styles and themes
- `assets/` - Resources (images, fonts, icons)

## 🎯 Core Capabilities

- **Smart Conversations:** Contextual dialogues with history preservation
- **Multimedia:** Support for text, voice, and documents
- **Personalization:** Flexible AI and interface settings
- **Security:** Data encryption and secure authentication
- **Performance:** Optimized operation and caching
- **Cross-platform:** iOS and Android support

---

*Tiny AI - your personal AI assistant with a futuristic interface* 🤖✨