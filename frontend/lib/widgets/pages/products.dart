import 'package:crud_app/classes/product.dart';
import 'package:crud_app/widgets/pages/product_with_comments.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/buttons/add_button.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:crud_app/widgets/your_pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum ActivePage { list, product }

class ProductsPage extends StatefulWidget {
  final String _accessToken;

  const ProductsPage({super.key, required String accessToken})
      : _accessToken = accessToken;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final ProductService productService;
  Logger logger = Logger();
  List<Product> products = [];
  int currentPage = 0;
  ActivePage activePage = ActivePage.list;
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    productService = ProductService(widget._accessToken, reload);
    fetchProductsAndLog(null);
  }

  Future<void> fetchProductsAndLog(int? newPage) async {
    var data = await productService.fetchProduct(newPage ?? currentPage);
    setState(() {
      products = data;
      currentPage = productService.getCurrentPage();
    });
  }

  void reload() {
    setState(() {
      fetchProductsAndLog(null);
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
    if (products.isEmpty) {
      return const Center(child: Text("No products"));
    }
    logger.i(products);
    if (activePage == ActivePage.list) {
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
                        item: Item.products,
                        onPressed: goToProduct)),
              ),
              YourPaginationWidget(
                  currentPage: productService.getCurrentPage(),
                  totalPages: productService.totalPages,
                  onPageChanged: loadPage),
            ],
          ),
          AddButton(onPressed: () {
            showDialog(
                context: context,
                builder: ((context) => AddDialog(
                    true, "Product", productService.addProduct, null)));
          })
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
