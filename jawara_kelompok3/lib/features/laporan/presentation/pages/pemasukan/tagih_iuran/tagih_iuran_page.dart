import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../data/services/tagihan_service.dart';
import '../../../../../warga/data/models/keluarga_model.dart';
import '../../../../../warga/data/services/keluarga_service.dart';

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  String? selectedIuran;
  final List<String> iuranList = ["Agustusan", "Mingguan", "Bulanan"];
  final TagihanService _tagihanService = TagihanService();
  final KeluargaService _keluargaService = KeluargaService();

  Future<void> _tagihIuran() async {
    if (selectedIuran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih jenis iuran terlebih dahulu")),
      );
      return;
    }

    // Ambil semua keluarga yang ada di Firestore
    List<KeluargaModel> keluargaData = await _keluargaService.getDataKeluarga();

    for (var keluarga in keluargaData) {
      // Memeriksa status keluarga dan hanya menagih keluarga yang aktif
      if (keluarga.status_keluarga == "Aktif") {  // Change here to status_keluarga
        final data = {
          "keluarga": keluarga.kepalaKeluarga, // Ambil kepala keluarga atau data yang sesuai
          "status": "Aktif",
          "iuran": selectedIuran!,
          "kode": "IUR-${keluarga.uid}", // Buat kode tagihan yang unik
          "nominal": "100000", // Tentukan nominal sesuai dengan iuran
          "periode": selectedIuran!,
          "tagihanStatus": "Belum Dibayar",
        };

        // Simpan data tagihan untuk keluarga aktif
        final success = await _tagihanService.add(data);

        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menambahkan tagihan"), backgroundColor: Colors.red),
          );
          return;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tagihan berhasil ditambahkan")),
    );

    setState(() {
      selectedIuran = null; // Reset pilihan setelah berhasil
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Tagih Iuran",
              showSearchBar: false,
              showFilterButton: false,
            ),
            const SizedBox(height: 18),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tagih Iuran ke Semua Keluarga Aktif",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Jenis Iuran",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          value: selectedIuran,
                          hint: const Text("-- Pilih Iuran --"),
                          items: iuranList.map((iuran) {
                            return DropdownMenuItem(value: iuran, child: Text(iuran));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedIuran = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.blueSuperDark,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: _tagihIuran,
                              child: const Text("Tagih Iuran"),
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.blueSuperDark,
                                side: const BorderSide(color: AppTheme.blueSuperDark),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onPressed: () {
                                setState(() => selectedIuran = null);
                              },
                              child: const Text("Reset"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
