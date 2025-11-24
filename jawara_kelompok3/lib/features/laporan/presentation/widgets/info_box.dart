import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.blueExtraLight,
        border: Border.all(color: AppTheme.blueDark, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Info:\nIuran Bulanan: Dibayar setiap bulan sekali secara rutin.\n"
        "Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu.",
        style: TextStyle(color: AppTheme.blueDark, fontWeight: FontWeight.w500),
      ),
    );
  }
}
