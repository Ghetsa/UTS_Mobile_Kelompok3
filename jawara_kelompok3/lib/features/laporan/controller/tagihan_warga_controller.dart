import 'package:flutter/material.dart';
import '../data/services/tagihan_warga_service.dart';
import '../data/models/tagihan_warga_model.dart';

class TagihanWargaController {
  final TagihanWargaService _service = TagihanWargaService();

  Future<List<TagihanWargaModel>> getTagihanWarga(String keluargaId) async {
    return await _service.getTagihanWarga(keluargaId);
  }

  Future<bool> bayarTagihan(
      BuildContext context, String tagihanId, String nominal, String catatan) async {
    bool success = await _service.bayarTagihan(tagihanId, nominal, catatan);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tagihan berhasil dibayar')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membayar tagihan'), backgroundColor: Colors.red),
      );
    }
    return success;
  }
}

