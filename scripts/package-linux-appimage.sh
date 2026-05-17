#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/linux-release"
APPDIR="$ROOT_DIR/build/AppDir"
DIST_DIR="$ROOT_DIR/dist"
APP_NAME="Solitaire"
EXECUTABLE_NAME="appqml-solitaire"

mkdir -p "$DIST_DIR"
rm -rf "$BUILD_DIR" "$APPDIR"

cmake -S "$ROOT_DIR/solitaire" -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build "$BUILD_DIR" --parallel "$(nproc)"
DESTDIR="$APPDIR" cmake --install "$BUILD_DIR"

mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/scalable/apps"
cp "$ROOT_DIR/packaging/linux/Solitaire.desktop" "$APPDIR/usr/share/applications/Solitaire.desktop"
cp "$ROOT_DIR/solitaire/images/blueCardBack.svg" "$APPDIR/usr/share/icons/hicolor/scalable/apps/solitaire.svg"

TOOLS_DIR="$ROOT_DIR/build/appimage-tools"
mkdir -p "$TOOLS_DIR"

LINUXDEPLOY="$TOOLS_DIR/linuxdeploy-x86_64.AppImage"
LINUXDEPLOY_QT="$TOOLS_DIR/linuxdeploy-plugin-qt-x86_64.AppImage"
APPIMAGETOOL="$TOOLS_DIR/appimagetool-x86_64.AppImage"

download_tool() {
  local url="$1"
  local dest="$2"
  if [[ ! -f "$dest" ]]; then
    wget -q "$url" -O "$dest"
    chmod +x "$dest"
  fi
}

download_tool "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage" "$LINUXDEPLOY"
download_tool "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage" "$LINUXDEPLOY_QT"
download_tool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" "$APPIMAGETOOL"

export OUTPUT="$DIST_DIR/${APP_NAME}-Linux-x86_64.AppImage"
export LINUXDEPLOY_PLUGIN_QT_QML_SOURCES_PATHS="$ROOT_DIR/solitaire"
export APPIMAGE_EXTRACT_AND_RUN=1
export LD_LIBRARY_PATH="/opt/Qt/6.7.3/gcc_64/lib:${LD_LIBRARY_PATH:-}"
ln -sf "$(basename "$LINUXDEPLOY_QT")" "$TOOLS_DIR/linuxdeploy-plugin-qt"
export PATH="$TOOLS_DIR:$PATH"

"$LINUXDEPLOY" \
  --appdir "$APPDIR" \
  --desktop-file "$APPDIR/usr/share/applications/Solitaire.desktop" \
  --icon-file "$APPDIR/usr/share/icons/hicolor/scalable/apps/solitaire.svg" \
  --executable "$APPDIR/usr/bin/$EXECUTABLE_NAME" \
  --plugin qt

QT_QML_DIR="/opt/Qt/6.7.3/gcc_64/qml"
if [[ -d "$QT_QML_DIR" ]]; then
  mkdir -p "$APPDIR/usr/qml"
  cp -a "$QT_QML_DIR/QtQml" "$APPDIR/usr/qml/"
  cp -a "$QT_QML_DIR/QtQuick" "$APPDIR/usr/qml/"

  QT_LIB_DIR="/opt/Qt/6.7.3/gcc_64/lib"
  find "$QT_LIB_DIR" -maxdepth 1 \
    \( -name "libQt6Qml*.so*" -o -name "libQt6Quick*.so*" -o -name "libQt6Labs*.so*" \) \
    -exec cp -a -n {} "$APPDIR/usr/lib/" \;
fi

"$APPIMAGETOOL" "$APPDIR" "$OUTPUT"
chmod +x "$OUTPUT"
echo "Created $OUTPUT"
