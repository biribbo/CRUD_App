import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../theme/colours.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;
  final String keyword;

  const SearchPage(
      {super.key, required this.accessToken, required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Logger logger = Logger();
  List<Product> foundProducts = [];
  bool isLoading = false;
  late final ProductService productService;
  late String keyword;

  @override
  void initState() {
    super.initState();
    keyword = widget.keyword;
    productService = ProductService(widget.accessToken, reload);
    foundProducts = productService.fetchSearchedProduct(keyword);
  }

  void reload() {
    setState(() {
      foundProducts = productService.fetchSearchedProduct(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (foundProducts.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: foundProducts.length,
        itemBuilder: (ctx, index) => CustomCard(
            data: foundProducts[index],
            service: productService,
            item: Item.products));
  }
}
