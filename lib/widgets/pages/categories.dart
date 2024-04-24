import 'package:crud_app/classes/category.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/category_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/buttons/add_button.dart';
import 'package:crud_app/widgets/pages/categories_products.dart';
import 'package:crud_app/widgets/pages/products.dart';
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
  late final CategoryService categoryService;
  ActivePage _activePage = ActivePage.list;
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    categoryService = CategoryService(widget._accessToken, reload);
    fetchCategories();
  }

  void goToCategory(int id) {
    setState(() {
      _activePage = ActivePage.product;
      selectedCategory = id;
    });
  }

  void backToList() {
    setState(() {
      _activePage = ActivePage.list;
      selectedCategory = null;
    });
  }

  Future<void> fetchCategories() async {
    var data = await categoryService.fetchCategory();
    setState(() {
      categories = data;
    });
  }

  void reload() {
    setState(() {
      fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories.contains(null)) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    if (_activePage == ActivePage.list) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) => CustomCard(
                    data: categories[index],
                    service: categoryService,
                    item: Item.categories,
                    onPressed: goToCategory)),
          ),
          AddButton(onPressed: () {
            showDialog(
              context: context,
              builder: ((context) => AddDialog(
                  true, "Category", categoryService.addCategory, null)),
            );
          })
        ],
      );
    } else {
      return CategoryProductsPage(
          accessToken: widget._accessToken,
          selectedCategory: selectedCategory!,
          backMethod: backToList);
    }
  }
}
