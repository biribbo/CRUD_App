import 'package:crud_app/classes/product.dart';
import 'package:crud_app/widgets/pages/product_with_comments.dart';
import 'package:crud_app/widgets/pages/products.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:crud_app/widgets/your_pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AllProductsPage extends StatefulWidget {
  final String _accessToken;

  const AllProductsPage({super.key, required String accessToken})
      : _accessToken = accessToken;

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late final ProductService productService;
  final Logger logger = Logger();
  List<Product> products = [];
  int currentPage = 0;
  ActivePage activePage = ActivePage.list;
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    productService = ProductService(widget._accessToken, reload);
    fetchProductsAndLog(currentPage);
  }

  Future<void> fetchProductsAndLog(int? newPage) async {
    var data =
        await productService.fetchProductWithDeleted(newPage ?? currentPage);
    setState(() {
      products = data;
      currentPage = productService.getCurrentPage();
    });
  }

  void reload(int? newPage) {
    setState(() {
      fetchProductsAndLog(newPage);
    });
  }

  void loadPage(int newPage) {
    setState(() {
      fetchProductsAndLog(newPage);
    });
  }

  void goToProduct(Product product) {
    setState(() {
      activePage = ActivePage.product;
      selectedProduct = product;
    });
  }

  void goToList() {
    setState(() {
      activePage = ActivePage.list;
      selectedProduct = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products.contains(null)) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    if (activePage == ActivePage.list) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (ctx, index) => CustomCard(
                      data: products[index],
                      service: productService,
                      item: Item.products,
                      onPressed: goToProduct,
                    )),
          ),
          YourPaginationWidget(
              currentPage: productService.getCurrentPage(),
              totalPages: productService.totalPages,
              onPageChanged: loadPage),
        ],
      );
    } else {
      return CommentsPage(
          accessToken: widget._accessToken,
          product: selectedProduct!,
          productService: productService,
          backMethod: goToList);
    }
  }
}
