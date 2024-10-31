import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scheduler/Components/ApiHelper.dart';
import 'package:scheduler/Components/calanderTags.dart';
import 'package:scheduler/ConfigJH.dart';
import 'package:http/http.dart' as http;

class TagNode {
  final String title;
  final String context;
  final DateTime timeDetail;
  final int tag; //tag number 1:blue, 2:yellow, 3:green, 4:black, 5:red
  final int sid; //scheulder 고유id

  TagNode({
    required this.title,
    required this.context,
    required this.timeDetail,
    required this.tag,
    required this.sid,
  });
}

class CalanderController extends GetxController {
  int year = -1;
  int month = -1;
  int start = 0;
  int maxRow = 0;

  //Dummy Tag
  Map<String, List<TagNode>> tagMap = {};
  void setYear(int args) {
    year = args;
  }

  void setMonth(int args) {
    month = month;
  }

  CalanderController() {
    DateTime now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  List<List<int>> viewDays = [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
  ];

  //Tag 추가함수
  void addTag(TagNode adder) {
    // API 단에서 adder.sid 받아와서 추가할 것 -> mySQL에서 호출 및 API 설정 //

    print(adder);

    DateTime dt = adder.timeDetail;
    String key = '${dt.year}-${dt.month}-${dt.day}';
    print(key);
    // 리스트가 비어 있으면 해당 키 삭제
    if (tagMap.containsKey(key)) {
      tagMap[key]!.add(adder);
    } else {
      tagMap[key] = [adder];
    }
  }

  //Tag삭제함수
  void removeTag(int year, int month, int day, int sid) {
    String key = '${year}-${month}-${day}';
    // 해당 날짜에 리스트가 있는지 확인
    if (tagMap.containsKey(key)) {
      tagMap[key]!.removeWhere((node) => node.sid == sid);

      if (tagMap[key]!.isEmpty) {
        tagMap.remove(key);
      }
    }
  }

  //Calander 에 3개만 보여줄 Tag 리스트
  List<Container> retTagShortList(int day, double width, double height) {
    List<Container> li = [];
    String key = '${year}-${month}-${day}';
    if (tagMap.containsKey(key)) {
      List<TagNode>? tagList = tagMap[key];
      if (tagList != null) {
        for (int i = 0; i < tagMap[key]!.length && i < 3; i++) {
          int tagInfo = tagList[i].tag;
          switch (tagInfo) {
            case 1:
              li.add(BlueTag(tagList[i].title, width, height));
              break;
            case 2:
              li.add(YellowTag(tagList[i].title, width, height));
              break;
            case 3:
              li.add(GreenTag(tagList[i].title, width, height));
              break;
            case 4:
              li.add(BlackTag(tagList[i].title, width, height));
              break;
            case 5:
              li.add(RedTag(tagList[i].title, width, height));
              break;
          }
        }
      }
    }

    return li;
  }

  //test 함수
  void Dummy() {
    print("dummy 추가");
    TagNode blue = TagNode(
        title: "공모전A",
        context: "공모전이 좋습니다",
        timeDetail: DateTime(2024, 10, 5, 12),
        tag: 1,
        sid: 12);
    TagNode yellow = TagNode(
        title: "시험B",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 10, 5, 12),
        tag: 2,
        sid: 12);
    TagNode green = TagNode(
        title: "롤정글",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 10, 5, 12),
        tag: 3,
        sid: 12);
    TagNode black = TagNode(
        title: "롤대남",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 10, 12, 14),
        tag: 4,
        sid: 12);
    TagNode red = TagNode(
        title: "롤로노이",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 10, 20, 20),
        tag: 5,
        sid: 12);
    TagNode red2 = TagNode(
        title: "롤로노이2",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 10, 20, 20),
        tag: 5,
        sid: 12);
    TagNode red3 = TagNode(
        title: "결혼식?",
        context: "시험이 ㅈ 습니다",
        timeDetail: DateTime(2024, 11, 9, 20),
        tag: 5,
        sid: 12);

    addTag(blue);
    addTag(red);
    addTag(red2);
    addTag(green);
    addTag(yellow);
    addTag(black);
    addTag(red3);
  }

  void monthDown() {
    if (month == 1) {
      year--;
    }
    month--;
    if (month == 0) {
      month = 12;
    }
  }

  void monthUp() {
    if (month == 12) {
      year++;
    }
    month++;
    if (month == 13) {
      month = 1;
    }
  }

  void calCalender(int y, int m) {
    year = y;
    month = m;
    DateTime date = DateTime(year, month, 1);
    start = date.weekday % 7;
    int lastDay = 0;

    if (month == 2) {
      // 윤년인지 확인
      bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      lastDay = isLeapYear ? 29 : 28;
    } else {
      // 30일과 31일인 경우
      lastDay = [1, 3, 5, 7, 8, 10, 12].contains(month) ? 31 : 30;
    }

    print("$year 년 $month 월 lastday=$lastDay, start=$start");

    int row = 0, col = start;

    for (int i = 0; i < viewDays.length; i++) {
      for (int j = 0; j < viewDays[i].length; j++) {
        viewDays[i][j] = 0;
      }
    }

    for (int i = 1; i <= lastDay; i++) {
      viewDays[row][col] = i;
      col++;
      if (col == 7) {
        col = 0;
        row++;
      }
    }

    maxRow = col != 0 ? row + 1 : row;
    print("maxrow $maxRow\n");
  }
}
