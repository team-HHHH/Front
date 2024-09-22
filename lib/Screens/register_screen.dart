import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scheduler/Components/apiHelper.dart';
import 'package:scheduler/Screens/register_detail_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Form 위젯을 위해 사용.

  // 이메일 인증 코드를 받음?
  final bool _isReceivedCode = false;

  // 중복된 아이디임?
  bool? _isDuplicatedId;
  bool? _validCode;
  String _enteredId = "";

  String _enteredPassword = "";

  String _enteredEmail = "";

  String _enteredCode = "";

  final bool _validId = false;
  bool? _validPassword;
  bool _validEmail = false;

  // ID 중복체크 버튼 터치 시
  void _handleCheckId() async {
    final url = Uri.http("localhost:8080", "users/check/id");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "loginId": _enteredId,
        },
      ),
    );
    if (response.statusCode == 200) return;
    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();
    if (resultCode != 200) return;

    final resultMessage = responseData.getResultMessage();
    final isDuplicated =
        responseData.getBodyValue("duplicated").toString() == "true";

    _isDuplicatedId = isDuplicated;
    setState(() {});
  }

  bool _handleEmailFormatCheck(String email) {
    // 정규식 패턴 정의 (일반적인 이메일 형식에 맞춤)
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Email 인증하기 버튼 터치 시
  void _handleReciveCode() async {
    final url = Uri.http("localhost:8080", "users/check/email");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "email": _enteredEmail,
        },
      ),
    );
    if (response.statusCode == 200) return;

    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();

    if (resultCode != 200) return;

    final resultMessage = responseData.getResultMessage();
    final isDuplicated =
        responseData.getBodyValue("duplicated").toString() == "true";

    if (isDuplicated) return; // 이미 존재하는 이메일
    setState(() {});
  }

  // Email 인증 버튼 터치 시
  void _handleCheckCode() async {
    final url = Uri.http("localhost:8080", "users/check/emailcode");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "email": _enteredEmail,
          "emailcode": _enteredCode,
        },
      ),
    );
    if (response.statusCode != 200) return;
    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();

    if (resultCode != 200) return;

    final resultMessage = responseData.getResultMessage();
    final isCorrectCode =
        responseData.getBodyValue("codeCorrect").toString() == "true";

    _validCode = isCorrectCode;

    setState() {}
  }

  // 계속하기 버튼 터치 시
  void _handleNext() async {
    //if (!_validEmail || !_validId || !_validPassword!) return;

    final url = Uri.http("localhost:8080", "/users/register");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          "email": _enteredEmail,
          "loginId": _enteredId,
          "password": _enteredPassword,
        },
      ),
    );
    if (response.statusCode != 200) return;
    final responseData = ApiHelper(response.body);
    final resultCode = responseData.getResultCode();

    if (resultCode != 200) return;

    final resultMessage = responseData.getResultMessage();
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => const RegisterDetailScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              _handleNext();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "계속하기",
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
                "로그인 정보 입력",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 14),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
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
                                hintText: "아이디를 입력하세요.",
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
                              onPressed: () {
                                //_formKey.currentState!.save();
                                _handleCheckId();
                              },
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
                    if (_isDuplicatedId == null)
                      const SizedBox(height: 20)
                    else
                      SizedBox(
                        height: 20,
                        child: Text(
                          _isDuplicatedId!
                              ? "    중복된 아이디입니다."
                              : "    사용가능한 아이디입니다.",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          _enteredPassword = value;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: "비밀번호를 입력하세요.",
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
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          _validPassword = (_enteredPassword == value);
                          setState(() {});
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: "비밀번호를 한번 더 입력하세요.",
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
                    SizedBox(
                      height: 20,
                      child: Text(
                        _validPassword == null
                            ? ""
                            : (_validPassword! ? "" : "    동일한 비밀번호를 입력하세요."),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              onChanged: (value) {
                                _enteredEmail = value;
                                _validEmail = _handleEmailFormatCheck(value);
                                setState(() {});
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "이메일 주소를 입력하세요.",
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
                              onPressed: () {
                                _formKey.currentState!.save();
                                _handleReciveCode();
                                // 중복확인 로직 검사
                              },
                              style: TextButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              child: const Text(
                                "인증하기",
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
                    SizedBox(
                      height: 20,
                      child: Text(
                        _validEmail == null
                            ? ""
                            : (_validEmail ? "" : "    올바른 이메일 형식을 입력하세요."),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    _isReceivedCode
                        ? Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    // onSaved: (newValue) {
                                    //   _enteredCode = newValue!;
                                    // },
                                    onChanged: (value) {
                                      _enteredCode = value;
                                      setState(() {});
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "6자리 코드를 입력하세요.",
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          15, 0, 0, 5),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            color:
                                                Colors.grey), // 비활성화 상태의 테두리 색상
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          borderSide: const BorderSide(
                                              color:
                                                  Colors.grey) // 활성화 상태의 테두리 색상
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
                                    onPressed: () {
                                      _formKey.currentState!.save();
                                      _handleCheckCode();
                                      // 중복확인 로직 검사
                                    },
                                    style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                    child: const Text(
                                      "인증",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "서비스 이용약관 동의",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "이용약관 전체 동의",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "[필수] 만 14세 이상입니다.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "[필수] 이용약관 동의",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "[필수] 개인정보 수집 및 이용 동의",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "[선택] 광고성 정보 수신 / 마케팅 활용 동의",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
