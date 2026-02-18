#!/usr/bin/env bash
#
# capture-screenshots.sh
#
# Automates App Store screenshot capture by running UI tests across
# multiple simulator device sizes with clean status bars.
#
# Usage:
#   ./capture-screenshots.sh <project-name> <scheme> <ui-test-class>
#
# Example:
#   ./capture-screenshots.sh MyApp MyApp ScreenshotTests
#
# Prerequisites:
#   - UI test class with methods that call XCTAttachment for screenshots
#   - Xcode and simulators installed for target devices
#
# The UI test class should look like:
#
#   import XCTest
#
#   final class ScreenshotTests: XCTestCase {
#       let app = XCUIApplication()
#
#       override func setUpWithError() throws {
#           continueAfterFailure = false
#           app.launch()
#       }
#
#       func takeScreenshot(_ name: String) {
#           let screenshot = app.windows.firstMatch.screenshot()
#           let attachment = XCTAttachment(screenshot: screenshot)
#           attachment.name = name
#           attachment.lifetime = .keepAlways
#           add(attachment)
#       }
#
#       func testHomeScreen() throws {
#           takeScreenshot("01-HomeScreen")
#       }
#
#       func testDetailScreen() throws {
#           // Navigate to detail...
#           takeScreenshot("02-DetailScreen")
#       }
#   }

set -euo pipefail

PROJECT_NAME="${1:?Usage: $0 <project-name> <scheme> <ui-test-class>}"
SCHEME="${2:?Usage: $0 <project-name> <scheme> <ui-test-class>}"
TEST_CLASS="${3:?Usage: $0 <project-name> <scheme> <ui-test-class>}"

OUTPUT_DIR="./screenshots"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Devices to capture — covers required App Store sizes
# Adjust device names to match your installed simulators
declare -a DEVICES=(
    "iPhone 16 Pro Max"    # 6.9" — required base size
    "iPad Pro 13-inch (M4)" # 13" — required for universal apps
)

mkdir -p "$OUTPUT_DIR"

for DEVICE in "${DEVICES[@]}"; do
    SAFE_NAME=$(echo "$DEVICE" | tr ' ' '_' | tr -d '()')
    DEVICE_DIR="$OUTPUT_DIR/${SAFE_NAME}_${TIMESTAMP}"
    mkdir -p "$DEVICE_DIR"

    echo "==> Capturing screenshots on: $DEVICE"

    # Set clean status bar
    xcrun simctl status_bar "$DEVICE" override \
        --time "9:41" \
        --batteryState charged \
        --batteryLevel 100 \
        --cellularMode active \
        --cellularBars 4 \
        --wifiBars 3 \
        2>/dev/null || echo "    (status_bar override not supported for this device)"

    # Determine project file
    if [ -f "${PROJECT_NAME}.xcworkspace/contents.xcworkspacedata" ]; then
        PROJECT_FLAG="-workspace ${PROJECT_NAME}.xcworkspace"
    else
        PROJECT_FLAG="-project ${PROJECT_NAME}.xcodeproj"
    fi

    # Run UI tests to capture screenshots
    RESULT_BUNDLE="$DEVICE_DIR/TestResults.xcresult"

    xcodebuild test \
        $PROJECT_FLAG \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$DEVICE" \
        -only-testing:"${SCHEME}UITests/${TEST_CLASS}" \
        -resultBundlePath "$RESULT_BUNDLE" \
        -derivedDataPath "./DerivedData" \
        2>&1 | tail -5

    # Extract screenshots from xcresult bundle
    if [ -d "$RESULT_BUNDLE" ]; then
        echo "    Extracting screenshots from test results..."
        # Use xcresulttool to list and extract attachments
        xcrun xcresulttool get --path "$RESULT_BUNDLE" --format json 2>/dev/null | \
            python3 -c "
import json, sys, subprocess, os
data = json.load(sys.stdin)
device_dir = '$DEVICE_DIR'

def find_attachments(obj, path=''):
    if isinstance(obj, dict):
        if obj.get('_type', {}).get('_name') == 'ActionTestAttachment':
            name = obj.get('name', {}).get('_value', 'screenshot')
            payload_ref = obj.get('payloadRef', {}).get('id', {}).get('_value', '')
            if payload_ref:
                ext = '.png'
                out_path = os.path.join(device_dir, f'{name}{ext}')
                subprocess.run([
                    'xcrun', 'xcresulttool', 'get',
                    '--path', '$RESULT_BUNDLE',
                    '--id', payload_ref,
                    '--output-path', out_path
                ], capture_output=True)
                if os.path.exists(out_path):
                    print(f'    Saved: {out_path}')
        for v in obj.values():
            find_attachments(v, path)
    elif isinstance(obj, list):
        for item in obj:
            find_attachments(item, path)

find_attachments(data)
" 2>/dev/null || echo "    (Could not auto-extract — check $RESULT_BUNDLE manually)"
    fi

    # Clear status bar override
    xcrun simctl status_bar "$DEVICE" clear 2>/dev/null || true

    echo "    Done: $DEVICE"
    echo ""
done

echo "==> Screenshots saved to: $OUTPUT_DIR"
echo ""
echo "Directories created:"
ls -d "$OUTPUT_DIR"/*_"$TIMESTAMP" 2>/dev/null || echo "(none)"
