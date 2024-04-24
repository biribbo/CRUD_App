import 'package:crud_app/customer_search_delegate.dart';
import 'package:crud_app/widgets/drawer_widgets/drawer.dart';
import 'package:crud_app/widgets/pages/products_all.dart';
import 'package:crud_app/widgets/pages/categories.dart';
import 'package:crud_app/widgets/pages/products.dart';
import 'package:crud_app/widgets/pages/login.dart';
import 'package:crud_app/widgets/pages/users.dart';
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
  String keyword = "";

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
            loginAttempt: loginAttempt,
          ),
        ),
      );
    }

    keyword = _activePage.replaceAll("-", " ");
    Widget page;
    switch (_activePage) {
      case "products":
        page = ProductsPage(accessToken: widget._authService.accessToken);
        break;
      case "all-products":
        page = AllProductsPage(accessToken: widget._authService.accessToken);
        break;
      case "categories":
        page = CategoriesPage(accessToken: widget._authService.accessToken);
        break;
      case "users":
        page = UserPage(authService: widget._authService);
        break;
      default:
        page = ProductsPage(accessToken: widget._authService.accessToken);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Listing $keyword", style: const TextStyle(color: white)),
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
      body: page,
      drawer: AppDrawer(
        accessToken: widget._authService.accessToken,
        navigation: navigation,
      ),
    );
  }
}
