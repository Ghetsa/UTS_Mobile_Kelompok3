import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
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

  final List<String> tipeItems = ["Bank", "E-Wallet", "Qris"];

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.channel?['nama'] ?? '');
    tipeController = TextEditingController(
        text: tipeItems.firstWhere(
            (e) =>
                e.toLowerCase() ==
                (widget.channel?['tipe'] ?? '').toLowerCase(),
            orElse: () => 'Bank'));
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
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: widget.channel == null ? "Tambah Channel" : "Edit Channel",
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
                            widget.channel == null
                                ? "Tambah Channel Transfer"
                                : "Edit Channel Transfer",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF48B0E0)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildField("Nama Channel", namaController),
                        _buildDropdownField(
                            "Tipe Channel", tipeController.text, tipeItems),
                        _buildField("Nomor Rekening / Akun", nomorController,
                            keyboardType: TextInputType.number),
                        _buildField("Atas Nama", pemilikController),
                        _buildImagePickerField(
                            "Thumbnail Channel",
                            newThumbnailFile,
                            widget.channel?['thumbnail'],
                            true),
                        _buildImagePickerField(
                            "QR Code", newQRFile, widget.channel?['qr'], false),
                        _buildField("Catatan", catatanController, maxLines: 3),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF48B0E0),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                child: const Text(
                                  "Kembali",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
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
            keyboardType: keyboardType,
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

  Widget _buildDropdownField(String label, String value, List<String> items) {
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
              value: value,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    tipeController.text = val;
                  });
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerField(
      String label, File? file, String? oldPath, bool isThumbnail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickFile(isThumbnail),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: file != null
                  ? Image.file(file, fit: BoxFit.cover)
                  : Image.asset(oldPath ?? "assets/images/default.jpg",
                      fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
