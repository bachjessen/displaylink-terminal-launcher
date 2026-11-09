#!/bin/zsh
set -euo pipefail

ROOT_DIR="${0:A:h}"
APP_NAME="DisplayLink Starter.app"
APP_DIR="$ROOT_DIR/build/$APP_NAME"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

rm -rf "$ROOT_DIR/build"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

xcrun swiftc \
    -O \
    -target arm64-apple-macos13.0 \
    -framework AppKit \
    "$ROOT_DIR/app/main.swift" \
    -o "$MACOS_DIR/DisplayLinkStarter"

cp "$ROOT_DIR/app/Info.plist" "$CONTENTS_DIR/Info.plist"
cp "$ROOT_DIR/app/launcher.zsh" "$RESOURCES_DIR/displaylink.command"
chmod +x "$RESOURCES_DIR/displaylink.command"

# iCloud Drive may attach Finder metadata that invalidates code signing.
xattr -cr "$APP_DIR"

/usr/bin/codesign --force --deep --sign - "$APP_DIR"
/usr/bin/codesign --verify --deep --strict --verbose=2 "$APP_DIR"

echo "Built $APP_DIR"
