import 'package:flutter/material.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pengguna_model.dart';
import '../../data/services/pengguna_service.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedRole;
  String? _selectedJenisKelamin;

  final List<String> _roleList = [
    'Warga',
    'Bendahara',
    'Ketua RT',
    'Ketua RW',
    'Admin'
  ];
  final List<String> _jenisKelaminList = ['L', 'P'];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan konfirmasi tidak cocok!"),
          backgroundColor: AppTheme.redMedium,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newUser = User(
      docId: '',
      nama: _namaController.text,
      email: _emailController.text,
      statusRegistrasi: 'aktif',
      role: _selectedRole ?? 'Warga',
      nik: _nikController.text,
      noHp: _noHpController.text,
      jenisKelamin: _selectedJenisKelamin ?? 'L',
      fotoIdentitas: null,
    );

    final success = await UserService().addUser(newUser);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data ${_namaController.text} berhasil ditambahkan!"),
          backgroundColor: const Color(0xFF48B0E0),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _handleReset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan pengguna!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleReset() {
    setState(() {
      _selectedRole = null;
      _selectedJenisKelamin = null;
    });
    _formKey.currentState!.reset();
    _namaController.clear();
    _emailController.clear();
    _nikController.clear();
    _noHpController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form berhasil di-reset!"),
        backgroundColor: const Color(0xFF48B0E0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextFormField(String label, String hint,
      {required TextEditingController controller,
      bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
    bool obscureText = isPassword
        ? (controller == _passwordController
            ? _obscurePassword
            : _obscureConfirmPassword)
        : false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.abu,
                    ),
                    onPressed: () {
                      setState(() {
                        if (controller == _passwordController) {
                          _obscurePassword = !_obscurePassword;
                        } else {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        }
                      });
                    },
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Field $label wajib diisi.';
            return null;
          },
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
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Field $label wajib dipilih.';
            return null;
          },
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
              title: "Tambah Pengguna",
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
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Buat Akun Pengguna Baru",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xFF48B0E0)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextFormField(
                              "Nama Lengkap", "Masukkan nama lengkap",
                              controller: _namaController),
                          _buildTextFormField("Email", "Masukkan email",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress),
                          _buildTextFormField(
                              "NIK / Nomor Identitas", "Masukkan NIK",
                              controller: _nikController,
                              keyboardType: TextInputType.number),
                          _buildTextFormField("Nomor HP", "Masukkan nomor HP",
                              controller: _noHpController,
                              keyboardType: TextInputType.phone),
                          _buildTextFormField("Password", "Masukkan password",
                              controller: _passwordController,
                              isPassword: true),
                          _buildTextFormField("Konfirmasi Password",
                              "Masukkan kembali password",
                              controller: _confirmPasswordController,
                              isPassword: true),
                          _buildDropdownField(
                              "Role",
                              "-- Pilih Role --",
                              _selectedRole,
                              _roleList,
                              (val) => setState(() => _selectedRole = val)),
                          _buildDropdownField(
                              "Jenis Kelamin",
                              "-- Pilih Jenis Kelamin --",
                              _selectedJenisKelamin,
                              _jenisKelaminList,
                              (val) =>
                                  setState(() => _selectedJenisKelamin = val)),
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
