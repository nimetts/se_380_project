import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:se_380_project/screens/home_screen.dart';

class categoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE6E6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
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
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(categories.length, (index) {
                  return CategoryTile(
                    imageUrl: categories[index]['imageUrl']!,
                    title: categories[index]['title']!,
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()));
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CategoryTile({required this.imageUrl, required this.title});

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
