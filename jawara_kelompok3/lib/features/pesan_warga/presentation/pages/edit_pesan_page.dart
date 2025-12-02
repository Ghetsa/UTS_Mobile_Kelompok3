import 'package:flutter/material.dart';
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

  final List<String> statusList = [
    'Pending',
    'Diterima',
    'Ditolak',
  ];

  @override
  void initState() {
    super.initState();
    isiController = TextEditingController(text: widget.model.isiPesan);
    kategoriController = TextEditingController(text: widget.model.kategori);
    selectedStatus = widget.model.status;
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
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memperbarui aspirasi."),
          backgroundColor: AppTheme.redMedium,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text("Edit Aspirasi",
            style: TextStyle(color: AppTheme.putihFull)),
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shadowColor: AppTheme.blueLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Isi Aspirasi"),
                _buildTextArea(isiController, "Tulis isi aspirasi..."),
                const SizedBox(height: 16),

                _buildLabel("Kategori"),
                _buildTextField(kategoriController, "Contoh: Infrastruktur"),
                const SizedBox(height: 16),

                _buildLabel("Status"),
                _buildDropdown(
                  value: selectedStatus,
                  items: statusList,
                  hint: "Pilih status",
                  onChanged: (val) => setState(() => selectedStatus = val),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updateAspirasi,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Perubahan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.greenDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            )),
      );

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppTheme.backgroundBlueWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hint) {
    return TextField(
      maxLines: 4,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppTheme.backgroundBlueWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlueWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.blueLight),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint),
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
