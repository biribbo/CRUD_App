import 'dart:convert';
import 'package:crud_app/classes/product.dart';
import 'package:crud_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ProductService {
  ProductService(this.bearerToken, this.reload);
  final Logger logger = Logger();
  final String bearerToken;
  final Function reload;
  int _currentPage = 0;
  late int totalPages;

  fetchProduct(int page, List<Product> result) async {
    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}?page=$page");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          logger.i(responseBody);
          var items = responseBody['content'];
          var pageInfo = responseBody['pageable'];
          _currentPage = pageInfo['pageNumber'];
          totalPages = responseBody['totalPages'];
          for (var item in items) {
            result.add(Product(
                item['id'],
                item['title'],
                item['description'],
                item['creationDate'],
                item['creatorUserId'],
                item['deleted'],
                item['imageUrl']));
          }
        } else {
          logger.i(response.statusCode);
        }
      } catch (error) {
        logger.i(error.hashCode);
      }
    }
  }

  fetchProductWithDeleted(int id) async {
    List<Product> result = List.empty();

    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/all?page=$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          var items = responseBody['content'];
          var pageInfo = responseBody['pageable'];
          _currentPage = pageInfo['pageNumber'];
          totalPages = responseBody['totalPages'];
          for (var item in items) {
            result.add(Product(
                item['id'],
                item['title'],
                item['description'],
                item['creationDate'],
                item['creatorUserId'],
                item['isDeleted'],
                item['imageUrl']));
          }
        } else {
          logger.i("Could not load products ${response.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    }
    return result;
  }

  fetchSingleProduct(int id) async {
    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var item = json.decode(response.body);
          Product product = Product(
              item['id'],
              item['title'],
              item['description'],
              item['creationDate'],
              item['creatorUserId'],
              item['isDeleted'],
              item['imageUrl']);
          return product;
        } else {
          //roduct = null;
          //isLoading = false;
          logger.i("Could not load product ${response.statusCode}");
          return null;
        }
      } catch (error) {
        logger.i(error.toString());
        return null;
      }
    }
  }

  fetchProductsByCategory(int id) async {
    List<Product> result = List.empty();

    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}/$id");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          for (var item in items) {
            result.add(Product(
                item['id'],
                item['title'],
                item['description'],
                item['creationDate'],
                item['creatorUserId'],
                item['isDeleted'],
                item['imageUrl']));
          }
        } else {
          logger.i("Could not load categories ${response.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    }
    return result;
  }

  fetchSearchedProduct(String keyword) async {
    List<Product> result = List.empty();

    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/search/$keyword");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          for (var item in items) {
            result.add(Product(
                item['id'],
                item['title'],
                item['description'],
                item['creationDate'],
                item['creatorUserId'],
                item['isDeleted'],
                item['imageUrl']));
          }
        } else {
          logger.i("Could not load products ${response.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    }
    return result;
  }

  void addProduct(String title, String description, String imageUrl) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.productsEndpoint);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl
    };
    var response =
        await http.post(url, body: json.encode(body), headers: headers);

    if (response.statusCode == 201) {
      reload();
    } else {
      logger.i("Error fetching: ${response.toString()}");
    }
  }

  editProduct(var id, String title, String description, String imageUrl) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl
    };
    var response =
        await http.put(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      reload();
    }
  }

  deleteProduct(var id) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      logger.i(response.toString());
      return false;
    } else {
      reload();
      return true;
    }
  }

  int getCurrentPage() {
    return _currentPage;
  }
}
