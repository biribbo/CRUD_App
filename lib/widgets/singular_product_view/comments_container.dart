import 'package:crud_app/widgets/dialogs/add_dialog.dart';
import 'package:flutter/material.dart';

class CommentsContainer extends StatelessWidget {
  const CommentsContainer(
      {super.key,
      required this.id,
      required this.description,
      required this.creationDate,
      required this.user,
      required this.editMethod,
      required this.deleteMethod});

  final int id;
  final String description;
  final String creationDate;
  final String? user;
  final Function editMethod;
  final Function deleteMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: $id", style: const TextStyle(color: Colors.white)),
                  Text(description,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 5),
                  Text(
                    'Created ${DateTime.parse(creationDate)} by ${user ?? "uknown"}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.grey,
                    iconSize: 20.0,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) =>
                              AddDialog(false, "Comment", editMethod, id)));
                    },
                  ),
                  IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.grey,
                      iconSize: 20.0,
                      onPressed: () {
                        deleteMethod(id);
                      }),
                ],
              ),
            )
          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}
