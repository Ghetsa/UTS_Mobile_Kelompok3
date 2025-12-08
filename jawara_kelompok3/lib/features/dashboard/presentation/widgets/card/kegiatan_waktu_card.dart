import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanWaktuCard extends StatelessWidget {
  final int lewat;
  final int hariIni;
  final int akanDatang;

  const KegiatanWaktuCard({
    super.key,
    required this.lewat,
    required this.hariIni,
    required this.akanDatang,
  });

  @override
  Widget build(BuildContext context) {
    final total = lewat + hariIni + akanDatang;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TITLE =====
          const Text(
            "Total Kegiatan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          // ===== SUBTITLE TOTAL =====
          Text(
            "Total: $total Kegiatan",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // ===== ANGKA BESAR =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _angka(lewat),
              _divider(),
              _angka(hariIni),
              _divider(),
              _angka(akanDatang),
            ],
          ),

          const SizedBox(height: 6),

          // ===== LABEL DI BAWAH ANGKA =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _label("    Lewat"),
              SizedBox(width: 1),
              _label("       Hari Ini"),
              SizedBox(width: 1),
              _label("  Akan Datang"),
            ],
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _angka(int value) {
    return Text(
      value.toString(),
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppTheme.blueDark,
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1.5,
      height: 34,
      color: AppTheme.primaryBlue,
    );
  }
}

class _label extends StatelessWidget {
  final String text;
  const _label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade700,
      ),
    );
  }
}
