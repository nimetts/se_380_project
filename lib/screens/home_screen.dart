import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> booksByCategory;

  HomeScreen({required this.booksByCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: booksByCategory.isEmpty
            ? Center(
          child: Text(
            "No books found. Please select some categories.",
            style: TextStyle(fontSize: 16),
          ),
        )
            : ListView(
          children: booksByCategory.entries.map((entry) {
            final category = entry.key;
            final books = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Container(
                        width: 120,
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: book['thumbnail'] != null
                                  ? Image.network(
                                book['thumbnail'],
                                fit: BoxFit.cover,
                              )
                                  : Image.asset(
                                "assets/book_placeholder.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              book['title'] ?? 'No Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16), // spacing between categories
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
