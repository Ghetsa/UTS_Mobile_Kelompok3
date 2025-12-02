import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/pesan_warga_model.dart';

class AspirasiMobileList extends StatelessWidget {
  final List<PesanWargaModel> data;
  final void Function(PesanWargaModel) onMorePressed;

  const AspirasiMobileList({
    super.key,
    required this.data,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.putihFull,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.abu,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),

            // -----------------------------------------------------
            // 🔵 NOMOR URUT — sekarang pakai index+1
            // -----------------------------------------------------
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: AppTheme.putihFull,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // -----------------------------------------------------
            // 🔵 ISI PESAN (judul pendek)
            // -----------------------------------------------------
            title: Text(
              item.isiPesan,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            // -----------------------------------------------------
            // 🔵 KATEGORI + TANGGAL
            // -----------------------------------------------------
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                Text(
                  "Kategori: ${item.kategori}",
                  style: const TextStyle(
                    color: AppTheme.hitam,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: AppTheme.abu),
                    const SizedBox(width: 4),
                    Text(
                      item.createdAt?.toString().substring(0, 16) ??
                          "- tidak ada tanggal -",
                      style: const TextStyle(
                        color: AppTheme.abu,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // -----------------------------------------------------
            // 🔵 TOMBOL ACTION (edit/hapus/detail)
            // -----------------------------------------------------
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => onMorePressed(item),
            ),
          ),
        );
      },
    );
  }
}
