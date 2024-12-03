import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  final String apiKey = 'AIzaSyALaf-OWZNNYcmem0yWLjPLIjtUOi5QNAg'; // our key!!

  Future<List<Map<String, dynamic>>> fetchBooksByCategory(String category) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=subject:$category&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List books = data['items'] ?? [];
      return books.map((book) {
        return {
          'title': book['volumeInfo']['title'] ?? 'No Title',
          'authors': book['volumeInfo']['authors']?.join(', ') ?? 'Unknown Author',
          'thumbnail': book['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
