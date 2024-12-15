import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = false;

  // Kitap arama fonksiyonu
  Future<void> searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _books = [];
    });

    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=10'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null) {
        setState(() {
          _books = data['items']
              .map<Map<String, dynamic>>((item) {
            final previewLink = item['volumeInfo']['previewLink'];
            return {
              'title': item['volumeInfo']['title'] ?? 'No Title',
              'authors': item['volumeInfo']['authors']?.join(', ') ?? 'Unknown',
              'previewLink': previewLink,
            };
          })
              .where((book) => book['previewLink'] != null && book['previewLink'].startsWith('http')) // Geçerli previewLink'leri al
              .toList();
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  // URL'yi tarayıcıda açmak için
  Future<void> openPreview(String? url) async {
    if (url == null) return; // Null kontrolü
    final uri = Uri.parse(url); // String'i Uri'ye dönüştürüyoruz

    try {
      // Check if the URL can be launched
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Tarayıcıda açmayı zorunlu yapar
        );
      } else {
        // Provide an error message if the URL cannot be launched
        throw 'Cannot launch URL: $url';
      }
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Search'),
        backgroundColor: Colors.purple[300],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a book',
                border: OutlineInputBorder(),
              ),
              onSubmitted: searchBooks,
            ),
          ),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text(book['authors']),
                  trailing: Icon(Icons.open_in_new, color: Colors.purple),
                  onTap: () {
                    openPreview(book['previewLink']); // Sadece geçerli linki aç
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}