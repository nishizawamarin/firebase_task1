import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore.collection('messages').orderBy('date').limit(10).snapshots();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    await _firestore.collection('messages').add(message);
  }
}
