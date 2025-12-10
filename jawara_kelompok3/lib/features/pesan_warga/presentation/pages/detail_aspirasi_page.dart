import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pesan_warga_model.dart';

class DetailAspirasi extends StatelessWidget {
  final PesanWargaModel model;

  const DetailAspirasi({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Detail Aspirasi",
              showSearchBar: false,
              showFilterButton: false,
              onSearch: (_) {},
              onFilter: () {},
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Detail Aspirasi",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF48B0E0)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Detail field
                        _buildReadOnlyField("ID Pesan", model.idPesan),
                        _buildReadOnlyField("Nama", model.nama),
                        _buildReadOnlyField("Isi Pesan", model.isiPesan),
                        _buildReadOnlyField("Kategori", model.kategori),
                        _buildReadOnlyField("Status", model.status),
                        _buildReadOnlyField(
                            "Tanggal Dibuat",
                            model.createdAt != null
                                ? model.createdAt.toString()
                                : "-"),
                        _buildReadOnlyField(
                            "Terakhir Update",
                            model.updatedAt != null
                                ? model.updatedAt.toString()
                                : "-"),
                        const SizedBox(height: 24),
                        // Tombol Kembali
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48B0E0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            child: const Text(
                              "Kembali",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
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

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ]),
    );
  }
}
