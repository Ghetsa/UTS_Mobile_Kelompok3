import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KeuanganKasCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  /// kalau kas minus -> merah, kalau plus -> kuning/emas (atau hijau kalau kamu mau)
  final bool isNegative;

  const KeuanganKasCard({
    super.key,
    this.title = "Total Kas Saat Ini",
    required this.value,
    this.subtitle = "Pemasukan - Pengeluaran",
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = isNegative ? AppTheme.redDark : AppTheme.yellowDark;

    return Container(
      width: double.infinity,
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
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          // Accent bar kiri biar beda dan rapi
          Container(
            width: 6,
            height: 66,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.90),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: accent.withOpacity(.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // icon kecil kanan (opsional)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withOpacity(0.18)),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: accent,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
