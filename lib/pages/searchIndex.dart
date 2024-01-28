import 'dart:convert';

import 'package:crud_app/constants.dart';
import 'package:crud_app/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../auth_service.dart';
import '../theme/colours.dart';

class SearchPage extends StatefulWidget {
  final AuthService authService;
  final String keyword;

  const SearchPage({required this.authService, required this.keyword});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Logger logger = Logger();
  List foundProducts = [];
  bool isLoading = false;
  late String keyword;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    keyword = widget.keyword;
    fetchProduct();
  }

  fetchProduct() async {
    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/search/$keyword");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          setState(() {
            foundProducts = items;
            isLoading = false;
          });
        } else {
          foundProducts = [];
          isLoading = false;
          showToast("Could not load products ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        showToast("Error fetching products");
      }
    } else {
      showToast("Bearer token is null or empty");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void addProduct() async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.productsEndpoint);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'imageUrl': imageUrlController.text
    };
    var response = await http.post(
        url,
        body: json.encode(body),
        headers: headers
    );

    if (response.statusCode == 201) {
      showToast('Product added successfully');
      fetchProduct();
    } else {
      showToast('Error adding product');
    }
  }

  editProduct(var id) async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'imageUrl': imageUrlController.text
    };
    var response = await http.put(
        url,
        body: json.encode(body),
        headers: headers
    );
  }

  deleteProduct(var id) async {
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      showToast('Error');
    } else {
      showToast('Product $id deleted');
      fetchProduct();
    }
  }

  void _showAddOrEditProductDialog(bool isToCreate, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary,
          title: const Text(
            'Add Product',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white), // Set label text color
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Set underline color
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white), // Set label text color
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

  @override
  Widget build(BuildContext context) {
    if(foundProducts.contains(null) || foundProducts.length < 0 || isLoading){
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primary),));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Search results for <$keyword>", style: TextStyle(color: white)),
        backgroundColor: primary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: getBody(),
      drawer: AppDrawer(authService: widget.authService,),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: foundProducts.length,
        itemBuilder: (context, index){
          return getCard(foundProducts[index]);
        });
  }
  Widget getCard(Map<String, dynamic> item) {
    var id = item['id'];
    var title = item['title'];
    var description = item['description'];
    var image = item['imageUrl'];
    return Card(
      color: primary,
      child: Padding(
        padding: const EdgeInsets.all(10.8),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(60 / 2),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover, // Added BoxFit.cover to ensure the image covers the container
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(title, style: const TextStyle(fontSize: 17, color: white)),
                    ),
                    const SizedBox(height: 10),
                    Text(description, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.grey,
                iconSize: 24.0,
                onPressed: () {
                  _showAddOrEditProductDialog(false, id);
                },
              ),
              IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.delete_rounded),
                color: Colors.grey,
                iconSize: 24.0,
                onPressed: () {
                  if (!widget.authService.roles.contains("ADMIN")) {
                    showToast("Access denied - admin role needed");
                  } else {
                    deleteProduct(id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}