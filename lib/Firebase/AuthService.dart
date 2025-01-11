import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, dynamic> userStats = {};

  Future<UserCredential?> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  Future<void> addUserStatsToFirestore(User user) async {
    final docRef = _firestore.collection('bookStats').doc(user.uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final booksRef = docRef.collection('books');
      final booksSnapshot = await booksRef.get();

      if (booksSnapshot.docs.isEmpty) {
        await booksRef.add({
          'title': 'Book 1',
          'readingProgress': 0,
        });
        await booksRef.add({
          'title': 'Book 2',
          'readingProgress': 0,
        });
      }
    } else {
      await docRef.set({
        'bestStreak': 0,
        'currentStreak': 0,
        'finishedBooks': 0,
        'readingStats': [
          {
            'day': '2024-12-01',
            'page': 0,
            'readingTime': 0,
          },
          {
            'day': '2024-12-02',
            'page': 0,
            'readingTime': 0,
          },
        ],
      });

      final booksRef = docRef.collection('books');
      await booksRef.add({
        'title': 'Book 1',
        'readingProgress': 0,
      });
      await booksRef.add({
        'title': 'Book 2',
        'readingProgress': 0,
      });


      await docRef.set({
        'finishedBooks': 0,
      }, SetOptions(merge: true));
    }
  }

  Future<void> fetchUserStatsFromFirestore(User user) async {
    final docRef = _firestore.collection('bookStats').doc(user.uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      userStats = docSnapshot.data() ?? {};
      print("User fetched: $userStats");
    } else {
      print("No stats ");
      userStats = {};
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
