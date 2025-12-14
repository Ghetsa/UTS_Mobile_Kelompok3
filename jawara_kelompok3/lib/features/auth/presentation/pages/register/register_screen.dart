import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../core/theme/app_theme.dart';
import 'register_controller.dart';
import 'dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController manualAddressController = TextEditingController();

  String? _selectedGender;
  String? _selectedAddressOption;
  String? _selectedOwnershipStatus;

  Uint8List? _profilePhotoBytes;
  String? _profilePhotoName;

  final RegisterController _controller = RegisterController();
  static const String manualAddressOption =
      'Alamat Rumah (Jika Tidak Ada di List)';

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _profilePhotoBytes = result.files.first.bytes;
        _profilePhotoName = result.files.first.name;
      });
    }
  }

  String? _computeAddressToSend() {
    if (_selectedAddressOption == null) return null;
    if (_selectedAddressOption == manualAddressOption) {
      final manual = manualAddressController.text.trim();
      return manual.isEmpty ? null : manual;
    }
    return _selectedAddressOption;
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
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
            suffixIcon: suffixIcon,
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Field $label wajib diisi.';
                }
                return null;
              },
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

  Widget _buildFileUploadField({required String label}) {
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
                  _profilePhotoName != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _profilePhotoName != null
                      ? AppTheme.greenDark
                      : AppTheme.redDark,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    _profilePhotoName ?? 'Upload foto KK/KTP (.png/.jpg)',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _profilePhotoName != null
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
            label: 'Alamat Rumah (Jika Tidak Ada di List)',
            hint: 'Blok 5A / No. 10',
            controller: manualAddressController,
          ),
      ],
    );
  }

  Future<void> _onRegisterPressed() async {
    final addressToSend = _computeAddressToSend();
    String nik = nikController.text.trim();
    if (nik.length != 16 || int.tryParse(nik) == null) {
      await showMessageDialog(
        context: context,
        title: 'Gagal!',
        message: 'NIK harus berisi tepat 16 angka.',
        success: false,
      );
      return;
    }

    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    List<String> pwErrors = [];

    if (password.length < 8) pwErrors.add("• Minimal 8 karakter");
    if (!RegExp(r'[A-Z]').hasMatch(password))
      pwErrors.add("• Harus ada huruf besar (A-Z)");
    if (!RegExp(r'[a-z]').hasMatch(password))
      pwErrors.add("• Harus ada huruf kecil (a-z)");
    if (!RegExp(r'[0-9]').hasMatch(password))
      pwErrors.add("• Harus ada angka (0-9)");
    if (!RegExp(r'[!@#\$%^&*(),.?\":{}|<>]').hasMatch(password))
      pwErrors.add("• Harus ada karakter khusus (!,@,#,...)");

    if (pwErrors.isNotEmpty) {
      await showMessageDialog(
        context: context,
        title: 'Password Lemah!',
        message: "Password kamu kurang:\n\n${pwErrors.join('\n')}",
        success: false,
      );
      return;
    }

    await _controller.registerUser(
      context: context,
      email: emailController.text.trim(),
      password: password,
      confirmPassword: confirmPassword,
      nama: nameController.text.trim(),
      nik: nik,
      noHp: phoneController.text.trim(),
      role: 'warga',
      jenis_kelamin: _selectedGender,
      alamat: addressToSend,
      kepemilikan: _selectedOwnershipStatus,
      fotoIdentitas: _profilePhotoBytes,
      profilePhotoName: _profilePhotoName,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                        controller: nameController),
                                    _buildInputField(
                                        label: 'Email',
                                        hint: 'Masukkan email aktif',
                                        controller: emailController),
                                    _buildInputField(
                                      label: 'Password',
                                      hint: 'Masukkan password',
                                      controller: passwordController,
                                      obscureText: !_showPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: AppTheme.abu),
                                        onPressed: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                      ),
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
                                        keyboardType: TextInputType.number),
                                    _buildInputField(
                                        label: 'No Telepon',
                                        hint: 'Masukkan nomor telepon',
                                        controller: phoneController),
                                    _buildInputField(
                                      label: 'Konfirmasi Password',
                                      hint: 'Masukkan ulang password',
                                      controller: confirmPasswordController,
                                      obscureText: !_showConfirmPassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            _showConfirmPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: AppTheme.abu),
                                        onPressed: () {
                                          setState(() {
                                            _showConfirmPassword =
                                                !_showConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                        _buildDropdownField(
                          label: 'Jenis Kelamin',
                          items: const ['L', 'P'],
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
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _onRegisterPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Buat Akun',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
