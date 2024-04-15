import 'package:crud_app/classes/category.dart';
import 'package:crud_app/service/category_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard(
      {super.key, required this.data, required this.categoryService});

  final Category data;
  final CategoryService categoryService;

  @override
  Widget build(BuildContext context) {
    var id = data.id;
    var name = data.name;

    return Row(children: <Widget>[
      const SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Text(name,
                  style: const TextStyle(fontSize: 17, color: white)),
            ),
            const SizedBox(height: 10),
            Text("ID: $id", style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.grey,
            iconSize: 24.0,
            onPressed: () {
              AddDialog(false, "Category", categoryService.editCategory, id);
            },
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.delete_rounded),
            color: Colors.grey,
            iconSize: 24.0,
            onPressed: () {
              if (!categoryService.deleteCategory(id)) {
                toastification.show(
                    context: context,
                    title: const Text("Access denied - admin role needed"),
                    autoCloseDuration: const Duration(seconds: 5));
              }
            },
          ),
        ],
      )
    ]);
  }
}
