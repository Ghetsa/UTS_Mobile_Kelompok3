import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_theme.dart';

class RegisterForm extends StatefulWidget {
  final Function(
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? nik,
    String? phone,
    String? gender,
    String? address,
    String? ownershipStatus,
    String? fileName,
  ) onChange;

  const RegisterForm({super.key, required this.onChange});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController manualAddressController = TextEditingController();

  String? _selectedGender;
  String? _selectedAddressOption;
  String? _selectedOwnershipStatus;
  String? _selectedFileName;

  static const String manualAddressOption = 'Alamat Rumah (Jika Tidak Ada di List)';

  // PICK FILE
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedFileName = result.files.first.name;
      });
      _updateParent();
    }
  }

  // UPDATE DATA KE PARENT
  void _updateParent() {
    String? address;
    if (_selectedAddressOption == manualAddressOption) {
      address = manualAddressController.text;
    } else {
      address = _selectedAddressOption;
    }

    widget.onChange(
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
      nikController.text,
      phoneController.text,
      _selectedGender,
      address,
      _selectedOwnershipStatus,
      _selectedFileName,
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.primaryBlue)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: AppTheme.hitam),
          onChanged: (_) => _updateParent(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.abu, fontSize: 14),
            fillColor: AppTheme.putih,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.abu),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.primaryBlue)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppTheme.putih, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            isExpanded: true,
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
            hint: Text(hint, style: TextStyle(color: AppTheme.abu, fontSize: 14)),
            items: items.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
            onChanged: (val) {
              onChanged(val);
              _updateParent();
            },
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
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.primaryBlue)),
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
              border: Border.all(color: AppTheme.abu),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_selectedFileName != null ? Icons.check_circle : Icons.upload_file,
                    color: _selectedFileName != null ? AppTheme.greenDark : AppTheme.redDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(_selectedFileName ?? 'Upload foto KK/KTP (.png/.jpg)',
                      textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
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
          onChanged: (val) => setState(() => _selectedAddressOption = val),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildInputField(label: 'Nama Lengkap', hint: 'Masukkan nama lengkap', controller: nameController),
                  _buildInputField(label: 'Email', hint: 'Masukkan email aktif', controller: emailController),
                  _buildInputField(label: 'Password', hint: 'Masukkan password', obscureText: true, controller: passwordController),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  _buildInputField(label: 'NIK', hint: 'Masukkan NIK', controller: nikController),
                  _buildInputField(label: 'No Telepon', hint: 'Masukkan nomor telepon', controller: phoneController),
                  _buildInputField(label: 'Konfirmasi Password', hint: 'Masukkan ulang password', obscureText: true, controller: confirmPasswordController),
                ],
              ),
            ),
          ],
        ),
        _buildDropdownField(
          label: 'Jenis Kelamin',
          items: const ['Laki-laki', 'Perempuan'],
          hint: '--- Pilih Jenis Kelamin ---',
          selectedValue: _selectedGender,
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
        _buildAddressSelectionField(),
        _buildDropdownField(
          label: 'Status Kepemilikan Rumah',
          items: const ['Pemilik', 'Penyewa'],
          hint: '--- Pilih Status ---',
          selectedValue: _selectedOwnershipStatus,
          onChanged: (val) => setState(() => _selectedOwnershipStatus = val),
        ),
        _buildFileUploadField(label: 'Foto Identitas'),
      ],
    );
  }
}