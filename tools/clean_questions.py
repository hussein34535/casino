# -*- coding: utf-8 -*-
"""Round-1 automated cleanup for assets/*.json question files.

Passes:
  1) dedupe by normalized question (keep first) / dedupe words
  2) strip editorial parentheticals from answers
  3) multi-answer fields ("X / Y", "X أو Y") -> first answer
  4) delete entries whose answer is embedded in the question (self-answer)
  5) words: apply reversed-order map, fix misspellings, drop long/non-Arabic
  6) explicit FIX_ANSWER / FIX_QUESTION / DELETE lists (verified items only)

Usage: python tools/clean_questions.py [--dry]
"""
import json
import re
import sys
import unicodedata
from difflib import SequenceMatcher
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

DRY = "--dry" in sys.argv
ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets"

QA_FILES = {
    "questions_general.json": 2,
    "puzzle.json": 4,
    "movies_series.json": 4,
}

META_PAREN_KEYS = [
    "فوازير", "مثلاً", "مثلا", "يتغير", "يختلف", "حسب", "المرجح", "عادة",
    "لعل", "قد يكون", "يُحسب", "يحسب", "يعتمد", "في بعض", "بحسب",
    "المرجع", "أو ي", "لا يمكن", "احتيال", "بالنسبة", "كنسبة",
]


def norm_q(s: str) -> str:
    s = unicodedata.normalize("NFC", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def load(name: str):
    with open(ASSETS / name, encoding="utf-8") as f:
        return json.load(f)


def save(name: str, data, indent: int):
    if DRY:
        return
    with open(ASSETS / name, "w", encoding="utf-8", newline="\n") as f:
        json.dump(data, f, ensure_ascii=False, indent=indent)
        f.write("\n")


def strip_meta_parens(ans: str) -> str:
    def repl(m):
        inner = m.group(0)[1:-1]
        if any(k in inner for k in META_PAREN_KEYS):
            return ""
        return m.group(0)

    out = re.sub(r"\s*\([^()]*\)", repl, ans)
    out = re.sub(r"\s+", " ", out).strip()
    out = re.sub(r"\s+([،,.!؟])", r"\1", out)
    return out


def first_answer(ans: str) -> str:
    if " / " in ans:
        ans = ans.split(" / ")[0]
    elif "/" in ans and "٪" not in ans and not re.search(r"\d/\d", ans):
        parts = [p.strip() for p in ans.split("/") if p.strip()]
        if parts and all(len(p) <= 40 for p in parts):
            ans = parts[0]
    if " أو " in ans and len(ans) < 80:
        ans = ans.split(" أو ")[0]
    return ans.strip()


# ---------------------------------------------------------------- explicit --
# question-substring -> corrected answer (only verified corrections)
FIX_ANSWER = {
    "عملة فرنسا": "اليورو",
    "الحرب المئة": "116 سنة",
    "حرب المئة": "116 سنة",
    "خلية في جسم الإنسان": "حوالي 37 تريليون خلية",
    "الناتو": None,      # handled by rule below
    "أقمار زحل": "حوالي 274 قمراً",
    "أقمار أورانوس": "28 قمراً",
    # puzzle fixes
    "له ذيل وليس له رأس": "الإبرة والخيط",
    "كثر الحارس قل اللص": "الضوء",
}

FIX_QUESTION = {
    "في أي مدينة تقع مدينة كيوتو": "في أي بلد تقع مدينة كيوتو؟",
    "الحشرة التي تلسع بذيلها": "ما المفصليات التي تلسع بذيلها؟",
    "أطول عظمة في": "ما أطول عظمة في جسم الإنسان؟",
    "أطول سلسلة جبال": "ما أطول سلسلة جبال في العالم؟",
}

DELETE_SUBSTR = [
    # puzzle: broken / circular / self-answer (verified from reports)
    "أوله نار وآخره نار",
    "كلما زاد اتسخ",
    "لا يمكن أن تأكله على الإفطار",
    "الظل موجود في الضوء",
    "كلما زاد وزنه أصبح أخف",
    "يصوم ويصلي ولا يتحرك",
    "يصوم ويفطر في نفس الوقت",
    "أقل رؤية",
    # questions_general: broken premises
    "مدينة كيوتو" ,  # kept only if FIX_QUESTION applied -> re-add below
]

# restore: كيوتو should be fixed, not deleted
DELETE_SUBSTR = [d for d in DELETE_SUBSTR if d != "مدينة كيوتو"]

DELETE_IF_ANSWER_CONTAINS = [
    # editorial notes leaked into answers
    "في بعض الفوازير",
    "يتغير سنوياً",
    "ليست إجابة",
    "برنامج وليس مسلسل",
    "عادة ما يقولها",
]

NUMBER_RULES = [
    # (question substrings all-of, new answer)
    (["الناتو", "عدد"], "32 دولة"),
    (["أوبك", "عدد"], "12 دولة"),
    (["اليورو", "عدد"], "21 دولة"),
    (["كأس العالم", "فريق"], "48 فريقاً"),
    (["عملة", "فرنسا"], "اليورو"),
]

WORD_FIXES = {"عيي": "عي", "أخضر زاه": "أخضر زاهي"}
WORD_DELETE = {"مطفأ وغير"}

REVERSED_WORDS = {"صحيح خبر":"خبر صحيح","جيد عمل":"عمل جيد","سيئ تصرف":"تصرف سيئ","جميل منظر":"منظر جميل","قبيح شكل":"شكل قبيح","سعيد قلب":"قلب سعيد","حزين روح":"روح حزينة","قوي إيمان":"إيمان قوي","ضعيف جسم":"جسم ضعيف","كبير عقل":"عقل كبير","صغير عمر":"عمر صغير","طويل قامة":"قامة طويلة","قصير شعر":"شعر قصير","عريض كتف":"كف عريض","ضيق أفق":"أفق ضيق","سهل فهم":"سهل الفهم","صعب حل":"صعب الحل","بسيط تركيب":"تركيب بسيط","معقد مسألة":"مسألة معقدة","نظيف مكان":"مكان نظيف","متسخ ثوب":"ثوب متسخ","جديد فكرة":"فكرة جديدة","قديم زمن":"زمن قديم","سريع غضب":"سريع الغضب","بطيء حركة":"حركة بطيئة","مشرق وجه":"وجه مشرق","مظلم ليل":"ليل مظلم","ساخن جو":"جو ساخن","بارد ماء":"ماء بارد","هادئ طبع":"طبع هادئ","صاخب صوت":"صوت صاخب","مفتوح باب":"باب مفتوح","مغلق نافذة":"نافذة مغلقة","قريب مكان":"مكان قريب","بعيد مسافة":"مسافة بعيدة","آخر شهر":"شهر آخر","التالي قادم":"القادم التالي","السابق مضى":"الماضي السابق","مختلف رأي":"رأي مختلف","متشابه ألوان":"ألوان متشابهة","واضح كلام":"كلام واضح","غامض لغز":"لغز غامض","مفهوم درس":"درس مفهوم","مفيد علم":"علم مفيد","ضار صحة":"صحة ضارة","مهم أمر":"أمر مهم","ضروري حياة":"حياة ضرورية","اختياري قرار":"قرار اختياري","متاح خدمة":"خدمة متاحة","حقيقي قصة":"قصة حقيقية","خيالي عالم":"عالم خيالي","واقعي حل":"حل واقعي","عملي حل":"حل عملي","صادق قول":"قول صادق","أمين صندوق":"صندوق أمين","خائن وطن":"وطن خائن","صبور شخص":"شخص صبور","عجول طبع":"طبع عجول","حكيم شيخ":"شيخ حكيم","أحمق شخص":"شخص أحمق","شجاع مقدام":"مقدام شجاع","متواضع قلب":"قلب متواضع","شكور عبد":"عبد شكور","قنوع رزق":"رزق قنوع","عاصي أمر":"أمر عاصٍ","بريء شخص":"شخص بريء","عادل حكم":"حكم عادل","قاس قلب":"قلب قاسٍ","ودود شخص":"شخص ودود","عدواني سلوك":"سلوك عدواني","مشهور عالم":"عالم مشهور","مجهول هوية":"هوية مجهولة","غني نفس":"نفس غنية","فقير مال":"مال فقير","ضعيف بنية":"بنية ضعيفة","ذكي عقل":"عقل ذكي","غبي سؤال":"سؤال غبي","ناجح عمل":"عمل ناجح","فاشل دراسة":"دراسة فاشلة","مدبر أمور":"أمور مدبرة","موافق رأي":"رأي موافق","مقدم طلب":"طلب مقدَّم","مؤخر دفع":"دفع مؤجَّل","مكرر حدث":"حدث مكرر","عادي يوم":"يوم عادي","مميز شكل":"شكل مميز","رائع منظر":"منظر رائع","فظيع منظر":"منظر فظيع","عظيم شأن":"شأن عظيم","بشع منظر":"منظر بشع","جذاب منظر":"منظر جذاب","منفر طبع":"طبع منفر","مريح مكان":"مكان مريح","متعب جسد":"جسد متعب","مرهق ذهن":"ذهن مرهق","ممتع قراءة":"قراءة ممتعة","ممل حديث":"حديث ممل","مطمئن قلب":"قلب مطمئن","مخيف صوت":"صوت مخيف","مغامر روح":"روح مغامرة","حذر شخص":"شخص حذر","متفائل نظرة":"نظرة متفائلة","متشائم نظرة":"نظرة متشائمة","إيجابي تفكير":"تفكير إيجابي","سلبي شعور":"شعور سلبي","متسامح قلب":"قلب متسامح","منتقم شخص":"شخص منتقم","مستعد شخص":"شخص مستعد","جاهز أمر":"أمر جاهز","متردد شخص":"شخص متردد","مؤكد خبر":"خبر مؤكد","مستبعد فكرة":"فكرة مستبعدة","مقبول عرض":"عرض مقبول","مرفوض طلب":"طلب مرفوض","مسموح دخول":"دخول مسموح","ممنوع خروج":"خروج ممنوع","قانوني إجراء":"إجراء قانوني","شرعي عقد":"عقد شرعي","واجب أداء":"أداء واجب","مستحب فعل":"فعل مستحب","مباح أمر":"أمر مباح","مكروه شيء":"شيء مكروه","حرام مال":"مال حرام","محرم شيء":"شيء محرم","فاسد أخلاق":"أخلاق فاسدة","باطل عمل":"عمل باطل","ناقص شيء":"شيء ناقص","كامل عدد":"عدد كامل","مجزء أقسام":"أقسام مجزأة","منفصل مكان":"مكان منفصل","مختلف آراء":"آراء مختلفة","متناقض أقوال":"أقوال متناقضة","مباشر اتصال":"اتصال مباشر","صريح قول":"قول صريح","مبهم كلام":"كلام مبهم","واضح معنى":"معنى واضح","أساسي مبدأ":"مبدأ أساسي","فرعي طريق":"طريق فرعي","رئيسي دور":"دور رئيسي","ثانوي أهمية":"أهمية ثانوية","مهم دور":"دور مهم","هامشي تأثير":"تأثير هامشي","ضروري شيء":"شيء ضروري","أساسي قاعدة":"قاعدة أساسية","تكميلي جزء":"جزء تكميلي","احتياطي مخزون":"مخزون احتياطي","فعال دواء":"دواء فعال","نشيط عامل":"عامل نشيط","كسول طالب":"طالب كسول","جدي عمل":"عمل جدي","مازح طبع":"طبع مازح","مبتسم وجه":"وجه مبتسم","عبوس وجه":"وجه عابس","مضطرب حال":"حال مضطرب","خائف شخص":"شخص خائف","يائس شخص":"شخص يائس","ودود طبع":"طبع ودود","عدائي سلوك":"سلوك عدائي","كريم شخص":"شخص كريم","شحيح نفس":"نفس شحيحة","مغرور شخص":"شخص مغرور","جائر حاكم":"حاكم جائر","غليظ قلب":"قلب غليظ","كاذب شخص":"شخص كاذب","خائن صديق":"صديق خائن","مخلص نية":"نيّة مخلصة","انتهازي شخص":"شخص انتهازي","متعاون فريق":"فريق متعاون","أناني شخص":"شخص أناني","مسالم شعب":"شعب مسالم","متذمر شخص":"شخص متذمر","حاقد قلب":"قلب حاقد","وديع طفل":"طفل وديع","متوحش حيوان":"حيوان متوحش","لطيف ابتسامة":"ابتسامة لطيفة","فظ قول":"قول فظ","لين طبع":"طبع لين","خشن ملمس":"ملمس خشن","رقيق قلب":"قلب رقيق","سميك جلد":"جلد سميك","خفيف روح":"روح خفيفة","ثقيل وزن":"وزن ثقيل","ناعم حرير":"حرير ناعم","أملس سطح":"سطح أملس","متعرج طريق":"طريق متعرج","مستقيم خط":"خط مستقيم","منحني شكل":"شكل منحني","مسطح أرض":"أرض مسطحة","محدب عدسة":"عدسة محدبة","مقعر مرآة":"مرآة مقعرة","مستدير شكل":"شكل مستدير","مثلث شكل":"شكل مثلث","بيضاوي شكل":"شكل بيضاوي","لوزي عين":"عين لوزية","دائري حركة":"حركة دائرية","كروي شكل":"شكل كروي","مخروطي شكل":"شكل مخروطي","أسطواني شكل":"شكل أسطواني","هرمي بناء":"بناء هرمي","متوازي خطوط":"خطوط متوازية","متساوي أبعاد":"أبعاد متساوية","متطابق نسخة":"نسخة متطابقة","شفاف زجاج":"زجاج شفاف","معتم زجاج":"زجاج معتم","لامع سطح":"سطح لامع","براق نجم":"نجم براق","مطفي لون":"لون مطفي","ميت جسد":"جسد ميت","صاحي ذهن":"ذهن صاحي","يقظ ذهن":"ذهن يقظ","غافل قلب":"قلب غافل","واع شخص":"شخص واعٍ","فصيح لسان":"لسان فصيح","أعجم لسان":"لسان أعجمي","بليغ خطيب":"خطيب بليغ","منطقي تفكير":"تفكير منطقي","معقول حل":"حل معقول","مرغوب سلعة":"سلعة مرغوبة","منبوذ فكرة":"فكرة منبوذة","مطلوب سلعة":"سلعة مطلوبة","ناقص معلومات":"معلومات ناقصة","ظاهر علامة":"علامة ظاهرة","خفي سر":"سر خفي","موجود دليل":"دليل موجود","مفقود أثر":"أثر مفقود","نادر وجود":"نادر الوجود","كثير عدد":"عدد كبير","قليل كمية":"كمية قليلة","وفير رزق":"رزق وفير","غني مال":"مال غني","فقير حال":"حال فقير","ضعيف حجج":"حجج ضعيفة","صغير حجم":"حجم صغير","قصير وقت":"وقت قصير","ضيق صدر":"صدر ضيق","خفيف ظل":"ظل خفيف","خشن صوت":"صوت خشن","لامع ذهب":"ذهب لامع","باهت لون":"لون باهت","حار طعام":"طعام حار","جاف هواء":"هواء جاف","مبلل ثوب":"ثوب مبلل","قذر مكان":"مكان قذر","مرتب شكل":"شكل مرتب","فوضوي تفكير":"تفكير فوضوي","منظم عمل":"عمل منظم","عشوائي اختيار":"اختيار عشوائي","منتظم نبض":"نبض منتظم","معوج خط":"خط معوج","بارز عين":"عين بارزة","غائر خد":"خد غائر","حاد نصل":"نصل حاد","كليل ذهن":"ذهن كليل","مرنة مادة":"مادة مرنة","صلبة صخر":"صخر صلب","قوية عضلات":"عضلات قوية","هشة عظام":"عظام هشة","متينة بناء":"بناء متين","ضعيفة إضاءة":"إضاءة ضعيفة","قاس حاكم":"حاكم قاسٍ","مقبول منطق":"منطق مقبول","مرفوض عرض":"عرض مرفوض","مطلوب عمل":"عمل مطلوب","جميل روح":"روح جميلة","جذاب شخصية":"شخصية جذابة","حقير فعل":"فعل حقير","لئيم شخص":"شخص لئيم","شجاع قلب":"قلب شجاع","حكيم قول":"قول حكيم","أحمق تصرف":"تصرف أحمق","مغرور طبع":"طبع مغرور","مجهول سبب":"سبب مجهول","فاشل محاولة":"محاولة فاشلة","أناني قرار":"قرار أناني","معقد تركيب":"تركيب معقد","مركب أجزاء":"أجزاء مركبة","احتياطي وقت":"وقت احتياطي"}


def clean_qa(name: str, indent: int):
    data = load(name)
    n0 = len(data)
    stats = {"dup": 0, "self": 0, "meta": 0, "slash": 0, "delsub": 0, "delans": 0, "fix": 0, "fixq": 0, "num": 0}
    seen = {}
    out = []
    conflicts = []
    dropped_samples = []
    for item in data:
        q = norm_q(item.get("question", ""))
        a = norm_q(item.get("answer", ""))
        if not q or not a:
            stats["dup"] += 1
            continue
        key = q.lower().rstrip("?؟")
        if key in seen:
            stats["dup"] += 1
            if seen[key][1] != a:
                conflicts.append((q, seen[key][1], a))
            continue
        # fuzzy: same answer + very similar question -> duplicate phrasing
        fuzzy_hit = False
        for prev_q, prev_a in seen.values():
            if prev_a == a and len(a) >= 6:
                if SequenceMatcher(None, key, prev_q.lower().rstrip("?؟")).ratio() >= 0.72:
                    stats["dup"] += 1
                    fuzzy_hit = True
                    break
        if fuzzy_hit:
            continue

        # explicit fixes first (so delete checks see the corrected values)
        for k, v in FIX_ANSWER.items():
            if v is not None and k in q:
                a = v
                stats["fix"] += 1
                break
        for k, v in FIX_QUESTION.items():
            if k in q:
                q = v
                stats["fixq"] += 1
                break
        for subs, new_a in NUMBER_RULES:
            if all(s in q for s in subs) and any(w in a for w in ("فرنك", "ملايين", "30 دولة", "13 دولة", "20 دولة", "20 فريق")):
                a = new_a
                stats["num"] += 1
                break

        # explicit delete by question substring
        if any(d in q for d in DELETE_SUBSTR):
            stats["delsub"] += 1
            dropped_samples.append(f"delsub: {q[:60]}")
            continue
        if any(t in a for t in DELETE_IF_ANSWER_CONTAINS):
            stats["delans"] += 1
            dropped_samples.append(f"delans: {q[:60]} => {a[:40]}")
            continue

        a_orig = a

        # automated hygiene
        stripped = strip_meta_parens(a)
        if stripped != a:
            stats["meta"] += 1
            a = stripped
        first = first_answer(a)
        if first != a:
            stats["slash"] += 1
            a = first
        a = norm_q(a)

        # self-answer: answer embedded verbatim in question (word-boundary safe)
        # exception: "أيهم/أيما" either-or questions legitimately name both options
        either_or = bool(re.search(r"أيما|أيهم|أيها", q))
        if not either_or and len(a) >= 4 and re.search(
            rf"(?<![\u0600-\u06FF]){re.escape(a)}(?![\u0600-\u06FF])", q
        ):
            stats["self"] += 1
            dropped_samples.append(f"self: {q[:60]} => {a[:40]}")
            continue
        if not a:
            stats["self"] += 1
            continue

        seen[key] = (q, a)
        out.append({"question": q, "answer": a})

    save(name, out, indent)
    print(f"[{name}] {n0} -> {len(out)}  " + " ".join(f"{k}={v}" for k, v in stats.items()))
    if conflicts:
        print(f"  conflicts kept-first: {len(conflicts)}")
        for c in conflicts[:8]:
            print(f"    Q: {c[0][:70]} | kept={c[1][:30]} | dropped={c[2][:30]}")
    if dropped_samples:
        print(f"  self/meta-deleted samples ({len(dropped_samples)}):")
        for s in dropped_samples[:12]:
            print(f"    - {s}")
    return len(out)


def clean_words():
    name = "words_list.json"
    words = load(name)
    n0 = len(words)
    stats = {"dup": 0, "rev": 0, "fix": 0, "del": 0, "len": 0, "latin": 0}
    out = []
    seen = set()
    existing = {norm_q(w) for w in words}
    for w in words:
        w = norm_q(w)
        if w in WORD_DELETE or w in REVERSED_WORDS:
            if w in REVERSED_WORDS:
                corrected = REVERSED_WORDS[w]
                stats["rev"] += 1
                if corrected in existing:
                    stats["del"] += 1
                    continue
                w = corrected
            else:
                stats["del"] += 1
                continue
        if w in WORD_FIXES:
            w = WORD_FIXES[w]
            stats["fix"] += 1
        if len(w) > 14:
            stats["len"] += 1
            continue
        if re.search(r"[A-Za-z0-9]", w):
            stats["latin"] += 1
            continue
        if w in seen:
            stats["dup"] += 1
            continue
        seen.add(w)
        out.append(w)
    save(name, out, 2)
    print(f"[{name}] {n0} -> {len(out)}  " + " ".join(f"{k}={v}" for k, v in stats.items()))


def main():
    for name, indent in QA_FILES.items():
        clean_qa(name, indent)
    clean_words()
    if DRY:
        print("(dry run - nothing written)")


if __name__ == "__main__":
    main()
