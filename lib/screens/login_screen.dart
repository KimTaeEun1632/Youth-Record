import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// 🖼️ Hero Image + Comic Card
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Stack(
                    children: [
                      /// Back card
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEE8C2B).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),

                      /// Main card
                      Container(
                        height: 420,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 24,
                              offset: Offset(0, 12),
                              color: Colors.black12,
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDUqkOaKEJBALrE2CkHimEmhSyaL-euntpybTiZsctaNQHSR-htL5JCPgEuvL_uK1A0YmhtRXbds6YOGHixJqoeadhLstPrFfWBo7Fejkwl6W53hrjazcPlsUw_TClJ9ZqLIqXws2pvf9s_TWIyipWwZtX6JOEjBirt3852c-higUbazgI0qfVc23f6KuUB-Nay5lm9JlPj8CM-T5_GQweXpxjzGx28Wylddg0YU--ixt4n4NJ3213j_02t6UWr5RCSKwxhwYzEdXIf',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black26, Colors.transparent],
                            ),
                          ),
                        ),
                      ),

                      /// START badge
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Transform.rotate(
                          angle: 0.1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(blurRadius: 8, color: Colors.black12),
                              ],
                            ),
                            child: const Text(
                              'START!',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFEE8C2B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 📝 Title & Description
            const SizedBox(height: 16),
            const Text(
              '청춘기록',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B140D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '너의 모든 순간이 만화가 된다.\n오늘 하루를 한 컷으로 남겨보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF6F665F),
              ),
            ),

            const SizedBox(height: 32),

            /// 🔘 Google Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE8C2B),
                    shape: const StadiumBorder(),
                    elevation: 6,
                  ),
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
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: const [
                      Icon(Icons.login),
                      Text(
                        '청춘기록 시작하기',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Secondary text
            TextButton(
              onPressed: () {},
              child: const Text(
                '이미 계정이 있나요? 로그인',
                style: TextStyle(color: Color(0xFF6F665F)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
