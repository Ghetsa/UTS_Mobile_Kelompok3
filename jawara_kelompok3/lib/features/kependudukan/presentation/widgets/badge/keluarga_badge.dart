import 'package:flutter/material.dart';

class KeluargaBadge extends StatelessWidget {
  final String label;

  const KeluargaBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
    );
  }
}
