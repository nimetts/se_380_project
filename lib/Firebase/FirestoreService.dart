import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateReadingStats(String day, int page, int readingTime) async {
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('bookStats').doc(user.uid).update({
        'readingStats': FieldValue.arrayUnion([
          {'day': day, 'page': page, 'readingTime': readingTime}
        ]),
      });
    }
  }

  Stream<DocumentSnapshot> getUserStatsStream() {
    final user = _auth.currentUser;

    if (user != null) {
      return _firestore.collection('bookStats').doc(user.uid).snapshots();
    } else {
      throw Exception("No user is logged in");
    }
  }
}
