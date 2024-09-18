import 'dart:convert';

class ApiHelper {
  var responseData;

  // ApiHelper(response.body) 생성자
  ApiHelper(String response) {
    responseData = jsonDecode(response);
  }

  Map<String, dynamic> _getResult() {
    final Map<String, dynamic> result = responseData['result'];
    return result;
  }

  String getResultMessage() {
    final String resultMessage = _getResult()["resultMessage"];
    return resultMessage;
  }

  int getResultCode() {
    final resultCode = _getResult()["resultCode"];
    return resultCode;
  }

  dynamic getValue(String key) {
    return _getResult()[key];
  }
}
