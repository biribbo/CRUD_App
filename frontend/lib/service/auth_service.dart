import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  String accessToken = "";
  List<String> roles = [];
  late bool loggedIn;

  Future<bool> login(String username, String password) async {
    var url = Uri.parse('http://10.0.2.2:8080/auth/login');
    var authRequest = {'username': username, 'password': password};
    final Logger logger = Logger();

    try {
      var response = await http.post(
        url,
        body: jsonEncode(authRequest),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var authResponse = json.decode(response.body);
        accessToken = authResponse['accessToken'];
        roles = List<String>.from(authResponse['authorities']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('accessToken', accessToken);
        prefs.setStringList('roles', roles);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      logger.i(error);
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    accessToken = "";
    roles = [];
  }
}
