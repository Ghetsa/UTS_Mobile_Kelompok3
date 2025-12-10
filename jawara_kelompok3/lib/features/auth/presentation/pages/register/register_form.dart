import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RegisterForm extends StatefulWidget {
  final Function(
    String name,
    String email,
    String password,
    String confirmPassword,
    String nik,
    String phone,
    String? gender,
    String? address,
    String? ownershipStatus,
    Uint8List? profilePhotoBytes,
    String? profilePhotoName,
  ) onChange;

  const RegisterForm({super.key, required this.onChange});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Uint8List? _profilePhotoBytes;
  String? _profilePhotoName;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _profilePhotoBytes = result.files.first.bytes;
        _profilePhotoName = result.files.first.name;
      });

      widget.onChange(
        nameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
        nikController.text,
        phoneController.text,
        null,
        null,
        null,
        _profilePhotoBytes,
        _profilePhotoName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // contoh minimal field (Anda bisa menambah sesuai kebutuhan)
        TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Nama')),
        const SizedBox(height: 8),
        TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email')),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickFile,
          child: Text(_profilePhotoName ?? "Pilih Foto"),
        ),
      ],
    );
  }
}
