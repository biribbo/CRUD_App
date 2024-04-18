import 'package:flutter/material.dart';

class CommentsContainer extends StatelessWidget {
  const CommentsContainer(
      {super.key,
      required this.id,
      required this.description,
      required this.creationDate,
      required this.user});

  final int id;
  final String description;
  final String creationDate;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text("ID: $id", style: const TextStyle(color: Colors.white)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                'Created ${DateTime.parse(creationDate)} by $user',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}
