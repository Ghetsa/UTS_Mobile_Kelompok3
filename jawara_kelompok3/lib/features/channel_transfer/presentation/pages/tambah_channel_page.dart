import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<String?> _uploadToCloudinary({
    required Uint8List bytes,
    required String filename,
    required String tipeChannel,
    required String channelId,
    required String subfolder, // 'qr' atau 'thumbnail'
  }) async {
    try {
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/droup6ar3/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'jawara_unsigned'
        ..fields['folder'] =
            'channel_transfer/$tipeChannel/$channelId/$subfolder'
        ..files.add(
            http.MultipartFile.fromBytes('file', bytes, filename: filename));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'];
      } else {
        debugPrint("Cloudinary Error: $responseData");
        return null;
      }
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
    required bool success,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final channelId =
          FirebaseFirestore.instance.collection('channel_transfer').doc().id;

      String qrUrl = "";
      String thumbUrl = "";

      // ================= Upload QR =================
      if (_qrBytes != null && _qrFileName != null) {
        final ext = _qrFileName!.split('.').last.toLowerCase();
        final fileName =
            "${_namaChannelController.text.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.$ext";

        if (!['jpg', 'jpeg', 'png'].contains(ext)) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message: 'Format file QR harus JPG/PNG',
            success: false,
          );
          return;
        }

        if (_qrBytes!.lengthInBytes > 1024 * 1024) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message: 'Ukuran file QR maksimal 1MB',
            success: false,
          );
          return;
        }

        debugPrint(
            "Uploading QR: $fileName, size: ${_qrBytes!.lengthInBytes} bytes");

        final uploadedQrUrl = await _uploadToCloudinary(
          bytes: _qrBytes!,
          filename: fileName,
          tipeChannel: _selectedTipe ?? 'lainnya',
          channelId: channelId,
          subfolder: 'qr',
        );

        if (uploadedQrUrl == null) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message: 'Upload QR ke Cloudinary gagal. Cek preset dan koneksi.',
            success: false,
          );
          return;
        }
        qrUrl = uploadedQrUrl;
        debugPrint("QR uploaded: $qrUrl");
      }

      // ================= Upload Thumbnail =================
      if (_thumbBytes != null && _thumbnailFileName != null) {
        final ext = _thumbnailFileName!.split('.').last.toLowerCase();
        final fileName =
            "${_namaChannelController.text.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.$ext";

        if (!['jpg', 'jpeg', 'png'].contains(ext)) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message: 'Format file Thumbnail harus JPG/PNG',
            success: false,
          );
          return;
        }

        if (_thumbBytes!.lengthInBytes > 1024 * 1024) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message: 'Ukuran file Thumbnail maksimal 1MB',
            success: false,
          );
          return;
        }

        debugPrint(
            "Uploading Thumbnail: $fileName, size: ${_thumbBytes!.lengthInBytes} bytes");

        final uploadedThumbUrl = await _uploadToCloudinary(
          bytes: _thumbBytes!,
          filename: fileName,
          tipeChannel: _selectedTipe ?? 'lainnya',
          channelId: channelId,
          subfolder: 'thumbnail',
        );

        if (uploadedThumbUrl == null) {
          Navigator.pop(context);
          await _showMessageDialog(
            title: 'Gagal!',
            message:
                'Upload Thumbnail ke Cloudinary gagal. Cek preset dan koneksi.',
            success: false,
          );
          return;
        }
        thumbUrl = uploadedThumbUrl;
        debugPrint("Thumbnail uploaded: $thumbUrl");
      }

      // ================= Simpan ke Firestore =================
      final data = {
        "id": channelId,
        "nama_channel": _namaChannelController.text,
        "tipe": _selectedTipe,
        "no_rekening": _nomorRekeningController.text,
        "nama_pemilik": _namaPemilikController.text,
        "catatan": _catatanController.text,
        "qr_url": qrUrl, // Pasti string
        "thumbnail_url": thumbUrl, // Pasti string
        "created_at": DateTime.now(),
      };

      debugPrint("Saving to Firestore: $data");

      await FirebaseFirestore.instance
          .collection("channel_transfer")
          .doc(channelId)
          .set(data);

      Navigator.pop(context); // tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Channel berhasil ditambahkan!"),
          backgroundColor: Color(0xFF48B0E0),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _handleReset();
    } catch (e, stack) {
      Navigator.pop(context); // pastikan loading tertutup
      debugPrint("Error: $e");
      debugPrint("$stack");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan: $e"),
          backgroundColor: Colors.red,
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
        backgroundColor: Color(0xFF48B0E0),
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
      TextInputType keyboardType = TextInputType.text,
      bool isOptional = false}) {
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
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (v) {
            if (isOptional) return null; // biarkan kosong
            return v == null || v.isEmpty ? "$label wajib diisi" : null;
          },
        )
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
          value: (value != null && items.contains(value)) ? value : null,
          hint: Text(hint),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white, width: 2),
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
    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Tambah Channel Transfer",
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Buat Channel Transfer Baru",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xFF48B0E0)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextFormField(
                              "Nama Channel", "Masukkan nama channel",
                              controller: _namaChannelController),
                          _buildDropdownField(
                              "Tipe Channel",
                              "-- Pilih Tipe --",
                              _selectedTipe,
                              ["bank", "ewallet", "qris", "lainnya"],
                              (v) => setState(() => _selectedTipe = v)),
                          _buildTextFormField(
                              "Nomor Rekening / Akun", "Masukkan nomor",
                              controller: _nomorRekeningController,
                              keyboardType: TextInputType.number),
                          _buildTextFormField(
                              "Nama Pemilik", "Masukkan nama pemilik",
                              controller: _namaPemilikController),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Upload QR",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                const SizedBox(height: 8),
                                InputDecorator(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ).toInputDecoration(),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                              _qrFileName ?? "Belum ada file")),
                                      IconButton(
                                        icon: const Icon(Icons.upload,
                                            color: Color(0xFF48B0E0)),
                                        onPressed: () => _pickFile('qr'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Upload Thumbnail",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                const SizedBox(height: 8),
                                InputDecorator(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ).toInputDecoration(),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(_thumbnailFileName ??
                                              "Belum ada file")),
                                      IconButton(
                                        icon: const Icon(Icons.upload,
                                            color: Color(0xFF48B0E0)),
                                        onPressed: () => _pickFile('thumbnail'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildTextFormField(
                              "Catatan (Opsional)", "Masukkan catatan",
                              controller: _catatanController, isOptional: true),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF48B0E0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text("Simpan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleReset,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text("Reset",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
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
          ],
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
