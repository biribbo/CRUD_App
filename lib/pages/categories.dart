import 'package:crud_app/classes/category.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/category_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/add_button.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CategoriesPage extends StatefulWidget {
  final String _accessToken;

  const CategoriesPage({super.key, required String accessToken})
      : _accessToken = accessToken;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Logger logger = Logger();
  List<Category> categories = [];
  bool isLoading = false;
  late final CategoryService categoryService;

  @override
  void initState() {
    super.initState();
    categoryService = CategoryService(widget._accessToken, reload);
    categories = categoryService.fetchCategory();
  }

  void reload() {
    setState(() {
      categories = categoryService.fetchCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Stack(
      children: [
        ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) => CustomCard(
                data: categories[index],
                service: categoryService,
                item: Item.categories)),
        AddButton(onPressed: () {
          AddDialog(true, "Category", categoryService.addCategory, null);
        })
      ],
    );
  }
}
