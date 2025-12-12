import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class WargaStatCard extends StatelessWidget {
  final int aktif;
  final int nonaktif;

  const WargaStatCard({
    super.key,
    required this.aktif,
    required this.nonaktif,
  });

  @override
  Widget build(BuildContext context) {
    final total = aktif + nonaktif;

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
          const Text(
            "Total Warga",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total: $total warga",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _itemStat(value: aktif, label: "Aktif"),
              _divider(),
              _itemStat(value: nonaktif, label: "Nonaktif"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemStat({required int value, required String label}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "$value",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.shade300,
    );
  }
}
