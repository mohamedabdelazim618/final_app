# حصن المسلم - تطبيق أذكار المسلم

تطبيق Flutter جميل لأذكار وأدعية المسلم من كتاب حصن المسلم، مع بيانات مباشرة من hisnmuslim.com

---

## ✨ المميزات

- 📖 **133+ فئة من الأذكار** — مستوردة مباشرة من API حصن المسلم
- 🌅 **وصول سريع** للأذكار المشهورة (الصباح، المساء، النوم، الصلاة)
- 🔍 **بحث فوري** في جميع الأذكار
- 🎵 **تشغيل صوتي** لكل ذكر من مصدره الأصيل
- 📿 **سبحة إلكترونية** مع عداد واهتزاز
- ❤️ **المفضلة** — احفظ الأذكار التي تحبها
- 📋 **نسخ النص** بضغطة واحدة
- 🌙 **الوضع الليلي / النهاري** مع حفظ التفضيل
- ✅ **عداد التكرار** — نقاط تفاعلية لكل ذكر متعدد التكرار
- 🎨 **تصميم عربي جميل** بخط Scheherazade New وCairo

---

## 🚀 تشغيل التطبيق

### المتطلبات
- Flutter SDK 3.0.0 أو أحدث
- Dart 3.0.0 أو أحدث
- Android Studio أو VS Code

### الخطوات

```bash
# 1. استنساخ أو فك ضغط المشروع
cd athkar_app

# 2. تثبيت الحزم
flutter pub get

# 3. تشغيل التطبيق
flutter run
```

### بناء APK للـ Android

```bash
flutter build apk --release
```

### بناء للـ iOS

```bash
flutter build ipa --release
```

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                  # نقطة الدخول + شاشة البداية
├── theme/
│   └── app_theme.dart         # ألوان وخطوط التطبيق
├── models/
│   ├── category.dart          # نموذج فئة الأذكار
│   └── dhikr.dart             # نموذج الذكر الواحد
├── services/
│   ├── api_service.dart       # خدمة API حصن المسلم
│   └── app_state.dart         # حالة التطبيق (Provider)
├── screens/
│   ├── home_screen.dart       # الشاشة الرئيسية
│   ├── athkar_screen.dart     # شاشة عرض الأذكار
│   ├── favorites_screen.dart  # شاشة المفضلة
│   └── tasbih_screen.dart     # شاشة السبحة الإلكترونية
└── widgets/
    ├── category_card.dart     # بطاقة فئة الأذكار
    ├── dhikr_card.dart        # بطاقة الذكر الواحد
    └── shimmer_loader.dart    # مؤشر التحميل
```

---

## 🔌 مصدر البيانات

البيانات مستوردة مباشرة من:
- **API الرئيسي:** `http://www.hisnmuslim.com/api/ar/husn_ar.json`
- **نصوص الأذكار:** `http://www.hisnmuslim.com/api/ar/{id}.json`
- **الصوتيات:** `http://www.hisnmuslim.com/audio/ar/{id}.mp3`

---

## 📦 الحزم المستخدمة

| الحزمة | الغرض |
|--------|--------|
| `provider` | إدارة الحالة |
| `http` | طلبات API |
| `shared_preferences` | حفظ التفضيلات محلياً |
| `google_fonts` | خطوط Cairo و Scheherazade New |
| `flutter_animate` | تأثيرات الحركة |
| `audioplayers` | تشغيل الصوتيات |
| `shimmer` | تأثير التحميل |

---

## 🎨 الشاشات

1. **Splash Screen** — شاشة بداية متحركة
2. **Home Screen** — قائمة بالأذكار + بحث + وصول سريع
3. **Athkar Screen** — عرض أذكار الفئة مع تشغيل الصوت
4. **Favorites Screen** — الأذكار المفضلة
5. **Tasbih Screen** — سبحة إلكترونية تفاعلية
