#!/bin/bash
set -euo pipefail

# Navigate to the Flutter project directory
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Install Flutter (if not already available in the environment)
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter is not installed. Installing Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
  export PATH="$PATH:$HOME/flutter/bin"
else
  echo "Flutter is already installed."
fi

# Verify Flutter installation
flutter --version

# Precache iOS artifacts
echo "Running flutter precache --ios..."
flutter precache --ios

# Install Dart/Flutter deps
echo "Running flutter pub get..."
flutter pub get

# Install FlutterFire CLI (needed for Crashlytics symbols upload build phase)
echo "Installing flutterfire_cli..."
dart pub global activate flutterfire_cli
export PATH="$PATH:$HOME/.pub-cache/bin"

echo "flutterfire:"
which flutterfire
flutterfire --version

# Install cocoapods
echo "Installing cocoapods..."
export HOMEBREW_NO_AUTO_UPDATE=1
brew install cocoapods

# Set up CocoaPods for iOS
echo "Running pod install for iOS..."
cd ios
pod repo update
pod install
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Create .env from environment variables
echo "Creating .env from environment variables..."
cat <<EOF > .env
NEXT_PUBLIC_SUPABASE_URL=${NEXT_PUBLIC_SUPABASE_URL:-}
NEXT_PUBLIC_SUPABASE_ANON_KEY=${NEXT_PUBLIC_SUPABASE_ANON_KEY:-}
EOF

echo "Flutter build running in ${BUILD_MODE:-release} mode..."

# Build iOS (no codesign in CI)
flutter build ios --no-codesign --release -t lib/main.dart
