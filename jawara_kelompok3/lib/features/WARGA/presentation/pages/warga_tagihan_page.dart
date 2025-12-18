import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../laporan/presentation/widgets/card/tagihan_warga_card.dart';
import '../../../laporan/data/models/tagihan_warga_model.dart';
import '../../../laporan/controller/tagihan_warga_controller.dart';
import '../../../../../../core/layout/header_warga.dart';
import '../../../../../../core/layout/sidebar_warga.dart';

class TagihanWargaPage extends StatefulWidget {
  const TagihanWargaPage({super.key});

  @override
  State<TagihanWargaPage> createState() => _TagihanWargaPageState();
}

class _TagihanWargaPageState extends State<TagihanWargaPage> {
  final TagihanController _controller = TagihanController();

  List<TagihanWargaModel> dataTagihan = [];
  bool _loading = true;

  String search = "";
  String _wargaDocId = "";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }

    final wargaDocId = await _resolveWargaDocId(user.uid);

    if (!mounted) return;

    if (wargaDocId == null || wargaDocId.isEmpty) {
      setState(() {
        _wargaDocId = "";
        dataTagihan = [];
        _loading = false;
      });
      return;
    }

    _wargaDocId = wargaDocId;
    await _loadTagihan();
  }

  Future<String?> _resolveWargaDocId(String uid) async {
    final wargaCol = FirebaseFirestore.instance.collection('warga');

    final direct = await wargaCol.doc(uid).get();
    if (direct.exists) return direct.id;

    final q1 = await wargaCol.where('user_id', isEqualTo: uid).limit(1).get();
    if (q1.docs.isNotEmpty) return q1.docs.first.id;

    final q2 = await wargaCol.where('uid', isEqualTo: uid).limit(1).get();
    if (q2.docs.isNotEmpty) return q2.docs.first.id;

    return null;
  }

  Future<void> _loadTagihan() async {
    setState(() => _loading = true);
    try {
      final tagihanList =
          await _controller.fetchByKepalaKeluargaId(_wargaDocId);

      if (!mounted) return;
      setState(() {
        dataTagihan = tagihanList; // ✅ SUDAH BENAR (TagihanWargaModel)
        _loading = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("LOAD TAGIHAN ERROR: $e");
      if (!mounted) return;
      setState(() {
        dataTagihan = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = search.trim().isEmpty
        ? dataTagihan
        : dataTagihan.where((t) {
            final q = search.toLowerCase();
            return t.keluarga.toLowerCase().contains(q) ||
                t.iuran.toLowerCase().contains(q) ||
                t.kode.toLowerCase().contains(q) ||
                t.periode.toLowerCase().contains(q) ||
                t.tagihanStatus.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const SidebarWarga(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeaderWarga(
              title: "Tagihan",
              searchHint: "Cari tagihan...",
              showSearchBar: true,
              onSearch: (v) => setState(() => search = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_wargaDocId.isEmpty)
                      ? const Center(
                          child: Text(
                            "Data warga tidak ditemukan.\nPastikan akun ini terhubung dengan data warga.",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : (filtered.isEmpty)
                          ? const Center(child: Text("Belum ada tagihan."))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final tagihan = filtered[index];
                                return TagihanCardWarga(data: tagihan);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
