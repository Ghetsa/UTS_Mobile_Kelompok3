import 'package:flutter/material.dart';
import '../Theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;
  }

  // LOGIN
  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Tampilkan dialog sukses
        await showMessageDialog(
          title: 'Berhasil!',
          message: 'Selamat datang ${user.email}',
          success: true,
        );

        setState(() {
          isLoading = false;
        });

        // Arahkan langsung ke dashboard TAMPA ROLE
        Navigator.pushReplacementNamed(
          context,
          '/dashboard/kegiatan',
          arguments: {'user': user},
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String message = 'Terjadi kesalahan, coba lagi';

      if (e.code == 'user-not-found') {
        message = 'Email tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah';
      }

      await showMessageDialog(
        title: 'Gagal!',
        message: message,
        success: false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      await showMessageDialog(
        title: 'Kesalahan!',
        message: 'Terjadi kesalahan, coba lagi',
        success: false,
      );
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardMaxWidth = screenWidth > 470 ? 400.0 : screenWidth * 0.80;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo dan Judul Aplikasi
                Column(
                  children: [
                    Image.asset('assets/images/Logo_jawara.png',
                        height: 60), // Logo aplikasi
                    const SizedBox(height: 8),
                    const Text(
                      'Jawara',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.putihFull,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Teks Selamat Datang
                const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.putihFull,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Login untuk mengakses sistem Jawara.',
                  style: TextStyle(fontSize: 14, color: AppTheme.putih),
                ),
                const SizedBox(height: 30),

                // Card Form Login
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardMaxWidth),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundBlueWhite,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.abu.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Judul Card
                        const Center(
                          child: Text(
                            'Masuk ke akun anda',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Input Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(
                            color: AppTheme.hitam,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan email disini',
                            hintStyle: const TextStyle(
                              color: AppTheme.abu,
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: AppTheme.putih,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.abu),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Input Email
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            color: AppTheme.hitam,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan password disini',
                            hintStyle: const TextStyle(
                              color: AppTheme.abu,
                              fontSize: 16,
                            ),
                            filled: true,
                            fillColor: AppTheme.putih,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.abu),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppTheme.abu,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 20),

                        // Tombol Login
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: AppTheme.putihFull)
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.putihFull,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tombol Register / Daftar
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Belum punya akun? ',
                                style: TextStyle(color: AppTheme.hitam),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'Daftar', // Teks link register
                                  style: TextStyle(
                                    color: AppTheme.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppTheme.primaryBlue,
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
