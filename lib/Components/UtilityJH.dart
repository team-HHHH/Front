import 'package:flutter/material.dart';
import '../ConfigJH.dart';

// Custom GestureDetector with Row
Widget profileNaviBar(String text, String gotos) {
  return GestureDetector(
    onTap: () {
      debugPrint(gotos + "으로 이동");
    },
    child: Container(
      width: double.infinity, // 화면 가로 길이 전체
      height: 35, // 버튼 높이
      color: Colors.transparent, // 버튼 배경색 없음
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(GRAY),
            size: 14,
          )
        ],
      ),
    ),
  );
}

// Custom Divider
Widget dividerBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(1.0), // 구분선의 두께
    child: Divider(
      thickness: 1.0,
      height: 1.0,
      color: Colors.grey.shade300, // 구분선 색상
    ),
  );
}

AppBar topBar(String text, String gotoUrl) {
  return AppBar(
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0), // 구분선의 두께
      child: Divider(
        thickness: 1.0,
        height: 1.0,
        color: Colors.grey.shade300, // 구분선 색상
      ),
    ),
    leading: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Color(SSU_BLUE),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      IconButton(
          onPressed: () {
            debugPrint(gotoUrl);
          },
          icon: const Icon(Icons.search, color: Color(SSU_BLUE))),
      const SizedBox(width: 14),
    ],
  );
}
