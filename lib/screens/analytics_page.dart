import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Firebase/AuthService.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _favoriteBooks = [];
  Map<String, int> totalPagesByDay = {};
  int _currentBookIndex = 0;
  int _totalTimeSpent = 0;
  int _finishedBookCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBooksFromFirestore();
  }

  Future<void> _loadBooksFromFirestore() async {
    User? user = _authService.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('bookStats')
            .doc(user.uid)
            .collection('books')
            .get();

        List<Map<String, dynamic>> books = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        Map<String, int> pagesByDay = {};

        for (var book in books) {
          var weeklyStats = book['weeklyStats'];
          if (weeklyStats is Map<String, dynamic>) {
            weeklyStats.forEach((day, stats) {
              if (stats is Map<String, dynamic> && stats['page'] != null) {
                int pageCount = (stats['page'] as num).toInt();

                pagesByDay.update(
                  day,
                  (existingPages) => existingPages + pageCount,
                  ifAbsent: () => pageCount,
                );
              }
            });
          }
        }

        setState(() {
          _favoriteBooks = books;
          totalPagesByDay = pagesByDay;

          _totalTimeSpent = books.fold(
            0,
            (sum, book) => sum + ((book['timeSpent'] ?? 0) as num).toInt(),
          );

          _finishedBookCount = books.fold(
            0,
            (count, book) => count + (book['finished'] == true ? 1 : 0),
          );

          print('Total Pages by Day: $totalPagesByDay');
        });
      } catch (e) {
        print('Error loading books: $e');
      }
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
        body: Center(
            child: Text(
                'Could not find any book realted data, did you add it from library tab first?')),
      );
    }

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
              const SizedBox(height: 16),
              _buildReadingProgress(),
              const SizedBox(height: 16),
              _buildWeeklyReadingChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.deepPurple[100],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                Icons.local_fire_department,
                'Current streak',
                AuthService.userStats["currentStreak"] ?? 0,
                Colors.red,
              ),
              _buildStatCard(
                Icons.emoji_events,
                'Best streak',
                AuthService.userStats["bestStreak"] ?? 0,
                Colors.deepOrange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                Icons.book,
                'Finished',
                _finishedBookCount,
                Colors.deepPurpleAccent,
              ),
              _buildStatCard(
                Icons.timer,
                'Reading time',
                _totalTimeSpent,
                Colors.blue,
              ),
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
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingProgress() {
    final currentBook = _favoriteBooks[_currentBookIndex];
    double readingProgress = (currentBook["readingProgress"] ?? 0).toDouble();
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
                  _favoriteBooks[_currentBookIndex]['title'],
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

  String _getFirestoreDayKey(int index) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[index % days.length];
  }

  String _getDayInitial(int index) {
    List<String> initials = ["M", "T", "W", "T", "F", "S", "S"];
    return initials[index % initials.length];
  }

  Widget _buildWeeklyReadingChart() {
    final maxPages = totalPagesByDay.values.isEmpty
        ? 1
        : totalPagesByDay.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Reading Chart', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              children: List.generate(7, (dayIndex) {
                String firestoreKey = _getFirestoreDayKey(dayIndex);

                int pagesReadOnThisDay = totalPagesByDay[firestoreKey] ?? 0;

                double progressFactor =
                    (pagesReadOnThisDay / maxPages).clamp(0.0, 1.0);

                String dayLabel = _getDayInitial(dayIndex);

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 20,
                        height: 150 * progressFactor,
                        color: _getColorForDay(dayIndex),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dayLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: List.generate(7, (dayIndex) {
              String firestoreKey = _getFirestoreDayKey(dayIndex);
              String dayLabel = _getDayInitial(dayIndex);
              int pagesReadOnThisDay = totalPagesByDay[firestoreKey] ?? 0;

              return Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: _getColorForDay(dayIndex),
                  ),
                  const SizedBox(width: 8),
                  Text(dayLabel, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    '$pagesReadOnThisDay pages',
                    style: const TextStyle(fontSize: 14),
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
