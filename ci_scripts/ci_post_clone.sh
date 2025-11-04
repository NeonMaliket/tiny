#!/bin/sh
set -e

echo "🚀 [CI] Pre-Xcode build: prepare Flutter environment"

if ! command -v flutter &> /dev/null
then
  echo "Flutter not found, installing..."
  git clone https://github.com/flutter/flutter.git -b stable
  export PATH="$PATH:`pwd`/flutter/bin"
fi

flutter pub get
flutter build ios --no-codesign

cd ios
pod install --repo-update
cd ..

echo "✅ [CI] Pre-build complete"
