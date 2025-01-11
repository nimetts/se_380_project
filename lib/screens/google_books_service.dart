import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  final String apiKey = 'AIzaSyALaf-OWZNNYcmem0yWLjPLIjtUOi5QNAg'; // our key!!
  final String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Map<String, dynamic>>> fetchBooksByQuery(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List books = data['items'] ?? [];
      return books.map((book) {
        return {
          'title': book['volumeInfo']['title'] ?? 'No Title',
          'authors': book['volumeInfo']['authors']?.join(', ') ?? 'Unknown Author',
          'thumbnail': book['volumeInfo']['imageLinks']?['thumbnail'] ?? '',
          'description': book['volumeInfo']['description'] ?? 'No description available',
          'pageCount': book['volumeInfo']['pageCount'] ?? 100
        };
      }).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Map<String, dynamic>> fetchRandomHighlight(String category) async {
    final books = await fetchBooksByCategory(category);
    books.shuffle();
    return books.first;
  }

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
          'description': book['volumeInfo']['description'] ?? 'No description available',
          'pageCount': book['volumeInfo']['pageCount'] ?? 100
        };
      }).toList();
    } else {
      throw Exception('Failed to load books for category $category');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPopularBooks() async {
    final url = Uri.parse('$_baseUrl?q=subject:fiction&maxResults=10');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> books = [];

      for (var item in data['items']) {
        final volumeInfo = item['volumeInfo'];
        final title = volumeInfo['title'];
        final authors = volumeInfo['authors']?.join(', ') ?? 'Unknown';
        final thumbnail = volumeInfo['imageLinks']?['thumbnail'] ?? '';
        final ratingsCount = item['volumeInfo']['ratingsCount'] ?? 0;
        final averageRating = item['volumeInfo']['averageRating'] ?? 0.0;
        final pageCount = item['volumeInfo']['pageCount'] ?? 100;
        final description = volumeInfo['description'] ?? 'No description available';

        books.add({
          'title': title,
          'authors': authors,
          'thumbnail': thumbnail,
          'ratingsCount': ratingsCount,
          'averageRating': averageRating,
          'description': description,
          'pageCount': pageCount
        });
      }

      books.sort((a, b) {
        if (b['ratingsCount'] == a['ratingsCount']) {
          return b['averageRating'].compareTo(a['averageRating']);
        }
        return b['ratingsCount'].compareTo(a['ratingsCount']);
      });

      return books;
    } else {
      throw Exception('Failed to load popular books');
    }
  }
}
