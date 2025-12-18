import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aktivitas_model.dart';

class LogService {
  final CollectionReference _logCollection =
      FirebaseFirestore.instance.collection('log_aktivitas');

  // Tambah log baru
  Future<void> tambahLog(Log log) async {
    await _logCollection.add(log.toFirestore());
  }

  // Ambil semua log
  Stream<List<Log>> getAllLogs() {
    return _logCollection.orderBy('tanggal', descending: true).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) =>
                Log.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
