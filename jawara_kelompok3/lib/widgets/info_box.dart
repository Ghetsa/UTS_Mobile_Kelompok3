import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Info:\nIuran Bulanan: Dibayar setiap bulan sekali secara rutin.\n"
        "Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu.",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
      ),
    );
  }
}
