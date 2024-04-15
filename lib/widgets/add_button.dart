import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function onPressed;

  const AddButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: ClipOval(
        child: ElevatedButton(
          onPressed: () {
            onPressed;
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.all(16.0),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
