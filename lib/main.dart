import 'package:flutter/material.dart';
import 'package:scheduler/Screens/login_screen.dart';
import 'package:scheduler/Screens/mypage_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 96, 193, 195),
        useMaterial3: true,
      ),
      //home: const LoginScreen(),
      home: const MypageScreen(),
    );
  }
}
