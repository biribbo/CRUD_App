import 'dart:convert';
import 'package:crud_app/auth_service.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/drawer.dart';
import 'package:crud_app/pages/productWithComments.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../customerSearchDelegate.dart';

//TODO: pagination handling

class IndexPage extends StatefulWidget {
  final AuthService authService;

  const IndexPage({required this.authService});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final Logger logger = Logger();
  List products = [];
  bool isLoading = false;
  int currentPage = 0;
  int totalPages = 1;
  int totalItems = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProduct(currentPage);
  }

  fetchProduct(int page) async {
    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}?page=$page");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var items = responseBody['content'];
          var pageInfo = responseBody['pageable'];
          setState(() {
            products = items;
            currentPage = pageInfo['pageNumber'];
            totalPages = responseBody['totalPages'];
            totalItems = responseBody['totalElements'];
            isLoading = false;
          });
          logger.i(currentPage);
          logger.i(totalPages);
          logger.i(totalItems);
        } else {
          products = [];
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
      fetchProduct(currentPage);
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
    if (response.statusCode == 200) {
      showToast('Product updated successfully');
      fetchProduct(currentPage);
    } else {
      showToast('Error updating product');
    }
  }

  deleteProduct(var id) async {
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      showToast('Error');
    } else {
      showToast('Product $id deleted');
      fetchProduct(currentPage);
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

  @override
  Widget build(BuildContext context) {
    if(products.contains(null) || products.length < 0 || isLoading){
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primary),));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Products", style: TextStyle(color: white)),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: CustomSearchDelegate(authService: widget.authService),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          getBody(),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ClipOval(
              child: ElevatedButton(
                onPressed: () {
                  _showAddOrEditProductDialog(true, 0);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: YourPaginationWidget(
        currentPage: currentPage,
        totalPages: totalPages,
        onPageChanged: (page) {
          fetchProduct(page);
        },
      ),
      drawer: AppDrawer(authService: widget.authService,),
    );
  }


  Widget getBody() {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index){
        return getCard(products[index]);
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
              IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.arrow_right),
                color: Colors.grey,
                iconSize: 24.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsPage(id: id, authService: widget.authService,)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
 }

 class YourPaginationWidget extends StatelessWidget {
   final int currentPage;
   final int totalPages;
   final Function(int) onPageChanged;

   YourPaginationWidget({
     required this.currentPage,
     required this.totalPages,
     required this.onPageChanged,
   });

   @override
   Widget build(BuildContext context) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         IconButton(
           icon: Icon(Icons.arrow_left,
               color: currentPage > 0 ? Colors.white : Colors.grey),
           onPressed: currentPage > 0
               ? () => onPageChanged(currentPage - 1)
               : null,
         ),
         Text('${currentPage + 1} / $totalPages', style: TextStyle(color: Colors.white),),
         IconButton(
           icon: Icon(Icons.arrow_right,
               color: currentPage < totalPages - 1 ? Colors.white : Colors
                   .grey),
           onPressed: currentPage < totalPages - 1 ? () =>
               onPageChanged(currentPage + 1) : null,
         ),
       ],
     );
   }
 }