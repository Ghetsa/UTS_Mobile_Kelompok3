import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_theme.dart';

class EditChannelPage extends StatefulWidget {
  final Map<String, String>? channel;

  const EditChannelPage({super.key, this.channel});

  @override
  State<EditChannelPage> createState() => _EditChannelPageState();
}

class _EditChannelPageState extends State<EditChannelPage> {
  late TextEditingController namaController;
  late TextEditingController tipeController;
  late TextEditingController nomorController;
  late TextEditingController pemilikController;
  late TextEditingController catatanController;

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
    namaController = TextEditingController(text: widget.channel?['nama'] ?? '');
    tipeController = TextEditingController(text: widget.channel?['tipe'] ?? '');
    nomorController = TextEditingController(text: widget.channel?['no'] ?? '');
    pemilikController =
        TextEditingController(text: widget.channel?['a/n'] ?? '');
    catatanController =
        TextEditingController(text: widget.channel?['catatan'] ?? '');
  }

  Future<void> _pickFile(bool isThumbnail) async {
    final filePicker =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePicker != null && filePicker.files.single.path != null) {
      setState(() {
        if (isThumbnail) {
          newThumbnailFile = File(filePicker.files.single.path!);
        } else {
          newQRFile = File(filePicker.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentTipe = tipeMap[tipeController.text.toLowerCase()];

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: Text(
          widget.channel == null
              ? "Tambah Transfer Channel"
              : "Edit Transfer Channel",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppTheme.putihFull),
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
                        widget.channel == null
                            ? "Tambah Channel Transfer"
                            : "Edit Channel Transfer",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildLabel("Nama Channel"),
                    _buildTextField(namaController, "Masukkan nama channel"),
                    const SizedBox(height: 16),
                    _buildLabel("Tipe Channel"),
                    _buildDropdown(
                        currentTipe ?? "", ["Bank", "E-Wallet", "Crypto"]),
                    const SizedBox(height: 16),
                    _buildLabel("Nomor Rekening / Akun"),
                    _buildTextField(nomorController, "Masukkan nomor",
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildLabel("Atas Nama"),
                    _buildTextField(pemilikController, "Masukkan nama pemilik"),
                    const SizedBox(height: 16),
                    _buildLabel("Thumbnail Channel"),
                    const SizedBox(height: 6),
                    _buildImagePicker(
                        newThumbnailFile, widget.channel?['thumbnail'], true),
                    const SizedBox(height: 20),
                    _buildLabel("QR Code"),
                    const SizedBox(height: 6),
                    _buildImagePicker(newQRFile, widget.channel?['qr'], false),
                    const SizedBox(height: 20),
                    _buildLabel("Catatan"),
                    _buildTextField(catatanController, "Masukkan catatan"),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          "Simpan",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.greenDark,
                          foregroundColor: AppTheme.putihFull,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            "nama": namaController.text,
                            "tipe": tipeController.text,
                            "no": nomorController.text,
                            "a/n": pemilikController.text,
                            "catatan": catatanController.text,
                            "thumbnailFile": newThumbnailFile,
                            "qrFile": newQRFile,
                          });
                        },
                      ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlue),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppTheme.abu.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppTheme.abu.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.abu.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.abu.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(14),
        onChanged: null, // Tetap read-only
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: AppTheme.hitam)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImagePicker(File? newFile, String? oldPath, bool isThumbnail) {
    return GestureDetector(
      onTap: () => _pickFile(isThumbnail),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: newFile != null
            ? Image.file(newFile, fit: BoxFit.cover)
            : Image.asset(
                oldPath ?? "assets/images/default.jpg",
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
