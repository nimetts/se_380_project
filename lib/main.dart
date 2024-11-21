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

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6FA),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // İlk ekran
          _buildPage(
            title: 'Discover Books that Speak to You',
            imagePath: 'assets/wizard.png',
            description:
            'Let your next great read find you. Get personalized recommendations based on your favorite genres and moods.',
          ),
          // İkinci ekran
          _buildPage(
            title: 'Start Reading Anytime, Anywhere',
            imagePath: 'assets/reading.png',
            description:
            'Read on the go with our built-in reader. Adjust fonts, colors, and settings to make your reading experience perfect for you.',
          ),
          // Üçüncü ekran
          _buildPage(
            title: 'Build Your Own Bookshelf',
            imagePath: 'assets/bookshelf.png',
            description:
            'Curate your personal bookshelf. Save books you love, track your progress, and keep your library organized.',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _previousPage,
            ),
            Row(
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
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _nextPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String imagePath, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.merriweather(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.asset(
          imagePath,
          height: 250,
        ),
        SizedBox(height: 20),
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
        SizedBox(height: 40),
      ],
    );
  }
}
