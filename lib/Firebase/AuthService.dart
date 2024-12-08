import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    try {
      print(email + password);
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("here");
      throw Exception('login failed');
    }
  }

  Future<void> addUserStatsToFirestore(User user) async {
    final userDoc = await _firestore.collection('bookStats').doc(user.uid).set({
      'bestStreak': 0,
      'currentStreak': 0,
      'finishedBooks': 0,
      'readingProgress': 0,
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
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
