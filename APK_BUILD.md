# FinancePro — Android APK Build Guide

This guide explains how to build the FinancePro Android APK from the web app using **Capacitor**.

The web app (`web/index.html`) is wrapped into a native Android shell using [Capacitor](https://capacitorjs.com/), then compiled into an installable APK with Gradle.

---

## Prerequisites

| Tool | Version | Purpose |
|---|---|---|
| Node.js | 18+ | Run Capacitor CLI |
| Java JDK | 21 (Temurin recommended) | Compile Android (Java/Kotlin) |
| Android SDK | Platform 34/35, Build-Tools 34 | Android build tools |
| Gradle | 8.11+ (via wrapper) | Build system |

---

## One-time Environment Setup

### 1. Install JDK 21 (Temurin)
```bash
wget https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.5%2B11/OpenJDK21U-jdk_x64_linux_hotspot_21.0.5_11.tar.gz
mkdir -p /opt/jdk21 && tar -xzf OpenJDK21U-jdk_x64_linux_hotspot_21.0.5_11.tar.gz -C /opt/jdk21 --strip-components=1
export JAVA_HOME=/opt/jdk21
export PATH=$JAVA_HOME/bin:$PATH
```

### 2. Install Android SDK (command-line tools)
```bash
mkdir -p /opt/android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdtools.zip
unzip cmdtools.zip -d /opt/android-sdk/cmdline-tools/
mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

---

## Build the APK

### 3. Set up the Capacitor project
```bash
mkdir apkbuild && cd apkbuild
npm init -y
npm install @capacitor/core @capacitor/cli @capacitor/android

# Copy the web app as web assets
mkdir -p www
cp ../web/index.html www/index.html
```

Create `capacitor.config.json`:
```json
{
  "appId": "com.financepro.app",
  "appName": "FinancePro",
  "webDir": "www",
  "android": {
    "allowMixedContent": true
  }
}
```

### 4. Add Android platform & sync
```bash
npx cap add android
npx cap sync android
```

### 5. Fix Kotlin stdlib conflict (Capacitor 7.x)
Add this to `android/app/build.gradle` inside the `android { }` block's sibling level:
```gradle
configurations.all {
    resolutionStrategy {
        force "org.jetbrains.kotlin:kotlin-stdlib:1.8.22"
        force "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.22"
        force "org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.22"
    }
}
```

### 6. Build the debug APK
```bash
cd android
echo "sdk.dir=$ANDROID_HOME" > local.properties
./gradlew assembleDebug --no-daemon --console=plain
```

### 7. Locate the APK
```bash
ls -la app/build/outputs/apk/debug/app-debug.apk
```

---

## APK Details

| Property | Value |
|---|---|
| App name | FinancePro |
| Package ID | com.financepro.app |
| Version | 1.0 (versionCode 1) |
| Min Android | 6.0 (API 23) |
| Target SDK | 35 (Android 15) |
| Build type | Debug (signed with debug key) |
| Size | ~3.9 MB |

---

## Install on a Device

1. Copy the `app-debug.apk` to your Android phone.
2. Open it (enable **"Install from unknown sources"** if prompted).
3. Tap **Install**.
4. Open **FinancePro** and log in with:
   - **Email:** `admin@financepro.com`
   - **Password:** `admin123`

> The first registered user automatically becomes the Super Admin.

---

## Building a Release (signed) APK

For a production-ready, signed APK:

```bash
# 1. Generate a keystore
keytool -genkey -v -keystore financepro.keystore -alias financepro \
  -keyalg RSA -keysize 2048 -validity 10000

# 2. Add signing config to android/app/build.gradle
# 3. Build release
./gradlew assembleRelease
```

The signed APK will be at `app/build/outputs/apk/release/app-release.apk`.

---

## Troubleshooting

| Error | Fix |
|---|---|
| `invalid source release: 21` | Use JDK 21 (not 17) |
| `Duplicate class kotlin.*` | Add the `resolutionStrategy` force block (step 5) |
| `SDK location not found` | Create `android/local.properties` with `sdk.dir=...` |
| Gradle download slow | First build downloads ~500MB of dependencies; be patient |
