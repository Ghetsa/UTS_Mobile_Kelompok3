import 'package:flutter/material.dart';
import '../../../layout/sidebar.dart';
import '../../../theme/app_theme.dart';

class TambahRumahPage extends StatefulWidget {
  const TambahRumahPage({super.key});

  @override
  State<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends State<TambahRumahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap input
  final TextEditingController noRumahController = TextEditingController();
  final TextEditingController kepalaKeluargaController =
      TextEditingController();
  final TextEditingController jumlahAnggotaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController rtController = TextEditingController();
  final TextEditingController rwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          "Tambah Rumah",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: AppTheme.backgroundBlueWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Judul Section
                  const Text(
                    "Data Rumah",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// No Rumah
                  _buildTextField(
                    label: "Nomor Rumah",
                    controller: noRumahController,
                    icon: Icons.home,
                    keyboardType: TextInputType.number,
                  ),

                  /// Nama Kepala Keluarga
                  _buildTextField(
                    label: "Nama Kepala Keluarga",
                    controller: kepalaKeluargaController,
                    icon: Icons.person,
                  ),

                  /// Jumlah Anggota
                  _buildTextField(
                    label: "Jumlah Anggota Keluarga",
                    controller: jumlahAnggotaController,
                    icon: Icons.group,
                    keyboardType: TextInputType.number,
                  ),

                  /// RT & RW dalam 1 baris
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: "RT",
                          controller: rtController,
                          icon: Icons.location_city,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: "RW",
                          controller: rwController,
                          icon: Icons.location_city,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  /// Alamat
                  _buildTextField(
                    label: "Alamat Lengkap",
                    controller: alamatController,
                    icon: Icons.map,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 30),

                  /// Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Data rumah berhasil disimpan!"),
                              backgroundColor: AppTheme.greenDark,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        "Simpan Data Rumah",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Widget builder input field agar seragam
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? 'Harap isi $label' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon != null ? Icon(icon, color: AppTheme.primaryBlue) : null,
          labelStyle: const TextStyle(color: AppTheme.primaryBlue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.grayLight, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
