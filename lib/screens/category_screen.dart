import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'google_books_service.dart';
import 'home_screen.dart';
import 'google_books_service.dart';
import 'home_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Set<String> _selectedCategories = {};
  final GoogleBooksService _googleBooksService = GoogleBooksService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xffE6E6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Which Categories best suit you?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index]['title']!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedCategories.contains(category)) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      });
                    },
                    child: CategoryTile(
                      title: category,
                      isSelected: _selectedCategories.contains(category),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  Map<String, List<Map<String, dynamic>>> booksByCategory = {};

                  // Fetch books for each selected category
                  for (String category in _selectedCategories) {
                    booksByCategory[category] =
                    await _googleBooksService.fetchBooksByCategory(category);
                  }

                  // Navigate to HomeScreen, passing the fetched books
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(booksByCategory: booksByCategory),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC8C8FF),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff333333),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryTile({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffC8C8FF),
        borderRadius: BorderRadius.circular(20.0),
        border: isSelected
            ? Border.all(
          color: Colors.blueAccent,
          width: 3.0,
        )
            : null,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

final List<Map<String, String>> categories = [
  {'title': 'Mystery'},
  {'title': 'Fiction'},
  {'title': 'Fantasy'},
  {'title': 'Romance'},
  {'title': 'Thriller'},
  {'title': 'Science-Fiction'},
  {'title': 'Historical'},
  {'title': 'Dystopian'},
  {'title': 'Young Adult'},
  {'title': 'Horror'},
  {'title': 'Non-Fiction'},
  {'title': 'Science'},
];
