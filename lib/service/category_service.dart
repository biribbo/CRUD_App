import 'dart:convert';
import 'package:crud_app/classes/category.dart';
import 'package:http/http.dart' as http;
import 'package:crud_app/constants.dart';
import 'package:logger/logger.dart';

class CategoryService {
  CategoryService(this.bearerToken, this.reload);
  final Logger logger = Logger();
  final String bearerToken;
  final Function reload;

  fetchCategory() async {
    List<Category> result = List.empty();
    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/all");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          for (var item in items) {
            result.add(Category(item['id'], item['name'], item['isDeleted']));
          }
        } else {
          logger.i("Could not load categories ${response.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    } else {
      logger.i("Bearer token is null or empty");
    }
  }

  void addCategory(String name) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.categoriesEndpoint);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'name': name,
    };
    var response =
        await http.post(url, body: json.encode(body), headers: headers);

    if (response.statusCode == 201) {
      reload();
    } else {
      logger.i("Error adding category: ${response.toString()}");
    }
  }

  editCategory(var id, String name) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'name': name,
    };
    var response =
        await http.put(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      reload();
    } else {
      logger.i('Error updating category ${response.toString()}');
    }
  }

  deleteCategory(var id) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      logger.i("Error deleting category: ${response.toString()}");
      return false;
    } else {
      reload();
      return true;
    }
  }
}
