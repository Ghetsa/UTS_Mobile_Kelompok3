import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../Theme/app_theme.dart';
import 'daftar_channel.dart';
import '../../main.dart';

class EditChannelPage extends StatefulWidget {
  final Map<String, String> channel;

  const EditChannelPage({super.key, required this.channel});

  @override
  State<EditChannelPage> createState() => _EditChannelPageState();
}

class _EditChannelPageState extends State<EditChannelPage> {
  late TextEditingController namaController;
  late TextEditingController tipeController;
  late TextEditingController nomorController;
  late TextEditingController pemilikController;
  late TextEditingController catatanController;

  // File sementara thumbnail / QR
  File? newThumbnailFile;
  File? newQRFile;

  final Map<String, String> tipeMap = {
    'bank': 'Bank',
    'ewallet': 'E-Wallet',
    'crypto': 'Crypto',
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal dari widget.channel
    namaController = TextEditingController(text: widget.channel['nama'] ?? '');
    tipeController = TextEditingController(text: widget.channel['tipe'] ?? '');
    nomorController = TextEditingController(text: widget.channel['no'] ?? '');
    pemilikController =
        TextEditingController(text: widget.channel['a/n'] ?? '');
    catatanController =
        TextEditingController(text: widget.channel['catatan'] ?? '');
  }

  @override
  void dispose() {
    // Dispose semua controller
    namaController.dispose();
    tipeController.dispose();
    nomorController.dispose();
    pemilikController.dispose();
    catatanController.dispose();
    super.dispose();
  }

  void _saveChannel() {
    // Simulasi update data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data ${namaController.text} berhasil diperbarui!"),
        backgroundColor: AppTheme.greenMediumDark,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  // Fungsi untuk mereset semua field ke nilai awal
  void _resetFields() {
    setState(() {
      namaController.text = widget.channel['nama'] ?? '';
      tipeController.text = widget.channel['tipe'] ?? '';
      nomorController.text = widget.channel['no'] ?? '';
      pemilikController.text = widget.channel['a/n'] ?? '';
      catatanController.text = widget.channel['catatan'] ?? '';
      newThumbnailFile = null;
      newQRFile = null;
    });
  }

  // Fungsi untuk memilih file gambar
  Future<void> _pickFile(bool isThumbnail) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      print('Picked file path: ${result.files.single.path}');
      setState(() {
        if (isThumbnail) {
          newThumbnailFile = File(result.files.single.path!);
        } else {
          newQRFile = File(result.files.single.path!);
        }
      });
    } else {
      print('No file picked or path is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil value tipe sesuai map untuk menghindari error dropdown
    String? currentTipe = tipeMap[tipeController.text.toLowerCase()];

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text(
          "Edit Transfer Channel",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppTheme.putihFull),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryBlue,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shadowColor: AppTheme.blueExtraLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Edit Informasi Transfer Channel",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Nama Channel
                    _buildLabel("Nama Channel"),
                    _buildTextField(namaController, "Masukkan nama channel"),
                    const SizedBox(height: 16),

                    // Tipe Channel (Dropdown)
                    _buildLabel("Tipe Channel"),
                    DropdownButtonFormField<String>(
                      value: currentTipe,
                      items: const [
                        DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                        DropdownMenuItem(
                            value: 'E-Wallet', child: Text('E-Wallet')),
                        DropdownMenuItem(
                            value: 'Crypto', child: Text('Crypto')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          tipeController.text = val ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppTheme.lightBlue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: AppTheme.blueLight, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nomor Rekening / Akun
                    _buildLabel("Nomor Rekening / Akun"),
                    _buildTextField(
                      nomorController,
                      "Masukkan nomor rekening",
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Nama Pemilik
                    _buildLabel("Atas Nama"),
                    _buildTextField(pemilikController, "Masukkan nama pemilik"),
                    const SizedBox(height: 16),

                    // Thumbnail
                    _buildLabel("Thumbnail Channel"),
                    const SizedBox(height: 6),
                    _buildImagePicker(
                      label: "Logo saat ini:",
                      file: newThumbnailFile,
                      defaultImagePath: widget.channel['thumbnail'] ??
                          'assets/images/default.jpg',
                      onTap: () => _pickFile(true),
                    ),

                    const SizedBox(height: 16),

                    // QR
                    _buildImagePicker(
                      label: "QR saat ini:",
                      file: newQRFile,
                      defaultImagePath: widget.channel['qr'] ??
                          'assets/images/default_qr.png',
                      onTap: () => _pickFile(false),
                    ),

                    const SizedBox(height: 16),

                    // Catatan
                    _buildLabel("Catatan (Opsional)"),
                    _buildTextField(catatanController, "Masukkan catatan"),
                    const SizedBox(height: 32),

                    // Tombol Simpan & Reset
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            label: const Text(
                              "Simpan",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.greenDark,
                              foregroundColor: AppTheme.putihFull,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: _saveChannel,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              "Reset",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.redMediumDark,
                              foregroundColor: AppTheme.putihFull,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: _resetFields,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan label di atas input field
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  // Widget untuk membuat TextField dengan berbagai opsi
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: readOnly ? AppTheme.abu : AppTheme.lightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan preview image dan picker
  Widget _buildImagePicker({
    required String label,
    required VoidCallback onTap,
    File? file,
    String? defaultImagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.blueDark,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.blueLight, width: 1),
            ),
            child: file != null
                ? Image.file(file, fit: BoxFit.contain)
                : Image.asset(
                    defaultImagePath ?? 'assets/images/default.jpg',
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ],
    );
  }
}
