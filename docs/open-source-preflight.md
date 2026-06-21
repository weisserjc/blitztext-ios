# Open Source Preflight

Use this checklist before making the repository public.

## P0 Before Public

- Run `xcodegen generate`.
- Run a simulator compile with:
  `xcodebuild -project BlitztextiOS.xcodeproj -scheme BlitztextiOS -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`.
- For a real-device check, run `./build.sh --device <DEVICE_ID> --team <TEAM_ID> --install`.
- Run a secret scan across the working tree and commit history.
- Confirm there are no private URLs, hosted backend credentials, internal docs, or old macOS app files.
- Keep the repository private until another maintainer has reviewed the first public commit.
- Confirm the root `LICENSE`, `README.md`, `SECURITY.md`, `CONTRIBUTING.md`, and `SUPPORT.md` are present.
- Make the preview status explicit: experimental, bring your own OpenAI API key, no hosted backend, no warranty.
- Enable GitHub private vulnerability reporting, secret scanning, and push protection before switching the repo public.
- Enable Dependabot alerts.
- Protect `main` with pull requests, at least one review, and required CI checks.
- Keep GitHub Actions permissions read-only by default.

## P1 Soon After Public

- Enable private vulnerability reporting.
- Decide whether Issues alone are enough or whether Discussions should be enabled for questions.
- Add repository topics such as `ios`, `swift`, `keyboard-extension`, `speech-to-text`, `openai`, and `whisper`.
- Add a lightweight TestFlight process only after signing is stable.
- Add focused tests for provider boundaries and shared storage behavior.

## P2 Later

- Add CODEOWNERS if multiple maintainers become active.
- Research whether any recording flow can reduce the app switch friction without violating iOS keyboard extension limits.
- Consider CodeQL once the repo has enough surface area to justify scheduled scans.
- Add App Store or TestFlight distribution only after privacy wording, review notes, and signing are ready.
