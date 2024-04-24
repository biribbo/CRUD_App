import 'package:crud_app/widgets/pages/search_index.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final String accessToken;

  CustomSearchDelegate(this.accessToken);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: primary,
        background: Colors.black54,
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
  Widget buildResults(BuildContext context) => Container();

  @override
  void showResults(BuildContext context) {
    close(context, null);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SearchPage(accessToken: accessToken, keyword: query)),
    );
    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
