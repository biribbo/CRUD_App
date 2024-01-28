import 'package:crud_app/auth_service.dart';
import 'package:crud_app/pages/allIndex.dart';
import 'package:crud_app/pages/categories.dart';
import 'package:crud_app/pages/index.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final AuthService authService;

  const AppDrawer({required this.authService});

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
              ListTile(
                title: const Text(
                  'Products',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPage(authService: authService,)), // Replace with your IndexPage widget
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'All products',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexPageWithDeleted(authService: authService,)),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Categories',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoriesPage(authService: authService,)),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Users',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        )

    );
  }
}