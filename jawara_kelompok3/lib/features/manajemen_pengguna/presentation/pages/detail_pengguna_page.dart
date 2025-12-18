import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/layout/header.dart';
import '../../../../core/layout/sidebar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pengguna_model.dart';

class DetailPenggunaPage extends StatefulWidget {
  final User user; // Data dari dokumen warga

  const DetailPenggunaPage({super.key, required this.user});

  @override
  State<DetailPenggunaPage> createState() => _DetailPenggunaPageState();
}

class _DetailPenggunaPageState extends State<DetailPenggunaPage> {
  String email = '-';
  String role = '-';
  bool loadingUserData = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Ambil data user dari collection 'users' berdasarkan uid warga
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.docId) // asumsi docId warga sama dengan uid di users
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        setState(() {
          email = data?['email'] ?? '-';
          role = data?['role'] ?? '-';
          loadingUserData = false;
        });
      } else {
        setState(() {
          email = '-';
          role = '-';
          loadingUserData = false;
        });
      }
    } catch (e) {
      setState(() {
        email = '-';
        role = '-';
        loadingUserData = false;
      });
      debugPrint("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final foto = widget.user.fotoIdentitas ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2F9),
      drawer: const AppSidebar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeader(
              title: "Detail Pengguna",
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
                    padding: const EdgeInsets.all(24),
                    child: loadingUserData
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Detail Pengguna",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color(0xFF48B0E0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Profil Pengguna
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xFF48B0E0),
                                    child: foto.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(
                                              foto,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.person,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.nama,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        role,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              // Detail field (read-only)
                              _buildReadOnlyField(
                                  "Nama Lengkap", widget.user.nama),
                              _buildReadOnlyField("Email", email),
                              _buildReadOnlyField("NIK", widget.user.nik),
                              _buildReadOnlyField("Nomor HP", widget.user.noHp),
                              _buildReadOnlyField(
                                  "Jenis Kelamin", widget.user.jenisKelamin),
                              _buildReadOnlyField(
                                  "Status Registrasi", widget.user.statusWarga),
                              _buildReadOnlyField("Role", role),
                              const SizedBox(height: 24),
                              // Foto identitas
                              const Text(
                                "Foto Identitas:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: foto.isNotEmpty
                                      ? Image.network(
                                          foto,
                                          width: double.infinity,
                                          height: 250,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'assets/images/gambar1.jpg',
                                            width: double.infinity,
                                            height: 250,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/gambar1.jpg',
                                          width: double.infinity,
                                          height: 250,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Tombol Kembali
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF48B0E0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  child: const Text(
                                    "Kembali",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
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
        ),
      ]),
    );
  }
}
