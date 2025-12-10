import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk masing-masing input form
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Untuk toggle visibility password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Variabel untuk menyimpan pilihan dropdown
  String? _selectedRole;
  String? _selectedJenisKelamin;

  // List pilihan role dan jenis kelamin
  final List<String> _roleList = [
    'Warga',
    'Bendahara',
    'Sekretaris',
    'Ketua RT',
    'Ketua RW',
    'Admin'
  ];
  final List<String> _jenisKelaminList = ['L', 'P'];

  @override
  void dispose() {
    // Membersihkan semua controller saat widget dihapus
    _namaController.dispose();
    _emailController.dispose();
    _nikController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menangani submit form
  void _handleSubmit() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) return;

    // Cek kesamaan password dan konfirmasi password
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan konfirmasi tidak cocok!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Membuat objek User dari input form
    final newUser = User(
      docId: '',
      nama: _namaController.text,
      email: _emailController.text,
      statusPengguna: 'aktif',
      role: _selectedRole ?? 'Warga',
      nik: _nikController.text,
      noHp: _noHpController.text,
      jenisKelamin: _selectedJenisKelamin ?? 'L',
      fotoIdentitas: null,
    );

    // Tambah user ke Firebase Auth dan collection users
    final success = await UserService().addUser(
      newUser,
      _passwordController.text,
    );

    if (success) {
      try {
        // Tambah data ke koleksi warga di Firestore
        final wargaRef = FirebaseFirestore.instance.collection('warga');
        await wargaRef.add({
          'nama': _namaController.text,
          'nik': _nikController.text,
          'noHp': _noHpController.text,
          'jenisKelamin': _selectedJenisKelamin ?? 'L',
          'email': _emailController.text,
          'role': _selectedRole ?? 'Warga',
          'status': 'aktif',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Tampilkan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Data ${_namaController.text} berhasil ditambahkan di Auth, users, dan warga!"),
            backgroundColor: const Color(0xFF48B0E0),
          ),
        );
        _handleReset(); // Reset form setelah sukses
      } catch (e) {
        // Menangani error saat menambahkan ke Firestore
        print('ERROR TAMBAH DATA WARGA: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menambahkan data ke tabel warga!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Tampilkan error jika gagal menambahkan user di Auth
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menambahkan pengguna!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk mereset semua form dan dropdown
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

    // Tampilkan notifikasi reset berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form berhasil di-reset!"),
        backgroundColor: Color(0xFF48B0E0),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Fungsi untuk membangun TextFormField dengan label dan hint
  Widget _buildTextFormField(
    String label,
    String hint, {
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, // <-- tambahkan ini
  }) {
    // Tentukan apakah field password tersembunyi
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
            // Tombol untuk menampilkan/menyembunyikan password
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
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty)
                  return 'Field $label wajib diisi.';
                return null;
              },
        ),
      ]),
    );
  }

  // Fungsi untuk membangun dropdown field
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
                          // Field nama
                          _buildTextFormField(
                              "Nama Lengkap", "Masukkan nama lengkap",
                              controller: _namaController),
                          // Field email
                          _buildTextFormField("Email", "Masukkan email",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress),
                          // Field NIK
                          _buildTextFormField("NIK", "Masukkan NIK",
                              controller: _nikController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Field NIK wajib diisi.';
                            if (!RegExp(r'^\d{16}$').hasMatch(value))
                              return 'NIK harus terdiri dari 16 digit angka.';
                            return null;
                          }),
                          // Field no HP
                          _buildTextFormField("Nomor HP", "Masukkan nomor HP",
                              controller: _noHpController,
                              keyboardType: TextInputType.phone),
                          // Field password
                          _buildTextFormField("Password", "Masukkan password",
                              controller: _passwordController,
                              isPassword: true, validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Field Password wajib diisi.';
                            if (!RegExp(
                                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$')
                                .hasMatch(value)) {
                              return 'Password minimal 8 karakter, termasuk huruf besar, huruf kecil, angka, dan simbol.';
                            }
                            return null;
                          }),
                          // Field konfirmasi password
                          _buildTextFormField("Konfirmasi Password",
                              "Masukkan kembali password",
                              controller: _confirmPasswordController,
                              isPassword: true),
                          // Dropdown role
                          _buildDropdownField(
                              "Role",
                              "-- Pilih Role --",
                              _selectedRole,
                              _roleList,
                              (val) => setState(() => _selectedRole = val)),
                          // Dropdown jenis kelamin
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
                              // Tombol simpan
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
                              // Tombol reset
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
