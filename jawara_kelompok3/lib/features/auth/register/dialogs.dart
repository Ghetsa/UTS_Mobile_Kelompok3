import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

Future<void> showMessageDialog({
  required BuildContext context,
  required String title,
  required String message,
  required bool success,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: success ? AppTheme.greenExtraLight : AppTheme.redExtraLight,
      title: Row(
        children: [
          Icon(
            success ? Icons.check_circle_outline : Icons.error_outline,
            color: success ? AppTheme.greenDark : AppTheme.redDark,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
