import 'dart:convert';

import 'package:crud_app/classes/toast.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../auth_service.dart';
import '../constants.dart';
import '../drawer.dart';
import '../theme/colours.dart';

class CommentsPage extends StatefulWidget {
  final AuthService authService;
  final int id;

  const CommentsPage({super.key, required this.authService, required this.id});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final Logger logger = Logger();
  final CustomToast toast = CustomToast();
  TextEditingController descriptionController = TextEditingController();
  List comments = [];
  var product;
  late int productId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    productId = widget.id;
    fetchProduct(widget.id);
    fetchComments(widget.id);
  }

  void addComment() async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants
        .productsEndpoint}/$productId${ApiConstants.commentsEndpoint}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'description': descriptionController.text,
    };
    var response = await http.post(
        url,
        body: json.encode(body),
        headers: headers
    );

    if (response.statusCode == 201) {
      toast.showToast('Comment added successfully');
      fetchProduct(productId);
    } else {
      toast.showToast('Error adding comment');
    }
  }

  editComment(var id) async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants
        .productsEndpoint}/$productId${ApiConstants.commentsEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'description': descriptionController.text,
    };
    var response = await http.put(
        url,
        body: json.encode(body),
        headers: headers
    );
    if (response.statusCode == 200) {
      toast.showToast('Comment updated successfully');
      fetchProduct(productId);
    } else {
      toast.showToast('Error updating comment');
    }
  }

  deleteComment(var id) async {
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants
        .productsEndpoint}/$productId${ApiConstants.commentsEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      toast.showToast('Error');
    } else {
      toast.showToast('Comment $id deleted');
      fetchProduct(productId);
    }
  }

  void _showAddOrEditCommentDialog(bool isToCreate, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary,
          title: const Text(
            'Add or Edit comment',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  // Set label text color
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white), // Set underline color
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
                  addComment();
                  Navigator.pop(context);
                } else {
                  editComment(id);
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

  fetchProduct(int id) async {
    String? bearerToken = widget.authService.accessToken;

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var item = json.decode(response.body);
          setState(() {
            product = item;
            isLoading = false;
          });
        } else {
          product = null;
          isLoading = false;
          toast.showToast("Could not load product ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        toast.showToast("Error fetching product");
      }
    } else {
      toast.showToast("Bearer token is null or empty");
    }
  }

  fetchComments(int id) async {
    String? bearerToken = widget.authService.accessToken;

    if (bearerToken != null && bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id/comments");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          logger.i(items);
          setState(() {
            comments = items;
            isLoading = false;
          });
        } else {
          comments = [];
          isLoading = false;
          toast.showToast("Could not load products ${response.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        toast.showToast("Error fetching products");
      }
    } else {
      toast.showToast("Bearer token is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null || comments == null || isLoading) {
      return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product", style: TextStyle(color: white)),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(60 / 2),
                              image: DecorationImage(
                                image: NetworkImage(product['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['title'], style: const TextStyle(fontSize: 17, color: white)),
                                const SizedBox(height: 10),
                                Text(product['description'], style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Created ${DateTime.parse(product['creationDate']).toString()} by ${product['creatorUserId'] ?? 'Unknown'}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.white),
                      const Text("Comments", style: TextStyle(color: Colors.white, fontSize: 18)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          var comment = comments[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("ID: ${comment['id']}", style: const TextStyle(color: Colors.white)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment['description'] ?? '', style: const TextStyle(color: Colors.white)),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Created ${DateTime.parse(comment['creationDate']).toString()} by ${comment['creatorUserId'] ?? 'Unknown'}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Your button at the bottom right
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ClipOval(
              child: ElevatedButton(
                onPressed: () {
                  _showAddOrEditCommentDialog(true, 0);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(authService: widget.authService),
    );
  }
}