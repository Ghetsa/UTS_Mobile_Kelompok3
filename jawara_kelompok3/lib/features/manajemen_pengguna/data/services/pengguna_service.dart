import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pengguna_model.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('users');

  // GET ALL
  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await _col.orderBy('created_at', descending: true).get();
      return snapshot.docs
          .map((doc) => User.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e, st) {
      print('ERROR GET ALL USERS: $e');
      print(st);
      return [];
    }
  }

  // GET DETAIL
  Future<User?> getDetail(String docId) async {
    try {
      final doc = await _col.doc(docId).get();
      if (!doc.exists) return null;

      return User.fromFirestore(doc.id, doc.data()!);
    } catch (e, st) {
      print('ERROR GET DETAIL USER: $e');
      print(st);
      return null;
    }
  }

  // CREATE
  Future<bool> addUser(User user) async {
    try {
      final map = user.toMap();
      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();

      await _col.add(map);
      return true;
    } catch (e, st) {
      print('ERROR ADD USER: $e');
      print(st);
      return false;
    }
  }

  // UPDATE
  Future<bool> updateUser(String docId, Map<String, dynamic> newData) async {
    try {
      newData['updated_at'] = FieldValue.serverTimestamp();

      await _col.doc(docId).update(newData);
      return true;
    } catch (e, st) {
      print('ERROR UPDATE USER: $e');
      print(st);
      return false;
    }
  }

  // DELETE
  Future<bool> deleteUser(String docId) async {
    try {
      await _col.doc(docId).delete();
      return true;
    } catch (e, st) {
      print('ERROR DELETE USER: $e');
      print(st);
      return false;
    }
  }
}
