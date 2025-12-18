import 'package:flutter/material.dart';

class LogBadge extends StatelessWidget {
  final String role;

  const LogBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (role.toLowerCase()) {
      case "admin":
        bg = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;
      case "owner":
        bg = Colors.purple.shade50;
        textColor = Colors.purple.shade800;
        break;
      case "staff":
        bg = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        break;
      case "user":
        bg = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;
      default:
        bg = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        role,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
