import 'dart:convert';
import 'package:crud_app/service/auth_service.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UserPage extends StatefulWidget {
  final AuthService _authService;

  const UserPage({super.key, required AuthService authService})
      : _authService = authService;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Logger logger = Logger();
  List users = [];
  bool isLoading = false;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    String? bearerToken = widget._authService.accessToken;
    logger.i("token: $bearerToken");

    if (bearerToken.isNotEmpty) {
      try {
        // Fetch admins
        var adminUrl = Uri.parse(
            "${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/ADMIN");
        var adminResponse = await http
            .get(adminUrl, headers: {'Authorization': 'Bearer $bearerToken'});
        if (adminResponse.statusCode == 200) {
          var admins = json.decode(adminResponse.body);
          setState(() {
            users.addAll(admins);
          });
        } else {
          logger.i("Could not load admins ${adminResponse.toString()}");
        }

        var userUrl = Uri.parse(
            "${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/USER");
        var userResponse = await http
            .get(userUrl, headers: {'Authorization': 'Bearer $bearerToken'});
        if (userResponse.statusCode == 200) {
          var regularUsers = json.decode(userResponse.body);
          setState(() {
            users.addAll(regularUsers);
            isLoading = false;
          });
        } else {
          logger.i("Could not load users ${userResponse.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (users.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return getBody();
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
                      width: MediaQuery.of(context).size.width * 0.65,
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
