import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; 
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart'; 

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

// State TambahChannelPage
class _TambahChannelPageState extends State<TambahChannelPage> {
  // Key form validation
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaChannelController = TextEditingController();
  final TextEditingController _nomorRekeningController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  // Variabel dropdown dan file
  String? _selectedTipe;
  String? _qrFileName; 
  String? _thumbnailFileName;

  // Dispose controller saat widget dihapus
  @override
  void dispose() {
    _namaChannelController.dispose();
    _nomorRekeningController.dispose();
    _namaPemilikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani tombol Simpan
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data formulir telah divalidasi dan siap dikirim (simulasi frontend).',
          ),
        ),
      );
      _handleReset();
    }
  }

  // Fungsi untuk menangani tombol Reset
  void _handleReset() {
    setState(() {
      _selectedTipe = null;
      _qrFileName = null;
      _thumbnailFileName = null;
    });
    _formKey.currentState!.reset(); 
    _namaChannelController.clear(); 
    _nomorRekeningController.clear(); 
    _namaPemilikController.clear(); 
    _catatanController.clear(); 
  }

  // Fungsi untuk membuka file picker dan memilih file
  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'], 
    );

    // Jika ada file yang dipilih, simpan nama file ke state
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (type == 'qr') {
          _qrFileName = result.files.first.name; 
        } else {
          _thumbnailFileName = result.files.first.name; 
        }
      });
    }
  }

  // Build UI halaman
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const AppSidebar(), 
      appBar: AppBar(
        title: const Text("Tambah Channel Transfer", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}), 
          IconButton(icon: const Icon(Icons.account_circle), onPressed: () {}), 
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul halaman
                  Center(
                    child: Text(
                      "Buat Transfer Channel",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Input Nama Channel
                  _buildTextFormSection(
                    label: "Nama Channel",
                    hint: "Contoh: BCA, Dana, QRIS RT",
                    controller: _namaChannelController,
                  ),

                  // Dropdown tipe channel
                  _buildDropdownSection(
                    label: "Tipe",
                    hint: "-- Pilih Tipe --",
                    value: _selectedTipe,
                    onChanged: (newValue) => setState(() => _selectedTipe = newValue),
                    dropdownItems: const ['bank', 'ewallet', 'qris', 'lainnya'],
                  ),

                  // Input Nomor Rekening
                  _buildTextFormSection(
                    label: "Nomor Rekening / Akun",
                    hint: "Contoh: 1234567890",
                    controller: _nomorRekeningController,
                    keyboardType: TextInputType.number,
                  ),

                  // Input Nama Pemilik
                  _buildTextFormSection(
                    label: "Nama Pemilik",
                    hint: "Contoh: John Doe",
                    controller: _namaPemilikController,
                  ),

                  // Upload QR
                  _buildFileUploadSection(
                    label: "QR",
                    hint: _qrFileName ?? "Klik untuk upload foto QR",
                    onTap: () => _pickFile('qr'),
                  ),

                  // Upload Thumbnail
                  _buildFileUploadSection(
                    label: "Thumbnail",
                    hint: _thumbnailFileName ?? "Klik untuk upload thumbnail",
                    onTap: () => _pickFile('thumbnail'),
                  ),

                  // Catatan opsional
                  _buildNoteSection(
                    label: "Catatan (Opsional)",
                    hint: "Contoh: Transfer hanya dari bank yang sama agar instan",
                    controller: _catatanController,
                  ),

                  const SizedBox(height: 30),

                  // Tombol Simpan & Reset
                  Row(
                    children: [
                      // Tombol Simpan
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, 
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Tombol Reset
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, 
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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

  // Widget input teks standar
  Widget _buildTextFormSection({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          // Input field
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            // Validasi input
            validator: (value) {
              if (label != "Catatan (Opsional)" && (value == null || value.isEmpty)) return 'Field $label wajib diisi.';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Widget dropdown pilihan
  Widget _buildDropdownSection({
    required String label,
    required String hint,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> dropdownItems,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label dropdown
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          // DropdownButtonFormField untuk validasi
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: dropdownItems.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
            // Validasi dropdown wajib dipilih
            validator: (value) {
              if (value == null || value.isEmpty) return 'Field $label wajib dipilih.';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Widget upload file QR atau Thumbnail
  Widget _buildFileUploadSection({
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label file upload
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          // InkWell agar bisa klik untuk upload
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload_file, color: AppTheme.primaryBlue),
                  const SizedBox(width: 10),
                  Flexible(child: Text(hint, style: TextStyle(color: Colors.grey.shade600, fontSize: 14))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget input Catatan opsional
  Widget _buildNoteSection({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          // Input multi-line
          TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
