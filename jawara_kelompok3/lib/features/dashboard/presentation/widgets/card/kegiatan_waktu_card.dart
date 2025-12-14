import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class KegiatanWaktuCard extends StatelessWidget {
  final int lewat;
  final int hariIni; // diisi jumlah "sedang berlangsung"
  final int akanDatang;

  const KegiatanWaktuCard({
    super.key,
    required this.lewat,
    required this.hariIni,
    required this.akanDatang,
  });

  @override
  Widget build(BuildContext context) {
    final total = lewat + hariIni + akanDatang;

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
          const Text(
            "Total Kegiatan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total: $total Kegiatan",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Lewat
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "$lewat",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lewat",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),

             
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "$hariIni",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Berlangsung", 
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),

              // Akan Datang
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "$akanDatang",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Akan Datang",
                      style: TextStyle(
                        color: Colors.grey.shade600,
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
