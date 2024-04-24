import 'package:flutter/material.dart';

class YourPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const YourPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left,
              color: currentPage > 0 ? Colors.white : Colors.grey),
          onPressed:
              currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Text(
          '${currentPage + 1} / $totalPages',
          style: const TextStyle(color: Colors.white),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right,
              color: currentPage < totalPages - 1 ? Colors.white : Colors.grey),
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
