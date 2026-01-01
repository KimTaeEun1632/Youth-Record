import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'user_service.dart';
import 'screens/episode_list_screen.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '청춘기록',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AuthGate(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('청춘기록')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Google로 로그인'),
          onPressed: () async {
            User? user = await AuthService.signInWithGoogle();

            if (user != null) {
              await UserService.createUserIfNotExists(user);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.displayName}님, 청춘기록에 오신 걸 환영해요 🌱'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
