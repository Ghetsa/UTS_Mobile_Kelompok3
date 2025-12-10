import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/pengguna_model.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('users');

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // GET ALL USERS
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

  // GET DETAIL USER
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

  // CREATE USER (Auth + Firestore)
  Future<bool> addUser(User user, String password) async {
    try {
      // 1. Create user at Firebase Auth
      fb.UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      String uid = credential.user!.uid;

      // 2. Save user data to Firestore
      final data = user.toMap();
      data['uid'] = uid;
      data['created_at'] = FieldValue.serverTimestamp();
      data['updated_at'] = FieldValue.serverTimestamp();

      await _col.doc(uid).set(data);

      return true;
    } catch (e, st) {
      print('ERROR ADD USER: $e');
      print(st);
      return false;
    }
  }

  // UPDATE USER
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

  // DELETE ONLY FROM FIRESTORE (Auth delete harus pakai backend Admin SDK)
  Future<bool> deleteUser(String uid) async {
    try {
      await _col.doc(uid).delete();
      return true;
    } catch (e, st) {
      print('ERROR DELETE USER: $e');
      print(st);
      return false;
    }
  }
}
