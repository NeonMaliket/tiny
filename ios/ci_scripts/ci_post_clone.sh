#!/bin/bash

# Navigate to the Flutter project directory
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Install Flutter (if not already available in the environment)
if ! command -v flutter &> /dev/null
then
    echo "Flutter is not installed. Installing Flutter SDK..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
    export PATH="$PATH:$HOME/flutter/bin"
else
    echo "Flutter is already installed."
fi

# Verify Flutter installation
flutter --version

# Install dependencies
echo "Running Flutter pub get..."
# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

flutter pub get

echo "Installing cocoapods..."
# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Set up CocoaPods for iOS
echo "Running pod install for iOS..."
cd ios
pod install --repo-update

# Go back to the workspace root
cd "$CI_PRIMARY_REPOSITORY_PATH"

echo "Creating .env from environment variables..."
cat <<EOF > .env
NEXT_PUBLIC_SUPABASE_URL=$NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=$NEXT_PUBLIC_SUPABASE_ANON_KEY
EOF

BUILD_MODE=${BUILD_MODE:-debug}

echo "Flutter build running in $BUILD_MODE mode..."

if [ "$BUILD_MODE" = "release" ]; then
  flutter build ios --no-codesign --release -t lib/main.dart
else
  flutter build ios --no-codesign --debug -t lib/main.dart
fi

