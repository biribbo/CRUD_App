import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class AddDialog extends AlertDialog {
  const AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    backgroundColor: primary,
    title: const Text(
      'Add Product',
      style: TextStyle(color: Colors.white),
    ),
    content: Column(
    children:
      TextField(
        controller: titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white), // Set underline color
  ),
  ),
  ),
  TextField(
  controller: imageUrlController,
  decoration: const InputDecoration(
  labelText: 'Title',
  labelStyle: TextStyle(color: Colors.white), // Set label text color
  enabledBorder: UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white), // Set underline color
  ),
  ),
  ),
  ],
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
  if (isToCreate) {
  addProduct();
  Navigator.pop(context);
  } else {
  editProduct(id);
  Navigator.pop(context);
  }
  },
  child: const Text(
  'Submit',
  style: TextStyle(color: Colors.black),
  ),
  ),
  ],
  );
},
);
}
}
}