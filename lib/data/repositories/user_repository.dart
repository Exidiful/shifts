import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shifts/data/models/user_model.dart';


class UserRepository {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(User user) async {
    await _usersCollection.doc(user.id).set(user.toFirestore());
  }

  Future<User?> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    return doc.exists ? User.fromFirestore(doc) : null;
  }

  Future<void> updateLastLogin(String userId) async {
    await _usersCollection.doc(userId).update({'lastLogin': FieldValue.serverTimestamp()});
  }
}
