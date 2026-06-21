# Roadmap

This is a preview roadmap, not a promise.

## Current Scope

- iOS app plus custom keyboard extension
- direct OpenAI API calls with a user-provided API key
- literal transcription mode
- improved/shortened text mode
- shared keychain handoff between app and keyboard
- no hosted backend
- no packaged public release

## Next Useful Work

- Make first-run setup clearer.
- Improve signing/keychain setup instructions for forks.
- Improve API key validation and recovery UX.
- Add tests around prompt construction and text improvement.
- Explore a robust background-session architecture for smoother dictation without a visible app switch.
- Improve the return flow if Apple exposes a reliable public API.
- Consider offline/on-device transcription only if model size, memory, and iOS extension limits make it practical.

## Not In Scope Yet

- Production support.
- Accounts, sync, teams, or hosted infrastructure.
- Claims that the app is offline or privacy-complete.
- App Store distribution.
- Bundled local speech models.
