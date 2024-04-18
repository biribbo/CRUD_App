import 'package:crud_app/classes/comment.dart';
import 'package:crud_app/classes/product.dart';
import 'package:crud_app/widgets/singular_product_view/comments_container.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/comment_service.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/add_button.dart';
import 'package:crud_app/widgets/singular_product_view/product_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CommentsPage extends StatefulWidget {
  final String accessToken;
  final int id;
  final ProductService productService;

  const CommentsPage(
      {super.key,
      required this.accessToken,
      required this.id,
      required this.productService});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final Logger logger = Logger();
  List<Comment> comments = [];
  late final Product product;
  late final int productId;
  late final CommentService commentService;

  @override
  void initState() {
    super.initState();
    productId = widget.id;
    commentService =
        CommentService(widget.accessToken, productId, widget.productService);
    product = commentService.productService.fetchSingleProduct(productId);
    comments = commentService.fetchComments(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductContainer(
              imageUrl: product.imageUrl,
              title: product.title,
              description: product.description,
              creationDate: product.creationDate,
              user: product.creatorUserId),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white),
                const Text("Comments",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment = comments[index];
                    return CommentsContainer(
                        id: comment.id,
                        description: comment.description,
                        creationDate: comment.creationDate,
                        user: comment.creatorUserId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      AddButton(onPressed: () {
        AddDialog(true, "Comment", commentService.addComment, null);
      })
    ]);
  }
}
