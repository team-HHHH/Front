import 'dart:typed_data';
import 'dart:ui'; // BackdropFilter를 사용하기 위해 추가

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _controller = DocumentScannerController();
  var isTaked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DocumentScanner(
              controller: _controller,
              onSave: (Uint8List imageBytes) {
                print("image bytes : $imageBytes");
              },
              takePhotoDocumentStyle: const TakePhotoDocumentStyle(
                top: 60,
                bottom: 60,
                left: 60,
                right: 60,
                hideDefaultButtonTakePicture: true,
              ),
              cropPhotoDocumentStyle: const CropPhotoDocumentStyle(
                  textButtonSave: "자르기", hideAppBarDefault: true),
              generalStyles: const GeneralStyles(
                hideDefaultDialogs: true,
                baseColor: Colors.black,
                hideDefaultBottomNavigation: true,
              ),
              editPhotoDocumentStyle: const EditPhotoDocumentStyle(
                hideAppBarDefault: true,
                hideBottomBarDefault: true,
                textButtonSave: "저장",
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      size: 35,
                      Icons.photo,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      size: 70,
                      Icons.circle_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      if (!isTaked) {
                        await _controller.takePhoto();
                        isTaked = true;
                      } else {
                        await _controller.cropPhoto();
                      }

                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      size: 35,
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
