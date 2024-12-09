import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  SearchResultsScreen({required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Results')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            leading: Image.network(book['thumbnail']),
            title: Text(book['title']),
            subtitle: Text(book['authors']),
          );
        },
      ),
    );
  }
}
