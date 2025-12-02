import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'register_form.dart';
import 'register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();

  // Semua data dari RegisterForm
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  String? nik;
  String? phone;
  String? gender;
  String? address;
  String? ownershipStatus;
  String? fileName;

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
                // Logo & Judul
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Logo_jawara.png', width: 60, height: 60),
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

                // Card Form
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

                        // RegisterForm
                        RegisterForm(
                          onChange: (
                            nameValue,
                            emailValue,
                            passwordValue,
                            confirmPasswordValue,
                            nikValue,
                            phoneValue,
                            genderValue,
                            addressValue,
                            ownershipStatusValue,
                            fileNameValue,
                          ) {
                            setState(() {
                              name = nameValue;
                              email = emailValue;
                              password = passwordValue;
                              confirmPassword = confirmPasswordValue;
                              nik = nikValue;
                              phone = phoneValue;
                              gender = genderValue;
                              address = addressValue;
                              ownershipStatus = ownershipStatusValue;
                              fileName = fileNameValue;
                            });
                          },
                        ),

                        // Tombol Submit
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              await _controller.registerUser(
                                context: context,
                                email: email ?? '',
                                password: password ?? '',
                                confirmPassword: confirmPassword ?? password ?? '',
                                name: name ?? '',
                                nik: nik ?? '',
                                phone: phone ?? '',
                                role: 'warga',
                                gender: gender,
                                address: address,
                                ownershipStatus: ownershipStatus,
                                fileName: fileName,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

                        // Link login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Sudah punya akun? ', style: TextStyle(color: AppTheme.hitam)),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
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