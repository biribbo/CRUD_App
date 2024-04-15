import 'package:flutter/material.dart';

class DrawerTile extends ListTile {
  const DrawerTile(this.text, this.onTapFun, this.argument, {super.key});
  final String text;
  final Function onTapFun;
  final String argument;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        onTapFun(argument);
      },
    );
  }
}
