import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: SearchBar(
        hintText: 'Search for instruments',
        leading: const Icon(Icons.search_rounded),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12),
        ),
        constraints: const BoxConstraints(minHeight: 42, maxHeight: 42),
      ),
    );
  }
}
