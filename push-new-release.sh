#!/usr/bin/env bash

BUILD=$(date '+%Y%m%d%H%M%S')
sed -i "s/alpha v0.1.0+.*/alpha v0.1.0+$BUILD',/g" lib/constants.dart
sed -i "s/version:.*/version: 0.1.0+$BUILD/g" pubspec.yaml
flutter build web
rm -rf docs
cp -r build/web/ docs
git add docs
git add pubspec.lock
git add pubspec.yaml
git add lib/constants.dart
echo "Build PWA $BUILD"
git commit -S -m "Build PWA $BUILD"
git push
