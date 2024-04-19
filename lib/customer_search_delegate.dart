import 'package:crud_app/widgets/pages/search_index.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

//TODO: fix search

class CustomSearchDelegate extends SearchDelegate {
  final String accessToken;

  CustomSearchDelegate(this.accessToken);

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
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
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
    return SearchPage(accessToken: accessToken, keyword: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
