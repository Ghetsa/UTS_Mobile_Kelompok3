import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart'; // Menggunakan path sidebar Anda
import '../../Theme/app_theme.dart'; // Menggunakan path theme Anda

class TambahChannelPage extends StatefulWidget {
  const TambahChannelPage({super.key});

  @override
  State<TambahChannelPage> createState() => _TambahChannelPageState();
}

class _TambahChannelPageState extends State<TambahChannelPage> {
  // Global Key untuk mengelola Form
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk setiap field input
  final TextEditingController _namaChannelController = TextEditingController();
  final TextEditingController _nomorRekeningController =
      TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  // State untuk Dropdown
  String? _selectedTipe;

  @override
  void dispose() {
    _namaChannelController.dispose();
    _nomorRekeningController.dispose();
    _namaPemilikController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Fungsi untuk mensimulasikan aksi Simpan (Frontend Only)
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Data telah divalidasi, sekarang hanya menampilkan feedback

      // Tampilkan feedback sederhana (Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        // Pada kondisi real, di sinilah Anda akan memanggil API atau fungsi backend
        const SnackBar(
            content: Text(
                'Data formulir telah divalidasi dan siap dikirim (simulasi frontend).')),
      );

      // Opsional: Reset formulir setelah simulasi kirim
      _handleReset();
    }
  }

  // Fungsi untuk mereset semua field
  void _handleReset() {
    setState(() {
      _selectedTipe = null;
    });
    _formKey.currentState!.reset();
    _namaChannelController.clear();
    _nomorRekeningController.clear();
    _namaPemilikController.clear();
    _catatanController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(), // Menggunakan AppSidebar
      appBar: AppBar(
        title: const Text("Tambah Channel Transfer",
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              // Menggunakan Form Widget
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul "Buat Transfer Channel"
                  Text(
                    "Buat Transfer Channel",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Nama Channel
                  _buildTextFormSection(
                    context,
                    label: "Nama Channel",
                    hint: "Contoh: BCA, Dana, QRIS RT",
                    controller: _namaChannelController,
                  ),

                  // Tipe (Dropdown)
                  _buildDropdownSection(
                    context,
                    label: "Tipe",
                    hint: "-- Pilih Tipe --",
                    value: _selectedTipe,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTipe = newValue;
                      });
                    },
                    dropdownItems: const ['bank', 'ewallet', 'qris', 'lainnya'],
                  ),

                  // Nomor Rekening / Akun
                  _buildTextFormSection(
                    context,
                    label: "Nomor Rekening / Akun",
                    hint: "Contoh: 1234567890",
                    controller: _nomorRekeningController,
                    keyboardType: TextInputType.number,
                  ),

                  // Nama Pemilik
                  _buildTextFormSection(
                    context,
                    label: "Nama Pemilik",
                    hint: "Contoh: John Doe",
                    controller: _namaPemilikController,
                  ),

                  // QR Upload
                  _buildFileUploadSection(
                    context,
                    label: "QR",
                    hint: "Upload foto QR (Jika ada) png/jpeg/jpg",
                  ),

                  // Thumbnail Upload
                  _buildFileUploadSection(
                    context,
                    label: "Thumbnail",
                    hint: "Upload thumbnail (Jika ada) png/jpeg/jpg",
                  ),

                  // Catatan (Opsional)
                  _buildNoteSection(
                    context,
                    label: "Catatan (Opsional)",
                    hint:
                        "Contoh: Transfer hanya dari bank yang sama agar instan",
                    controller: _catatanController,
                  ),

                  const SizedBox(height: 30),

                  // Tombol Simpan dan Reset
                  Row(
                    children: [
                      // Tombol Simpan (Memanggil aksi Simpan)
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Simpan"),
                      ),
                      const SizedBox(width: 10),
                      // Tombol Reset (Memanggil aksi Reset)
                      OutlinedButton(
                        onPressed: _handleReset,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Reset",
                            style: TextStyle(color: Colors.black54)),
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

  // --- HELPER WIDGETS DENGAN TAMPILAN SESUAI GAMBAR ---

  // Helper Widget untuk Input Teks (TextFormField)
  Widget _buildTextFormSection(
    BuildContext context, {
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            // Validasi sederhana (wajib isi kecuali Catatan)
            validator: (value) {
              if (label != "Catatan (Opsional)" &&
                  (value == null || value.isEmpty)) {
                return 'Field $label wajib diisi.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Dropdown
  Widget _buildDropdownSection(
    BuildContext context, {
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            items: dropdownItems.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            // Validasi untuk Dropdown (wajib pilih)
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field $label wajib dipilih.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Bagian Upload File (QR & Thumbnail)
  Widget _buildFileUploadSection(
    BuildContext context, {
    required String label,
    required String hint,
  }) {
    // Note: Karena fokus frontend, fungsi upload di sini hanya simulasi tampilan.
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            // Menggunakan InkWell untuk simulasi klik
            onTap: () {
              // Menghapus log: log('Simulasi: Membuka dialog/pemilih file untuk $label.');
            },
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Powered by PDNA",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Bagian Catatan (Textarea)
  Widget _buildNoteSection(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("Powered by PDNA",
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}
