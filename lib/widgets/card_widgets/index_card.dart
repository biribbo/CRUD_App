import 'package:crud_app/classes/product.dart';
import 'package:crud_app/pages/product_with_comments.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class IndexCard extends StatelessWidget {
  const IndexCard(this._productService, {required this.data, super.key});

  final Product data;
  final ProductService _productService;

  @override
  Widget build(BuildContext context) {
    var id = data.id;
    var title = data.title;
    var description = data.description;
    var image = data.imageUrl;
    var deleted = data.isDeleted;
    return Row(children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(60 / 2),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(title,
                  style: const TextStyle(fontSize: 17, color: white)),
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      if (!deleted) ...[
        IconButton(
          icon: const Icon(Icons.edit),
          color: Colors.grey,
          iconSize: 24.0,
          onPressed: () {
            AddDialog(false, "Product", _productService.editProduct, id);
          },
        ),
        IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.delete_rounded),
            color: Colors.grey,
            iconSize: 24.0,
            onPressed: () {
              if (!_productService.deleteProduct(id)) {
                toastification.show(
                    context: context,
                    title: const Text("Access denied - admin role needed"),
                    autoCloseDuration: const Duration(seconds: 5));
              }
            }),
      ] else ...[
        const Icon(Icons.delete_outline, color: Colors.red),
        const SizedBox(width: 5),
        const Text('Deleted',
            style: TextStyle(fontSize: 12, color: Colors.red)),
      ],
      IconButton(
        alignment: Alignment.centerRight,
        icon: const Icon(Icons.arrow_right),
        color: Colors.grey,
        iconSize: 24.0,
        onPressed: () {
          CommentsPage(
              accessToken: _productService.bearerToken,
              id: id,
              productService: _productService);
        },
      ),
    ]);
  }
}
