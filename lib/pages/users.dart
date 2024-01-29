import 'dart:convert';
import 'package:crud_app/auth_service.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/drawer.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class UserPage extends StatefulWidget {
  final AuthService authService;

  const UserPage({required this.authService});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Logger logger = Logger();
  List users = [];
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    String? bearerToken = widget.authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken != null && bearerToken.isNotEmpty) {
      try {
        // Fetch admins
        var adminUrl = Uri.parse(
            "${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/ADMIN");
        var adminResponse = await http.get(
            adminUrl, headers: {'Authorization': 'Bearer $bearerToken'});
        if (adminResponse.statusCode == 200) {
          var admins = json.decode(adminResponse.body);
          setState(() {
            users.addAll(admins);
          });
        } else {
          showToast("Could not load admins ${adminResponse.statusCode}");
        }

        var userUrl = Uri.parse(
            "${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/USER");
        var userResponse = await http.get(
            userUrl, headers: {'Authorization': 'Bearer $bearerToken'});
        if (userResponse.statusCode == 200) {
          var regularUsers = json.decode(userResponse.body);
          setState(() {
            users.addAll(regularUsers);
            isLoading = false;
          });
        } else {
          showToast("Could not load users ${userResponse.statusCode}");
        }
      } catch (error) {
        logger.i(error.toString());
        showToast("Error fetching users");
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

  void _showAddOrEditUserDialog(bool isToCreate, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primary,
          title: const Text(
            'Add or Edit User',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: selectedRole,
                items: ['admin', 'user'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      selectedRole = value;
                    });
                  }
                },
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
                  addUser();
                  Navigator.pop(context);
                } else {
                  editUser(id);
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

  void addUser() async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'username': usernameController.text,
      'password': passwordController.text,
      'roleName': selectedRole
    };
    var response = await http.post(
        url,
        body: json.encode(body),
        headers: headers
    );

    if (response.statusCode == 201) {
      showToast('User added successfully');
      fetchUsers();
    } else {
      showToast('Error adding user');
    }
  }

  editUser(var id) async {
    String? bearerToken = widget.authService.accessToken;
    var url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'username': usernameController.text,
      'password': passwordController.text,
      'roleName': selectedRole
    };
    var response = await http.put(
        url,
        body: json.encode(body),
        headers: headers
    );
    if (response.statusCode == 200) {
      showToast('User updated successfully');
      fetchUsers();
    } else {
      showToast('Error updating user');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.contains(null) || users.length < 0 || isLoading) {
      return const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Users", style: TextStyle(color: white)),
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
          getBody(),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ClipOval(
              child: ElevatedButton(
                onPressed: () {
                  _showAddOrEditUserDialog(true, 0);
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
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(Map<String, dynamic> item) {
    var id = item['id'];
    var username = item['username'];
    var role = item['roleName'];

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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      child: Text("$username (ID: $id)",
                          style: const TextStyle(fontSize: 17, color: white)),
                    ),
                    const SizedBox(height: 10),
                    Text("Role: $role",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}