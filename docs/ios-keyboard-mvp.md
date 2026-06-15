# Blitztext iOS Keyboard MVP

This branch adds an iOS container app and a custom keyboard extension.

## Current flow

1. The user enables the Blitztext keyboard in iOS Settings.
2. In any editable text field, the user switches to the Blitztext keyboard.
3. The keyboard's `Diktieren` button opens `blitztext://record?source=keyboard`.
4. The iOS app records audio, sends it to OpenAI Whisper, and stores the transcript in the shared App Group.
5. The transcript is also marked for auto-insert.
6. When the Blitztext keyboard appears again, it consumes the pending transcript and inserts it through `textDocumentProxy.insertText(...)`.

## Why recording is in the app

Apple's custom keyboard documentation says custom keyboards do not have microphone access, so dictation cannot run directly inside the keyboard extension. The keyboard therefore acts as the text insertion surface, while the containing app owns microphone capture and transcription.

## Shared state

The app and keyboard share lightweight state through:

```text
group.app.blitztext.shared
```

The OpenAI API key is stored in the iOS Keychain by the containing app. The keyboard currently does not need the key because it does not perform transcription itself.

## Next steps

- Add App Intents for Action Button, Back Tap, and Shortcuts.
- Improve the return-to-keyboard UX after recording.
- Add history and deletion controls.
- Explore local WhisperKit on iOS in the containing app first, then evaluate memory limits for keyboard-adjacent workflows.

