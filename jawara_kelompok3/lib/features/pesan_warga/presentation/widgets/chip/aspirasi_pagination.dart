import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AspirasiPagination extends StatelessWidget {
  final int currentPage; // index 0-based
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const AspirasiPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 0
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        ...List.generate(totalPages, (i) {
          final isActive = i == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isActive ? AppTheme.primaryBlue : AppTheme.putihFull,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => onPageChanged(i),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  color: isActive ? AppTheme.putihFull : AppTheme.hitam,
                ),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }
}
