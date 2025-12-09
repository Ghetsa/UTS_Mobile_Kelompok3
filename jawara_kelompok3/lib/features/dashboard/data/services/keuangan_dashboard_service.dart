import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/keuangan_dashboard_model.dart';

class KeuanganService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Ambil SEMUA data:
  /// - pemasukan
  /// - pengeluaran
  /// - tagihan yang sudah dibayar
  Future<List<KeuanganModel>> getAllKeuangan() async {
    try {
      final pemasukanSnap = await _db.collection('pemasukan').get();
      final pengeluaranSnap = await _db.collection('pengeluaran').get();
      final tagihanSnap = await _db.collection('tagihan').get();

      final List<KeuanganModel> list = [];

      // Pemasukan
      for (final doc in pemasukanSnap.docs) {
        list.add(KeuanganModel.fromPemasukanDoc(doc));
      }

      // Pengeluaran
      for (final doc in pengeluaranSnap.docs) {
        list.add(KeuanganModel.fromPengeluaranDoc(doc));
      }

      // Tagihan (hanya yang sudah dibayar)
      for (final doc in tagihanSnap.docs) {
        final item = KeuanganModel.fromTagihanDoc(doc);
        if (item != null) list.add(item);
      }

      return list;
    } catch (e, st) {
      // debug di console
      // ignore: avoid_print
      print('❌ ERROR getAllKeuangan: $e');
      // ignore: avoid_print
      print(st);
      return [];
    }
  }
}
