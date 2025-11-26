import 'package:flutter/material.dart';

class RumahStatusChip extends StatelessWidget {
  final String status;
  const RumahStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isTersedia = status.toLowerCase() == 'tersedia';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isTersedia ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTersedia ? Colors.green : Colors.blue, width: 0.8),
      ),
      child: Text(status, style: TextStyle(color: isTersedia ? Colors.green.shade700 : Colors.blue.shade700, fontWeight: FontWeight.bold)),
    );
  }
}
