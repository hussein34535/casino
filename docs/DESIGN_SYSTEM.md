# نظام التصميم الموحّد — Xo Game Show

> **المرجع الوحيد للـ UI/UX في كل التطبيق.** أي شاشة جديدة أو تعديل لازم يتبعه.
> النمط المعتمد: **Comic الفاتح** (كريمي + حدود سوداء + ظلال صلبة + إيموجي في العناوين).

## 1. لماذا هذه الوثيقة

التطبيق كان يعاني من **3 أنماط تنافسية** في نفس الوقت:

| النمط | المكان | الحالة |
|---|---|---|
| **Comic (الفاتح)** ✅ | الرئيسية، التابات، شاشات اللعب | **القياسي المعتمد** |
| Xo-Luxe (داكن/ذهبي) | auth، غرف الأونلاين | ❌ ملغى — تم تحويله لـ Comic |
| AppColors (كحلي Material) | onboarding، gamification، admin | ❌ ملغى — ألوانه أُعيدت لـ Comic |

## 2. الألوان — `ComicColors` (من `core/widgets/premium_widgets.dart`)

| Token | القيمة | الاستخدام |
|---|---|---|
| `yellow` | `0xFFFFD600` | اللون الأساسي، أزرار التمييز، هايلايت |
| `orange` | `0xFFFF6B00` | ثانوي دافئ، تدرّجات |
| `red` | `0xFFFF1F4B` | خطأ/خطر/تحذير |
| `blue` | `0xFF0066FF` | أزرار "التالي"/روابط، AppBar أزرق |
| `skyBlue` | `0xFF00C2FF` | تمييز فاتح |
| `green` | `0xFF00D26A` | نجاح/تأكيد |
| `purple` | `0xFF8B2BE2` | AppBar أخضر-بنفسجي لاختيار الفئة |
| `pink` | `0xFFFF3DDD` | تمييز نادر |
| `grey` | `0xFF888888` | نصوص ثانوية، عناصر معطّلة |
| `black` | `0xFF1A1A1A` | كل الحدود + النصوص الأساسية |
| `white` | `0xFFFFFBF0` | خلفية البطاقات (أبيض دافئ) |
| `cream` | `0xFFFFF8DC` | خلفية الصفحات |

**رموز الخلفيات الموحّدة** (تُستبدل أي ألوان hardcoded قديمة):
- خلفية صفحة فاتحة: `ComicColors.cream`
- خلفية بطاقة: `ComicColors.white`
- لا تُستخدم `Color(0x...)` يدويًا في الشاشات — فقط عبر `ComicColors`

## 3. الودجات — `core/widgets/premium_widgets.dart`

| الودجة | تُستخدم لـ | ملاحظات |
|---|---|---|
| `ComicCard` | كل البطاقات والأقسام | حد أسود **3px** + ظل صلب `(6,6) blur:0` + radius 20 |
| `ComicButton` | كل الأزرار الرئيسية | حد أسود 3px + radius 18 + ظل يزول عند الضغط |
| `ComicBackground` | خلفية كل صفحة | نقاط halftone فوق `bgColor` |
| `ComicTag` | شارات صغيرة/أزرار ثانوية | حد 2.5px + ظل `(3,3)` + radius 10 |
| `ComicBadge` | عدّادات (Q: 3، نقاط) | دائري + حد 2.5px |
| `ComicScoreChip` | عرض النقاط | radius 30 |

**قواعد:**
- أي بطاقة/زر/شارة → من `premium_widgets` بس. ❌ مافيش `Container` يعيد اختراع بطاقة.
- `ElevatedButton`/`Card` الخام ممنوع في الشاشات — استخدم Comic.
- الأيقونات داخل الأزرار: `ComicButton.icon` تقبل `IconData` (Material) للتوافق.

## 4. الأيقونات — `XoIcon` (SVG من `assets/icons/*.svg`)

- أيقونات الواجهة (أزرار، تبويبات، سكشنات) → `XoIcon('wifi')` إلخ من Lucide.
- الأسماء المتوفرة موثقة في `lib/core/design/xo_icon.dart`. أيقونة ناقصة؟ نزّلها من
  `https://raw.githubusercontent.com/lucide-icons/lucide/main/icons/<name>.svg`
  إلى `assets/icons/` (مُصرَّح في pubspec بـ `assets/icons/`).
- **الإيموجي مسموح** في عناوين الشاشات وأسماء الأوضاع (هوية Comic) — `🎯 اختر فئة`.
- أيقونات Material (`Icons.*`) مسموحة فقط داخل `ComicButton`/حالة لا توجد لها بديلة SVG.

## 5. بنية الصفحة

```dart
Scaffold(
  backgroundColor: ComicColors.cream,          // أو لون فاتح hardcoded قديم موحّد
  appBar: AppBar(
    backgroundColor: <لون ComicColor>,           // ملوّن، مختلف لكل قسم
    elevation: 0,
    shape: Border(bottom: BorderSide(color: ComicColors.black, width: 3)),  // إلزامي
    title: Text('🎯 العنوان', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
  ),
  body: ComicBackground(bgColor: ..., dotColor: <لون AppBar>),
)
```

- **العنوان**: إيموجي + نص، `FontWeight.w900`.
- `Scaffold.backgroundColor` و `ComicBackground.bgColor` = **نفس اللون**.
- خطوط: `Cairo` من الثيم — العناوين w900، النصوص w700، الثانوي w600.

## 6. المسافات والأشكال

- Radius: بطاقة 20، زر 18، شارة/حقل صغير 10–16.
- الحدود: `ComicColors.black` بعرض **3** للبطاقات، **2.5** للشارات.
- الظلال: صلبة `BoxShadow(color: black, offset: Offset(N,N), blurRadius: 0)` بدل الظلال الناعمة.

## 7. SnackBars والحوارات

- SnackBar: `ScaffoldMessenger` + `behavior: SnackBarBehavior.floating` + خلفية `ComicColors.black` + نص w800.
- حوار: `AlertDialog` بـ `backgroundColor: ComicColors.cream/yellow` + حد أسود 3–5px + radius 24–32.

## 8. ممنوع (Deprecated) — لا تُستخدم في أي شاشة جديدة

| العنصر | المسار | البديل |
|---|---|---|
| `XoDesign`، `XoScaffold`، `XoCard`، `XoButton`، `XoGlassCard`، `XoCodeInput`… | `core/design/xo_design.dart`, `xo_widgets.dart` | `ComicColors` + `premium_widgets` |
| `AppColors.darkBlue/surfaceDark/cardDark` كخلفيات | `core/theme/app_theme.dart` | `ComicColors.cream/white` |
| `XoCard`/`XoButton` القديمة (كحلي شفاف) | `presentation/widgets/common/` | أُعيدت تهيئتها لـ Comic — استمر باستخدامها كما هي |
| خلفيات `Color(0xFFF0F7FF)` و`0xFFFFF5CC` المتشعبة | شاشات قديمة | `ComicColors.cream` |

## 9. ملاحظات بنيوية

- شاشات اللعب (game_screen, local_setup…) وقسم الجرس: **مرخصة بمظهر Comic** —
  حدود سوداء + خلفيات فاتحة + ألوان `ComicColors` + `XoIcon` للأيقونات.
- `AppTheme.lightTheme` أُعيد تهيئته لهوية Comic (Cairo، خلفية فاتحة، بطاقات بحدود).
- اختصارات: أي تعديل UI جديد → حدّث هذا الملف أولًا.
