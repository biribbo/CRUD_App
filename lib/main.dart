import 'package:crud_app/constants.dart';
import 'package:crud_app/pages/index.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: primary,
      primaryColor: Colors.white
    ),
    home: IndexPage(),
  ));
}


