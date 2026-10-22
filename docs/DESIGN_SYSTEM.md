# نظام التصميم الموحّد — Xo Game Show

> **المرجع الوحيد للـ UI/UX في كل التطبيق.** أي شاشة جديدة أو تعديل لازم يتبعه.
> النمط المعتمد: **مسرح اللعبة — Game Show Stage** (خلفية نيلية داكنة + كشافات +
> كروت بيضاء + أصفر ذهبي). المرجع البصلي: `docs/ui_templates/01-game-show.html`.

## 1. لماذا هذه الوثيقة

التطبيق مرّ بعدة أنماط تنافسية — الكل اتوحّد لصالح المسرح:

| النمط | الحالة |
|---|---|
| **Game Show Stage** ✅ | **القياسي المعتمد لكل التطبيق** |
| Comic الفاتح (كريمي + حدود سوداء + ظلال صلبة) | ❌ ملغى — استُبدل بالكامل (نفس أسماء الودجات، قيم جديدة) |
| Xo-Luxe (داكن/ذهبي)، Danten (`core/design/`)، AppColors (كحلي) | ❌ ملغى من قبل |

## 2. الألوان — `ComicColors` (من `core/widgets/premium_widgets.dart`)

### الخلفيات والأسطح

| Token | القيمة | الاستخدام |
|---|---|---|
| `stage` | `0xFF161046` | خلفية الصفحات الأساسية (نيلي عميق) |
| `stage2` | `0xFF241A6B` | طبقات فوقها + خلفية الحوارات |
| `ink` | `0xFF14123A` | AppBars، الشريط السفلي، نص على الأصفر/الأبيض |
| `white` | `0xFFFFFFFF` | كروت المحتوى (بيضاء صافية) |
| `cream` | = `stage` | اسم قديم محفوظ للتوافق — يرجع النيلي |

### ألوان العلامة

| Token | القيمة | الاستخدام |
|---|---|---|
| `yellow` / `gold` | `0xFFFFD60A` | اللون الأساسي: أزرار، الشارة العلوية، العنصر النشط |
| `goldShadow` | `0xFFB79300` | الظل الذهبي تحت الأزرار الصفراء |
| `red` | `0xFFFF2E4C` | خطر/خطأ/بطاقة حمراء |
| `orange` | `0xFFFF6B00` | تمييز دافئ ثانوي |
| `blue` | `0xFF2E6BFF` | "التالي"/روابط/أزرار إجراء |
| `cyan` | `0xFF3BE0FF` | تركيز الحقول، توهج مختار |
| `green` | `0xFF00D26A` | نجاح/تأكيد |
| `purple` | `0xFF5A3BFF` | تمييز نادر |
| `pink` | `0xFFFF3DDD` | تمييز نادر |

### النصوص

| Token | القيمة | الاستخدام |
|---|---|---|
| `light` | `0xFFEDEBFF` | النص الأساسي **على الخلفية الداكنة** |
| `lightMuted` | `0xFFB9B4E8` | نص ثانوي على الداكن |
| `navMuted` | `0xFF8F8AC4` | نصوص التاب غير النشط + hint على الداكن |
| `black` | = `ink` | النص الأساسي **على الأبيض/الأصفر** |
| `grey` | `0xFF6A67A6` | نص ثانوي على الأبيض |

### حدود وزخارف

| Token | القيمة | الاستخدام |
|---|---|---|
| `line` | `0xFFE7E5F7` | خطوط فاصلة على الأبيض |
| شفاف أبيض | `Color(0x29FFFFFF)` (16%) | حدود الكروت/الكبسولات على الداكن |
| شفاف أبيض | `Color(0x24FFFFFF)` (14%) | حدود ثانوية + فواصل AppBar |
| ظل ناعم | `Color(0x59000000)` + `Offset(0, 10)` + `blur 24` | **الظل الوحيد المسموح** |

## 3. الخطوط

- **الجسم والعناوين**: `Cairo` — `kStageBodyFont` (من `assets/fonts/Cairo.ttf`)، من الثيم.
- **الأرقام والعرض الكبير**: `Lalezar` — `kStageDisplayFont` (من `assets/fonts/Lalezar-Regular.ttf`)
  للنقاس، الأكواد، المؤقتات، النتائج (`ComicScoreChip` تستخدمه تلقائيًا).
- الأوزان: عناوين w900، نصوص w700، ثانوي w600.

## 4. الودجات — `core/widgets/premium_widgets.dart`

| الودجة | السلوك |
|---|---|
| `ComicCard` | كرت **أبيض بلا حدود**، radius 16، ظل ناعم `(0,12) blur:30`. يفرض تلقائيًا لون نص/أيقونة يقرأ حسب سطح البطاقة (فاتح → ink، غامق → أبيض) — النصوص بدون لون جوّاه صارت مقروءة تلقائيًا. |
| `ComicButton` | زر **أصفر** بظل ذهبي صلب `(0,5) blur:0` تحته، يهبط `translate(0,5)` عند الضغط. نص ink افتراضيًا. |
| `ComicBackground` | خلفية الصفحة: **كشافات radial spotlight** (stage2 فوق stage) — لا نقاط halftone. |
| `ComicTag` | كبسولة **صلبة** (pill) بلونها، نص ink على الألوان الفاتحة/أبيض على الغامقة تلقائيًا. |
| `ComicBadge` | عدّادات مع توهج. |
| `ComicScoreChip` | رقاقة نقاط بخط `Lalezar`. |
| `showComicSnack` | SnackBar عائم بخلفية ink ونص light. |

**قواعد:**
- أي بطاقة/زر/شارة → من `premium_widgets` أو `presentation/widgets/common/xo_card.dart` بس.
- `XoCard` (common): خلفية بيضاء صافية فوق أي تدرّج (الgradient طبقة غسيل فوق اللون)،
  بدون حد افتراضي، radius 16، نفس قاعدة لون النص التلقائي.
- الأيقونات: `XoIcon` (SVG من `assets/icons/`) — الإيموجي مسموح في العناوين.

## 5. بنية الصفحة

```dart
Scaffold(
  backgroundColor: ComicColors.stage,
  appBar: AppBar(
    backgroundColor: ComicColors.ink,          // موحّد لكل الشاشات
    elevation: 0,
    shape: Border(bottom: BorderSide(color: Color(0x24FFFFFF))),  // خط أبيض 14%
    title: Text('🏆 العنوان', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.light, fontSize: 20)),
  ),
  body: ComicBackground(bgColor: ComicColors.stage, dotColor: ComicColors.stage2, child: ...),
)
```

- **Bottom nav** (`main_scaffold`): خلفية `Color(0xB80A0728)` + خط علوي أبيض 12%،
  العنصر النشط `yellow`، غير النشط `navMuted`.
- الحقول: تعبئة `Colors.white @ 8%` + حد أبيض 28% + تركيز `cyan` + نص `light`.
- الحوارات: `dialogTheme` = خلفية `stage2` + نصوص `light` (حوار على أصفر/أبيض ← حدّد نصوص ink صريحة).
- SnackBars: خلفية `ink` + نص `light` (من الثيم).

## 6. قواعد النص وال_contrast (إلزامية)

1. نص **بدون لون** داخل `ComicCard`/`XoCard` → يُلوَّن تلقائيًا حسب سطح البطاقة.
   على أسطح صغيرة خارج الودجات (حوارات، كبسولات، حقول): حدّد لونًا صريحًا —
   `ink`/`black` على الأبيض والأصفر، `light` على stage/stage2/ink.
2. ❌ ممنوع `light`/`Colors.white` كنص فوق أسطح فاتحة (أبيض/أصفر/كريمي).
3. فواصل داخل كروت بيضاء: `Divider(color: Color(0x14000000), thickness: 1)` —
   ❌ لا فواصل سوداء غليظة.

## 7. المسافات والأشكال

- Radius: بطاقة **16**، حوار 20، زر 14–16، كبسولات/شارات `999` (pill).
- الحدود: شفافة بيضاء فقط (`0x29FFFFFF`/`0x24FFFFFF`) — ❌ ممنوع حدود سوداء.
- الظلال: ناعمة `(0,10) blur:24` فقط — ❌ ممنوع `blurRadius: 0` أو إزاحة صلبة (عدا ظل الذهب
  المقصود تحت `ComicButton`).

## 8. ممنوع (Deprecated)

| العنصر | البديل |
|---|---|
| كريمي/خلفيات فاتحة، حدود سوداء 3px، ظلال صلبة `(N,N) blur:0` (نمط Comic القديم) | stage + حدود شفافة + ظلال ناعمة |
| `XoDesign`/`XoScaffold`/`XoCard`/`XoButton` من `core/design/` (Danten) | `premium_widgets` + `common/xo_card.dart` |
| `AppColors.darkBlue` كخلفيات | `ComicColors.stage` |
| gradient text، glassmorphism، radius > 16 للبطاقات، كروت متطابقة بدون hierarchy | — |
| نص فاتح على سطح فاتح / نص داكن على سطح غامق | قاعدة §6 |

## 9. ملاحظات بنيوية

- الأسماء القديمة (`ComicColors`/`ComicCard`…) **محفوظة عمدًا** بقيم وتنفيذ جدد —
  لا تُعاد تسميتها، ولا يُرجع تنفيذها للنمط القديم.
- `AppTheme.lightTheme` هو ثيم التطبيق الفعلي: `brightness.dark` + أصفر primary.
- شاشات auth/الغرف/التركيب/اللعب كلها مرخصة بمظهر المسرح — أي تعديل UI جديد
  ← حدّث هذا الملف أولًا، والمرجع البصري `docs/ui_templates/01-game-show.html`.
