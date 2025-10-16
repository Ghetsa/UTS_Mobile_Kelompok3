import 'package:flutter/material.dart';
import '../../main.dart';

const Color primaryDark = Color(0xFF5C4E43); 
const Color secondaryCream = Color(0xFFEDE8D2); 
const Color accentGold = Color(0xFFC7B68D); 

class User {
  final int no;
  final String nama;
  final String email;
  final String statusRegistrasi;
  final String role; 
  final String nik;
  final String noHp;
  final String jenisKelamin;

  User(
    this.no,
    this.nama,
    this.email,
    this.statusRegistrasi, {
    this.role = "Warga",
    this.nik = "Tidak tersedia",
    this.noHp = "08XXXXXXXXXX",
    this.jenisKelamin = "Tidak Tersedia",
  });
}

// HALAMAN EDIT
class EditPenggunaPage extends StatefulWidget {
  final User user;

  const EditPenggunaPage({super.key, required this.user});

  @override
  State<EditPenggunaPage> createState() => _EditPenggunaPageState();
}

class _EditPenggunaPageState extends State<EditPenggunaPage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  late String _selectedRole;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _noHpController = TextEditingController(text: widget.user.noHp == "08XXXXXXXXXX" ? "" : widget.user.noHp);
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  final List<String> availableRoles = ["Warga", "Bendahara", "Ketua RT", "Admin"];

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      // Simulasi pembaruan data
      final updatedUser = User(
        widget.user.no,
        _namaController.text,
        _emailController.text,
        widget.user.statusRegistrasi,
        role: _selectedRole,
        nik: widget.user.nik,
        noHp: _noHpController.text,
        jenisKelamin: widget.user.jenisKelamin
      );

      // Setelah menyimpan, kembali ke halaman sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data ${updatedUser.nama} berhasil diperbarui!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Akun Pengguna: ${widget.user.nama}"),
        backgroundColor: secondaryCream,
        foregroundColor: primaryDark,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Edit Akun Pengguna",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryDark,
                            ),
                      ),
                      const Divider(height: 30, thickness: 2),

                      // Nama Lengkap
                      _buildTextField("Nama Lengkap", _namaController, "Masukkan nama lengkap", 
                        validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null),
                      const SizedBox(height: 16),
                      
                      // Email
                      _buildTextField("Email", _emailController, "Masukkan email", readOnly: true), 
                      const SizedBox(height: 16),

                      // Nomor HP
                      _buildTextField("Nomor HP", _noHpController, "Masukkan nomor HP", keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),

                      // Password Baru
                      _buildTextField("Password Baru (kosongkan jika tidak diganti)", TextEditingController(), "Kosongkan jika tidak diganti", isPassword: true),
                      const SizedBox(height: 16),

                      // Konfirmasi Password Baru
                      _buildTextField("Konfirmasi Password Baru", TextEditingController(), "Masukkan kembali password", isPassword: true),
                      const SizedBox(height: 16),

                      // Role (Dropdown) 
                      _buildDropdownField("Role (tidak dapat diubah)", _selectedRole, availableRoles),
                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          onPressed: _simpanPerubahan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDark,
                            foregroundColor: secondaryCream,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Perbarui", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText, {bool isPassword = false, bool readOnly = false, String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: primaryDark)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[100] : secondaryCream,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdownField(String label, String currentValue, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: primaryDark)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: currentValue,
          decoration: InputDecoration( 
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            filled: true,
            fillColor: Colors.grey[200], 
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: null, 
        ),
      ],
    );
  }
}

// MAIN PAGE (Simulasi Daftar Pengguna)
class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<User> users = [
    User(1, "Bia", "y@gmail.com", "Diterima", role: "Bendahara", noHp: "089722321412", nik: "320101XXXXXXXXX", jenisKelamin: "Perempuan"),
    User(2, "Ijat4", "ijat4@gmail.com", "Pending"),
    User(3, "Dani", "dani@test.com", "Diterima", role: "Warga", noHp: "081234567890", nik: "320102XXXXXXXXX", jenisKelamin: "Laki-laki"),
    User(4, "Admin Utama", "admin@domain.com", "Diterima", role: "Admin", noHp: "080011223344", nik: "320103XXXXXXXXX", jenisKelamin: "Laki-laki"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Pengguna (Simulasi)"),
        backgroundColor: primaryDark,
        foregroundColor: secondaryCream,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith((states) => accentGold.withOpacity(0.3)),
          columns: const [
            DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
            DataColumn(label: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
            DataColumn(label: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
            DataColumn(label: Text('ROLE', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
            DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold, color: primaryDark))),
          ],
          rows: users.map((user) {
            final isApproved = user.statusRegistrasi == "Diterima";
            final statusColor = isApproved ? Colors.green : Colors.amber;

            return DataRow(cells: [
              DataCell(Text(user.no.toString())),
              DataCell(Text(user.nama)),
              DataCell(Text(user.email)),
              DataCell(Text(user.role)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.statusRegistrasi,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    // TOMBOL EDIT 
                    IconButton(
                      icon: const Icon(Icons.edit, color: primaryDark),
                      tooltip: "Edit",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPenggunaPage(user: user), 
                          ),
                        );
                      },
                    ),
                    // TOMBOL DETAIL
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: accentGold),
                      tooltip: "Detail",
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPenggunaPage(user: user), 
                          ),
                        );
                      },
                    ),
                    // TOMBOL HAPUS 
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: "Hapus",
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text("Fitur Hapus untuk ${user.nama} dipilih.")),
                         );
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

// KODE HALAMAN DETAIL 
class DetailPenggunaPage extends StatelessWidget {
  final User user;

  const DetailPenggunaPage({super.key, required this.user});

  Widget _buildDetailItem({
    required String key,
    required String value,
    required bool isApproved,
  }) {
    final statusWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: value == "Diterima" ? Colors.green[100] : Colors.amber[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: value == "Diterima" ? Colors.green[700] : Colors.amber[700],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          key == "Status Registrasi"
              ? statusWidget
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengguna"),
        backgroundColor: secondaryCream,
        foregroundColor: primaryDark,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: primaryDark),
                  label: const Text(
                    "Kembali",
                    style: TextStyle(
                      color: primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informasi Lengkap Pengguna",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryDark,
                          ),
                        ),
                        const Divider(height: 30),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: accentGold, 
                              child: const Icon(
                                Icons.person,
                                size: 35,
                                color: primaryDark,
                              ),
                            ),
                            const SizedBox(width: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.nama,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.role,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        _buildDetailItem(
                          key: "NIK",
                          value: user.nik,
                          isApproved: user.nik != "Tidak Tersedia",
                        ),
                        _buildDetailItem(
                          key: "Email",
                          value: user.email,
                          isApproved: true,
                        ),
                        _buildDetailItem(
                          key: "Nomor HP",
                          value: user.noHp,
                          isApproved: user.noHp != "08XXXXXXXXXX",
                        ),
                        _buildDetailItem(
                          key: "Jenis Kelamin",
                          value: user.jenisKelamin,
                          isApproved: user.jenisKelamin != "Tidak Tersedia",
                        ),
                        _buildDetailItem(
                          key: "Status Registrasi",
                          value: user.statusRegistrasi,
                          isApproved: user.statusRegistrasi == "Diterima",
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