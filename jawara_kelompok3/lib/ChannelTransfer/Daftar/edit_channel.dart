import 'package:flutter/material.dart';
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
  // Controller untuk setiap input field
  late TextEditingController namaController;
  late TextEditingController tipeController;
  late TextEditingController nomorController;
  late TextEditingController pemilikController;
  late TextEditingController catatanController;

  // Path sementara untuk preview ganti thumbnail / QR
  String? newThumbnail;
  String? newQR;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.channel['nama'] ?? '');
    tipeController = TextEditingController(text: widget.channel['tipe'] ?? '');
    nomorController = TextEditingController(text: widget.channel['no'] ?? '');
    pemilikController = TextEditingController(text: widget.channel['a/n'] ?? '');
    catatanController =
        TextEditingController(text: widget.channel['catatan'] ?? '');
  }

  @override
  void dispose() {
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

  void _resetFields() {
    setState(() {
      namaController.text = widget.channel['nama'] ?? '';
      tipeController.text = widget.channel['tipe'] ?? '';
      nomorController.text = widget.channel['no'] ?? '';
      pemilikController.text = widget.channel['a/n'] ?? '';
      catatanController.text = widget.channel['catatan'] ?? '';
      newThumbnail = null;
      newQR = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text(
          "Edit Transfer Channel",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                            color: AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Nama Channel
                    _buildLabel("Nama Channel"),
                    _buildTextField(namaController, "Masukkan nama channel"),
                    const SizedBox(height: 16),

                    // Tipe
                    _buildLabel("Tipe Channel"),
                    _buildTextField(tipeController, "Masukkan tipe channel"),
                    const SizedBox(height: 16),

                    // Nomor Rekening / Akun
                    _buildLabel("Nomor Rekening / Akun"),
                    _buildTextField(nomorController, "Masukkan nomor rekening",
                        keyboardType: TextInputType.number),
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
                      imagePath: newThumbnail ??
                          widget.channel['thumbnail'] ??
                          'assets/images/default.jpg',
                      onTap: () {
                        setState(() =>
                            newThumbnail = widget.channel['thumbnail']);
                      },
                    ),
                    const SizedBox(height: 16),

                    // QR
                    _buildLabel("QR Code"),
                    const SizedBox(height: 6),
                    _buildImagePicker(
                      label: "QR saat ini:",
                      imagePath: newQR ??
                          widget.channel['qr'] ??
                          'assets/images/default_qr.png',
                      onTap: () {
                        setState(() => newQR = widget.channel['qr']);
                      },
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
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
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
                              backgroundColor: AppTheme.redMedium,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
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
      {bool isPassword = false,
      bool readOnly = false,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: readOnly ? Colors.grey[200] : AppTheme.lightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.blueLight, width: 1),
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.blueDark)),
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
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
