#!/usr/bin/env bash
# Run CLIVORA on Linux desktop (Flutter is not on default PATH on this machine).
export PATH="/home/usmanghias/flutter/bin:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-/home/usmanghias/android-sdk}"
cd "$(dirname "$0")"
flutter pub get
flutter run -d linux
