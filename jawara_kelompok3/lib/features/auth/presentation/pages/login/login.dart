import 'package:flutter/material.dart';
import '../../../../../core/layout/header.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../firebase_options.dart';

// tambahan untuk session & biometric
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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

  // session & security
  final LocalAuthentication authLocal = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    initializeFirebaseAndSession();
  }

  Future<void> initializeFirebaseAndSession() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;

    // init SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Coba restore session yang masih aktif (Firebase tetap simpan session secara default)
    await tryRestoreSession();

    // Coba biometric auto-login jika ada kredensial tersimpan
    await tryBiometricAutoLoginIfAvailable();
  }

  // -------- Session Management ----------
  Future<void> saveSession({
    required String uid,
    required String email,
    required String role,
  }) async {
    await _prefs?.setString('uid', uid);
    await _prefs?.setString('email', email);
    await _prefs?.setString('role', role);
    // Simpan waktu login sebagai referensi
    await _prefs?.setString('last_login', DateTime.now().toIso8601String());
  }

  Future<void> clearSession() async {
    await _prefs?.remove('uid');
    await _prefs?.remove('email');
    await _prefs?.remove('role');
    await _prefs?.remove('last_login');
    // juga hapus kredensial tersimpan (opsional)
    await secureStorage.delete(key: 'saved_email');
    await secureStorage.delete(key: 'saved_password');
  }

  Future<void> tryRestoreSession() async {
    final isLoggedOut = _prefs?.getBool('logged_out') ?? false;

    if (isLoggedOut) return; // user baru saja logout, jangan auto-redirect

    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final role = (doc.exists &&
                doc.data() != null &&
                doc.data()!.containsKey('role'))
            ? doc.data()!['role'].toString()
            : 'warga';
        await saveSession(uid: user.uid, email: user.email ?? '', role: role);
        _navigateByRole(role, user);
      } catch (_) {
        await saveSession(
            uid: user.uid, email: user.email ?? '', role: 'warga');
        _navigateByRole('warga', user);
      }
    }
  }

  // -------- Biometric helpers ----------
  Future<bool> deviceSupportsBiometrics() async {
    try {
      return await authLocal.canCheckBiometrics ||
          await authLocal.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Jika ada kredensial tersimpan di secure storage, minta biometric dan login otomatis.
  Future<void> tryBiometricAutoLoginIfAvailable() async {
    final savedEmail = await secureStorage.read(key: 'saved_email');
    final savedPassword = await secureStorage.read(key: 'saved_password');

    if (savedEmail != null && savedPassword != null) {
      // minta biometric
      try {
        final didAuthenticate = await authLocal.authenticate(
          localizedReason: 'Autentikasi untuk masuk secara cepat',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true),
        );
        if (didAuthenticate) {
          // gunakan kredensial yang tersimpan untuk login
          emailController.text = savedEmail;
          passwordController.text = savedPassword;
          await login(useSavedCredentials: true);
        }
      } catch (e) {
        // jangan tampilkan dialog agar UI tetap sama; cukup log error di console
        // print('Biometric / auto-login failed: $e');
      }
    }
  }

  /// Memungkinkan penyimpanan kredensial secara aman untuk biometric auto-login
  /// Panggil fungsi ini dari bagian pengaturan / profil setelah user setuju.
  Future<void> enableBiometricForCurrentUser(
      String email, String password) async {
    final supports = await deviceSupportsBiometrics();
    if (!supports) return;
    await secureStorage.write(key: 'saved_email', value: email);
    await secureStorage.write(key: 'saved_password', value: password);
  }

  /// Matikan biometric auto-login (hapus kredensial)
  Future<void> disableBiometricForCurrentUser() async {
    await secureStorage.delete(key: 'saved_email');
    await secureStorage.delete(key: 'saved_password');
  }

  // -------- LOGIN ----------
  /// parameter useSavedCredentials true -> gunakan isi controller (yang sudah diisi) seperti biasa.
  Future<void> login({bool useSavedCredentials = false}) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      await showMessageDialog(
        title: 'Gagal!',
        message: 'Email dan password wajib diisi.',
        success: false,
      );
      return;
    }

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
        // ambil role dari Firestore (collection 'users', field 'role')
        String role = 'warga';
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists &&
              doc.data() != null &&
              doc.data()!.containsKey('role')) {
            role = doc.data()!['role'].toString();
          } else {
            // jika belum ada, set default role di Firestore (opsional)
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'email': user.email ?? '',
              'role': role,
              'updated_at': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }
        } catch (e) {
          // jika gagal ambil role, biarkan role default 'warga'
        }

        // simpan session
        await saveSession(uid: user.uid, email: user.email ?? '', role: role);

        // Tampilkan dialog sukses
        await showMessageDialog(
          title: 'Berhasil!',
          message: 'Selamat datang ${user.email}',
          success: true,
        );

        setState(() {
          isLoading = false;
        });

        // Arahkan berdasarkan role
        _navigateByRole(role, user);
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
      } else if (e.code == 'invalid-email') {
        message = 'Format email tidak valid';
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

  // routing per role; sesuaikan route names dengan route yang Anda definisikan di app
  void _navigateByRole(String role, User user) {
    // Simpan role di SharedPreferences
    _prefs?.setString('role', role);

    // Anda bisa menyesuaikan route yang sesuai. Saya menambahkan mapping standar:
    String route =
        '/dashboard/kegiatan'; // fallback (preserve existing behavior)
    switch (role.toLowerCase()) {
      case 'admin':
        route = '/dashboard/admin';
        break;
      case 'ketua_rt':
      case 'ketuart':
      case 'ketua-rt':
        route = '/dashboard/rt';
        break;
      case 'ketua_rw':
      case 'ketuarw':
      case 'ketua-rw':
        route = '/dashboard/rw';
        break;
      case 'bendahara':
        route = '/dashboard/bendahara';
        break;
      case 'sekretaris':
        route = '/dashboard/sekretaris';
        break;
      case 'warga':
      default:
        // jika Anda ingin tetap ke '/dashboard/kegiatan' untuk warga, biarkan.
        route = '/dashboard/kegiatan';
    }

    // Jika Anda ingin mengoper arguments:
    Navigator.pushReplacementNamed(
      context,
      route,
      arguments: {'user': user, 'role': role},
    );
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

  // Anda bisa memanggil fungsi logout di menu lain; disediakan helper
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_out', true); // tandai sudah logout
    await FirebaseAuth.instance.signOut(); // logout Firebase

    // redirect ke login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                    Image.asset('assets/images/Logo_jawara.png', height: 60),
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
                                  'Daftar',
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
