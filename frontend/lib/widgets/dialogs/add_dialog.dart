import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/input_text_field.dart';
import 'package:flutter/material.dart';

class AddDialog extends StatelessWidget {
  AddDialog(this.isToCreate, this.item, this.method, this.id, {super.key});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final bool isToCreate;
  final String item;
  final Function method;
  final int? id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primary,
      title: Text(
        isToCreate ? "Add $item" : "Edit $item",
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: _textFields(item),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            switch (item) {
              case "Product":
                isToCreate
                    ? method(titleController.text, descriptionController.text,
                        imageUrlController.text)
                    : method(id, titleController.text,
                        descriptionController.text, imageUrlController.text);
                break;
              case "Comment":
                isToCreate
                    ? method(descriptionController.text)
                    : method(id, descriptionController.text);
                break;
              case "Category":
                isToCreate
                    ? method(titleController.text)
                    : method(id, titleController.text);
                break;
              default:
                break;
            }
            Navigator.pop(context);
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _textFields(String item) {
    if (item == "Product") {
      return Column(
        children: [
          InputTextField(controller: titleController, text: "Title"),
          InputTextField(
              controller: descriptionController, text: "Description"),
          InputTextField(controller: imageUrlController, text: "Image URL"),
        ],
      );
    } else if (item == "Category") {
      return Column(
        children: [
          InputTextField(controller: titleController, text: "Title"),
        ],
      );
    } else if (item == "Comment") {
      return Column(
        children: [
          InputTextField(
              controller: descriptionController, text: "Description"),
        ],
      );
    } else {
      return const Column(); // Return an empty column if item is not recognized
    }
  }
}
