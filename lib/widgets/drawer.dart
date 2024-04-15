import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String accessToken;
  final Function navigation;

  const AppDrawer(
      {super.key, required this.accessToken, required this.navigation});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: Text(
              'Navigation',
              style: TextStyle(color: Colors.white),
            ),
          ),
          DrawerTile("Products", navigation, "products"),
          DrawerTile("All Products", navigation, "all-products"),
          DrawerTile("Categories", navigation, "categories"),
          DrawerTile("Users", navigation, "users")
        ],
      ),
    ));
  }
}
