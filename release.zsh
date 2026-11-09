#!/bin/zsh
set -euo pipefail

ROOT_DIR="${0:A:h}"
VERSION="$1"
APP_DIR="$ROOT_DIR/build/DisplayLink Starter.app"
DIST_DIR="$ROOT_DIR/dist"
ZIP_NAME="DisplayLink-Terminal-Launcher-${VERSION}.zip"
ZIP_PATH="$DIST_DIR/$ZIP_NAME"

usage() {
    echo "Usage: zsh release.zsh <version>" >&2
    exit 64
}

[[ $# -eq 1 ]] || usage

"$ROOT_DIR/build.zsh"

/usr/bin/codesign --verify --deep --strict --verbose=2 "$APP_DIR"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

(cd "$ROOT_DIR/build" && COPYFILE_DISABLE=1 /usr/bin/ditto -c -k --keepParent "DisplayLink Starter.app" "$ZIP_PATH")

/usr/bin/unzip -t "$ZIP_PATH" >/dev/null

(cd "$DIST_DIR" && /usr/bin/shasum -a 256 "$ZIP_NAME" > "$ZIP_NAME.sha256")

echo "Created $ZIP_PATH"
echo "Created $ZIP_PATH.sha256"
