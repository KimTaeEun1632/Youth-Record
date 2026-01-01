import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '청춘기록',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('지금 이 순간을 기록하세요', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 48),

              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Google로 로그인'),
                onPressed: () async {
                  try {
                    User? user = await AuthService.signInWithGoogle();

                    if (user != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('로그인 성공 🎉')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
