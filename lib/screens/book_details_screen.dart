import 'package:flutter/material.dart';
import 'favorites_manager.dart';
import 'book_search_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  BookDetailsScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoritesManager().isFavorite(book);

    return Scaffold(
      backgroundColor: const Color(0xffE6E6FA),
      appBar: AppBar(
        backgroundColor: Color(0xff8C7BB7),
        title: Text(
          book['title'] ?? 'Book Details',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 8,
        shadowColor: Colors.purple.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kitap görseli
              Center(
                child: Container(
                  height: 250,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book['thumbnail'] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Kitap başlığı
              Text(
                book['title'] ?? 'No title available',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xff4A2C2A),
                ),
              ),
              SizedBox(height: 10),

              // Yazar bilgisi
              Text(
                'Author(s): ${_getAuthors(book['authors'])}',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Puanlama
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 5),
                  Text(
                    book['averageRating'] != null
                        ? book['averageRating'].toString()
                        : 'No ratings available',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Text(
                'Total Ratings: ${book['ratingsCount'] ?? '0'}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),

              // Özet
              Text(
                'Synopsis: ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                book['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
              ),
              SizedBox(height: 30),

              // Favorilere ekleme/çıkarma butonu
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isFavorite) {
                      FavoritesManager().removeFromFavorites(book);
                    } else {
                      FavoritesManager().addToFavorites(book);
                    }
                    (context as Element).markNeedsBuild();
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFavorite ? Colors.red[400] : Color(0xffC8C8FF),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Yeni eklenen buton

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookSearchScreen()),
                    );
                  },
                  icon: Icon(Icons.search, color: Colors.white),
                  label: Text('Go to Book Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffC8C8FF),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  String _getAuthors(dynamic authors) {
    if (authors is List) {
      return authors.join(", ");
    } else {
      return authors ?? 'No author information available';
    }
  }
}
