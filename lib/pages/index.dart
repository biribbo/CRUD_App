import 'dart:convert';
import 'package:crud_app/constants.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchProduct();
  }

  fetchProduct() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.productsEndpoint);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        products = items;
        isLoading = false;
      });
    } else {
        products = [];
        isLoading = false;
      }
    }

  deleteProduct(var id) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.productsEndpoint + "/" + id.toString());
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      showToast('Error');
    } else {
      showToast('Product ' + id.toString() + ' deleted');
      fetchProduct();
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
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(primary),));
    }
  return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Products", style: TextStyle(color: white)),
        backgroundColor: primary,
      ),
      body: getBody()
    );
  }

  Widget getBody() {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index){
        return getCard(products[index]);
      });
  }
  Widget getCard(item) {
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
                      borderRadius: BorderRadius.circular(60/2),
                      image: DecorationImage(
                        image: NetworkImage(image)
                      )
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(title, style: TextStyle(fontSize: 17, color: white))),
                    SizedBox(height: 10),
                    Text(description, style: TextStyle(color: Colors.grey)),
                    //Spacer(),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.delete_rounded),
                      color: Colors.grey,
                      iconSize: 24.0,
                      onPressed: () {
                        deleteProduct(id);
                      },
                    ),
                  ],
                )
              ],
            )
        )
      )
    );
  }
 }