import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AspirasiStatusBadge extends StatelessWidget {
  final String status;

  const AspirasiStatusBadge({
    super.key,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMediumDark;
      case 'Pending':
        return AppTheme.yellowMedium;
      case 'Ditolak':
        return AppTheme.redMediumDark;
      default:
        return AppTheme.abu;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
