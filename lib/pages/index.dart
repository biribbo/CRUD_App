import 'package:crud_app/classes/product.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/add_button.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:crud_app/widgets/your_pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class IndexPage extends StatefulWidget {
  final String accessToken;

  const IndexPage({super.key, required this.accessToken});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late final ProductService productService;
  Logger logger = Logger();
  List<Product> products = [];
  late int currentPage;

  @override
  void initState() {
    super.initState();
    productService = ProductService(widget.accessToken, reload);
    fetchProductsAndLog();
  }

  Future<void> fetchProductsAndLog() async {
    await productService.fetchProduct(0, products);
    currentPage = productService.getCurrentPage();
    logger.i(products);
  }

  void reload() {
    setState(() {
      productService.fetchProduct(currentPage, products);
    });
  }

  void loadPage(int newPage) {
    setState(() {
      productService.fetchProduct(newPage, products);
      currentPage = productService.getCurrentPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text("No products"));
    }
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (ctx, index) => CustomCard(
                      data: products[index],
                      service: productService,
                      item: Item.products)),
            ),
            YourPaginationWidget(
                currentPage: productService.getCurrentPage(),
                totalPages: productService.totalPages,
                onPageChanged: loadPage),
          ],
        ),
        AddButton(onPressed: () {
          AddDialog(true, "Product", productService.addProduct, null);
        })
      ],
    );
  }
}
