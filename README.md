# Solitaire

A desktop Klondike Solitaire game built with Qt 6, C++, and QML. The game uses a QML interface backed by C++ objects for the deck, tableau, foundations, scoring, timer, undo history, and win detection.

## Download

Get the latest builds from the [Releases page](https://github.com/zmcgill7/Solitaire/releases/latest).

### Windows

Download `Solitaire-Windows-x64-Setup.exe`, run the installer, then launch Solitaire from the Start menu or desktop shortcut.

### Linux

Download `Solitaire-Linux-x86_64.AppImage`, mark it executable, and run it:

```bash
chmod +x Solitaire-Linux-x86_64.AppImage
./Solitaire-Linux-x86_64.AppImage
```

## Features

- Classic Klondike layout with stock, waste, foundation, and seven tableau piles
- Drag-and-drop card movement
- Double-click assisted moves
- Undo support
- Timer, score, reset, and win screen
- SVG playing card artwork
- Windows installer and Linux AppImage release builds

## Screens

The game opens directly to the card table and is designed for desktop play. The Qt Quick layout adapts the table and controls to the available window size.

## Tech Stack

- C++17
- Qt 6.5+
- Qt Quick / QML
- CMake

## How It Works

`main.cpp` creates the deck, assigns SVG image paths, shuffles the cards, initializes the tableau piles, creates the draw pile, exposes the C++ game objects to QML, and loads the main QML view.

`Main.qml` owns the visual table, card slots, controls, drag handlers, and win screen. User actions call into the C++ model objects to validate moves and update game state.

The core C++ classes are:

- `card`: rank, suit, face-up state, and image path
- `drawPile`: stock pile behavior
- `waste`: waste pile behavior
- `foundation`: ascending same-suit foundation stacks
- `tableau`: descending alternating-color tableau stacks
- `GameState`: shuffle/reset, drag state, scoring, timer, undo snapshots, and win detection

## Build From Source

Install Qt 6.5+ with Qt Quick and a compatible C++ toolchain.

```bash
cmake -S solitaire -B build
cmake --build build
```

In Qt Creator, open `solitaire/CMakeLists.txt`, select a Qt 6.5+ kit, and run the `appqml-solitaire` target.

## Release Automation

Release builds are created from version tags:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Cloud Build builds the Linux AppImage and uploads release files to the matching GitHub Release. The Windows installer is prepared separately with Inno Setup, copied into `packaging/windows/Solitaire-Windows-x64-Setup.exe`, and uploaded alongside the Linux build.

The publish step expects a Secret Manager secret named `github-release-token` with permission to create releases and upload release assets for this repository.
