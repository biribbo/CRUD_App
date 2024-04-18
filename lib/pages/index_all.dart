import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class IndexPageWithDeleted extends StatefulWidget {
  final String accessToken;

  const IndexPageWithDeleted({super.key, required this.accessToken});

  @override
  State<IndexPageWithDeleted> createState() => _IndexPageWithDeletedState();
}

class _IndexPageWithDeletedState extends State<IndexPageWithDeleted> {
  late final ProductService productService;
  final Logger logger = Logger();
  List<Product> products = [];
  bool isLoading = false;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    productService = ProductService(widget.accessToken, reload);
    fetchProductsAndLog();
  }

  Future<void> fetchProductsAndLog() async {
    await productService.fetchProductWithDeleted(0, products);
    setState(() {
      currentPage = productService.getCurrentPage();
    });
  }

  void reload() {
    setState(() {
      productService.fetchProductWithDeleted(currentPage, products);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) => CustomCard(
            data: products[index],
            service: productService,
            item: Item.products));
  }
}
