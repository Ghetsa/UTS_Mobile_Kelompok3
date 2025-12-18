import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../laporan/data/models/tagihan_warga_model.dart';
import '../../../laporan/controller/bayar_tagihan_warga_controller.dart';

class BayarTagihanPage extends StatefulWidget {
  const BayarTagihanPage({super.key});

  @override
  State<BayarTagihanPage> createState() => _BayarTagihanPageState();
}

class _BayarTagihanPageState extends State<BayarTagihanPage> {
  final _formKey = GlobalKey<FormState>();
  final BayarTagihanController _controller = BayarTagihanController();

  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nominalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagihan =
        ModalRoute.of(context)!.settings.arguments as TagihanWargaModel;

    if (_nominalController.text.isEmpty) {
      _nominalController.text = tagihan.nominal;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text('Bayar Tagihan'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.primaryBlue.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pembayaran Iuran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tagihan.iuran,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Info Tagihan Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              "Informasi Tagihan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.family_restroom,
                          label: "Keluarga",
                          value: tagihan.keluarga,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.category,
                          label: "Jenis Iuran",
                          value: tagihan.iuran,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: "Periode",
                          value: tagihan.periode,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.qr_code,
                          label: "Kode Tagihan",
                          value: tagihan.kode,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.payments,
                          label: "Nominal",
                          value: "Rp ${tagihan.nominal}",
                          isHighlight: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Form Pembayaran
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_note,
                                color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              "Form Pembayaran",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _nominalController,
                          decoration: InputDecoration(
                            labelText: "Nominal Pembayaran (Rp)",
                            hintText: "Masukkan nominal pembayaran",
                            prefixIcon: Icon(Icons.money,
                                color: AppTheme.primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppTheme.primaryBlue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Nominal tidak boleh kosong";
                            }
                            final cleaned =
                                value.replaceAll(RegExp(r'[^0-9]'), '');
                            if (cleaned.isEmpty ||
                                int.tryParse(cleaned) == null) {
                              return "Nominal harus berupa angka";
                            }
                            if ((int.tryParse(cleaned) ?? 0) <= 0) {
                              return "Nominal harus > 0";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _catatanController,
                          decoration: InputDecoration(
                            labelText: "Catatan Pembayaran (Opsional)",
                            hintText: "Contoh: Dibayar via transfer BCA",
                            prefixIcon: Icon(Icons.note_alt,
                                color: AppTheme.primaryBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppTheme.primaryBlue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          maxLines: 3,
                          maxLength: 200,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting
                          ? null
                          : () async {
                              final ok = _formKey.currentState?.validate() ?? false;
                              if (!ok) return;

                              setState(() => _submitting = true);
                              try {
                                await _controller.submitPembayaran(
                                  context,
                                  tagihan,
                                  _nominalController.text,
                                  _catatanController.text,
                                );
                              } finally {
                                if (mounted) setState(() => _submitting = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Konfirmasi Pembayaran",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isHighlight ? Colors.green.shade700 : Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color:
                      isHighlight ? Colors.green.shade700 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
