import 'dart:convert';
import '../ConfigJH.dart';
import '../Components/UtilityJH.dart';
import 'package:flutter/material.dart';
import '../Components/GetBody.dart';
import '../Components/FileIo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userImg = "assets/images/DefaultProfile.png";
  bool _isLoading = true;
  String _userNickName = "준혁이형 후계자";
  String _userEmail = "baejh724@gmail.com";
  String _userAddr = "서울 강남구 봉은사 5길";

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
    return Scaffold(
      appBar: topBarDefault("회원정보 수정", "수정", "/mypage", "/mypage/profile/edit", context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20, //마진
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  //나중에 버튼으로 변경
                  child: Image.asset(
                    alignment: Alignment.center,
                    _userImg,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Container(
              height: 20,
            ), //Margin

            const Text(
              "회원정보",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            Container(
              height: 10,
            ), //Margin

            keyValueText("닉네임", _userNickName),
            keyValueText("이메일", _userEmail),
            keyValueText("주소", _userAddr),

            /************* 계정정보  *************/
            Container(
              height: 30,
            ), //Margin

            const Text(
              "계정 정보",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),

            Container(
              height: 10,
            ), //Margin
            //구분 선 두는겨
            profileNaviBar("비밀번호 변경", "/change/password", context),

            /************* 부가정보  *************/

            Container(
              height: 30,
            ), //Margin

            dividerBar(),
            grayTextButton("로그아웃", "/logout"),
            grayTextButton("회원탈퇴", "/delete"),
          ],
        ),
      ),
    );
  }
}
