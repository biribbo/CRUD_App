import 'package:crud_app/pages/searchIndex.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class CustomSearchDelegate extends SearchDelegate {
  final AuthService authService;

  CustomSearchDelegate({required this.authService});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: primary,
        background: Colors.black54, // Background color for the body
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white,),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(authService: authService, keyword: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}