import 'package:crud_app/classes/category.dart';
import 'package:crud_app/classes/product.dart';
import 'package:crud_app/service/category_service.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/card_widgets/categories_card.dart';
import 'package:crud_app/widgets/card_widgets/product_card.dart';
import 'package:flutter/material.dart';

enum Item { products, categories, productsCategories, users }

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.data,
      required this.service,
      required this.item,
      this.onPressed});
  final Object data;
  final Object service;
  final Item item;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primary,
      child: Padding(
          padding: const EdgeInsets.all(10.8),
          child: switch (item) {
            Item.products => ProductCard(service as ProductService,
                data: data as Product, onPressed: onPressed),
            Item.categories => CategoriesCard(
                data: data as Category,
                categoryService: service as CategoryService,
                move: onPressed!),
            Item.productsCategories => null,
            Item.users => null,
          }),
    );
  }
}
