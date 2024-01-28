import 'dart:convert';
import 'package:crud_app/auth_service.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/drawer.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class IndexPageWithDeleted extends StatefulWidget {
  final AuthService authService;

  const IndexPageWithDeleted({required this.authService});

  @override
  _IndexPageWithDeletedState createState() => _IndexPageWithDeletedState();
}

class _IndexPageWithDeletedState extends State<IndexPageWithDeleted> {
  final Logger logger = Logger();
  List products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProduct(0);
  }

  fetchProduct(int id) async {

    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/all?page=$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          setState(() {
            products = items;
            isLoading = false;
          });
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
        title: const Text("Listing Products With Deleted", style: TextStyle(color: white)),
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
                    const SizedBox(height: 5),
                    if (isDeleted == 'true')
                      const Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 5),
                          Text('Deleted', style: TextStyle(fontSize: 12, color: Colors.red)),
                        ],
                      ),
                    const SizedBox(height: 5),
                    Text('Created $creationDate by $creatorUserId', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ID: $id', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  if (isDeleted == true) const Icon(Icons.delete_outline, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}