import 'dart:convert';
import 'package:scheduler/Components/ButtonContainer.dart';

import '../ConfigJH.dart';
import '../Components/UtilityJH.dart';
import '../Components/FileIo.dart';
import '../Components/GetBody.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  String _userImg = "assets/images/DefaultProfile.png";

  String _userNickName = "준혁이형 후계자";
  String _userEmail = "baejh724@gmail.com";
  String _userAddr = "서울 강남구 봉은사 5길";
  String _myAccess = "";
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>(); // Form 위젯을 위해 사용.
  final TextEditingController _newNicknameController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newAddressController = TextEditingController();


  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final myAccess = prefs.getString(ACCESS);

    final nickname = await getToken(NICKNAME);
    final email = await getToken(EMAIL);
    final address = await getToken(ADDRESS);

    print("${nickname}, ${email}, ${address}");
    setState(() {
      _userNickName = nickname.toString();
      _userEmail= email.toString();
      _userAddr = address.toString();
      _isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadData();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return Scaffold(
        appBar: topBarDefault("회원정보 수정", "수정", "/mypage/profile", "그러게", context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20, //마진
              ),
              Container(
                height: 40,
                child: const Text(
                  "회원정보",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlueButton(
                  controller: _newNicknameController,
                  hint_text: _userNickName,
                  context: context,
                  buttonName: "중복확인",
                  type1: "닉네임이 중복됩니다",
                  type2: "닉네임이 중복되지 않습니다"),
              BlueButton(
                  controller: _newEmailController,
                  hint_text: _userEmail,
                  context: context,
                  buttonName: "인증하기",
                  type1: "일치하지 않는 코드입니다",
                  type2: "인증에 성공하셨습니다"),
              grayInputLongWithSearch(
                  _newAddressController, _userAddr, context),

              /*** 제출 ****/
              Container(
                height: 20, //마진
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                  },
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
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
      );
    }  else {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Page'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

}
