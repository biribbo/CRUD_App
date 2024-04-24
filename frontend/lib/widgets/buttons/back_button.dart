import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  final Function onPressed;

  const MyBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: ClipOval(
        child: ElevatedButton(
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.all(16.0),
            ),
            child: Transform.rotate(
              angle: 3.14159,
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            )),
      ),
    );
  }
}
