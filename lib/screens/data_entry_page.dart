import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se_380_project/Firebase/AuthService.dart';
import 'favorites_manager.dart';

class DataEntryPage extends StatefulWidget {
  int get hourSpent => 0;
  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _totalPagesController = TextEditingController();

  String? _selectedBook;
  String? _selectedBookImage;
  int? _selectedBookPageCount;
  List<Map<String, dynamic>> _favoriteBooks = [];
  bool _isBookListVisible = false;

  // New field for day selection
  String? _selectedDayOfWeek;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await FavoritesManager().fetchFavorites();
    setState(() {
      _favoriteBooks = FavoritesManager().getFavorites();
      if (_favoriteBooks.isNotEmpty) {
        _selectedBook =
            _favoriteBooks[0]['title'];
        _selectedBookImage =
            _favoriteBooks[0]['thumbnail'];
        _selectedBookPageCount = _favoriteBooks[0]['pageCount'];// Set the default image
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isBookListVisible = !_isBookListVisible;
                      });
                    },
                    child: Text(_selectedBook ?? 'Select a Book'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[200],
                    ),
                  ),
                  Spacer(),
                  if (_selectedBookImage != null)
                    Image.network(
                      _selectedBookImage!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              if (_isBookListVisible)
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _favoriteBooks.length,
                    itemBuilder: (context, index) {
                      final book = _favoriteBooks[index];
                      String bookName = book['title'] ?? 'Untitled';
                      String bookImage = book['thumbnail'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBook = bookName;
                            _selectedBookImage = bookImage;
                            _isBookListVisible = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(bookImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              TextField(
                controller: _pagesController,
                decoration: InputDecoration(
                  labelText: 'Pages Read',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time Spent (in minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),


              // Dropdown for selecting the day of the week
              DropdownButton<String>(
                value: _selectedDayOfWeek,
                hint: Text('Select Day of the Week'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDayOfWeek = newValue;
                  });
                },
                items: [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _updateStats(context),
                child: Text('Update Stats'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateStats(BuildContext context) async {
    if (_selectedBook == null || _selectedBook!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a book!')),
      );
      return;
    }

    if (_selectedDayOfWeek == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a day of the week!')),
      );
      return;
    }

    int pagesRead = int.tryParse(_pagesController.text) ?? 0;
    int timeSpentInMinutes = int.tryParse(_timeController.text) ?? 0;
    int totalPages = _selectedBookPageCount ?? 1;


    final AuthService _authService = AuthService();
    User? user = _authService.currentUser;
    final _firestore = FirebaseFirestore.instance;

    if (user != null) {
      final docRef = _firestore.collection('bookStats').doc(user.uid);
      final booksRef = docRef.collection('books');

      final bookDoc = await booksRef.doc(_selectedBook).get();
      Map<String, dynamic> weeklyStats = bookDoc.data()?['weeklyStats'] ?? {};

      weeklyStats[_selectedDayOfWeek!] =  {
        "time" : timeSpentInMinutes,
        "page" :pagesRead
      };

      int pagesReadUpUntilNow = 0;

      weeklyStats.forEach((key, value) {
        if (value is Map<String, dynamic> && value['page'] != null) {
          pagesReadUpUntilNow += value['page'] as int;
        }
      });

      int totalTimeSpent = 0;

      weeklyStats.forEach((key, value) {
        if (value is Map<String, dynamic> && value['time'] != null) {
          totalTimeSpent += value['time'] as int;
        }
      });

      double readingProgress = (pagesReadUpUntilNow / totalPages) * 100;
      bool finish = pagesReadUpUntilNow == totalPages;

      if (bookDoc.exists) {
        await booksRef.doc(_selectedBook).update({
          'readingProgress': readingProgress,
          'weeklyStats': weeklyStats,
          'timeSpent': totalTimeSpent,
          'pagesRead': pagesReadUpUntilNow,
          'finished': finish
        });
      } else {
        await booksRef.doc(_selectedBook).set({
          'thumbnail': _selectedBookImage,
          'title': _selectedBook,
          'totalPage': totalPages,
          'readingProgress': readingProgress,
          'weeklyStats': weeklyStats,
          'timeSpent': totalTimeSpent,
          'pagesRead': pagesReadUpUntilNow,
          'finished': finish
        });
      }

      // If book progress is 100%, increment finished books count
      if (readingProgress == 100) {
        await docRef.update({
          'finishedBooks': FieldValue.increment(1),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stats updated successfully!')),
      );

      _pagesController.clear();
      _timeController.clear();
      _totalPagesController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in!')),
      );
    }
  }
}
