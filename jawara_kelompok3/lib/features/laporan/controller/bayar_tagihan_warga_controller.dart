import 'package:flutter/material.dart';
import '../data/models/tagihan_warga_model.dart';
import '../data/services/tagihan_warga_service.dart';
import '../controller/bayar_tagihan_warga_controller.dart';
import '../controller/tagihan_warga_controller.dart';

class BayarTagihanController {
  final TagihanController _controller = TagihanController();

  Future<bool> bayarTagihan(TagihanWargaModel tagihan, String nominal, String catatan) async {
    try {
      // Temporary local implementation to avoid compile error.
      // Replace this with the real call to TagihanController when available.
      await Future.delayed(const Duration(milliseconds: 500));
      return true; // For now, we return true (payment successful).
    } catch (e) {
      print('Error during payment: $e');
      return false; // If any error occurs
    }
  }

  Future<void> submitPembayaran(BuildContext context, TagihanWargaModel tagihan, String nominal, String catatan) async {
    final formKey = GlobalKey<FormState>();

    if (!formKey.currentState!.validate()) return;

    // Konfirmasi sebelum submit
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Apakah Anda yakin ingin mengkonfirmasi pembayaran sebesar Rp $nominal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Ya, Konfirmasi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      bool success = await bayarTagihan(tagihan, nominal, catatan);

      if (success) {
        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
                const SizedBox(width: 12),
                const Text('Berhasil'),
              ],
            ),
            content: const Text(
              'Pembayaran berhasil dikonfirmasi. Status tagihan Anda telah diperbarui.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return to list with refresh
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
