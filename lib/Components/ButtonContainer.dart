import 'package:flutter/material.dart';
import './UtilityJH.dart';
import '../ConfigJH.dart';

class BlueButton extends StatefulWidget {
  final TextEditingController controller;
  final String hint_text;
  final BuildContext context;
  final String buttonName;
  final String type1;
  final String type2;

  BlueButton(
      {required this.controller,
      required this.hint_text,
      required this.context,
      required this.buttonName,
      required this.type1,
      required this.type2});

  @override
  _BlueButtonState createState() => _BlueButtonState();
}

class _BlueButtonState extends State<BlueButton> {
  int isCheck = 0; // 초기 상태

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            grayInput(widget.controller, widget.hint_text, widget.context),
            Container(
              width: MediaQuery.of(context).size.width * 0.02,
            ), //margin
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.23,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // 로직 추가
                    isCheck = (isCheck + 1) % 3;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(
                      color: Color(SSU_BLUE), // 버튼 테두리 색상
                      width: 1.0, // 버튼 테두리 두께
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.buttonName,
                    style: const TextStyle(
                        fontSize: 13, // 텍스트 크기
                        color: Color(SSU_BLUE)),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isCheck == 1)
          SizedBox(
              height: 30,
              child: Text(
                widget.type1,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ))
        else if (isCheck == 2)
          SizedBox(
            height: 30,
            child: Text(
              widget.type2,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          )
        else
          Container(
            height: 20,
          )
      ],
    );
  }
}
