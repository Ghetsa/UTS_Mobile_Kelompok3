import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../data/services/tagihan_service.dart';
import '../../../../../warga/data/models/keluarga_model.dart';
import '../../../../../warga/data/services/keluarga_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  String? selectedIuran;
  final List<String> iuranList = ["Agustusan", "Mingguan", "Bulanan"];
  final TagihanService _service = TagihanService();
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

    bool isSuccess = true; 

   
    for (var keluarga in keluargaData) {
      if (keluarga.statusKeluarga == "Aktif") {  
        final data = {
          "keluarga": keluarga.kepalaKeluarga, 
          "status": "Aktif",
          "iuran": selectedIuran!,
          "kode": "IUR-${keluarga.uid}", 
          "nominal": "100000", 
          "periode": selectedIuran!, 
          "tagihanStatus": "Belum Dibayar", 
          "tanggalTagih": Timestamp.now(), 
        };


        final success = await _service.add(data);

        if (!success) {
          isSuccess = false; 
          break; 
        }
      }
    }

    // Menampilkan pesan berdasarkan hasil
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tagihan berhasil ditambahkan")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan tagihan"), backgroundColor: Colors.red),
      );
    }

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
