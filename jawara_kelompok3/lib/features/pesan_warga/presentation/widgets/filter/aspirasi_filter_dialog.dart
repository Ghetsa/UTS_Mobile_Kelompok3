import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AspirasiFilterDialog extends StatefulWidget {
  final String initialSearch;
  final String? initialStatus;
  final void Function(String search, String? status) onApply;
  final VoidCallback onReset;

  const AspirasiFilterDialog({
    super.key,
    required this.initialSearch,
    required this.initialStatus,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<AspirasiFilterDialog> createState() => _AspirasiFilterDialogState();
}

class _AspirasiFilterDialogState extends State<AspirasiFilterDialog> {
  late TextEditingController _searchCtrl;
  String? _status;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.initialSearch);
    _status = widget.initialStatus;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundBlueWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Filter Pesan Warga',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppTheme.primaryBlue,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Judul",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.hitam,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _searchCtrl,
              style: const TextStyle(
                color: AppTheme.hitam,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: "Cari Judul",
                hintStyle: const TextStyle(
                  color: AppTheme.abu,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: AppTheme.abu.withOpacity(0.2),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppTheme.abu),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Status",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.hitam,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.abu.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.abu),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _status,
                hint: const Text('-- Pilih Status --'),
                items: const [
                  DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                  DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                ],
                onChanged: (val) => setState(() => _status = val),
                dropdownColor: AppTheme.putih,
                style: const TextStyle(
                  color: AppTheme.hitam,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onReset();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.redMediumDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Text('Reset Filter',
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_searchCtrl.text, _status);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.greenDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child:
              const Text('Terapkan', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
