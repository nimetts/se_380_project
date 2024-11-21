import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6FA),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildPage(
                  title: 'Discover Books that Speak to You',
                  imagePath: 'assets/wizard.png',
                  description:
                  'Let your next great read find you. Get personalized recommendations based on your favorite genres and moods.',
                ),
                _buildPage(
                  title: 'Start Reading Anytime, Anywhere',
                  imagePath: 'assets/reading.png',
                  description:
                  'Read on the go with our built-in reader. Adjust fonts, colors, and settings to make your reading experience perfect for you.',
                ),
                _buildPage(
                  title: 'Build Your Own Bookshelf',
                  imagePath: 'assets/bookshelf.png',
                  description:
                  'Curate your personal bookshelf. Save books you love, track your progress, and keep your library organized.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor:
                    _currentPage == index ? Colors.black : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String imagePath,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.merriweather(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Image.asset(
          imagePath,
          height: 250,
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            description,
            style: GoogleFonts.lora(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}