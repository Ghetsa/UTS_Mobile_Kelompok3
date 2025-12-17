import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/keuangan_dashboard_model.dart';

class KeuanganService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<KeuanganModel>> getAllKeuangan() async {
    try {
      final pemasukanSnap = await _db.collection('pemasukan').get();
      final pengeluaranSnap = await _db.collection('pengeluaran').get();

      final List<KeuanganModel> list = [];

      for (final doc in pemasukanSnap.docs) {
        list.add(KeuanganModel.fromDoc(doc: doc, sumber: 'pemasukan'));
      }
      for (final doc in pengeluaranSnap.docs) {
        list.add(KeuanganModel.fromDoc(doc: doc, sumber: 'pengeluaran'));
      }

      return list;
    } catch (e, st) {
      // ignore: avoid_print
      print('❌ ERROR getAllKeuangan: $e');
      // ignore: avoid_print
      print(st);
      return [];
    }
  }
}
