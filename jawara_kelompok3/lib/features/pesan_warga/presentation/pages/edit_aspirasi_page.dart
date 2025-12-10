import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pesan_warga_model.dart';
import '../../data/services/pesan_warga_service.dart';

class EditAspirasi extends StatefulWidget {
  final PesanWargaModel model;

  const EditAspirasi({super.key, required this.model});

  @override
  State<EditAspirasi> createState() => _EditAspirasiState();
}

class _EditAspirasiState extends State<EditAspirasi> {
  late TextEditingController isiController;
  late TextEditingController kategoriController;
  String? selectedStatus;

  final PesanWargaService _service = PesanWargaService();
  final List<String> statusList = ['Pending', 'Diterima', 'Ditolak'];

  @override
  void initState() {
    super.initState();
    isiController = TextEditingController(text: widget.model.isiPesan);
    kategoriController = TextEditingController(text: widget.model.kategori);
    selectedStatus = widget.model.status.isNotEmpty ? widget.model.status : null;
  }

  @override
  void dispose() {
    isiController.dispose();
    kategoriController.dispose();
    super.dispose();
  }

  Future<void> _updateAspirasi() async {
    final success = await _service.updatePesan(widget.model.docId, {
      "isi_pesan": isiController.text,
      "kategori": kategoriController.text,
      "status": selectedStatus,
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aspirasi berhasil diperbarui!"),
          backgroundColor: AppTheme.greenMediumDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memperbarui aspirasi."),
          backgroundColor: AppTheme.redMedium,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
              title: "Edit Aspirasi",
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
                            "Edit Informasi Aspirasi",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF48B0E0)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField("Isi Aspirasi", isiController, maxLines: 4),
                        _buildTextField("Kategori", kategoriController),
                        _buildDropdownField("Status", selectedStatus, statusList),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateAspirasi,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF48B0E0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade400,
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
                        const SizedBox(height: 12),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF48B0E0), width: 2)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonFormField<String>(
              value: value != null && items.contains(value) ? value : null,
              hint: const Text("Pilih status"),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedStatus = val;
                });
              },
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
