# Xo Game Show App - Development Guide

## Commands

### Dependencies
- `flutter pub get` - Install dependencies
- `flutter pub outdated` - Check outdated packages

### Code Generation
- `dart run build_runner build --delete-conflicting-outputs` - Build freezed/json codegen
- `dart run build_runner watch` - Watch mode codegen

### Analysis & Testing
- `flutter analyze` - Static analysis (target: 0 errors)
- `flutter test` - Run all tests (452 total, 442 passing, 10 pre-existing Firebase failures)
- `flutter test --coverage` - Coverage report

### Build
- `flutter build apk --release` - Android APK (requires `android/key.properties` and keystore)
- `flutter build ios --release --no-codesign` - iOS build (requires GoogleService-Info.plist)
- `flutter build web` - Web build

### Firebase
- `firebase deploy --only functions,firestore` - Deploy backend
- `firebase emulators:start` - Local emulator
- `firebase.json` project: `casino-be258` | `.firebaserc` default: `casino-be258`

### Publishing
- Android keystore: `android/app/upload-keystore.jks` (password: `xogame2026`)
- Android applicationId: `com.example.xo` (تغييره يتطلب تحديث google-services.json من Firebase Console)
- iOS bundle identifier: `com.example.xo` (تغييره يتطلب إعادة تشغيل flutterfire configure)
- App icons: `dart run flutter_launcher_icons` (requires `assets/icon.png`)

## Project Structure
- `lib/core/` - Theme, constants, errors, network, utils
- `lib/data/models/` - Data models (user, game, question, etc.)
- `lib/data/repositories/` - Repository implementations
- `lib/data/datasources/` - Remote/local data sources
- `lib/domain/repositories/` - Abstract repository interfaces
- `lib/domain/usecases/` - Business logic use cases
- `lib/presentation/screens/` - All UI screens
- `lib/presentation/providers/` - Riverpod state providers
- `lib/services/` - Firebase, API, analytics, streaming, voice, notifications
- `lib/router/` - GoRouter configuration (37 routes)

## Architecture
- State Management: Riverpod (flutter_riverpod) — NO GetIt (removed)
- Routing: GoRouter
- Backend: Firebase (Auth, Firestore, Storage, Crashlytics, Performance, Analytics — لا Cloud Functions)
- Architecture: Clean Architecture (data/domain/presentation)
- DI: Riverpod providers only

## Design System (MANDATORY)
- **اقرأ `docs/DESIGN_SYSTEM.md` قبل أي تعديل UI.** النمط الموحّد لكل التطبيق: **مسرح اللعبة
  (Game Show Stage)** — خلفية نيلية `stage #161046` + كشافات + كروت بيضاء بلا حدود +
  أصفر `#FFD60A` + خطوط Cairo/Lalezar (من `assets/fonts/`).
- الألوان والودجات: `core/widgets/premium_widgets.dart` (`ComicColors`, `ComicCard`, `ComicButton`,
  `ComicBackground`, `ComicTag`, `ComicBadge`) + `presentation/widgets/common/xo_card.dart` (`XoCard`) فقط.
  الأسماء القديمة "Comic" محفوظة عمدًا بقيم/تنفيذ المسرح الجديد — لا تُعاد تسمية ولا تُرجع قيمها القديمة.
- الأيقونات: `XoIcon` (SVG من `assets/icons/`) — الإيموجي مسموح في العناوين.
- قواعد صارمة: ظلال ناعمة `(0,10) blur:24` فقط (ممنوع `blurRadius: 0`)، حدود شفافة بيضاء فقط
  (ممنوع حدود سوداء)، نص `light` على الغامق و`ink` على الأبيض/الأصفر فقط.
- ❌ ممنوع: كريمي/أنماط Comic القديمة، `XoDesign`/`XoScaffold`/`XoButton` من `core/design/`
  (نمط Danten ملغى)، `AppColors.darkBlue` كخلفيات، gradient text، radius > 16 للبطاقات.
- المرجع البصري للقوالب: `docs/ui_templates/` (المختار: `01-game-show.html`).

## Key Features
- Live streaming via `livekit_client` (route: `/live-stream/:gameId`)
- Voice input via `speech_to_text` + TTS via `flutter_tts`
- Keyboard shortcuts for game screen (Space, C, W, R, Escape)
- Offline mode with connectivity banner
- In-app purchases + AI service + AI opponent
- Multi-language (ar/en/fr)
- 12 gamification services (streak, battle pass, challenges, shop, etc.)
