import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart'; // gunakan sidebar sesuai struktur folder global
import '../../Theme/app_theme.dart'; // gunakan theme global

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final List<String> roles = const [
    '-- Pilih Role --',
    'Admin',
    'Bendahara',
    'Warga',
  ];

  late String selectedRole;
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomorHpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedRole = roles.first;
  }

  @override
  void dispose() {
    namaLengkapController.dispose();
    emailController.dispose();
    nomorHpController.dispose();
    passwordController.dispose();
    konfirmasiPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text(
          "Tambah Akun Pengguna",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppSidebar(), // sidebar konsisten dengan layout utama
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Formulir Tambah Pengguna",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),

                    // Input: Nama Lengkap
                    _buildTextField(
                      controller: namaLengkapController,
                      label: "Nama Lengkap",
                      hint: "Masukkan nama lengkap",
                    ),
                    const SizedBox(height: 20),

                    // Input: Email
                    _buildTextField(
                      controller: emailController,
                      label: "Email",
                      hint: "Masukkan email aktif",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Input: Nomor HP
                    _buildTextField(
                      controller: nomorHpController,
                      label: "Nomor HP",
                      hint: "Masukkan nomor HP (cth. 08xxxxxxxxx)",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Input: Password
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      hint: "Masukkan password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    // Input: Konfirmasi Password
                    _buildTextField(
                      controller: konfirmasiPasswordController,
                      label: "Konfirmasi Password",
                      hint: "Masukkan ulang password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    // Input: Role (Dropdown)
                    _buildRoleDropdown(),
                    const SizedBox(height: 30),

                    // Tombol Aksi
                    Row(
                      children: [
                        // Tombol Simpan
                        ElevatedButton(
                          onPressed: _handleSimpan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Tombol Reset
                        OutlinedButton(
                          onPressed: _handleReset,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryBlue,
                            side: const BorderSide(
                              color: AppTheme.primaryBlue,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 16),
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

  // === Logika tombol Simpan ===
  void _handleSimpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menyimpan Pengguna Baru: ${namaLengkapController.text} dengan Role $selectedRole',
        ),
      ),
    );
  }

  // === Logika tombol Reset ===
  void _handleReset() {
    setState(() {
      namaLengkapController.clear();
      emailController.clear();
      nomorHpController.clear();
      passwordController.clear();
      konfirmasiPasswordController.clear();
      selectedRole = roles.first;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Formulir telah di-reset.')));
  }

  // === Widget TextField ===
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primaryBlue,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // === Widget Dropdown Role ===
  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Role",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedRole,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.primaryBlue,
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedRole = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}