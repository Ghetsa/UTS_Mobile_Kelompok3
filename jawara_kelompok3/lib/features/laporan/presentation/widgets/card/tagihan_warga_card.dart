import 'package:flutter/material.dart';
import '../../../data/models/tagihan_warga_model.dart';

class TagihanCardWarga extends StatelessWidget {
  final TagihanWargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit; // This is used for "Bayar Tagihan"

  const TagihanCardWarga({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Remove 'static' from here, define the colors in the 'State' class instead
    final Color _green = const Color(0xFF2F6F4E);
    final Color _brown = const Color(0xFF8B6B3E);

    return Container(
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
          // Header Row
          Row(
            children: [
              Expanded(
                child: Text(
                  data.keluarga,
                  style: TextStyle(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _green.withOpacity(0.25)),
                ),
                child: Text(
                  data.tagihanStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: data.tagihanStatus == "Belum Dibayar"
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Info Rows
          Row(
            children: [
              _Pill(icon: Icons.category, text: data.iuran, color: _brown),
              const SizedBox(width: 8),
              _Pill(icon: Icons.place, text: data.periode, color: _green),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.money, size: 18, color: _brown),
              const SizedBox(width: 8),
              Text(
                "Rp ${data.nominal}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Pill({required this.icon, required this.text, required this.color});

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
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
