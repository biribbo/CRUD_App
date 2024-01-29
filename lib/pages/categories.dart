import 'dart:convert';
import 'package:crud_app/auth_service.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/drawer.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class CategoriesPage extends StatefulWidget {
  final AuthService authService;

  const CategoriesPage({required this.authService});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Logger logger = Logger();
  List categories = [];
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  fetchCategory() async {
    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/all");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          setState(() {
            categories = items;
            isLoading = false;
          });
        } else {
          categories = [];
          isLoading = false;
          showToast("Could not load categories ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        showToast("Error fetching categories");
      }
    } else {
      showToast("Bearer token is null or empty");
    }
  }

  void addCategory() async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.categoriesEndpoint);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'name': nameController.text,
    };
    var response = await http.post(
        url,
        body: json.encode(body),
        headers: headers
    );

    if (response.statusCode == 201) {
      showToast('Category added successfully');
      fetchCategory();
    } else {
      showToast('Error adding category');
    }
  }

  editCategory(var id) async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'name': nameController.text,
    };
    var response = await http.put(
        url,
        body: json.encode(body),
        headers: headers
    );
    if (response.statusCode == 200) {
      showToast('Category updated successfully');
      fetchCategory();
    } else {
      showToast('Error updating category');
    }
  }

  deleteCategory(var id) async {
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      showToast('Error');
    } else {
      showToast('Category $id deleted');
      fetchCategory();
    }
  }

  void _showAddOrEditCategoryDialog(bool isToCreate, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary,
          title: const Text(
            'Add or Edit Category',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                  addCategory();
                  Navigator.pop(context);
                } else {
                  editCategory(id);
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
    if(categories.contains(null) || categories.length < 0 || isLoading){
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primary),));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Categories", style: TextStyle(color: white)),
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
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryProductsPage(authService: widget.authService,)),
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
                  _showAddOrEditCategoryDialog(true, 0);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      drawer: AppDrawer(authService: widget.authService,),
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index){
          return getCard(categories[index]);
        });
  }
  Widget getCard(Map<String, dynamic> item) {
    var id = item['id'];
    var name = item['name'];
    var isDeleted = item['deleted'];
    logger.i("$id deleted: $isDeleted");

    return Card(
      color: primary,
      child: Padding(
        padding: const EdgeInsets.all(10.8),
        child: ListTile(
          title: Row(
            children: <Widget>[
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(name, style: const TextStyle(fontSize: 17, color: white)),
                    ),
                    const SizedBox(height: 10),
                    Text("ID: $id", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.grey,
                      iconSize: 24.0,
                      onPressed: () {
                        _showAddOrEditCategoryDialog(false, id);
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
                          deleteCategory(id);
                        }
                      },
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryProductsPage extends StatefulWidget {
  final AuthService authService;

  const CategoryProductsPage({Key? key, required this.authService}) : super(key: key);

  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  int? selectedValue;
  List products = [];
  List categories = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchCategory();
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

  fetchCategory() async {
    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/all");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          setState(() {
            categories = items;
          });
        } else {
          categories = [];
          showToast("Could not load categories ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        showToast("Error fetching categories");
      }
    } else {
      showToast("Bearer token is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products by category", style: TextStyle(color: Colors.white)),
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
          DropdownButton<int>(
            value: selectedValue,
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            onChanged: (int? newValue) {
              setState(() {
                selectedValue = newValue;
                logger.i(newValue);
                fetchProductsByCategory(newValue!);
              });
            },
            items: categories.map((value) {
              return DropdownMenuItem<int>(
                value: value['id'],
                child: Text(value['name']),
              );
            }).toList(),
            dropdownColor: Colors.black54,
          ),
        ],
      ),
      body: getBody(),
      drawer: AppDrawer(authService: widget.authService,),
    );
  }

  Widget getBody() {
    logger.i(products);
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
    var isDeleted = item['deleted'];
    var creatorUserId = item['creatorUserId'];
    var creationDate = item['creationDate'];
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
                    fit: BoxFit
                        .cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      child: Text(title,
                          style: const TextStyle(fontSize: 17, color: white)),
                    ),
                    const SizedBox(height: 10),
                    Text(description,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    if (isDeleted == 'true')
                      const Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Deleted', style: TextStyle(fontSize: 12,
                              color: Colors.red)),
                        ],
                      ),
                    const SizedBox(height: 5),
                    Text('Created $creationDate by $creatorUserId',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ID: $id',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (isDeleted == true) const Icon(
                      Icons.delete_outline, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchProductsByCategory(int id) async {
    String? bearerToken = widget.authService.accessToken;

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          setState(() {
            products = items;
          });
        } else {
          products = [];
          showToast("Could not load categories ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        showToast("Error fetching categories");
      }
    } else {
      showToast("Bearer token is null or empty");
    }
  }
}