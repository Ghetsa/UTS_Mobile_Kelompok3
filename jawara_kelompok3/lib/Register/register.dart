import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../Theme/app_theme.dart'; // ✅ pakai tema global

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // === Ambil warna dari AppTheme agar konsisten dengan seluruh aplikasi ===
  static const Color primaryDark = AppTheme.primaryBlue;
  static const Color secondaryCream = AppTheme.lightBlue;
  static const Color accentGold = Color(0xFFC7B68D); // tetap dipertahankan
  static const Color textDark = AppTheme.primaryGreen;
  static const Color secondaryText = Color(0xFF666666);

  String? _selectedFileName;
  String? _selectedAddressOption;

  static const String manualAddressOption =
      'Alamat Rumah (Jika Tidak Ada di List)';

  @override
  void initState() {
    super.initState();
    _selectedAddressOption = null;
  }

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

  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: textDark,
            )),
        const SizedBox(height: 4),
        TextFormField(
          obscureText: obscureText,
          style: const TextStyle(color: textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(color: primaryDark, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

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
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: textDark,
            )),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(border: InputBorder.none),
            isExpanded: true,
            hint: Text(hint,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
            items: items
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: textDark)),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFileUploadField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: textDark,
            )),
        const SizedBox(height: 4),
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: secondaryCream,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: accentGold),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedFileName != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _selectedFileName != null ? primaryDark : accentGold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFileName ?? 'Upload foto KK/KTP (.png/.jpg)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _selectedFileName != null
                          ? textDark
                          : primaryDark.withOpacity(0.8),
                      fontSize: 14,
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
          _buildInputField(
              label: 'Alamat Rumah (Isi Manual)', hint: 'Blok 5A / No. 10'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardMaxWidth = screenWidth > 600 ? 600.0 : screenWidth * 0.9;

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
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Logo_jawara.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Jawara',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Card Form
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardMaxWidth),
                  child: Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Daftar Akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Lengkapi formulir untuk membuat akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: secondaryText),
                        ),
                        const SizedBox(height: 30),

                        // Form field
                        _buildInputField(
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap'),
                        _buildInputField(
                            label: 'Email', hint: 'Masukkan email aktif'),
                        _buildInputField(
                            label: 'Password',
                            hint: 'Masukkan password',
                            obscureText: true),
                        _buildInputField(
                            label: 'Konfirmasi Password',
                            hint: 'Masukkan ulang password',
                            obscureText: true),
                        _buildDropdownField(
                          label: 'Jenis Kelamin',
                          items: const ['Laki-laki', 'Perempuan'],
                          hint: '--- Pilih Jenis Kelamin ---',
                        ),
                        _buildAddressSelectionField(),
                        _buildFileUploadField(label: 'Foto Identitas'),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
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

                        // Link ke Login
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ',
                                  style: TextStyle(color: secondaryText)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
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