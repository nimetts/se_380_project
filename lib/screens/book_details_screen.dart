import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text(book['title'] ?? 'Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Book Title
            Text(
              book['title'] ?? 'No title available',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Author(s)
            Text(
              'Author(s): ${_getAuthors(book['authors'])}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // Average Rating
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 5),
                Text(
                  book['averageRating'] != null
                      ? book['averageRating'].toString()
                      : 'No ratings available',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Ratings Count
            Text(
              'Total Ratings: ${book['ratingsCount'] ?? '0'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get authors, handling both list and non-list values
  String _getAuthors(dynamic authors) {
    if (authors is List) {
      return authors.join(", ");
    } else {
      return authors ?? 'No author information available';
    }
  }
}
