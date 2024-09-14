import 'dart:convert';
import 'dart:io';
import '../Components/GetBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../ConfigJH.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form 위젯을 위해 사용.

  String _enteredId = "";
  String _enteredPassword = "";

  // 로그인 버튼 누를 시 수행.
  void handleLogin(BuildContext context) async {
    final url = Uri.parse("http://121.151.185.49:8080/users/login/custom");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "loginId": _enteredId,
          "password": _enteredPassword,
        },
      ),
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // result 객체 추출
      final Map<String, dynamic> result = responseData['result'];
      final int resultCode = result['resultCode'];
      final String resultMessage = result['resultMessage'];

      print("debug :: ${responseData}");
      // body 객체 추출
      final Map<String, dynamic> body = getBody(responseData);

      final headers = response.headers;
      final accessToken = headers["authorization"];
      final refreshToken = headers["refresh"];

      print("access : ${accessToken}");
      print("refresh : ${refreshToken}");
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ACCESS, accessToken.toString());
      await prefs.setString(REFRESH, refreshToken.toString());

      Navigator.pushNamed(context, "/mypage");
    }
    else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // 구분선의 두께
          child: Divider(
            thickness: 1.0,
            height: 1.0,
            color: Colors.grey.shade300, // 구분선 색상
          ),
        ),
        title: const Text(
          "로그인",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "귀찮은 포스터 요약은",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "혁혁호형",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      onSaved: (newValue) {
                        _enteredId = newValue!;
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: "아이디",
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Colors.grey), // 비활성화 상태의 테두리 색상
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.grey) // 활성화 상태의 테두리 색상
                            ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ), // 포커스 상태에서 테두리 색상
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      onSaved: (newValue) {
                        _enteredPassword = newValue!;
                      },
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: "비밀번호",
                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                              color: Colors.grey), // 비활성화 상태의 테두리 색상
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: Colors.grey) // 활성화 상태의 테두리 색상
                            ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ), // 포커스 상태에서 테두리 색상
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        handleLogin(context);
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    "아이디 찾기",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {},
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    "비밀번호 찾기",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
