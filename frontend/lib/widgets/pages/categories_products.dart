import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/buttons/back_button.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CategoryProductsPage extends StatefulWidget {
  final String _accessToken;
  final int selectedCategory;
  final Function backMethod;

  const CategoryProductsPage(
      {super.key,
      required String accessToken,
      required this.selectedCategory,
      required this.backMethod})
      : _accessToken = accessToken;

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late final int selectedCategory;
  late final ProductService productService;
  List<Product> products = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
    productService = ProductService(widget._accessToken, reload);
    fetchProductsAndLog();
  }

  Future<void> fetchProductsAndLog() async {
    var data = await productService.fetchProductsByCategory(selectedCategory);
    setState(() {
      products = data;
    });
  }

  void reload() {
    setState(() {
      products = productService.fetchProductsByCategory(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => CustomCard(
                  data: products[index],
                  service: productService,
                  item: Item.products,
                )),
      ),
      MyBackButton(onPressed: widget.backMethod)
    ]);
  }
}
