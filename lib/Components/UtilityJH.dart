import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ConfigJH.dart';
import './Webview.dart';

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

AppBar topBarDefault(String text, String buttonName, String gotoUrl) {
  return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0), // 구분선의 두께
        child: Divider(
          thickness: 1.0,
          height: 1.0,
          color: Colors.grey.shade300, // 구분선 색상
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.arrow_back,
          size: 20,
          color: Color(SSU_BLUE),
        ),
      ),
      title: Text(text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )),
      actions: <Widget>[
        TextButton(
            onPressed: () {},
            child: Text(
              buttonName,
              style: const TextStyle(
                color: Color(SSU_BLUE),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            )),
      ]);
}

Widget keyValueText(String key, String value) {
  return SizedBox(
    height: 30,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        key,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          color: Color(GRAY),
          fontWeight: FontWeight.normal,
        ),
      )
    ]),
  );
}

Widget grayTextButton(String name, String url) {
  return SizedBox(
    height: 35,
    child: TextButton(
      onPressed: () {
        debugPrint(url);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(0, 0),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 13, // 폰트 크기
          color: Color(GRAY), // 텍스트 색상
        ),
      ),
    ),
  );
}

Widget grayInputLong(TextEditingController controller, String hintText,
    BuildContext context, bool passwd) {
  return Container(
      //width: double.infinity,
      width: MediaQuery.of(context).size.width * 0.9,
      height: 40,
      child: TextFormField(
          obscureText: passwd,
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Colors.grey), // 비활성화 상태의 테두리 색상
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Colors.grey) // 활성화 상태의 테두리 색상
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ), // 포커스 상태에서 테두리 색상
              ))));
}

Widget grayInputLongWithSearch(
    TextEditingController controller, String hintText, BuildContext context) {
  return Container(
      //width: double.infinity,
      width: MediaQuery.of(context).size.width * 0.9,
      height: 40,
      child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Colors.grey), // 비활성화 상태의 테두리 색상
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Colors.grey) // 활성화 상태의 테두리 색상
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ), // 포커스 상태에서 테두리 색상
              ),
              suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Color(SSU_BLUE),
                  ),
                  onPressed: () {
                    debugPrint("web view");
                    //showAddressSearchDialog(context);
                  }))));
}

Widget grayInput(
    TextEditingController controller, String hintText, BuildContext context) {
  return Container(
      //width: double.infinity,
      width: MediaQuery.of(context).size.width * 0.6,
      height: 40,
      child: TextFormField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide:
                  const BorderSide(color: Colors.grey), // 비활성화 상태의 테두리 색상
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:
                    const BorderSide(color: Colors.grey) // 활성화 상태의 테두리 색상
                ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ), // 포커스 상태에서 테두리 색상
            ),
          )));
}
