# ตัวอย่างโค้ดสำหรับ Get ID Token

ตัวอย่างโค้ดสำหรับ log `id_token` ออกมาจาก Google Sign-In และ Apple Sign-In

## 📋 สารบัญ

1. [Web (HTML/JavaScript) - แนะนำ](#web-htmljavascript---แนะนำ)
2. [Flutter](#flutter)

---

## 🌐 Web (HTML/JavaScript) - แนะนำ

**ง่ายที่สุด!** แค่เปิดไฟล์ HTML ใน browser ได้เลย

### วิธีใช้งาน:

1. **เปิดไฟล์ `web-google-signin.html`** ใน browser
2. **แก้ไข Google Client ID:**
   - ไปที่ Firebase Console > Project Settings > General
   - คัดลอก Web Client ID
   - วางในไฟล์ HTML: `const GOOGLE_CLIENT_ID = 'YOUR_CLIENT_ID';`

3. **กดปุ่ม "Sign in with Google"**
4. **ดู id_token ใน Console และบนหน้าเว็บ**

### ข้อดี:
- ✅ ไม่ต้อง setup project
- ✅ เปิดได้ทันทีใน browser
- ✅ เหมาะสำหรับการทดสอบ
- ✅ เห็นผลลัพธ์ทันที

### ข้อเสีย:
- ❌ Apple Sign-In ต้อง setup มากกว่า (ต้องมี Service ID)

---

## 📱 Flutter

### วิธีใช้งาน:

1. **สร้าง Flutter Project:**
```bash
flutter create get_id_token_example
cd get_id_token_example
```

2. **เพิ่ม Dependencies ใน `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_sign_in: ^6.1.5
  sign_in_with_apple: ^5.0.0
```

3. **Setup Google Sign-In:**

   **Android:**
   - ไปที่ Firebase Console > Project Settings > Your apps
   - Download `google-services.json` วางใน `android/app/`
   - ไปที่ Google Cloud Console เพื่อสร้าง OAuth 2.0 Client ID
   - ใช้ SHA-1 fingerprint (หาได้จาก: `keytool -list -v -keystore ~/.android/debug.keystore`)

   **iOS:**
   - ไปที่ Firebase Console > Project Settings > Your apps
   - Download `GoogleService-Info.plist` วางใน `ios/Runner/`
   - ไปที่ Google Cloud Console เพื่อสร้าง OAuth 2.0 Client ID
   - ใช้ Bundle ID ของคุณ

4. **Copy ไฟล์ `flutter_google_signin_example.dart`** ไปแทน `lib/main.dart`

5. **Run:**
```bash
flutter pub get
flutter run
```

### ข้อดี:
- ✅ เหมาะสำหรับ Mobile App
- ✅ รองรับทั้ง Android และ iOS
- ✅ UI สวยงาม

### ข้อเสีย:
- ❌ ต้อง setup project มากกว่า
- ❌ ต้อง configure OAuth credentials
- ❌ ต้อง build/compile

---

## 🔍 วิธีหา ID Token

### Google Sign-In:

**Web:**
```javascript
// id_token มาจาก response.credential
const idToken = response.credential;
console.log('ID Token:', idToken);
```

**Flutter:**
```dart
final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
final String? idToken = googleAuth.idToken;
print('ID Token: $idToken');
```

### Apple Sign-In:

**Web:**
```javascript
// id_token มาจาก response.id_token
const idToken = response.id_token;
console.log('ID Token:', idToken);
```

**Flutter:**
```dart
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
);
final String? idToken = credential.identityToken;
print('ID Token: $idToken');
```

---

## 📝 หมายเหตุ

1. **Google Client ID:** หาได้จาก Firebase Console > Project Settings > General > Your apps > Web app
2. **Apple Service ID:** ต้องสร้างใน Apple Developer Console
3. **id_token** จะถูก log ออกมาใน:
   - Browser Console (F12) สำหรับ Web
   - Flutter Console/Debug สำหรับ Flutter
4. **id_token** ใช้ได้ครั้งเดียวและมีอายุจำกัด (ประมาณ 1 ชั่วโมง)

---

## 🚀 การใช้งาน id_token กับ Backend API

หลังจากได้ `id_token` แล้ว สามารถใช้กับ Backend API ได้:

```bash
curl -X POST http://localhost:3000/api/session/auth/link-standard \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_SESSION_TOKEN" \
  -d '{
    "id_token": "YOUR_ID_TOKEN_FROM_GOOGLE_OR_APPLE",
    "provider_id": "google.com"
  }'
```

---

## ❓ FAQ

**Q: Web หรือ Flutter ง่ายกว่ากัน?**  
A: **Web ง่ายกว่า** เพราะไม่ต้อง setup project หรือ build ใดๆ แค่เปิดไฟล์ HTML ใน browser

**Q: ต้องมี Firebase Project ไหม?**  
A: ใช่ ต้องมี Firebase Project และ configure Google Sign-In ใน Firebase Console

**Q: id_token ใช้ได้นานแค่ไหน?**  
A: โดยปกติใช้ได้ประมาณ 1 ชั่วโมง หลังจากนั้นต้อง login ใหม่

**Q: ใช้ id_token กับ Backend API ได้เลยไหม?**  
A: ได้ แต่ต้องมี Session Token ด้วย (ได้จาก login ผ่านระบบปกติ)


