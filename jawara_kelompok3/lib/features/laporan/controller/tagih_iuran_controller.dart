import 'package:flutter/material.dart';
import '../data/models/tagih_iuran_mode.dart';
import '../data/services/tagih_iuran_service.dart';
import '../../warga/data/services/keluarga_service.dart';
import '../../warga/data/models/keluarga_model.dart';

class TagihanController {
  final TagihIuranService _tagihanService = TagihIuranService();
  final KeluargaService _keluargaService = KeluargaService();

  // Mengambil data keluarga dengan status 'aktif'
  Future<List<KeluargaModel>> getActiveFamilies() async {
    return await _keluargaService.getActiveFamilies();
  }

  // Menambahkan tagihan baru
  Future<bool> addTagihan(Map<String, dynamic> data) async {
    return await _tagihanService.addTagihan(data);
  }

  // Tagih Iuran function
  Future<void> tagihIuran(String selectedIuran, String nominal) async {
    // Ambil keluarga yang statusnya 'aktif'
    List<KeluargaModel> keluargaList = await getActiveFamilies();

    // Cek apakah ada keluarga aktif
    if (keluargaList.isEmpty) {
      print("Tidak ada keluarga aktif");
      return;
    }

    // Loop untuk setiap keluarga yang aktif dan buatkan tagihan
    for (var keluarga in keluargaList) {
      final data = {
        "keluarga": keluarga.kepalaKeluarga,
        "status": "Aktif",
        "iuran": selectedIuran,
        "kode": "IUR-${DateTime.now().millisecondsSinceEpoch}",
        "nominal": nominal,
        "tagihanStatus": "Belum Dibayar", // Mengatur status tagihan
      };

      final success = await addTagihan(data);

      if (success) {
        print("Tagihan berhasil ditambahkan untuk keluarga ${keluarga.kepalaKeluarga}");
      } else {
        print("Gagal menambahkan tagihan untuk keluarga ${keluarga.kepalaKeluarga}");
      }
    }
  }
}
