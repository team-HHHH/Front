import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scheduler/Components/apiHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDetailScreen extends StatefulWidget {
  const RegisterDetailScreen({super.key});

  @override
  State<RegisterDetailScreen> createState() => _RegisterDetailScreenState();
}

class _RegisterDetailScreenState extends State<RegisterDetailScreen> {
  String _enteredNickName = "";
  bool? _validNickName;

  void _handleNickNameCheck() async {
    final url = Uri.http("localhost:8080", "users/check/nickname");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "nickname": _enteredNickName,
        },
      ),
    );
    if (response.statusCode != 200) return;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    final resultMessage = responseData.getResultMessage();

    if (resultCode != 200) return;
    final isDuplicated =
        responseData.getBodyValue("duplicated").toString() == "true";

    _validNickName = isDuplicated;
  }

  // 회원가입 완료하기 버튼 터치 시
  void _handleRegister() async {
    // if (_validNickName == null || !_validNickName!) return;
    final url = Uri.http("localhost:8080", "users/register-detailed");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "nickname": _enteredNickName,
          "address": "",
          "profileImg": "",
        },
      ),
    );
    if (response.statusCode == 200) return;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    final resultMessage = responseData.getResultMessage();

    if (resultCode != 200) return;

    // 로컬 DB에 닉네임 저장
    _saveNickname(_enteredNickName);

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _saveNickname(String nickname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("nickname", nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: TextButton(
            onPressed: () {
              //_formKey.currentState!.save();
              // 아이디, 비밀번호 형식 검사 로직 추가 해야함.
              _handleRegister();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "회원가입 완료하기",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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
          "회원가입",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "더욱 자세한 정보 제공을 위해",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "정보를 입력해주세요!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "세부 정보 입력",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          _enteredNickName = value;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "활동할 닉네임을 입력하세요.",
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 0, 0, 5),
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          "중복확인",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_validNickName == null)
                const SizedBox(height: 20)
              else
                SizedBox(
                  height: 20,
                  child: Text(
                    _validNickName!
                        ? "      사용가능한 닉네임입니다."
                        : "      이미 존재하는 닉네임입니다.",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
