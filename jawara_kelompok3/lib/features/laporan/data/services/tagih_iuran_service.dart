import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagih_iuran_mode.dart';

class TagihIuranService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('tagihan');

  Future<bool> addTagihan(Map<String, dynamic> data) async {
    try {
      await _ref.add({
        ...data,
        'created_at': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('ERROR add Tagihan: $e');
      return false;
    }
  }
}
