# FinancePro — Smart Finance Management System

**FinancePro** is a personal finance management application available in two formats:

1. **Web App** (`web/index.html`) — A complete, single-file Progressive-Web-App–style finance manager that runs in any modern browser. No build step, no server, no backend. All data is stored locally in the browser via `localStorage`.
2. **Flutter App** (`lib/`) — A native Flutter (Dart) implementation focused on the onboarding flow (splash → login → register) with animated 3D-style visuals, designed for Android/iOS.

> © 2026 FinancePro Manager · Developed by Rahul Patil · Version 1.0

---

## 🌐 Web App (`web/index.html`)

A self-contained, offline-capable finance dashboard built with plain HTML, CSS, and vanilla JavaScript.

### Features

- **Authentication** — Login & Register screens with a glassmorphism card. The **first registered user automatically becomes the Super Admin**. Credentials are stored in `localStorage`.
- **Dashboard** — Total Balance, Net Worth, Total Income, and Total Expenses stat cards with trend indicators.
- **Quick Actions** — Add Expense, Add Income, Pay Bill, and Loan Manager shortcuts.
- **Recent Transactions** — Income and expense feed with categories, timestamps, and status badges.
- **Upcoming Bills** — Pending bill reminders with due-date countdowns.
- **Reports** — Daily, Weekly, Monthly, and Yearly report cards plus Income, Expense, and Budget report shortcuts.
- **Analytics** — Financial Health score, Savings Rate, Expense Ratio, Budget Accuracy, and top income/expense category insights.
- **Settings** — Profile, Currency (₹ INR), Theme toggle, Backup, Restore, Category Management, and Logout.
- **Dark / Light Theme** — One-tap theme switching.
- **Responsive** — Mobile-first layout with a fixed bottom navigation bar, capped at 480px for a native app feel.
- **Toast Notifications** — Non-intrusive feedback for every action.

### Demo Login

A demo Super Admin account is seeded automatically on first load:

```
Email:    admin@financepro.com
Password: admin123
```

### Default Categories (Super Admin)

When the Super Admin is created, the following expense categories and sub-categories are seeded:

| Category | Sub-categories |
|---|---|
| Home | Rent, Property Tax, Home Maintenance, Furniture, Home Repair |
| Utilities | Electricity Bill, Gas Bill, Water Bill, Internet Bill, Cell Phone Bill, DTH Bill |
| Departmental | Grocery, Clothing, Personal Items, Household Items, Kids, Toys |
| Entertainment | Movies, Music, OTT Subscription, Games, Picnic |
| Car / Auto | Petrol, Diesel, Service, Insurance, Parking, Toll Tax |
| Insurance / Medical | Medical Expenses, Health Insurance, Doctor Visit, Hospital, Medicine |
| Misc / One-Time | Air Ticket, Hotel, Lodging, Gifts, Donation, Festival Expenses |

### How to Run

No dependencies required. Simply open the file in a browser:

```bash
# Option 1: open directly
open web/index.html

# Option 2: serve locally
cd web && python3 -m http.server 8000
# then visit http://localhost:8000
```

Because everything runs client-side with `localStorage`, your financial data never leaves your device.

### Data Storage Keys (localStorage)

| Key | Purpose |
|---|---|
| `financepro_users` | Array of registered users (id, name, email, password, role, created) |
| `financepro_categories` | Default expense categories & sub-categories |

---

## 📱 Flutter App (`lib/`)

A Flutter implementation of the FinancePro onboarding experience.

### Structure

```
lib/
  main.dart                       — App entry, Material 3 dark theme
  screens/
    splash_screen.dart            — Animated logo splash (2.6s)
    login_screen.dart             — Main login (glassmorphism + 3D char)
    register_screen.dart          — Register (first user = Admin)
  widgets/
    animated_background.dart      — Gradient + glow orbs + floating icons
    character_3d.dart             — 3D-look business character (CustomPaint)
pubspec.yaml                      — Dependencies
preview/index.html                — HTML mockup for visual reference
```

### How to Run (Flutter)

```bash
flutter create financepro          # 1. scaffold a new project
# 2. replace lib/ and pubspec.yaml with these files
flutter pub get                    # 3. fetch dependencies
flutter run                        # dev
flutter build apk                  # release APK
```

### Design Highlights

- Deep-blue animated 3D background with moving glow orbs
- Floating finance icons: ₹, card, coin, chart, wallet, bank
- Glassmorphism form card (BackdropFilter blur)
- Business-man 3D character (CustomPaint — no asset needed)
- Material 3 + Poppins font + gradient buttons
- Splash → Login → Register / Dashboard flow
- Fingerprint + Face ID biometric buttons (stub)

### Build / CI

- `.github/workflows/build-apk.yml` — GitHub Actions workflow to build an APK
- `codemagic.yaml` — Codemagic CI configuration
- See `APK_BUILD_GUIDE.txt` for detailed build instructions

---

## Repository Layout

```
.
├── web/
│   └── index.html          # Complete web app (HTML + CSS + JS, single file)
├── lib/                    # Flutter source (Dart)
│   ├── main.dart
│   ├── screens/
│   └── widgets/
├── preview/
│   └── index.html          # Visual mockup reference
├── assets/
│   ├── animations/
│   └── images/
├── android/                # Android platform config
├── .github/workflows/
│   └── build-apk.yml       # APK build workflow
├── pubspec.yaml            # Flutter dependencies
├── codemagic.yaml          # Codemagic CI
├── README.md               # This file
├── README.txt              # Original Flutter README
└── APK_BUILD_GUIDE.txt     # APK build guide
```

---

## Tech Stack

| Layer | Web App | Flutter App |
|---|---|---|
| Language | HTML, CSS, JavaScript | Dart |
| Framework | Vanilla (no framework) | Flutter |
| Storage | `localStorage` | shared_preferences / SQLite |
| Build | None (static file) | `flutter build apk` |
| Target | Any modern browser | Android / iOS |

---

## License

Personal project — © 2026 Rahul Patil. All rights reserved.
