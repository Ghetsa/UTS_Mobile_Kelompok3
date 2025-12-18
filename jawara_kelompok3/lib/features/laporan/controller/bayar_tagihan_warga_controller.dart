import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/tagihan_warga_model.dart';

class BayarTagihanController {
  final CollectionReference<Map<String, dynamic>> _ref =
      FirebaseFirestore.instance.collection('tagihan');

  /// sanitize "20.000" / "Rp 20.000" -> "20000"
  String _onlyNumber(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> submitPembayaran(
    BuildContext context,
    TagihanWargaModel tagihan,
    String nominalInput,
    String catatanInput,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _snack(context, "Kamu belum login.", isError: true);
      return;
    }

    // ✅ validasi nominal
    final nominalClean = _onlyNumber(nominalInput.trim());
    if (nominalClean.isEmpty) {
      _snack(context, "Nominal tidak boleh kosong.", isError: true);
      return;
    }

    final nominalInt = int.tryParse(nominalClean);
    if (nominalInt == null || nominalInt <= 0) {
      _snack(context, "Nominal harus angka dan > 0.", isError: true);
      return;
    }

    // ✅ konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Pembayaran"),
        content: Text(
          "Yakin ingin mengirim pembayaran sebesar Rp $nominalClean untuk tagihan:\n\n"
          "${tagihan.iuran} • ${tagihan.kode} ?\n\n"
          "Status tagihan akan berubah menjadi 'Menunggu Verifikasi'.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, Kirim"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // ✅ ambil doc tagihan terbaru
      final docRef = _ref.doc(tagihan.id);
      final snap = await docRef.get();

      if (!snap.exists) {
        _snack(context, "Tagihan tidak ditemukan.", isError: true);
        return;
      }

      final data = snap.data() ?? {};
      final idKepala = (data['id_kepala_warga'] ?? '').toString().trim();

      // ✅ keamanan tambahan (meski rules sebaiknya juga membatasi)
      // Tagihan hanya boleh dibayar oleh kepala warga yang sesuai
      if (idKepala.isNotEmpty && idKepala != user.uid) {
        _snack(context, "Kamu tidak punya akses untuk tagihan ini.", isError: true);
        return;
      }

      final statusNow = (data['tagihanStatus'] ?? '').toString().toLowerCase().trim();
      if (statusNow == 'sudah dibayar') {
        _snack(context, "Tagihan ini sudah dibayar.", isError: true);
        return;
      }
      if (statusNow == 'menunggu verifikasi') {
        _snack(context, "Pembayaran sudah pernah dikirim. Menunggu verifikasi admin.", isError: true);
        return;
      }

      // ✅ update pembayaran (warga)
      await docRef.update({
        'nominalDibayar': nominalClean, // simpan string biar konsisten sama datamu
        'catatanPembayaran': catatanInput.trim(),
        'tanggalBayar': FieldValue.serverTimestamp(),
        'tagihanStatus': 'Menunggu Verifikasi',
        'pembayar_uid': user.uid, // opsional tapi berguna
        'updated_at': FieldValue.serverTimestamp(),
      });

      _snack(context, "✅ Pembayaran dikirim. Menunggu verifikasi admin.");

      // ✅ balik ke list dan trigger refresh (pakai Navigator.pop(context, true))
      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      _snack(context, "Gagal mengirim pembayaran: ${e.message ?? e.code}", isError: true);
    } catch (e) {
      _snack(context, "Gagal mengirim pembayaran: $e", isError: true);
    }
  }

  void _snack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
