# Blitztext iOS

Blitztext iOS is an experimental open-source iPhone/iPad dictation app with a custom
iOS keyboard. It lets you start Whisper-style speech-to-text from a text field, record in
the Blitztext app, and insert the finished text back through the keyboard.

This repository is an iOS-focused fork of
[cmagnussen/blitztext-app](https://github.com/cmagnussen/blitztext-app). The original
project is a macOS menubar speech-to-text preview. This fork keeps the idea, license, and
spirit, but removes the macOS app code so the repository focuses only on the iOS
experiment.

> Preview status: bring your own OpenAI API key, no hosted backend, no App Store release,
> no warranty, no support guarantee.

## What It Does

- **Blitztext keyboard**: start dictation from any iOS text field through a custom keyboard.
- **Blitztext app**: records audio, sends it to OpenAI Whisper, and stores the result for
  the keyboard.
- **Wörtlich**: direct 1:1 transcription.
- **Verbessert**: transcription plus cleanup/shortening while preserving the meaning.
- **Shared keychain handoff**: app and keyboard exchange prepared text without reading the
  clipboard, avoiding recurring iOS paste permission prompts.

## Why It Is Split Into App + Keyboard

iOS custom keyboard extensions do not reliably get microphone input on real devices. The
keyboard therefore cannot do the recording itself.

The current workflow is:

1. Open any app with a text field.
2. Switch to the Blitztext keyboard.
3. Tap **Diktieren**.
4. The keyboard opens the Blitztext app and requests an immediate recording.
5. Stop the recording in Blitztext.
6. Blitztext transcribes the audio and stores the text in the shared keychain.
7. Use the iOS **"‹ Back"** chip to return to the original app.
8. The keyboard sees the prepared text and inserts it into the active text field.

There is currently no public iOS API that reliably lets Blitztext automatically return to
an arbitrary previous app. The system back chip is the deliberate fallback.

## Project Structure

```text
BlitztextiOS/
  App/          iOS container app, recording screen, settings
  Resources/    iOS app Info.plist and entitlements
BlitztextKeyboard/
  Resources/    keyboard extension Info.plist and entitlements
  *.swift       custom keyboard UI and text insertion
BlitztextShared/
  *.swift       OpenAI, audio, keychain, and shared state helpers
project.yml     XcodeGen project definition for the iOS app + keyboard extension
build.sh        helper script for local iOS builds
docs/           setup, privacy, and implementation notes
```

## Requirements

- macOS with Xcode installed
- XcodeGen
- A real iPhone or iPad for testing
- An Apple development team for local device signing
- Full Access enabled for the Blitztext keyboard in iOS Settings
- Your own OpenAI API key

Install XcodeGen if needed:

```bash
brew install xcodegen
```

## Build

Generate the Xcode project:

```bash
xcodegen generate
```

Open `BlitztextiOS.xcodeproj`, select the `BlitztextiOS` scheme, set your signing team,
and build to a connected device.

You can also use the helper script:

```bash
./build.sh --device <DEVICE_ID> --team <TEAM_ID>
```

The bundle identifiers and keychain access group in this preview currently reflect the
maintainer's local development setup. If you fork this repository, replace:

- `de.johannesweisser.blitztext.ios`
- `de.johannesweisser.blitztext.ios.keyboard`
- `43AUMU7SS5.de.johannesweisser.blitztext.shared`

with your own app identifiers, Apple Team ID, and matching keychain access group.

More details live in [docs/setup.md](docs/setup.md) and
[docs/ios-keyboard-mvp.md](docs/ios-keyboard-mvp.md).

## Data Flow

There is no hosted Blitztext backend.

```text
Audio transcription: iPhone/iPad -> OpenAI Audio Transcriptions API
Text improvement:    iPhone/iPad -> OpenAI Chat Completions API
Keyboard handoff:    Blitztext app -> shared iOS keychain -> Blitztext keyboard
```

Read [docs/privacy.md](docs/privacy.md) before using the preview with sensitive content.

## Contributing

Contributions are welcome if they make the iOS preview easier to build, understand, or
fork. Please read [CONTRIBUTING.md](CONTRIBUTING.md).

## License And Attribution

Code is released under the MIT License. See [LICENSE](LICENSE).

This repository is a fork of
[cmagnussen/blitztext-app](https://github.com/cmagnussen/blitztext-app). Project names,
logos, and app icons are not automatically granted as trademarks or brand assets. See
[TRADEMARKS.md](TRADEMARKS.md).
