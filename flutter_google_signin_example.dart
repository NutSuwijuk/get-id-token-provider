// Flutter Example: Google Sign-In - Get ID Token
// 
// วิธีใช้งาน:
// 1. เพิ่ม dependencies ใน pubspec.yaml:
//    dependencies:
//      google_sign_in: ^6.1.5
//      sign_in_with_apple: ^5.0.0
//
// 2. Setup Google Sign-In:
//    - ไปที่ Firebase Console > Authentication > Sign-in method
//    - Enable Google Sign-In
//    - ไปที่ Google Cloud Console เพื่อสร้าง OAuth 2.0 Client ID
//    - สำหรับ Android: ใช้ SHA-1 fingerprint
//    - สำหรับ iOS: ใช้ Bundle ID
//
// 3. Setup Apple Sign-In:
//    - ไปที่ Apple Developer Console
//    - สร้าง Service ID และ Key
//    - Configure ใน Firebase Console

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get ID Token Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? _idToken;
  String? _providerId;
  String? _errorMessage;

  // Google Sign-In Configuration
  // ต้องเปลี่ยนเป็น Client ID ของคุณ
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // สำหรับ Web: ใช้ clientId จาก Firebase Console
    // clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get ID Token Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🔐 Sign-In เพื่อดู ID Token',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            
            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 15),
            
            // Apple Sign-In Button (iOS only)
            if (Theme.of(context).platform == TargetPlatform.iOS)
              ElevatedButton.icon(
                onPressed: _signInWithApple,
                icon: const Icon(Icons.apple),
                label: const Text('Sign in with Apple'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            
            const SizedBox(height: 30),
            
            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '❌ Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            
            // ID Token Display
            if (_idToken != null) ...[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ ID Token:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      _idToken!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Provider: $_providerId',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Copy to clipboard
                        // Clipboard.setData(ClipboardData(text: _idToken));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Token copied to clipboard!'),
                          ),
                        );
                      },
                      child: const Text('📋 Copy Token'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Google Sign-In Function
  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _errorMessage = null;
        _idToken = null;
      });

      // เริ่มต้น Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // ผู้ใช้ยกเลิกการ login
        setState(() {
          _errorMessage = 'User cancelled the sign-in';
        });
        return;
      }

      // ดึง authentication details
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      // id_token มาจาก googleAuth.idToken
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        setState(() {
          _errorMessage = 'Failed to get ID token from Google';
        });
        return;
      }

      // Log id_token ออกมา
      developer.log('=== GOOGLE ID TOKEN ===');
      developer.log(idToken);
      developer.log('======================');
      print('=== GOOGLE ID TOKEN ===');
      print(idToken);
      print('======================');

      setState(() {
        _idToken = idToken;
        _providerId = 'google.com';
      });

      // แสดง Snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login สำเร็จ! ดู ID Token ด้านล่าง'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      developer.log('Google Sign-In Error: $error');
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }

  // Apple Sign-In Function (iOS only)
  Future<void> _signInWithApple() async {
    try {
      setState(() {
        _errorMessage = null;
        _idToken = null;
      });

      // เริ่มต้น Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // id_token มาจาก credential.identityToken
      // แต่ต้อง decode จาก base64 ก่อน
      final String? idToken = credential.identityToken;

      if (idToken == null) {
        setState(() {
          _errorMessage = 'Failed to get ID token from Apple';
        });
        return;
      }

      // Log id_token ออกมา
      developer.log('=== APPLE ID TOKEN ===');
      developer.log(idToken);
      developer.log('======================');
      print('=== APPLE ID TOKEN ===');
      print(idToken);
      print('======================');

      setState(() {
        _idToken = idToken;
        _providerId = 'apple.com';
      });

      // แสดง Snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login สำเร็จ! ดู ID Token ด้านล่าง'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      developer.log('Apple Sign-In Error: $error');
      setState(() {
        _errorMessage = 'Error: $error';
      });
    }
  }
}


