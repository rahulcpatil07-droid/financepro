#!/usr/bin/env bash
#
# build-apk.sh — Build the FinancePro Android APK from the web app
#
# Prerequisites: JDK 21, Android SDK (platform-tools, build-tools 34, platform 34)
#
# Usage:
#   export ANDROID_HOME=/opt/android-sdk
#   export JAVA_HOME=/opt/jdk21
#   ./build-apk.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$SCRIPT_DIR/.build"

echo "==> FinancePro APK Build"
echo "    Repo:   $REPO_ROOT"
echo "    Build:  $BUILD_DIR"

: "${ANDROID_HOME:?ANDROID_HOME is not set}"
: "${JAVA_HOME:?JAVA_HOME is not set}"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/www"
cp "$REPO_ROOT/web/index.html" "$BUILD_DIR/www/index.html"
cp "$SCRIPT_DIR/capacitor.config.json" "$BUILD_DIR/capacitor.config.json"
cp "$SCRIPT_DIR/package.json" "$BUILD_DIR/package.json"

cd "$BUILD_DIR"
echo "==> Installing Capacitor dependencies..."
npm install --silent

echo "==> Adding Android platform..."
npx cap add android

echo "==> Syncing web assets..."
npx cap sync android

GRADLE_APP="$BUILD_DIR/android/app/build.gradle"
python3 - "$GRADLE_APP" <<'PY'
import sys, re
p = sys.argv[1]
s = open(p).read()
fix = """
// Fix Kotlin stdlib duplicate class conflict (Capacitor 7.x)
configurations.all {
    resolutionStrategy {
        force "org.jetbrains.kotlin:kotlin-stdlib:1.8.22"
        force "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.22"
        force "org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.22"
    }
}
"""
if "kotlin-stdlib:1.8.22" not in s:
    s = re.sub(r'\n}\n', fix + "}\n", s, count=1)
    open(p, "w").write(s)
    print("Applied Kotlin fix to", p)
else:
    print("Kotlin fix already present")
PY

echo "sdk.dir=$ANDROID_HOME" > "$BUILD_DIR/android/local.properties"

echo "==> Building debug APK (first run downloads dependencies, be patient)..."
cd "$BUILD_DIR/android"
chmod +x gradlew
./gradlew assembleDebug --no-daemon --console=plain

APK="$BUILD_DIR/android/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
    OUT="$SCRIPT_DIR/FinancePro-v1.0.apk"
    cp "$APK" "$OUT"
    echo ""
    echo "==> SUCCESS! APK built:"
    echo "    $OUT"
    echo "    Size: $(du -h "$OUT" | cut -f1)"
else
    echo "==> ERROR: APK not found at $APK"
    exit 1
fi
