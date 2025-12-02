import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/pesan_warga_model.dart';
import '../badge/aspirasi_status_badge.dart';

class AspirasiDesktopTable extends StatelessWidget {
  final List<PesanWargaModel> data;
  final void Function(PesanWargaModel) onMorePressed;

  const AspirasiDesktopTable({
    super.key,
    required this.data,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(AppTheme.lightBlue.withOpacity(0.3)),
        dataRowColor: MaterialStateProperty.all(AppTheme.backgroundBlueWhite),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.hitam,
        ),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Isi Pesan')),
          DataColumn(label: Text('Kategori')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Tanggal Dibuat')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: List.generate(data.length, (index) {
          final item = data[index];

          return DataRow(
            cells: [
              DataCell(Text((index + 1).toString())),

              // ISI PESAN
              DataCell(
                SizedBox(
                  width: 230,
                  child: Text(
                    item.isiPesan,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // KATEGORI
              DataCell(Text(item.kategori)),

              // STATUS + BADGE
              DataCell(
                AspirasiStatusBadge(status: item.status),
              ),

              // TANGGAL
              DataCell(
                Text(
                  item.createdAt?.toString().substring(0, 16) ?? "-",
                ),
              ),

              // MORE ACTION
              DataCell(
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () => onMorePressed(item),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
