# Security Policy

Blitztext iOS is experimental software.

It is provided as-is, without warranty, support guarantees, or production-readiness claims.

## Supported Versions

Only the current `main` branch is considered for security fixes.

## Reporting A Vulnerability

Please do not open a public issue with sensitive security details.

Use GitHub private vulnerability reporting for this repository if available. If private
vulnerability reporting is not available, open a minimal public issue titled `Security
contact request` without technical details.

Do not include OpenAI API keys, access tokens, private recordings, or confidential
transcripts in a report.

Include:

- what you found
- how to reproduce it
- what data or system access could be affected
- your suggested fix, if you have one

## Security Notes

- The app sends audio and text directly to OpenAI when using transcription or improvement.
- Your OpenAI API key is stored in the iOS Keychain.
- The app and keyboard exchange state through a shared keychain access group.
- Temporary audio files may exist briefly during processing.
- The keyboard requires Full Access so it can communicate with the app and insert text.

Do not use this preview for confidential or regulated data without your own review.
