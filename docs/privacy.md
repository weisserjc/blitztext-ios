# Privacy Notes

Blitztext iOS does not include a hosted backend.

When you use the app, your iPhone or iPad sends data directly to OpenAI:

- audio recordings for transcription
- transcribed text for the optional improvement/cleanup step
- custom terms and language hints if configured

You are responsible for your OpenAI account, API usage, costs, and data handling.

## Local Data

The iOS app stores:

- your OpenAI API key in the iOS Keychain
- the latest pending keyboard transcript in the shared keychain so the keyboard extension
  can insert it
- mode state, language, and custom terms in local user defaults or shared keychain state
- temporary audio files while a transcription is being processed; the app attempts to
  delete each recording after processing

The iOS keyboard intentionally reads prepared transcript text from the shared keychain
rather than reading the clipboard. This avoids repeated iOS paste permission prompts and
avoids accidentally pulling content from Universal Clipboard.

## Offline Scope

This iOS preview currently uses OpenAI for transcription. It is not an offline dictation
app. The **Verbessert** mode also sends the transcript to OpenAI for rewriting.

## Sensitive Content

Do not use this preview with confidential, regulated, or highly sensitive content unless
you have reviewed the code, your OpenAI settings, and your legal/privacy requirements.
