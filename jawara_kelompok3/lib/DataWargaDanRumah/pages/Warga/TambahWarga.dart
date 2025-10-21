import 'package:flutter/material.dart';
import '../../../layout/sidebar.dart';
import '../../../theme/app_theme.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  // Dropdown selections
  String? _keluarga;
  String? _jenisKelamin;
  String? _agama;
  String? _golonganDarah;
  String? _peranKeluarga;
  String? _pendidikan;
  String? _pekerjaan;
  String? _status;

  // Dispose all controllers
  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data warga berhasil disubmit (simulasi).'),
        ),
      );
      _handleReset();
    }
  }

  void _handleReset() {
    _formKey.currentState!.reset();
    setState(() {
      _keluarga = null;
      _jenisKelamin = null;
      _agama = null;
      _golonganDarah = null;
      _peranKeluarga = null;
      _pendidikan = null;
      _pekerjaan = null;
      _status = null;
    });
    _namaController.clear();
    _nikController.clear();
    _teleponController.clear();
    _tempatLahirController.clear();
    _tanggalLahirController.clear();
  }

  // Pick date of birth
  Future<void> _pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      _tanggalLahirController.text =
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title:
            const Text("Tambah Warga", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: AppTheme.backgroundBlueWhite,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppTheme.grayLight, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Tambah Warga",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Dropdown keluarga
                    _buildDropdown(
                      label: "Pilih Keluarga",
                      hint: "-- Pilih Keluarga --",
                      value: _keluarga,
                      items: const ['Keluarga A', 'Keluarga B', 'Keluarga C'],
                      onChanged: (v) => setState(() => _keluarga = v),
                    ),

                    _buildTextField(
                      label: "Nama",
                      hint: "Masukkan nama lengkap",
                      controller: _namaController,
                    ),

                    _buildTextField(
                      label: "NIK",
                      hint: "Masukkan NIK sesuai KTP",
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                    ),

                    _buildTextField(
                      label: "Nomor Telepon",
                      hint: "08xxxxxxx",
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                    ),

                    _buildTextField(
                      label: "Tempat Lahir",
                      hint: "Masukkan tempat lahir",
                      controller: _tempatLahirController,
                    ),

                    // Tanggal Lahir
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Tanggal Lahir",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _tanggalLahirController,
                            readOnly: true,
                            onTap: _pickDate,
                            decoration: InputDecoration(
                              hintText: "--/--/----",
                              hintStyle: const TextStyle(
                                  color: Colors.grey, // ← ubah warna di sini
                                  fontSize: 16),
                              filled: true,
                              fillColor: AppTheme.graySuperLight,
                              suffixIcon: const Icon(Icons.calendar_today),

                              // BORDER SAAT TIDAK FOKUS
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppTheme.grayMediumLight, width: 1),
                              ),

                              // BORDER SAAT FOKUS
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppTheme.blueMediumLight, width: 1),
                              ),

                              // (Opsional) BORDER SAAT ERROR
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.redAccent, width: 1),
                              ),

                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Tanggal lahir wajib diisi.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    _buildDropdown(
                      label: "Jenis Kelamin",
                      hint: "-- Pilih Jenis Kelamin --",
                      value: _jenisKelamin,
                      items: const ['Laki-laki', 'Perempuan'],
                      onChanged: (v) => setState(() => _jenisKelamin = v),
                    ),

                    _buildDropdown(
                      label: "Agama",
                      hint: "-- Pilih Agama --",
                      value: _agama,
                      items: const [
                        'Islam',
                        'Kristen',
                        'Katolik',
                        'Hindu',
                        'Buddha',
                        'Konghucu'
                      ],
                      onChanged: (v) => setState(() => _agama = v),
                    ),

                    _buildDropdown(
                      label: "Golongan Darah",
                      hint: "-- Pilih Golongan Darah --",
                      value: _golonganDarah,
                      items: const ['A', 'B', 'AB', 'O'],
                      onChanged: (v) => setState(() => _golonganDarah = v),
                    ),

                    _buildDropdown(
                      label: "Peran Keluarga",
                      hint: "-- Pilih Peran Keluarga --",
                      value: _peranKeluarga,
                      items: const ['Ayah', 'Ibu', 'Anak'],
                      onChanged: (v) => setState(() => _peranKeluarga = v),
                    ),

                    _buildDropdown(
                      label: "Pendidikan Terakhir",
                      hint: "-- Pilih Pendidikan Terakhir --",
                      value: _pendidikan,
                      items: const ['SD', 'SMP', 'SMA', 'D3', 'S1', 'S2', 'S3'],
                      onChanged: (v) => setState(() => _pendidikan = v),
                    ),

                    _buildDropdown(
                      label: "Pekerjaan",
                      hint: "-- Pilih Jenis Pekerjaan --",
                      value: _pekerjaan,
                      items: const [
                        'Pelajar',
                        'Wiraswasta',
                        'PNS',
                        'Karyawan Swasta',
                        'Petani',
                        'Lainnya'
                      ],
                      onChanged: (v) => setState(() => _pekerjaan = v),
                    ),

                    _buildDropdown(
                      label: "Status",
                      hint: "-- Pilih Status --",
                      value: _status,
                      items: const [
                        'Menikah',
                        'Belum Menikah',
                        'Cerai Hidup',
                        'Cerai Mati'
                      ],
                      onChanged: (v) => setState(() => _status = v),
                    ),

                    const SizedBox(height: 30),

                    // Tombol submit & reset
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.greenMediumDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Submit",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleReset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.redMediumDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Reset",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Input teks standar
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black,
              )),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Colors.grey, // ← ubah warna di sini
                  fontSize: 16),
              filled: true,
              fillColor: AppTheme.graySuperLight,
              // BORDER SAAT TIDAK FOKUS
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.grayMediumLight, width: 1),
              ),

              // BORDER SAAT FOKUS
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.blueMediumLight, width: 1),
              ),

              // (Opsional) BORDER SAAT ERROR
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return '$label wajib diisi.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Dropdown field standar
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: AppTheme.graySuperLight,
              // BORDER SAAT TIDAK FOKUS
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.grayMediumLight, width: 1),
              ),

              // BORDER SAAT FOKUS
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.blueMediumLight, width: 1),
              ),

              // (Opsional) BORDER SAAT ERROR
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return '$label wajib dipilih.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
