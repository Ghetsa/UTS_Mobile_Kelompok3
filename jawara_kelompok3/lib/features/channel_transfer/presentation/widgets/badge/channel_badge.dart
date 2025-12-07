import 'package:flutter/material.dart';

class ChannelBadge extends StatelessWidget {
  final String type;

  const ChannelBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (type.toLowerCase()) {
      case "manual":
        bg = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;

      case "auto":
        bg = Colors.blue.shade50;
        textColor = Colors.blue.shade800;
        break;

      case "qr":
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
        type,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
