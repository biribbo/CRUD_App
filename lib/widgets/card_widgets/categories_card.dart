import 'package:crud_app/classes/category.dart';
import 'package:crud_app/service/category_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  const CategoriesCard(
      {super.key,
      required this.data,
      required this.categoryService,
      required this.move});

  final Category data;
  final CategoryService categoryService;
  final Function move;

  @override
  Widget build(BuildContext context) {
    var id = data.id;
    var name = data.name;
    var deleted = data.isDeleted;

    return Row(children: <Widget>[
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!deleted) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.grey,
              iconSize: 24.0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) => AddDialog(
                        false, "Category", categoryService.editCategory, id)));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              color: Colors.grey,
              iconSize: 24.0,
              onPressed: () {
                categoryService.deleteCategory(id);
              },
            ),
          ] else ...[
            const Icon(Icons.delete_outline, color: Colors.red),
            const SizedBox(width: 5),
            const Text('Deleted',
                style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
          IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: Colors.grey,
              iconSize: 24.0,
              onPressed: () {
                move(id);
              })
        ],
      )
    ]);
  }
}
