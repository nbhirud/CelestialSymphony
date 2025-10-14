#!/bin/sh

# This is a LINUX (Fedora) setup config. 


# Directories
# $HOME = user's home dir
CODE_BASE_PATH="$HOME/nb/CodeProjects"
CELSYM_DIR="$CODE_BASE_PATH/CelestialSymphony"
FLUTTER_SDK_DIR="$CODE_BASE_PATH/flutter"

# Create directories
mkdir -p CODE_BASE_PATH
cd CODE_BASE_PATH || exit


# Download this repo
git clone https://github.com/nbhirud/CelestialSymphony.git

# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to your PATH
export PATH="$FLUTTER_SDK_DIR/bin:$PATH"

# Verify Flutter installation
flutter --version

# Accept licenses (for Android build)
flutter doctor --android-licenses

# Verify everything
# Check that Flutter, Dart, Android SDK, and Java JDK are all green
flutter doctor

# Install Linux packages
sudo dnf install gtk3 glib2
sudo dnf install mpv-libs
ldconfig -p | grep libmpv
sudo ln -s /lib64/libmpv.so.2 /usr/lib/libmpv.so.1
sudo ln -s /lib64/libmpv.so.2 /lib64/libmpv.so.1 

# Disable ATK accessibility if you don’t use screen readers
export NO_AT_BRIDGE=1

# Optional: Install an older libmpv.so.1 alongside
# sudo dnf install mpv-0.29-libs

# Set brave browser as default chrome executable if installed: 
# Initialize variable
BRAVE_PATH=""

# 1. Check for native Linux installation
if command -v brave >/dev/null 2>&1; then
    BRAVE_PATH=$(command -v brave)
elif command -v brave-browser >/dev/null 2>&1; then
    BRAVE_PATH=$(command -v brave-browser)
fi

# 2. If not found natively, check Flatpak
if [[ -z "$BRAVE_PATH" ]]; then
    if flatpak info com.brave.Browser >/dev/null 2>&1; then
        BRAVE_PATH="flatpak run com.brave.Browser"
    fi
fi

# 3. Export CHROME_EXECUTABLE if Brave was found
if [[ -n "$BRAVE_PATH" ]]; then
    export CHROME_EXECUTABLE="$BRAVE_PATH"
    echo "CHROME_EXECUTABLE set to: $CHROME_EXECUTABLE"
else
    echo "Brave browser not found. CHROME_EXECUTABLE not set."
fi

# Setup development environment:
cd $CELSYM_DIR || exit

# Create a virtual environment
python -m venv venv
source venv/bin/activate   # Linux / macOS
# venv\Scripts\activate      # Windows

# Install dependencies
pip install -r requirements.txt


# Run the app
python main.py

# generates an .apk you can install and test locally
# flet build apk

# Transfer the APK to your Android phone for testing
# adb install path/to/CelestialSymphony.apk

# F-Droid requires a metadata file for your project. Minimum info:
# categories: Science
# description: Track and enjoy aurora borealis with a simple FOSS app.
# license: MIT
# source:
#     url: https://github.com/yourusername/celestial_symphony
# gradle:  # or python-for-android instructions

