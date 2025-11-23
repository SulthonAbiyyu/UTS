#!/usr/bin/env bash
set -e

# 1) install / update flutter SDK in workspace
if [ -d flutter ]; then
  cd flutter
  git pull
  cd ..
else
  git clone https://github.com/flutter/flutter.git
fi

# 2) add flutter to PATH for this session
export PATH="$(pwd)/flutter/bin:$PATH"

# 3) enable web support (idempotent)
flutter config --enable-web

# 4) go to project directory (jika app di subfolder, ganti '.' jadi 'namafolder')
cd .

# 5) get dependencies and build web
flutter pub get
flutter build web --release

# 6) show build result
ls -la build/web
