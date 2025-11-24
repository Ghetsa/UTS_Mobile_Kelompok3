import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import 'daftar_pengguna_page.dart';

class EditPenggunaPage extends StatefulWidget {
  final User user;
  const EditPenggunaPage({super.key, required this.user});

  @override
  State<EditPenggunaPage> createState() => _EditPenggunaPageState();
}

class _EditPenggunaPageState extends State<EditPenggunaPage> {
  // Controller untuk setiap input field
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController noHpController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late String selectedRole; // Untuk dropdown role

  // Daftar role yang tersedia
  final List<String> roleList = [
    'Warga',
    'Bendahara',
    'Ketua RT',
    'Ketua RW',
    'Admin',
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data user
    namaController = TextEditingController(text: widget.user.nama);
    emailController = TextEditingController(text: widget.user.email);
    noHpController = TextEditingController(
        text: widget.user.noHp == "08XXXXXXXXXX" ? "" : widget.user.noHp);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    // Melepaskan controller agar tidak memory leak
    namaController.dispose();
    emailController.dispose();
    noHpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengeksekusi update data pengguna
  void _updatePengguna() {
    if (passwordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password baru dan konfirmasi tidak cocok!"),
          backgroundColor: AppTheme.redMedium,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Simulasi update data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Data ${namaController.text} berhasil diperbarui!"),
        backgroundColor: AppTheme.greenMedium,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text(
          "Edit Akun Pengguna",
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
                    // Judul halaman
                    Center(
                      child: Text(
                        "Edit Informasi Akun Pengguna",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Field Nama Lengkap
                    _buildLabel("Nama Lengkap"),
                    _buildTextField(namaController, "Masukkan nama lengkap"),
                    const SizedBox(height: 16),

                    // Field Email (sudah bisa diganti)
                    _buildLabel("Email"),
                    _buildTextField(emailController, "Masukkan email",
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),

                    // Field Nomor HP
                    _buildLabel("Nomor HP"),
                    _buildTextField(noHpController, "Masukkan nomor HP",
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),

                    // Field Password Baru
                    _buildLabel("Password Baru (kosongkan jika tidak diganti)"),
                    _buildTextField(
                        passwordController, "Masukkan password baru",
                        isPassword: true),
                    const SizedBox(height: 16),

                    // Field Konfirmasi Password Baru
                    _buildLabel("Konfirmasi Password Baru"),
                    _buildTextField(
                        confirmPasswordController, "Masukkan kembali password",
                        isPassword: true),
                    const SizedBox(height: 16),

                    // Field Role (tidak dapat diubah)
                    _buildLabel("Role (tidak dapat diubah)"),
                    _buildDropdown(selectedRole, roleList),
                    const SizedBox(height: 32),

                    // Tombol Update
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.update_rounded),
                        label: const Text(
                          "Update",
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
                        onPressed: _updatePengguna,
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

  // Widget pembuat label di atas input field
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

  // Widget pembuat TextField
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
        fillColor: readOnly ? AppTheme.abu : AppTheme.abu.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppTheme.abu.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }

  // Widget pembuat dropdown role
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
        onChanged: null,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: AppTheme.hitam)),
          );
        }).toList(),
      ),
    );
  }
}
