import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/layout/header_warga.dart';
import '../../../../core/layout/sidebar_warga.dart';

class WargaAspirasiPage extends StatefulWidget {
  const WargaAspirasiPage({super.key});

  @override
  State<WargaAspirasiPage> createState() => _WargaAspirasiPageState();
}

class _WargaAspirasiPageState extends State<WargaAspirasiPage> {
  static const Color _green = Color(0xFF2F6F4E);
  static const Color _brown = Color(0xFF8B6B3E);
  static const Color _bg = Color(0xFFF4F7F3);

  // ✅ koleksi harus sama dengan admin
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('pesan_warga');

  Future<String> _getNamaWarga(String uid) async {
    try {
      // 1) coba users/{uid}
      final udoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final u = udoc.data();
      final namaUsers = (u?['nama'] ?? '').toString().trim();
      if (namaUsers.isNotEmpty) return namaUsers;

      // 2) coba warga docId == uid
      final wdoc =
          await FirebaseFirestore.instance.collection('warga').doc(uid).get();
      if (wdoc.exists) {
        final w = wdoc.data() ?? {};
        final namaWarga = (w['nama'] ?? '').toString().trim();
        if (namaWarga.isNotEmpty) return namaWarga;
      }

      // 3) fallback: email
      return FirebaseAuth.instance.currentUser?.email ?? 'Warga';
    } catch (_) {
      return FirebaseAuth.instance.currentUser?.email ?? 'Warga';
    }
  }

  String _fmtTime(dynamic ts) {
    if (ts == null) return "-";
    if (ts is Timestamp) {
      final d = ts.toDate();
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final hh = d.hour.toString().padLeft(2, '0');
      final mi = d.minute.toString().padLeft(2, '0');
      return "$dd-$mm-${d.year} • $hh:$mi";
    }
    return "-";
  }

  Color _statusColor(String s) {
    final v = s.toLowerCase().trim();

    // admin kamu pakai apa? umumnya: Pending/Diterima/Ditolak/Selesai/Diproses
    if (v.contains('selesai')) return _green;
    if (v.contains('diproses') || v.contains('diterima')) return _brown;
    if (v.contains('ditolak')) return Colors.red;
    if (v.contains('pending')) return Colors.grey.shade700;

    return Colors.grey.shade700;
  }

  Future<void> _openTambahAspirasi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _snack("Kamu belum login.", isError: true);
      return;
    }

    final kategoriList = const [
      "Aspirasi",
      "Keluhan",
      "Saran",
      "Laporan",
    ];

    final judulC = TextEditingController();
    final isiC = TextEditingController();
    String kategori = kategoriList.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Aspirasi"),
        content: StatefulBuilder(
          builder: (context, setLocal) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            final maxH = MediaQuery.of(context).size.height * 0.55;

            return AnimatedPadding(
              padding: EdgeInsets.only(bottom: bottomInset),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxH),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: judulC,
                        decoration: const InputDecoration(
                          labelText: "Judul / Ringkas",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: kategori,
                        decoration: const InputDecoration(
                          labelText: "Kategori",
                          border: OutlineInputBorder(),
                        ),
                        items: kategoriList
                            .map((k) =>
                                DropdownMenuItem(value: k, child: Text(k)))
                            .toList(),
                        onChanged: (v) =>
                            setLocal(() => kategori = v ?? kategori),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: isiC,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Isi Pesan",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, false);
            },
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, true);
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final judul = judulC.text.trim();
    final isi = isiC.text.trim();
    if (judul.isEmpty || isi.isEmpty) {
      _snack("Judul dan isi pesan wajib diisi.", isError: true);
      return;
    }

    final nama = await _getNamaWarga(uid);

    // ✅ id pesan (admin butuh field "id")
    final idPesan = "P-${DateTime.now().millisecondsSinceEpoch}";

    // ✅ status default (samakan dengan admin)
    const statusDefault = "Pending";

    await _col.add({
      'id': idPesan,
      'user_id': uid,
      'nama': nama,
      'isi_pesan':
          "$judul\n\n$isi", // judul disimpan di isi agar admin tetap tampil
      'kategori': kategori,
      'status': statusDefault,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    _snack("✅ Aspirasi berhasil dikirim.");
  }

  Future<void> _confirmDelete(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data() ?? {};
    final status = (data['status'] ?? '').toString();

    // warga hanya boleh hapus kalau masih pending (biar aman)
    final isPending = status.toLowerCase().contains('pending');
    if (!isPending) {
      _snack("Tidak bisa dihapus karena sudah diproses admin.", isError: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Aspirasi"),
        content: const Text("Yakin ingin menghapus aspirasi ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _col.doc(doc.id).delete();
    if (!mounted) return;
    _snack("✅ Aspirasi dihapus.");
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : _green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // ✅ sengaja TANPA orderBy biar tidak butuh index (sorting di client)
    final stream = (uid == null)
        ? const Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
        : _col.where('user_id', isEqualTo: uid).snapshots();

    return Scaffold(
      backgroundColor: _bg,
      drawer: const SidebarWarga(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_comment),
        label: const Text("Tambah Aspirasi"),
        onPressed: _openTambahAspirasi,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeaderWarga(
              title: "Aspirasi Warga",
              showSearchBar: false,
              showFilterButton: false,
            ),
            Expanded(
              child: uid == null
                  ? const Center(
                      child: Text("Silakan login untuk melihat aspirasi."))
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: stream,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snap.hasError) {
                          return Center(
                            child: Text(
                              "Error: ${snap.error}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        var docs = snap.data?.docs ?? [];

                        // ✅ sorting client-side (created_at desc)
                        docs = docs.toList()
                          ..sort((a, b) {
                            final ta = (a.data()['created_at'] as Timestamp?)
                                    ?.millisecondsSinceEpoch ??
                                0;
                            final tb = (b.data()['created_at'] as Timestamp?)
                                    ?.millisecondsSinceEpoch ??
                                0;
                            return tb.compareTo(ta);
                          });

                        if (docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: _EmptyState(
                              green: _green,
                              brown: _brown,
                              onAdd: _openTambahAspirasi,
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: docs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final doc = docs[i];
                            final d = doc.data();

                            final idPesan = (d['id'] ?? '').toString();
                            final isiPesan = (d['isi_pesan'] ?? '').toString();
                            final kategori = (d['kategori'] ?? '').toString();
                            final status =
                                (d['status'] ?? 'Pending').toString();
                            final createdAt = d['created_at'];

                            // judul tampil: ambil baris pertama dari isi_pesan
                            final judul =
                                isiPesan.split('\n').first.trim().isEmpty
                                    ? "Aspirasi"
                                    : isiPesan.split('\n').first.trim();

                            return _AspirasiCard(
                              green: _green,
                              brown: _brown,
                              judul: judul,
                              subtitle: kategori.isEmpty
                                  ? idPesan
                                  : "$kategori • $idPesan",
                              isi: isiPesan,
                              status: status,
                              statusColor: _statusColor(status),
                              createdLabel: _fmtTime(createdAt),
                              onDelete: () => _confirmDelete(doc),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color green;
  final Color brown;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.green,
    required this.brown,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: green.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.forum_outlined, size: 46, color: green),
          const SizedBox(height: 10),
          Text(
            "Belum ada aspirasi",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: green,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Kirim aspirasi/keluhan/saran agar admin bisa menindaklanjuti.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Buat Aspirasi"),
          )
        ],
      ),
    );
  }
}

class _AspirasiCard extends StatelessWidget {
  final Color green;
  final Color brown;

  final String judul;
  final String subtitle;
  final String isi;
  final String status;
  final Color statusColor;
  final String createdLabel;

  final VoidCallback onDelete;

  const _AspirasiCard({
    required this.green,
    required this.brown,
    required this.judul,
    required this.subtitle,
    required this.isi,
    required this.status,
    required this.statusColor,
    required this.createdLabel,
    required this.onDelete,
  });

  bool get _isPending => status.toLowerCase().contains('pending');

  @override
  Widget build(BuildContext context) {
    // tampilkan isi tanpa mengulang judul (ambil setelah baris pertama)
    final lines = isi.split('\n');
    final body = (lines.length <= 1) ? isi : lines.skip(1).join('\n').trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: green.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  judul,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: green,
                  ),
                ),
              ),
              if (_isPending)
                IconButton(
                  tooltip: "Hapus (hanya jika masih Pending)",
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
                color: Colors.grey.shade700, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withOpacity(0.25)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.schedule, size: 16, color: brown),
              const SizedBox(width: 6),
              Text(
                createdLabel,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(color: Colors.grey.shade800, height: 1.3),
            ),
          ],
        ],
      ),
    );
  }
}
