import 'package:flutter/material.dart';
import '../../../data/models/tagihan_warga_model.dart';

class TagihanCardWarga extends StatelessWidget {
  final TagihanWargaModel data;

  final VoidCallback? onDetail;
  final VoidCallback? onBayar;
  final Future<void> Function()? onRefresh;

  const TagihanCardWarga({
    super.key,
    required this.data,
    this.onDetail,
    this.onBayar,
    this.onRefresh,
  });

  static const Color _green = Color(0xFF2F6F4E);
  static const Color _brown = Color(0xFF8B6B3E);

  // ✅ NORMALISASI BIAR AMAN DI WEB (NBSP, newline, double space, dll)
  String _clean(String? raw) {
    return (raw ?? '')
        .replaceAll('\u00A0', ' ') // NBSP
        .replaceAll(RegExp(r'\s+'), ' ') // banyak whitespace -> 1 spasi
        .trim()
        .toLowerCase();
  }

  bool get _isBelumDibayar {
    final s = _clean(data.tagihanStatus);

    // kalau kosong, anggap belum dibayar biar tombol tetap muncul
    if (s.isEmpty) return true;

    // toleransi beberapa variasi
    return s == 'belum dibayar' ||
        s == 'pending' ||
        s == 'unpaid' ||
        s.contains('belum'); // "belum bayar", "belum dibayar ", dst
  }

  bool get _isMenungguVerifikasi {
    final s = _clean(data.tagihanStatus);
    return s.contains('menunggu') && s.contains('verifikasi');
  }

  bool get _isSudahDibayar {
    final s = _clean(data.tagihanStatus);
    return s.contains('sudah') && s.contains('dibayar');
  }

  Color _statusColor() {
    if (_isBelumDibayar) return Colors.red;
    if (_isMenungguVerifikasi) return Colors.orange.shade800;
    if (_isSudahDibayar) return Colors.green.shade700;
    return Colors.grey.shade700;
  }

  Color _statusBg() => _statusColor().withOpacity(0.10);

  Future<void> _goBayar(BuildContext context) async {
    if (onBayar != null) {
      onBayar!();
      return;
    }

    final changed = await Navigator.pushNamed(
      context,
      '/warga/bayarTagihan',
      arguments: data,
    );

    if (changed == true && onRefresh != null) {
      await onRefresh!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onDetail,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: _green.withOpacity(0.10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    data.keluarga,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: _green,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusBg(),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: statusColor.withOpacity(0.25)),
                  ),
                  child: Text(
                    data.tagihanStatus,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ===== Pills =====
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Pill(icon: Icons.category, text: data.iuran, color: _brown),
                if (data.periode.trim().isNotEmpty)
                  _Pill(
                      icon: Icons.calendar_today,
                      text: data.periode,
                      color: _green),
                if (data.kode.trim().isNotEmpty)
                  _Pill(
                      icon: Icons.qr_code,
                      text: data.kode,
                      color: Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 12),

            // ===== Nominal =====
            Row(
              children: [
                const Icon(Icons.payments, size: 18, color: _brown),
                const SizedBox(width: 8),
                Text(
                  "Rp ${data.nominal}",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // ===== Tombol Bayar (jika belum dibayar) =====
            if (_isBelumDibayar) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _goBayar(context),
                  icon: const Icon(Icons.payment, size: 18),
                  label: const Text("Bayar Tagihan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ] else if (_isMenungguVerifikasi) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.25)),
                ),
                child: Text(
                  "Pembayaran sudah dikirim. Menunggu verifikasi admin.",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Pill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
