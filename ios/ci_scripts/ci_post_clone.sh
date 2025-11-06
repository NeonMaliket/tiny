        #!/bin/sh
        # Install CocoaPods
        brew install cocoapods
        # Install Flutter
        brew install --cask flutter
        # Run Flutter doctor
        flutter doctor
        # Get Flutter packages
        flutter packages get
        # Build the iOS app
        flutter build ios --no-codesign --release
