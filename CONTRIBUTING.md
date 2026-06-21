# Contributing

Thanks for taking a look at Blitztext iOS.

This repository is intentionally a preview. Contributions should make it easier to learn
from, build, fork, or safely extend the iOS app and keyboard extension.

## Good First Contributions

- improve iOS build instructions
- improve keyboard or recording error messages
- document signing/keychain setup more clearly
- add tests around prompt construction or text improvement
- simplify setup for new forks

## Before Opening A Pull Request

Please include:

- what changed
- why it changed
- how you tested it
- whether you used AI-assisted coding tools

Keep changes small when possible. Avoid unrelated cleanup in the same PR.

## Local Build

```bash
xcodegen generate
xcodebuild -project BlitztextiOS.xcodeproj -scheme BlitztextiOS \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

For real workflow testing, build to a physical iPhone or iPad.

## Security And Privacy

- Never commit API keys, tokens, private audio, or confidential transcripts.
- Avoid adding telemetry, hosted services, or external dependencies without a clear issue first.
- Call out privacy-impacting changes in the pull request description.
- Keep the preview honest: do not describe OpenAI workflows as offline or local.

## Project Boundaries

This preview currently does not include:

- a hosted backend
- App Store distribution
- packaged releases
- offline iOS transcription
- local text rewriting
