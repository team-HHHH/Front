import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_story.dart';
import 'package:scheduler/Screens/login_screen.dart';
import 'package:scheduler/Screens/register_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '1e183dbd3fe27b83dd4f6c01898a258f',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  var isDetailRegisterFinished = false;

  void _checkRegisterFinish() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? nickname = prefs.getString("nickname");

    if (nickname == null) {
      final url = Uri.http("localhost:8080", "/users/register");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, String>{
            "nickname": nickname!,
          },
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // result 객체 추출
        final Map<String, dynamic> result = responseData['result'];
        final String resultMessage = result['resultMessage'];
        // body 객체 추출
        final Map<String, dynamic> body = responseData['body'];
        if (resultMessage == "닉네임 존재") {
          isDetailRegisterFinished = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 96, 193, 195),
        useMaterial3: true,
      ),
      home: isDetailRegisterFinished
          ? const LoginScreen()
          : const RegisterDetailScreen(),
      //home: const MypageScreen(),
      //home: const ProfileScreen(),
      //home: const ProfileEditScreen(),
      //home: const PasswordEditScreen(),
    );
  }
}
