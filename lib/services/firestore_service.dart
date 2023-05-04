import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessagesStream({int limit = 10}) {
    return Stream.empty();
  }

  Future<void> addMessage(Map<String, dynamic> message) async {
    await _firestore.collection('messages').add(message);
  }
}
