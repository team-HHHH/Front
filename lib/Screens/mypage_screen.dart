import 'dart:convert';
import '../ConfigJH.dart';
import '../Components/UtilityJH.dart';
import '../Components/GetBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Components/FileIo.dart';


class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  String _userImg = "assets/images/DefaultProfile.png";
  String _userNickName = "준혁이형 후계자";
  String _userEmail = "baejh724@gmail.com";
  bool _isLoading = true; // 로딩 상태를 관리하는 변수
  String? _myAccess;

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final myAccess = prefs.getString(ACCESS);
    setState(() {
      _myAccess = myAccess.toString();
      _isLoading = false; // 데이터 로딩 완료
    });

    final uri = Uri.parse("http://121.151.185.49:8080/users");
    final response = await http.get(
      uri,
      headers: {
        'Authorization': _myAccess.toString(),
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final Map<String, dynamic> result = responseData['result'];
      final int resultCode = result['resultCode'];
      final String resultMessage = result['resultMessage'];

      final Map<String, dynamic> body = getBody(responseData);
      print("debug :: -> ${body}");

      saveToken(NICKNAME, body["nickname"]);
      saveToken(LOGINID, body["loginId"]);
      saveToken(ADDRESS, body["address"]);
      saveToken(EMAIL, body["email"]);
      saveToken(PROFILEIMG, body["profileImg"]);

      final userImg = await getToken(PROFILEIMG);
      final userNickName = await getToken(NICKNAME);
      final userEmail = await getToken(EMAIL);

      setState(() {
          _userImg = userImg.toString();
          _userEmail = userEmail.toString();
          _userNickName = userNickName.toString();
      });
    }
    else {
      print("연결 실패");
    }
  }

  void test() async {
    final prefs = await SharedPreferences.getInstance();

    final name = await getToken(NICKNAME);
    final email = await getToken(EMAIL);
    final pfile = await getToken(PROFILEIMG);

    print(name.toString());
    setState(() {
      _userImg = pfile.toString();
      _userEmail = email.toString();
      _userNickName = name.toString();
    });

  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // 데이터 로딩 중일 때 로딩 인디케이터 표시
      return Scaffold(
        appBar: AppBar(
          title: Text('My Page'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        appBar: topBar("마이페이지", "준혁이형 뭐하노 url"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //버튼 1
              GestureDetector(
                onTap: () async {
                  print("버튼이 클릭되었습니다!");
                  Navigator.pushNamed(context, "/mypage/profile");
                  // 클릭 시 동작할 코드
                },
                child: Container(
                  width: double.infinity, // 화면 가로 길이 전체
                  height: 100, // 버튼 높이
                  color: Colors.transparent, // 버튼 배경색 없음
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(_userImg, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center, //중앙 배치
                        crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                        children: [
                          Text(
                            _userNickName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _userEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(GRAY),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(SSU_BLUE),
                      )
                    ],
                  ),
                ),
              ),

              //구분 선 두는겨
              PreferredSize(
                preferredSize: const Size.fromHeight(1.0), // 구분선의 두께
                child: Divider(
                  thickness: 1.0,
                  height: 1.0,
                  color: Colors.grey.shade300, // 구분선 색상
                ),
              ),
              Container(
                height: 30,
              ),
              const Text(
                "주요 기능",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Container(
                height: 5,
              ),
              profileNaviBar("내 포스터 관리", "/myposter", context),
              profileNaviBar("유사 포스터 찾기", "/likeposter", context),
              profileNaviBar("주변 포스터 구경하기", "/otherposter", context),
              profileNaviBar("찜 포스터 목록들", "/mylover", context),
              dividerBar(),
              //GestureDetector(),
              //GestureDetector(),
              //GestureDetector(),
            ],
          ),
        ),
      );
    }
  }
}
