import 'dart:convert';
import 'package:flutter/material.dart';

Map<String, dynamic> getBody(Map<String, dynamic> responseData) {
  print(responseData);
  return responseData["body"];
}