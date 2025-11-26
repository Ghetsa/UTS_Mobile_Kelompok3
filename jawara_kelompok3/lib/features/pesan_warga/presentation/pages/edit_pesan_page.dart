import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/layout/sidebar.dart';

class EditAspirasi extends StatefulWidget {
  final Map<String, String> data;
  const EditAspirasi({super.key, required this.data});

  @override
  State<EditAspirasi> createState() => _EditAspirasiState();
}

class _EditAspirasiState extends State<EditAspirasi> {
  late TextEditingController judulController;
  late TextEditingController deskripsiController;
  String? selectedStatus;

  final List<String> statusList = [
    'Pending',
    'Diterima',
    'Ditolak',
  ];

  // Inisialisasi data awal
  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.data['judul']);
    deskripsiController = TextEditingController(text: widget.data['deskripsi']);
    selectedStatus = widget.data['status'];
  }

  // Membersihkan controller
  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  // Fungsi menyimpan perubahan
  void _updateAspirasi() {
    // Notifikasi berhasil diperbarui
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Aspirasi berhasil diperbarui!'),
        backgroundColor: AppTheme.greenMediumDark,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Mengembalikan data perubahan
    Navigator.pop(context, {
      'judul': judulController.text,
      'deskripsi': deskripsiController.text,
      'status': selectedStatus,
    });
  }

  // Tampilan halaman EditAspirasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          "Edit Aspirasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.putihFull,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shadowColor: AppTheme.blueExtraLight,
          color: AppTheme.putihFull,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul utama halaman
                Center(
                  child: Text(
                    "Edit Informasi Aspirasi Warga",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Judul Pesan
                _buildLabel("Judul Pesan"),
                _buildTextField(judulController, "Masukkan judul pesan"),
                const SizedBox(height: 16),

                // Deskripsi Pesan
                _buildLabel("Deskripsi Pesan"),
                _buildTextArea(deskripsiController, "Tuliskan deskripsi pesan"),
                const SizedBox(height: 16),

                // Dropdown Status
                _buildLabel("Status"),
                _buildDropdown(
                  value: selectedStatus,
                  items: statusList,
                  hint: "Pilih status",
                  onChanged: (val) => setState(() => selectedStatus = val),
                ),
                const SizedBox(height: 32),

                // Tombol Update
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.update_rounded),
                    label: const Text(
                      "Update",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.greenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: _updateAspirasi,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Label teks di atas input field
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  // Input 1 baris judul aspirasi
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppTheme.backgroundBlueWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1.5),
        ),
      ),
    );
  }

  // Input multiline deskripsi panjang
  Widget _buildTextArea(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppTheme.backgroundBlueWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1.5),
        ),
      ),
    );
  }

  // Dropdown status aspirasi
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlueWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.blueLight, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(14),
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: AppTheme.hitam),
            ),
          );
        }).toList(),
      ),
    );
  }
}
