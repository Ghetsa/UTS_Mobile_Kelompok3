import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final String docId;
  final String aktivitas;
  final String role;
  final DateTime tanggal;

  Log({
    required this.docId,
    required this.aktivitas,
    required this.role,
    required this.tanggal,
  });

  // Dari Firestore document
  factory Log.fromFirestore(String id, Map<String, dynamic> data) {
    return Log(
      docId: id,
      aktivitas: data['aktivitas'] ?? '-',
      role: data['role'] ?? 'user',
      tanggal: (data['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Untuk menyimpan ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'aktivitas': aktivitas,
      'role': role,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
