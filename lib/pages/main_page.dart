import 'package:crud_app/customer_search_delegate.dart';
import 'package:crud_app/widgets/drawer.dart';
import 'package:crud_app/pages/index_all.dart';
import 'package:crud_app/pages/categories.dart';
import 'package:crud_app/pages/index.dart';
import 'package:crud_app/pages/login.dart';
import 'package:crud_app/pages/users.dart';
import 'package:crud_app/service/auth_service.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final AuthService _authService = AuthService();

  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoggedIn = false;
  var _activePage = "login";

  @override
  void initState() {
    super.initState();
    if (widget._authService.accessToken != "") {
      isLoggedIn = true;
      _activePage = "products";
    }
  }

  void navigation(String page) {
    setState(() {
      _activePage = page;
    });
  }

  void loginAttempt() {
    setState(() {
      if (widget._authService.accessToken != "") {
        isLoggedIn = true;
        _activePage = "products";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_activePage == "login") {
      return MaterialApp(
          home: Scaffold(
              backgroundColor: primary,
              body: LoginPage(
                  authService: widget._authService,
                  loginAttempt: loginAttempt)));
    }

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Listing Products", style: TextStyle(color: white)),
        backgroundColor: primary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: CustomSearchDelegate(widget._authService.accessToken),
              );
            },
          ),
        ],
      ),
      backgroundColor: primary,
      body: switch (_activePage) {
        "products" => IndexPage(accessToken: widget._authService.accessToken),
        "all-products" =>
          IndexPageWithDeleted(accessToken: widget._authService.accessToken),
        "categories" =>
          CategoriesPage(accessToken: widget._authService.accessToken),
        "users" => UserPage(authService: widget._authService),
        String() => IndexPage(accessToken: widget._authService.accessToken)
      },
      drawer: AppDrawer(
          accessToken: widget._authService.accessToken, navigation: navigation),
    ));
  }
}
