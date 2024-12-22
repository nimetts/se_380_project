import 'package:flutter/material.dart';
import 'favorites_manager.dart';
import 'book_details_screen.dart';
import 'home_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteBooks = FavoritesManager().getFavorites();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(booksByCategory: {},)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff8C7BB7),
          title: const Text(
            'Your Favorites',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8C7BB7), Color(0xffE6E6FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: favoriteBooks.isEmpty
              ? Center(
            child: Text(
              'No books in your favorites yet!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 120,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  book['thumbnail'] ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              book['title'] ?? 'Untitled',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
