# Pluto

A minimal new tab for Chrome.(more on the way!) built with [Flutter](https://flutter.dev/) ![logo](flutter.png).

![Screenshot](screenshots/banner.png)

## Installation

### Install to Chrome/Edge

#### Local Install

1. Download `chrome.zip` from [Releases](https://github.com/birjuvachhani/pluto/releases)
2. Unzip the file
3. In Chrome/Edge go to the extensions page (`chrome://extensions` or `edge://extensions`).
4. Enable Developer Mode.
5. Drag the unzipped folder anywhere on the page to import it (do not delete the folder afterwards).

## Build from source

1. Clone the repo
2. Install dependencies with `flutter pub get`
3. Run `flutter build web --release --web-renderer html --csp`
4. Load the `build/web` directory to your browser

## Credits

This project is inspired by [avinayak/minim](https://github.com/avinayak/minim)
