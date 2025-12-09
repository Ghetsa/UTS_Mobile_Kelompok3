import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KeuanganSummaryCard extends StatelessWidget {
  final int pemasukanCount;
  final int pengeluaranCount;
  final int totalTransaksi;

  const KeuanganSummaryCard({
    super.key,
    required this.pemasukanCount,
    required this.pengeluaranCount,
    required this.totalTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== TITLE & SUBTITLE =====
          const Text(
            "Total Transaksi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total: $totalTransaksi Transaksi",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          /// ===== 3 KOLOM: PEMASUKAN | PENGELUARAN | TOTAL =====
          Row(
            children: [
              // PEMASUKAN
              Expanded(
                child: Column(
                  children: [
                    Text(
                      pemasukanCount.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.greenDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pemasukan",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // VERTICAL DIVIDER
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),

              // PENGELUARAN
              Expanded(
                child: Column(
                  children: [
                    Text(
                      pengeluaranCount.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.redDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pengeluaran",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // VERTICAL DIVIDER
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),

              // TOTAL
              Expanded(
                child: Column(
                  children: [
                    Text(
                      totalTransaksi.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.yellowDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
