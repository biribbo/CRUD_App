import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CategoryProductsPage extends StatefulWidget {
  final String accessToken;
  final int selectedCategory;

  const CategoryProductsPage(
      {super.key, required this.accessToken, required this.selectedCategory});

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
    productService = ProductService(widget.accessToken, reload);
    products = productService.fetchProductsByCategory(selectedCategory);
  }

  void reload() {
    setState(() {
      products = productService.fetchProductsByCategory(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => CustomCard(
            data: products[index],
            service: productService,
            item: Item.products));
  }
}
