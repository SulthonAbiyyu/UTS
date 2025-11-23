#!/bin/bash

# Clone Flutter jika belum ada
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git
else
  cd flutter
  git pull
  cd ..
fi

export PATH="$(pwd)/flutter/bin:$PATH"

flutter config --enable-web
flutter pub get
flutter build web
