import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaChannelController = TextEditingController();
  final TextEditingController _nomorRekeningController =
      TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? _selectedTipe;
  String? _qrFileName;
  String? _thumbnailFileName;

  File? _qrFile;
  File? _thumbFile;

  Uint8List? _qrBytes;
  Uint8List? _thumbBytes;

  @override
  void dispose() {
    _namaChannelController.dispose();
    _nomorRekeningController.dispose();
    _namaPemilikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<String?> _uploadFile({
    required Uint8List? bytes,
    required File? file,
    required String folder,
  }) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref("$folder/$fileName.jpg");

      UploadTask uploadTask;
      if (kIsWeb) {
        if (bytes == null) return null;
        uploadTask =
            ref.putData(bytes, SettableMetadata(contentType: "image/jpeg"));
      } else {
        if (file == null) return null;
        uploadTask = ref.putFile(file);
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("UPLOAD ERROR ($folder): $e");
      return null;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? qrUrl;
      String? thumbUrl;

      if (_qrBytes != null || _qrFile != null) {
        qrUrl = await _uploadFile(
            bytes: _qrBytes, file: _qrFile, folder: "qr_images");
        if (qrUrl == null) throw "Gagal upload QR";
      }

      if (_thumbBytes != null || _thumbFile != null) {
        thumbUrl = await _uploadFile(
            bytes: _thumbBytes, file: _thumbFile, folder: "thumbnails");
        if (thumbUrl == null) throw "Gagal upload Thumbnail";
      }

      await FirebaseFirestore.instance.collection("channel_transfer").add({
        "nama_channel": _namaChannelController.text,
        "tipe": _selectedTipe,
        "no_rekening": _nomorRekeningController.text,
        "nama_pemilik": _namaPemilikController.text,
        "catatan": _catatanController.text,
        "qr_url": qrUrl,
        "thumbnail_url": thumbUrl,
        "created_at": DateTime.now(),
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Channel berhasil ditambahkan!"),
          backgroundColor: AppTheme.greenMedium,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _handleReset();
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan: $e"),
          backgroundColor: AppTheme.redMedium,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleReset() {
    setState(() {
      _selectedTipe = null;
      _qrFileName = null;
      _thumbnailFileName = null;
      _qrFile = null;
      _thumbFile = null;
      _qrBytes = null;
      _thumbBytes = null;
    });
    _formKey.currentState!.reset();
    _namaChannelController.clear();
    _nomorRekeningController.clear();
    _namaPemilikController.clear();
    _catatanController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form berhasil di-reset!"),
        backgroundColor: AppTheme.greenMedium,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        final bytes = result.files.first.bytes;
        final name = result.files.first.name;
        if (type == 'qr') {
          _qrFileName = name;
          _qrBytes = bytes;
          if (!kIsWeb && result.files.first.path != null)
            _qrFile = File(result.files.first.path!);
        } else {
          _thumbnailFileName = name;
          _thumbBytes = bytes;
          if (!kIsWeb && result.files.first.path != null)
            _thumbFile = File(result.files.first.path!);
        }
      });
    }
  }

  Widget _buildTextFormField(String label, String hint,
      {required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppTheme.putih,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "$label wajib diisi" : null,
        ),
      ]),
    );
  }

  Widget _buildDropdownField(String label, String hint, String? value,
      List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppTheme.putih,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          validator: (v) =>
              v == null || v.isEmpty ? "$label wajib dipilih" : null,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title:
            const Text("Tambah Channel", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Buat Channel Transfer Baru",
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextFormField("Nama Channel", "Masukkan nama channel",
                      controller: _namaChannelController),
                  _buildDropdownField(
                      "Tipe Channel",
                      "-- Pilih Tipe --",
                      _selectedTipe,
                      ["bank", "ewallet", "qris", "lainnya"],
                      (v) => setState(() => _selectedTipe = v)),
                  _buildTextFormField("Nomor Rekening / Akun", "Masukkan nomor",
                      controller: _nomorRekeningController,
                      keyboardType: TextInputType.number),
                  _buildTextFormField("Nama Pemilik", "Masukkan nama pemilik",
                      controller: _namaPemilikController),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload QR",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 8),
                          InputDecorator(
                            decoration: BoxDecoration(
                              color: AppTheme.putih,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.transparent),
                            ).toInputDecoration(),
                            child: Row(
                              children: [
                                Expanded(
                                    child:
                                        Text(_qrFileName ?? "Belum ada file")),
                                IconButton(
                                    icon: const Icon(Icons.upload),
                                    onPressed: () => _pickFile('qr')),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload Thumbnail",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 8),
                          InputDecorator(
                            decoration: BoxDecoration(
                              color: AppTheme.putih,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.transparent),
                            ).toInputDecoration(),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(_thumbnailFileName ??
                                        "Belum ada file")),
                                IconButton(
                                    icon: const Icon(Icons.upload),
                                    onPressed: () => _pickFile('thumbnail')),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  _buildTextFormField("Catatan (Opsional)", "Masukkan catatan",
                      controller: _catatanController),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.greenDark,
                            foregroundColor: AppTheme.putihFull,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: const Text("Simpan",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redMediumDark,
                            foregroundColor: AppTheme.putihFull,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          child: const Text("Reset",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
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
    );
  }
}

extension BoxDecorationExtension on BoxDecoration {
  InputDecoration toInputDecoration() => InputDecoration(
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
          borderRadius:
              borderRadius?.resolve(TextDirection.ltr) ?? BorderRadius.zero,
          borderSide: border == null
              ? BorderSide.none
              : const BorderSide(color: Colors.transparent),
        ),
      );
}
