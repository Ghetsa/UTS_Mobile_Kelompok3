import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/services/keluarga_service.dart';
import '../../../data/services/rumah_service.dart';

class WargaCard extends StatefulWidget {
  final WargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WargaCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<WargaCard> createState() => _WargaCardState();
}

class _WargaCardState extends State<WargaCard> {
  final _keluargaService = KeluargaService();
  final _rumahService = RumahService();

  String? _namaKepalaKeluarga;
  String? _alamatRumah;
  bool _loadingRelasi = true;

  @override
  void initState() {
    super.initState();
    _loadRelasi();
  }

  Future<void> _loadRelasi() async {
    try {
      // ambil kepala keluarga dari koleksi "keluarga"
      if (widget.data.idKeluarga.isNotEmpty) {
        final keluarga =
            await _keluargaService.getByDocId(widget.data.idKeluarga);
        _namaKepalaKeluarga = keluarga?.kepalaKeluarga;
      }

      // ambil alamat rumah dari koleksi "rumah"
      if (widget.data.idRumah.isNotEmpty) {
        final rumah = await _rumahService.getByDocId(widget.data.idRumah);
        _alamatRumah = rumah?.alamat;
      }
    } catch (_) {
      // kalau error, biarkan null saja
    }

    if (!mounted) return;
    setState(() {
      _loadingRelasi = false;
    });
  }

  // Konversi jenis kelamin ke teks panjang
  String _genderText(String jk) {
    final lower = jk.toLowerCase();
    if (lower == 'l') return 'Laki-laki';
    if (lower == 'p') return 'Perempuan';
    return jk;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    // fallback status kalau kosong
    final rawStatus =
        (data.statusWarga.isEmpty ? "aktif" : data.statusWarga).toLowerCase();

    // warna kecil buat badge/status
    Color statusColor() {
      switch (rawStatus) {
        case 'aktif':
          return Colors.green.shade600;
        case 'nonaktif':
          return Colors.red.shade600;
        case 'pindah':
          return Colors.orange.shade600;
        case 'sementara':
          return Colors.blueGrey.shade600;
        default:
          return Colors.grey.shade700;
      }
    }

    // teks status dengan huruf pertama kapital
    String statusText() {
      if (rawStatus.isEmpty) return "-";
      return rawStatus[0].toUpperCase() + rawStatus.substring(1);
    }

    // teks kepala keluarga: loading / ada / tidak ada
    String kepalaKeluargaText() {
      if (_loadingRelasi) return "Kepala Keluarga: (memuat...)";
      if ((_namaKepalaKeluarga ?? "").isEmpty) {
        return "Kepala Keluarga: -";
      }
      return "Kepala Keluarga: $_namaKepalaKeluarga";
    }

    // teks alamat rumah
    String alamatRumahText() {
      if (_loadingRelasi) return "Alamat Rumah: (memuat...)";
      if ((_alamatRumah ?? "").isEmpty) {
        return "Alamat Rumah: -";
      }
      return "Alamat Rumah: $_alamatRumah";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON ORANG
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.purple),
          ),

          const SizedBox(width: 16),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama
                Text(
                  data.nama,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Jenis kelamin • Agama • Pendidikan
                Text(
                  "${_genderText(data.jenisKelamin)} • ${data.agama} • ${data.pendidikan.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // NIK
                Text(
                  "NIK: ${data.nik}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // Kepala keluarga dari koleksi keluarga (id_keluarga)
                Text(
                  kepalaKeluargaText(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // Alamat rumah dari koleksi rumah (id_rumah)
                Text(
                  alamatRumahText(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // Pekerjaan + No HP
                Text(
                  "${data.pekerjaan} • ${data.noHp.isEmpty ? '-' : data.noHp}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 8),

                // Status badge + created time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor()),
                          const SizedBox(width: 6),
                          Text(
                            statusText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CreatedAt
                    Text(
                      data.createdAt != null
                          ? data.createdAt.toString().substring(0, 16)
                          : "-",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // MENU (detail, edit, hapus)
          PopupMenuButton(
            onSelected: (value) {
              if (value == "detail" && widget.onDetail != null) {
                widget.onDetail!();
              }
              if (value == "edit" && widget.onEdit != null) {
                widget.onEdit!();
              }
              if (value == "hapus" && widget.onDelete != null) {
                widget.onDelete!();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "detail",
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Detail"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "hapus",
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Hapus"),
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
