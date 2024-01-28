import 'package:crud_app/constants.dart';
import 'package:crud_app/pages/login.dart';
import 'package:crud_app/pages/index.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primary,
        primaryColor: Colors.white,
      ),
      home: FutureBuilder<bool>(
        future: _authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator while checking authentication status
          } else if (snapshot.data == true) {
            return IndexPage(authService: _authService); // User is logged in, navigate to IndexPage
          } else {
            return LoginPage(authService: _authService); // User is not logged in, show login page
          }
        },
      ),
    );
  }
}

