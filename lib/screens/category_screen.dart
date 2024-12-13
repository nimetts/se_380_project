import 'package:flutter/material.dart';

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
                      imageUrl: categories[index]['imageUrl']!,
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
                  for (String category in _selectedCategories) {
                    booksByCategory[category] =
                    await _googleBooksService.fetchBooksByCategory(category);
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(booksByCategory: booksByCategory),
                      )
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
  final String imageUrl;
  final String title;
  final bool isSelected;

  const CategoryTile({
    required this.imageUrl,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black.withOpacity(0.5),
            border: isSelected
                ? Border.all(
              color: Colors.blueAccent,
              width: 3.0,
            )
                : null,
          ),
        ),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

final List<Map<String, String>> categories = [
  {'imageUrl': 'lib/assets/Mystery.png', 'title': 'Mystery'},
  {'imageUrl': 'lib/assets/Fiction.jpg', 'title': 'Fiction'},
  {'imageUrl': 'lib/assets/Fantasy.png', 'title': 'Fantasy'},
  {'imageUrl': 'lib/assets/Romance.png', 'title': 'Romance'},
  {'imageUrl': 'lib/assets/Thriller.jpg', 'title': 'Thriller'},
  {'imageUrl': 'lib/assets/ScienceFiction.jpg', 'title': 'Science-Fiction'},
  {'imageUrl': 'lib/assets/Historical.jpg', 'title': 'Historical'},
  {'imageUrl': 'lib/assets/Dystopian.png', 'title': 'Dystopian'},
  {'imageUrl': 'lib/assets/YoungAdult.png', 'title': 'Young Adult'},
  {'imageUrl': 'lib/assets/Horror.jpg', 'title': 'Horror'},
  {'imageUrl': 'lib/assets/NonFiction.jpg', 'title': 'Non-Fiction'},
  {'imageUrl': 'lib/assets/Science.png', 'title': 'Science'},
];