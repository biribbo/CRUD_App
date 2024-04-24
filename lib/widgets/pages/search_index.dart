import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/card_widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../theme/colours.dart';

class SearchPage extends StatefulWidget {
  final String _accessToken;
  final String keyword;

  const SearchPage(
      {super.key, required String accessToken, required this.keyword})
      : _accessToken = accessToken;

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
    productService = ProductService(widget._accessToken, reload);
    fetchProductsAndLog(null);
  }

  Future<void> fetchProductsAndLog(int? newPage) async {
    var data = await productService.fetchSearchedProduct(keyword);
    setState(() {
      foundProducts = data;
    });
  }

  void reload() {
    setState(() {
      fetchProductsAndLog(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (foundProducts.contains(null) || isLoading) {
      return const Center(
          child: Text("No products", style: TextStyle(color: white)));
    }
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text("Search results for '$keyword'",
            style: const TextStyle(color: white)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Transform.rotate(
                angle: 3.14159,
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: foundProducts.length,
            itemBuilder: (ctx, index) => CustomCard(
                data: foundProducts[index],
                service: productService,
                item: Item.products)),
      ),
    );
  }
}
