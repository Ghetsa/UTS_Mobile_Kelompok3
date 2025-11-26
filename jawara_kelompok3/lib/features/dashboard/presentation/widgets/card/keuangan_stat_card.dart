import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  final bool centered; // ⬅️ Baru
  final Color background; // ⬅️ Baru
  final Color textColor; // ⬅️ Baru

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.centered = false, // default
    this.background = Colors.white, // default
    this.textColor = Colors.black, // default
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
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
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(.7),
              ),
              textAlign: centered ? TextAlign.center : TextAlign.start,
            ),
          ],
        ],
      ),
    );
  }
}
