import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:se_380_project/screens/data_entry_page.dart';
import '../Firebase/AuthService.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _favoriteBooks = [];
  int _currentBookIndex = 0;
  int a = 0;

  @override
  void initState() {
    super.initState();
    _loadBooksFromFirestore();
  }

  Future<void> _loadBooksFromFirestore() async {
    User? user = _authService.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('bookStats')
          .doc(user.uid)
          .collection('books')
          .get();

      setState(() {
        _favoriteBooks = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_favoriteBooks.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: Text('No favorite books found.')),
      );
    }

    final currentBook = _favoriteBooks[_currentBookIndex];
    final bookTitle = currentBook['title'] ?? 'Unknown Title';
    final bookThumbnail = currentBook['thumbnail'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 16),
              _buildReadingProgress(bookTitle, bookThumbnail),
              SizedBox(height: 16),
              _buildWeeklyReadingChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurple[100]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(Icons.local_fire_department, 'Current streak',
                  AuthService.userStats["currentStreak"] ?? 0, Colors.red),
              _buildStatCard(Icons.emoji_events, 'Best streak',
                  AuthService.userStats["bestStreak"] ?? 0, Colors.deepOrange),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                  Icons.book,
                  'Finished',
                 a,
                  Colors.deepPurpleAccent),
              _buildStatCard(Icons.timer, 'Reading time',
                  DataEntryPage().hourSpent, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, int value, Color color) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),
          Text(value.toString(),
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReadingProgress(String bookTitle, String bookThumbnail) {
    final currentBook = _favoriteBooks[_currentBookIndex];
    double readingProgress = (currentBook["readingProgress"] ?? 0).toDouble();
    if (readingProgress > 100 || readingProgress == 100) {
      a++;
    }
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reading Progress', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  bookTitle,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: readingProgress.clamp(0.0, 100.0),
            min: 0,
            max: 100,
            divisions: 100,
            label: '${readingProgress.toStringAsFixed(0)}%',
            onChanged: (double value) {
              setState(() {
                readingProgress = value.clamp(0.0, 100.0);
                _updateBookProgress(currentBook, readingProgress);
              });
            },
          ),
          const SizedBox(height: 8),
          Text('${readingProgress.toStringAsFixed(2)}% completed'),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentBookIndex > 0
                  ? IconButton(
                      icon: Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          _currentBookIndex--;
                        });
                      },
                    )
                  : SizedBox(),
              _currentBookIndex < _favoriteBooks.length - 1
                  ? IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          _currentBookIndex++;
                        });
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyReadingChart() {
    Map<String, List<Map<String, dynamic>>> dailyBooks = {};

    // Organize books by the day they were read
    for (var book in _favoriteBooks) {
      String readDay = book["readDay"] ?? '';
      if (!dailyBooks.containsKey(readDay)) {
        dailyBooks[readDay] = [];
      }
      dailyBooks[readDay]!.add(book);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Reading Chart', style: TextStyle(fontSize: 18)),
          SizedBox(
            height: 200,
            child: Row(
              children: List.generate(7, (dayIndex) {
                String day = _getDayInitial(dayIndex);
                List<Map<String, dynamic>> booksOnThisDay =
                    dailyBooks[day] ?? [];

                double totalProgress = 0;
                int booksReadOnThisDay = booksOnThisDay.length;

                // Calculate total progress for the day
                for (var book in booksOnThisDay) {
                  double progress = (book["readingProgress"] ?? 0).toDouble();
                  totalProgress += progress;
                }

                double averageProgress = booksReadOnThisDay > 0
                    ? totalProgress / booksReadOnThisDay
                    : 0;

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 20,
                    color: _getColorForDay(dayIndex),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: averageProgress / 100,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16),
          Column(
            children: List.generate(7, (dayIndex) {
              String day = _getDayInitial(dayIndex);
              List<Map<String, dynamic>> booksOnThisDay = dailyBooks[day] ?? [];
              int booksReadOnThisDay = booksOnThisDay.length;

              return Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: _getColorForDay(dayIndex),
                  ),
                  SizedBox(width: 8),
                  Text(day, style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text(
                    '$booksReadOnThisDay books',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getColorForDay(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }

  String _getDayInitial(int index) {
    List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
    return days[index % days.length];
  }

  Future<void> _updateBookProgress(
      Map<String, dynamic> book, double progress) async {
    User? user = _authService.currentUser;

    if (progress >= 100) {
      await _firestore.collection('bookStats').doc(user?.uid).update({
        'finishedBooks': FieldValue.increment(1),
      });

      await _firestore
          .collection('bookStats')
          .doc(user?.uid)
          .collection('books')
          .doc(book['id'])
          .delete();

      setState(() {
        _favoriteBooks.remove(book);
      });
    } else {
      await _firestore
          .collection('bookStats')
          .doc(user?.uid)
          .collection('books')
          .doc(book['id'])
          .update({
        'readingProgress': progress,
      });
    }
  }
}
