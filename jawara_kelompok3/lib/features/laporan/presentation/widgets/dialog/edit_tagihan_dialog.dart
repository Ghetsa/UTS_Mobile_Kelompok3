import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../data/models/tagihan_model.dart';

class EditTagihanDialog extends StatefulWidget {
  final TagihanModel tagihan;

  const EditTagihanDialog({super.key, required this.tagihan});

  @override
  State<EditTagihanDialog> createState() => _EditTagihanDialogState();
}

class _EditTagihanDialogState extends State<EditTagihanDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _keluargaController;
  late TextEditingController _iuranController;
  late TextEditingController _nominalController;
  late TextEditingController _periodeController;

  String? _selectedStatus;

  static const String sBelum = "Belum Dibayar";
  static const String sMenunggu = "Menunggu Verifikasi";
  static const String sSudah = "Sudah Dibayar";

  List<String> get _statusItems {
    final raw = <String>[sBelum, sMenunggu, sSudah];
    final unique = <String>[];
    for (final s in raw) {
      if (!unique.contains(s)) unique.add(s);
    }
    return unique;
  }

  String _norm(String? raw) {
    final v = (raw ?? "").trim();
    final singleSpace = v.replaceAll(RegExp(r'\s+'), ' ');
    return singleSpace.toLowerCase();
  }

  String _canonStatus(String? raw) {
    final v = _norm(raw);
    if (v == _norm(sSudah)) return sSudah;
    if (v == _norm(sMenunggu)) return sMenunggu;
    return sBelum;
  }

  bool get _isMenungguVerifikasi => _canonStatus(_selectedStatus) == sMenunggu;

  Color _statusColor(String status) {
    final v = _norm(status);
    if (v == _norm(sSudah)) return const Color.fromARGB(255, 0, 66, 2);
    if (v == _norm(sMenunggu)) return const Color.fromARGB(255, 253, 173, 1);
    return const Color.fromARGB(255, 212, 14, 0);
  }

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  void initState() {
    super.initState();
    _keluargaController = TextEditingController(text: widget.tagihan.keluarga);
    _iuranController = TextEditingController(text: widget.tagihan.iuran);
    _nominalController = TextEditingController(text: widget.tagihan.nominal);
    _periodeController = TextEditingController(text: widget.tagihan.periode);
    _selectedStatus = _canonStatus(widget.tagihan.tagihanStatus);
  }

  @override
  void dispose() {
    _keluargaController.dispose();
    _iuranController.dispose();
    _nominalController.dispose();
    _periodeController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final safeStatus = _canonStatus(_selectedStatus);

    // ✅ AMBIL NILAI HASIL EDIT DARI CONTROLLER
    final newPeriode = _periodeController.text.trim();
    final newNominal = _digitsOnly(_nominalController.text.trim());

    final updatedTagihan = TagihanModel(
      id: widget.tagihan.id,
      keluarga: widget.tagihan.keluarga,
      status: widget.tagihan.status,
      iuran: widget.tagihan.iuran,
      kode: widget.tagihan.kode,
      nominal: newNominal, // ✅ fix
      periode: newPeriode, // ✅ fix
      tagihanStatus: safeStatus,
      createdAt: widget.tagihan.createdAt,
    );

    Navigator.pop(context, updatedTagihan);
  }

  void _verifikasi() {
    setState(() => _selectedStatus = sSudah);
    _simpan();
  }

  void _tolak() {
    setState(() => _selectedStatus = sBelum);
    _simpan();
  }

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.85;

    final items = _statusItems;
    final canon = _canonStatus(_selectedStatus);
    final safeValue = items.contains(canon) ? canon : sBelum;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Tagihan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  _isMenungguVerifikasi
                      ? "Warga sudah mengirim pembayaran. Silakan verifikasi."
                      : "Ubah status tagihan yang diperlukan.",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _keluargaController,
                  decoration: const InputDecoration(labelText: "Nama Keluarga"),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _iuranController,
                  decoration: const InputDecoration(labelText: "Iuran"),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _periodeController,
                  decoration: const InputDecoration(labelText: "Periode"),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nominalController,
                  decoration: const InputDecoration(labelText: "Nominal (Rp)"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return "Nominal wajib diisi";
                    final digits = _digitsOnly(v);
                    if (digits.isEmpty) return "Nominal harus berupa angka";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey<String>(safeValue),
                  value: safeValue,
                  decoration:
                      const InputDecoration(labelText: "Status Tagihan"),
                  items: items.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _statusColor(status),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedStatus = _canonStatus(value)),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Pilih status" : null,
                ),
                const SizedBox(height: 24),
                if (_isMenungguVerifikasi) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _tolak,
                          icon: const Icon(Icons.close),
                          label: const Text("Tolak"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _verifikasi,
                          icon: const Icon(Icons.verified),
                          label: const Text("Verifikasi"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                      ),
                      child: const Text("Batal"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
