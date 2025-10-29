import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';

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
    'Warga'
  ];

  // Variabel menyimpan
  late String selectedRole;

  // Controller untuk setiap input text
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomorHpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController konfirmasiPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default role yang dipilih
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

  // Fungsi untuk menampilkan snackbar ketika tombol Simpan ditekan
  void _handleSimpan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Menyimpan Pengguna Baru: ${namaLengkapController.text} dengan Role $selectedRole'),
        backgroundColor: AppTheme.greenMediumDark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Fungsi untuk mereset seluruh inputan form
  void _handleReset() {
    setState(() {
      namaLengkapController.clear();
      emailController.clear();
      nomorHpController.clear();
      passwordController.clear();
      konfirmasiPasswordController.clear();
      selectedRole = roles.first;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Formulir telah di-reset.'),
      backgroundColor: AppTheme.greenMediumDark,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      drawer: const AppSidebar(),

      // AppBar
      appBar: AppBar(
        title: const Text(
          "Tambah Akun Pengguna",
          style:
              TextStyle(color: AppTheme.putihFull, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: AppTheme.putihFull),
      ),

      // Body menggunakan SingleChildScrollView agar scrollable
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Form
                    Center(
                      child: Text(
                        "Formulir Tambah Pengguna",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Input Fields
                    _buildTextField(
                        controller: namaLengkapController,
                        label: "Nama Lengkap",
                        hint: "Masukkan nama lengkap"),
                    _buildTextField(
                        controller: emailController,
                        label: "Email",
                        hint: "Masukkan email aktif",
                        keyboardType: TextInputType.emailAddress),
                    _buildTextField(
                        controller: nomorHpController,
                        label: "Nomor HP",
                        hint: "Masukkan nomor HP (cth. 08xxxxxxxxx)",
                        keyboardType: TextInputType.phone),
                    _buildTextField(
                        controller: passwordController,
                        label: "Password",
                        hint: "Masukkan password",
                        isPassword: true),
                    _buildTextField(
                        controller: konfirmasiPasswordController,
                        label: "Konfirmasi Password",
                        hint: "Masukkan ulang password",
                        isPassword: true),

                    // Dropdown Role
                    const SizedBox(height: 20),
                    _buildRoleDropdown(),
                    const SizedBox(height: 30),

                    // Tombol aksi Simpan dan Reset
                    Row(
                      children: [
                        // Tombol Simpan
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSimpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.greenDark,
                              foregroundColor: AppTheme.putihFull,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            child: const Text("Simpan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Tombol Reset
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleReset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.redMediumDark,
                              foregroundColor: AppTheme.putihFull,
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
      ),
    );
  }

  // Widget TextField dengan style mirip Tambah Channel
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label field
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),

          // TextField input
          TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppTheme.abu.withOpacity(0.2),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppTheme.primaryBlue, width: 2)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Dropdown Role dengan style mirip Tambah Channel
  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Role
          const Text("Role",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),

          // Dropdown container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.abu.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.abu),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedRole,
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: AppTheme.primaryBlue),
                items: roles
                    .map((role) =>
                        DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) setState(() => selectedRole = newValue);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
