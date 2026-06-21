#!/bin/bash
set -euo pipefail

# Blitztext iOS - local build helper
# Requirements: Xcode, XcodeGen, an Apple development team for device builds.

BUILD_CONFIGURATION="Debug"
DEVICE_ID=""
TEAM_ID=""
INSTALL_APP=false

usage() {
    cat <<USAGE
Usage:
  ./build.sh --device <DEVICE_ID> --team <TEAM_ID> [--release] [--install]

Options:
  --device <id>   iPhone/iPad device identifier for xcodebuild destination
  --team <id>     Apple Developer Team ID used for signing
  --release       Build Release instead of Debug
  --install       Install the built app to the device with xcrun devicectl

For a compile-only simulator check, use:
  xcodegen generate
  xcodebuild -project BlitztextiOS.xcodeproj -scheme BlitztextiOS \\
    -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --device)
            DEVICE_ID="${2:-}"
            shift 2
            ;;
        --team)
            TEAM_ID="${2:-}"
            shift 2
            ;;
        --install)
            INSTALL_APP=true
            shift
            ;;
        --release)
            BUILD_CONFIGURATION="Release"
            shift
            ;;
        --debug)
            BUILD_CONFIGURATION="Debug"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$DEVICE_ID" || -z "$TEAM_ID" ]]; then
    usage
    exit 1
fi

if ! command -v xcodegen >/dev/null 2>&1; then
    echo "xcodegen is required. Install with: brew install xcodegen"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DERIVED_DATA_PATH="$SCRIPT_DIR/.derivedData-blitztext-ios"

cd "$SCRIPT_DIR"

echo "Generating Xcode project ..."
xcodegen generate

echo "Building BlitztextiOS for device $DEVICE_ID ..."
xcodebuild \
    -project BlitztextiOS.xcodeproj \
    -scheme BlitztextiOS \
    -destination "platform=iOS,id=$DEVICE_ID" \
    -configuration "$BUILD_CONFIGURATION" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    -allowProvisioningUpdates \
    DEVELOPMENT_TEAM="$TEAM_ID" \
    build

APP_PATH="$DERIVED_DATA_PATH/Build/Products/$BUILD_CONFIGURATION-iphoneos/Blitztext.app"

if [[ ! -d "$APP_PATH" ]]; then
    echo "Build finished but app was not found at: $APP_PATH"
    exit 1
fi

echo "Built app:"
echo "  $APP_PATH"

if [[ "$INSTALL_APP" == true ]]; then
    echo "Installing app to device ..."
    xcrun devicectl device install app --device "$DEVICE_ID" "$APP_PATH"
fi
