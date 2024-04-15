import 'dart:convert';

import 'package:crud_app/classes/comment.dart';
import 'package:crud_app/constants.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class CommentService {
  CommentService(this.bearerToken, this.productId, this.productService);
  final Logger logger = Logger();
  final String bearerToken;
  final int productId;
  final ProductService productService;

  fetchComments(int id) async {
    List<Comment> result = List.empty();
    if (bearerToken.isNotEmpty) {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id/comments");
      var headers = {'Authorization': 'Bearer $bearerToken'};
      try {
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          var items = json.decode(response.body);
          for (var item in items) {
            result.add(Comment(
                item['id'],
                productId,
                item['description'],
                item['creationDate'],
                item['isDeleted'],
                item['creatorUserId']));
          }
        } else {
          logger.i("Could not load comments ${response.toString()}");
        }
      } catch (error) {
        logger.i(error.toString());
      }
    }
    return result;
  }

  void addComment(String description) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$productId${ApiConstants.commentsEndpoint}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'description': description,
    };
    var response =
        await http.post(url, body: json.encode(body), headers: headers);

    if (response.statusCode == 201) {
      productService.fetchSingleProduct(productId);
    } else {
      logger.i('Error adding comment: ${response.toString()}');
    }
  }

  editComment(var id, String description) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$productId${ApiConstants.commentsEndpoint}/$id");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    var body = {
      'description': description,
    };
    var response =
        await http.put(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      productService.fetchSingleProduct(productId);
    } else {
      logger.i('Error updating comment: ${response.toString()}');
    }
  }

  deleteComment(var id) async {
    var url = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$productId${ApiConstants.commentsEndpoint}/$id");
    final request = http.Request("DELETE", url);
    final response = await request.send();
    if (response.statusCode != 200) {
      logger.i('Error deleting comment: ${response.toString()}');
      return false;
    } else {
      productService.fetchSingleProduct(productId);
      return true;
    }
  }
}
