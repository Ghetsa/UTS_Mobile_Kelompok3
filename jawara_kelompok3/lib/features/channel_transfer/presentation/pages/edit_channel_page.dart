import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

class EditChannelPage extends StatefulWidget {
  final Map<String, dynamic>? channel;

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

  String? _feedbackMessage;
  Color _feedbackColor = Colors.green;

  final List<String> tipeItems = ["Bank", "E-Wallet", "Qris"];
  final CloudinaryPublic cloudinary = CloudinaryPublic(
    'droup6ar3',
    'jawara_unsigned',
    cache: false,
  );

  @override
  void initState() {
    super.initState();
    namaController =
        TextEditingController(text: widget.channel?['nama_channel'] ?? '');
    tipeController = TextEditingController(
        text: tipeItems.firstWhere(
            (e) =>
                e.toLowerCase() ==
                (widget.channel?['tipe'] ?? '').toString().toLowerCase(),
            orElse: () => 'Bank'));
    nomorController =
        TextEditingController(text: widget.channel?['no_rekening'] ?? '');
    pemilikController =
        TextEditingController(text: widget.channel?['nama_pemilik'] ?? '');
    catatanController =
        TextEditingController(text: widget.channel?['catatan'] ?? '');
  }

  void _pickFile(bool isThumbnail) async {
    final filePicker =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (filePicker != null && filePicker.files.single.path != null) {
      final path = filePicker.files.single.path!;
      setState(() {
        if (isThumbnail) {
          newThumbnailFile = File(path);
        } else {
          newQRFile = File(path);
        }
      });
    }
  }

  Future<String?> _uploadToCloudinary(File file) async {
    try {
      CloudinaryResponse response =
          await cloudinary.uploadFile(CloudinaryFile.fromFile(file.path));
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveChannel() async {
    String? thumbnailUrl = widget.channel?['thumbnail_url'];
    String? qrUrl = widget.channel?['qr_url'];

    setState(() {
      _feedbackMessage = null; // reset feedback
    });

    try {
      if (newThumbnailFile != null) {
        String? url = await _uploadToCloudinary(newThumbnailFile!);
        if (url != null) thumbnailUrl = url;
      }
      if (newQRFile != null) {
        String? url = await _uploadToCloudinary(newQRFile!);
        if (url != null) qrUrl = url;
      }

      if (widget.channel != null && widget.channel!['docId'] != null) {
        await FirebaseFirestore.instance
            .collection('channel_transfer')
            .doc(widget.channel!['docId'])
            .update({
          'nama_channel': namaController.text,
          'tipe': tipeController.text,
          'no_rekening': nomorController.text,
          'nama_pemilik': pemilikController.text,
          'catatan': catatanController.text,
          'thumbnail_url': thumbnailUrl,
          'qr_url': qrUrl,
        });

        // Kirim feedback ke halaman daftar channel
        Navigator.pop(context, {
          "status": "success",
          "message": "Data channel ${namaController.text} berhasil diperbarui!",
          "nama_channel": namaController.text,
          "tipe": tipeController.text,
          "no_rekening": nomorController.text,
          "nama_pemilik": pemilikController.text,
          "catatan": catatanController.text,
          "thumbnail_url": thumbnailUrl,
          "qr_url": qrUrl,
        });
      } else {
        throw Exception("DocId tidak ditemukan.");
      }
    } catch (e) {
      // Kirim feedback gagal ke halaman daftar channel
      Navigator.pop(context, {
        "status": "error",
        "message": "Gagal menyimpan data channel: $e",
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
                            widget.channel?['thumbnail_url'],
                            true),
                        _buildImagePickerField("QR Code", newQRFile,
                            widget.channel?['qr_url'], false),
                        _buildField("Catatan", catatanController, maxLines: 3),
                        const SizedBox(height: 16),

                        // TOMBOL
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _saveChannel,
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
                  : (oldPath != null
                      ? Image.network(oldPath, fit: BoxFit.cover)
                      : Image.asset("assets/images/default.jpg",
                          fit: BoxFit.cover)),
            ),
          ),
        ],
      ),
    );
  }
}
