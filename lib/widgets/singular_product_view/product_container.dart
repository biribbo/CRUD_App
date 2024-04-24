import 'package:crud_app/theme/colours.dart';
import 'package:flutter/material.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.creationDate,
      required this.user});
  final String imageUrl;
  final String title;
  final String description;
  final String creationDate;
  final String? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(60 / 2),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 17, color: white)),
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Created ${DateTime.parse(creationDate).toString()} by ${user ?? "unknown"}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
