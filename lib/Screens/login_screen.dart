import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_story.dart';
import 'package:scheduler/Components/apiHelper.dart';
import 'package:scheduler/Screens/register_detail_screen.dart';
import 'package:scheduler/Screens/register_screen.dart';

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
  void _handleLogin() async {
    final url = Uri.parse("users/login/custom");
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
    if (response.statusCode != 200) return;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    final resultMessage = responseData.getResultMessage();

    if (resultCode != 200) return;

    final isFirstLogin =
        responseData.getBodyValue("isFirstLogin").toString() == "true";
  }

  // Oauth 로그인 버튼 클릭 시
  void _handleOauthLogin(String sns) async {
    // 이 해시키를 카카오 플랫폼에 등록해야함.
    // print(await KakaoSdk.origin);

    (String, String)? info;
    info = (sns == "kakao") ? await _getKakaoInfo() : await _getGoogleInfo();
    if (info == null) return;

    final (email, userCode) = info;

    // Oauth 로그인 시도(이미 회원인가 확인)
    final isFirstLogin = await _tryOauthLogin(email, userCode);

    // 처음 로그인이라면? 회원가입해야함.
    if (isFirstLogin) {
      await _registerOauthInfo(email, userCode);
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => const RegisterDetailScreen()));
    }
  }

  Future<(String, String)?> _getKakaoInfo() async {
    // 카카오톡이 설치되어 있다면?
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {}
      }
      // 카카오톡 설치안되어 있다면?
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {}
    }

    try {
      User user = await UserApi.instance.me();

      final String email = user.kakaoAccount!.email!;
      final String userCode = user.id.toString();

      return (email, userCode);
    } catch (error) {}

    return null;
  }

  Future<bool> _tryOauthLogin(String email, String userCode) async {
    final url = Uri.parse("/users/login/oauth");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "loginId": "*$userCode",
          "password": email,
        },
      ),
    );
    if (response.statusCode != 200) return false;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    final resultMessage = responseData.getResultMessage();

    if (resultCode != 200) return false;

    final isFirstLogin =
        responseData.getBodyValue("isFirstLogin").toString() == "true";

    return isFirstLogin;
  }

  Future<void> _registerOauthInfo(String email, String userCode) async {
    final url = Uri.parse("/users/register");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "email": email,
          "id": userCode,
        },
      ),
    );
    if (response.statusCode != 200) return;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    final resultMessage = responseData.getResultMessage();

    if (resultCode != 200) return;

    final receivedEmail = responseData.getBodyValue("email").toString();
    final loginId = responseData.getBodyValue("loginId").toString();
    final password = responseData.getBodyValue("password").toString();
  }

  Future<(String, String)?> _getGoogleInfo() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final email = googleUser.email;
    final userCode = googleUser.id;
    return (email, userCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
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
                        // 아이디, 비밀번호 형식 검사 로직 추가 해야함.

                        _handleLogin();
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
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
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
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "SNS로 로그인 하기",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _handleOauthLogin("kakao");
                  },
                  icon: Image.asset("assets/images/kakao_login.png"),
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () {
                    _handleOauthLogin("google");
                  },
                  icon: Image.asset("assets/images/google_login.png"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
