import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers untuk input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController manualAddressController = TextEditingController();

  // Variabel 
  String? _selectedFileName;
  String? _selectedAddressOption;
  String? _selectedOwnershipStatus;
  String? _selectedGender;
  late FirebaseAuth _auth;

  static const String manualAddressOption =
      'Alamat Rumah (Jika Tidak Ada di List)';

  @override
  void initState() {
    super.initState();
    _selectedAddressOption = null;
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;
  }

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      await showMessageDialog(
          title: 'Gagal!',
          message: 'Email dan password wajib diisi',
          success: false);
      return;
    }

    if (password != confirmPassword) {
      await showMessageDialog(
          title: 'Gagal!',
          message: 'Password dan konfirmasi password tidak cocok',
          success: false);
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Semua user otomatis jadi warga
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': nameController.text.trim(),
        'role': "warga", // tidak hapus role untuk kesesuaian Firestore
        'nik': nikController.text.trim(),
        'phone': phoneController.text.trim(),
      });

      await showMessageDialog(
        title: 'Berhasil!',
        message: 'Akun berhasil dibuat. Silakan login.',
        success: true,
      );

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan, coba lagi';

      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      }

      await showMessageDialog(
        title: 'Berhasil!',
        message: 'Akun berhasil dibuat. Silakan login.',
        success: true,
      );
      
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> showMessageDialog({
    required String title,
    required String message,
    required bool success,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor:
            success ? AppTheme.greenExtraLight : AppTheme.redExtraLight,
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: success ? AppTheme.greenDark : AppTheme.redDark,
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fungsi memilih file menggunakan FilePicker
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedFileName = result.files.first.name;
      });
    }
  }

  // Fungsi input field standar (text/password)
  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller, // tambahkan controller
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.primaryBlue,
            )),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller, // hubungkan controller
          obscureText: obscureText,
          style: TextStyle(color: AppTheme.hitam),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.abu, fontSize: 14),
            fillColor: AppTheme.putih,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.putih),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.abu),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Fungsi membuat dropdown field
  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String hint,
    String? selectedValue,
    Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppTheme.primaryBlue,
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.putih,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.putih),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            isExpanded: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.putih,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.abu),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.abu),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
            ),
            hint:
                Text(hint, style: TextStyle(color: AppTheme.abu, fontSize: 14)),
            items: items
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          style:
                              TextStyle(color: AppTheme.hitam, fontSize: 14)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Fungsi membuat field upload file
  Widget _buildFileUploadField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.primaryBlue)),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.putih,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.abu, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedFileName != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _selectedFileName != null
                      ? AppTheme.greenDark
                      : AppTheme.redDark,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedFileName ?? 'Upload foto KK/KTP (.png/.jpg)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _selectedFileName != null
                          ? AppTheme.hitam
                          : AppTheme.hitam.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Fungsi membangun field alamat dengan opsi manual
  Widget _buildAddressSelectionField() {
    List<String> addressOptions = [
      'Rumah Blok A (Jl. Mawar No. 1)',
      'Rumah Blok B (Jl. Anggrek No. 5)',
      'Rumah Blok C (Jl. Tulip No. 9)',
      manualAddressOption,
    ];
    bool showManualInput = _selectedAddressOption == manualAddressOption;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Pilih Rumah yang Sudah Ada',
          items: addressOptions,
          hint: '--- Pilih Rumah ---',
          selectedValue: _selectedAddressOption,
          onChanged: (newValue) {
            setState(() {
              _selectedAddressOption = newValue;
            });
          },
        ),
        if (showManualInput)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini',
                style: TextStyle(
                    color: AppTheme.abu,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                  label: 'Alamat Rumah (Jika Tidak Ada di List)',
                  hint: 'Blok 5A / No. 10'),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lebar layar layout responsif
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardMaxWidth = screenWidth > 470 ? 400.0 : screenWidth * 0.80;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo dan judul aplikasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Logo_jawara.png',
                        width: 60, height: 60),
                    const SizedBox(width: 8),
                    const Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Jawara',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.putihFull,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Card utama form register
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardMaxWidth),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Judul card
                        const Text(
                          'Daftar Akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Lengkapi formulir untuk membuat akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: AppTheme.hitam),
                        ),
                        const SizedBox(height: 30),

                        // Dua kolom form sejajar
                        LayoutBuilder(builder: (context, constraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      label: 'Nama Lengkap',
                                      hint: 'Masukkan nama lengkap',
                                      controller: nameController,
                                    ),
                                    _buildInputField(
                                      label: 'Email',
                                      hint: 'Masukkan email aktif',
                                      controller: emailController,
                                    ),
                                    _buildInputField(
                                      label: 'Password',
                                      hint: 'Masukkan password',
                                      obscureText: true,
                                      controller: passwordController,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      label: 'NIK',
                                      hint: 'Masukkan NIK',
                                      controller: nikController,
                                    ),
                                    _buildInputField(
                                      label: 'No Telepon',
                                      hint: 'Masukkan nomor telepon',
                                      controller: phoneController,
                                    ),
                                    _buildInputField(
                                      label: 'Konfirmasi Password',
                                      hint: 'Masukkan ulang password',
                                      obscureText: true,
                                      controller: confirmPasswordController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),

                        // Dropdown dan field lainnya
                        _buildDropdownField(
                          label: 'Jenis Kelamin',
                          items: const ['Laki-laki', 'Perempuan'],
                          hint: '--- Pilih Jenis Kelamin ---',
                          selectedValue: _selectedGender,
                          onChanged: (val) =>
                              setState(() => _selectedGender = val),
                        ),
                        _buildAddressSelectionField(),
                        _buildDropdownField(
                          label: 'Status Kepemilikan Rumah',
                          items: const ['Pemilik', 'Penyewa'],
                          hint: '--- Pilih Status ---',
                          selectedValue: _selectedOwnershipStatus,
                          onChanged: (val) =>
                              setState(() => _selectedOwnershipStatus = val),
                        ),
                        _buildFileUploadField(label: 'Foto Identitas'),

                        // Tombol Buat Akun
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            // Kembali ke login setelah submit
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Buat Akun',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Link ke login jika sudah punya akun
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Sudah punya akun? ',
                                style: TextStyle(color: AppTheme.hitam)),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, '/login'),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}