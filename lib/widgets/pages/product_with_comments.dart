import 'package:crud_app/classes/comment.dart';
import 'package:crud_app/classes/product.dart';
import 'package:crud_app/theme/colours.dart';
import 'package:crud_app/widgets/buttons/back_button.dart';
import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:crud_app/service/comment_service.dart';
import 'package:crud_app/service/product_service.dart';
import 'package:crud_app/widgets/buttons/add_button.dart';
import 'package:crud_app/widgets/singular_product_view/comments_container.dart';
import 'package:crud_app/widgets/singular_product_view/product_container.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CommentsPage extends StatefulWidget {
  final String _accessToken;
  final Product product;
  final ProductService productService;
  final Function backMethod;

  const CommentsPage(
      {super.key,
      required String accessToken,
      required this.productService,
      required this.product,
      required this.backMethod})
      : _accessToken = accessToken;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final Logger logger = Logger();
  List<Comment> comments = [];
  late final CommentService commentService;

  @override
  void initState() {
    super.initState();
    commentService = CommentService(
        widget._accessToken, widget.product.id, widget.productService, reload);
    fetchComments();
  }

  Future<void> fetchComments() async {
    var commentsData = await commentService.fetchComments(widget.product.id);
    setState(() {
      comments = commentsData;
    });
  }

  void reload() {
    setState(() {
      fetchComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    var product = widget.product;
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductContainer(
              imageUrl: product.imageUrl,
              title: product.title,
              description: product.description,
              creationDate: product.creationDate,
              user: product.creatorUserId,
            ),
            const SizedBox(height: 15),
            const Divider(color: white),
            const SizedBox(height: 15),
            const Text(
              "Comments",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  var comment = comments[index];
                  return CommentsContainer(
                    id: comment.id,
                    description: comment.description,
                    creationDate: comment.creationDate,
                    user: comment.creatorUserId,
                    editMethod: commentService.editComment,
                    deleteMethod: commentService.deleteComment,
                  );
                },
              ),
            )
          ],
        ),
      ),
      MyBackButton(onPressed: widget.backMethod),
      AddButton(onPressed: () {
        showDialog(
          context: context,
          builder: ((context) =>
              AddDialog(true, "Comment", commentService.addComment, null)),
        );
      })
    ]);
  }
}
