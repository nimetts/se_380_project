import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:se_380_project/Data/ReadingData.dart';

class ReadingProvider extends ChangeNotifier {
  int currentStreak = 0;
  int bestStreak = 0;
  int finishedBooks = 0;
  int readingTime = 0;
  double readingProgress = 0.0;
  List<Map<String, dynamic>> readingStats = [];
  List<Map<String, dynamic>> weeklyReadingStats = [];
  final String userID;

  ReadingProvider({required this.userID});

  Future<void> fetchReadingData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('bookStats')
          .doc(userID)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        currentStreak = data['currentStreak'] ?? 0;
        bestStreak = data['bestStreak'] ?? 0;
        finishedBooks = data['finishedBooks'] ?? 0;
        readingTime = data['readingTime'] ?? 0;
        readingProgress = data['readingProgress'] ?? 0.0;
        readingStats =
            List<Map<String, dynamic>>.from(data['readingStats'] ?? []);
        calculateWeeklyReadingStats();
        notifyListeners();
      }
    } catch (e) {
      print('error fetching data');
    }
  }

  void updateStreak(int minutes) {
    final currentDate = DateTime.now().toIso8601String().split("T")[0];
    final lastEntry = readingStats.isNotEmpty ? readingStats.last : null;
    if (lastEntry != null && lastEntry['day'] == currentDate) {
      lastEntry['minutes'] += minutes;
    } else {
      readingStats.add({'day': currentDate, 'minutes': minutes});
      currentStreak =
          lastEntry != null && lastEntry['minutes'] > 0 ? currentStreak + 1 : 1;
    }
    if (currentStreak > bestStreak) {
      bestStreak = currentStreak;
    }
    updateReadingData();
    notifyListeners();
  }

  void updateReadingTime(int minutes) {
    readingTime += minutes;
    FirebaseFirestore.instance.collection('bookStats').doc(userID).update({
      'readingTime': readingTime,
    });
    notifyListeners();
  }

  Future<void> updateReadingData() async {
    try {
      await FirebaseFirestore.instance
          .collection('bookStats')
          .doc(userID)
          .update({
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'finishedBooks': finishedBooks,
        'readingTime': readingTime,
        'readingProgress': readingProgress,
        'readingStats': readingStats,
      });
      calculateWeeklyReadingStats();
      notifyListeners();
    } catch (e) {
      print("Error updating reading data: $e");
    }
  }

  void updateReadingProgress(double progress) {
    readingProgress = progress;
    FirebaseFirestore.instance.collection('bookStats').doc(userID).update({
      'readingProgress': readingProgress,
    });
    notifyListeners();
  }

  void finishBook() {
    finishedBooks += 1;
    updateReadingData();
    notifyListeners();
  }

  void calculateWeeklyReadingStats() {
    weeklyReadingStats = List.generate(7, (index) {
      return {'day': index, 'hours': 0.0};
    });

    final today = DateTime.now();
    for (final entry in readingStats) {
      final entryDate = DateTime.parse(entry['day']);
      final difference = today.difference(entryDate).inDays;
      if (difference < 7) {
        final dayOfWeek = today.weekday - difference - 1;
        if (dayOfWeek >= 0 && dayOfWeek < 7) {
          weeklyReadingStats[dayOfWeek]['hours'] += entry['minutes'] / 60;
        }
      }
    }
  }
}
