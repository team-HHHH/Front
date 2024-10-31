import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:scheduler/Components/ButtonContainer.dart';
import 'package:scheduler/Components/calanderTags.dart';
import 'package:scheduler/Controllers/calander_controller.dart';
import 'package:scheduler/Screens/profile_screen.dart';

import '../ConfigJH.dart';
import '../Components/UtilityJH.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalanderScreen extends StatefulWidget {
  const CalanderScreen({super.key});

  @override
  State<CalanderScreen> createState() => _CalanderScreenState();
}

class _CalanderScreenState extends State<CalanderScreen> {
  final List<String> weekdays = ["일", "월", "화", "수", "목", "금", "토"];
  final calanderCont = Get.put(CalanderController());

  List<List<int>> viewDays = [
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0],
  ];

  @override
  void initState() {
    super.initState();

    ///test
    calanderCont.Dummy();

    ///
    calanderCont.calCalender(calanderCont.year, calanderCont.month);
    setState(() {
      viewDays = calanderCont.viewDays;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double itemWidth = screenWidth / 8; // 너비를 화면의 1/8로 설정
    double dayHeight = screenHeight / 8;
    double WeekHeight = dayHeight / 3;

    void chgDate(int year, int month) {
      print("chgDate\n");
      calanderCont.calCalender(year, month);

      setState(() {
        year = calanderCont.year;
        month = calanderCont.month;
        viewDays = calanderCont.viewDays;
      });
    }

    return Scaffold(
      appBar: topBarDefault("Calander", "수정", const ProfileScreen()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20, //마진
            ),

            /// 2024년10월 V + part///
            Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*
                    IconButton(
                        icon: Icon(Icons.arrow_drop_down, size: 40),
                        color: SSU_BLUE,
                        onPressed: () {
                          //Popup
                          //calanderCont.monthUp();
                          chgDate(calanderCont.year, calanderCont.month);
                        }),
                    */
                    IconButton(
                        icon: Icon(Icons.arrow_left, size: 30),
                        color: SSU_BLUE,
                        onPressed: () {
                          calanderCont.monthDown();
                          chgDate(calanderCont.year, calanderCont.month);
                        }),
                    Text(
                      "${calanderCont.year.toString()}년 ${calanderCont.month.toString()}월",
                      style: const TextStyle(
                        fontSize: 24,
                        color: CALANDER_TEXT_GRAY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.arrow_right, size: 30),
                        color: SSU_BLUE,
                        onPressed: () {
                          calanderCont.monthUp();
                          chgDate(calanderCont.year, calanderCont.month);
                        }),
                    Container(
                      width: 10,
                    ),
                    const Spacer(), // Spacer를 사용하여 남은 공간을 차지
                    // + 아이콘을 오른쪽 끝에 배치
                    const Icon(
                      Icons.add, // + 아이콘
                      color: SSU_BLUE,
                      size: 25,
                    ),
                  ],
                )),

            Container(
              height: 20, //마진
            ),

            // 달력 {월, 화, 수, 목, 금, 토, 일} 부분..
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List<Widget>.generate(
                  weekdays.length,
                  (index) => Container(
                    width: itemWidth,
                    height: WeekHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: BORDER_GRAY, width: 1),
                      borderRadius: index == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(10),
                            )
                          : index == 6
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                )
                              : null,
                    ),
                    child: Center(
                      // 텍스트 중앙 정렬
                      child: Text(
                        weekdays[index], // weekdays 리스트에서 해당 index의 값을 가져옴
                        style: TextStyle(
                            color: index == 0
                                ? RED
                                : index == 6
                                    ? SSU_BLUE
                                    : CALANDER_TEXT_GRAY,
                            fontSize: 16,
                            fontWeight: FontWeight.bold), // 텍스트 스타일 정의
                      ),
                    ),
                  ),
                )
              ],
            ),

            /////////////////////진짜 달력 부분 ////////////////////
            ...List<Widget>.generate(
              calanderCont.maxRow,
              //calanderCont.viewDays.length,
              (row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List<Widget>.generate(
                      calanderCont.viewDays[row].length,
                      (col) => InkWell(
                            onTap: () => {},
                            child: Container(
                                width: itemWidth,
                                height: dayHeight,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: BORDER_GRAY, width: 1),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Text(
                                        "${calanderCont.viewDays[row][col] == 0 ? "" : calanderCont.viewDays[row][col]}",
                                        style: TextStyle(
                                            color: col == 0
                                                ? RED
                                                : col == 6
                                                    ? SSU_BLUE
                                                    : CALANDER_TEXT_GRAY,
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold), // 텍스트 스타일 정의
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ...calanderCont.retTagShortList(
                                              calanderCont.viewDays[row][col],
                                              itemWidth,
                                              dayHeight),
                                          /*
                                          BlueTag("공모전", itemWidth, dayHeight),
                                          GreenTag("공모전이 왔어요 왔어요", itemWidth,
                                              dayHeight),
                                          RedTag("긴급일정", itemWidth, dayHeight),
                                          */
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
