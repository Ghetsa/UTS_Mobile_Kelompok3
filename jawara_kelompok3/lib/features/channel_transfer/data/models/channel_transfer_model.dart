import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelTransfer {
  final String docId;
  final String namaChannel;
  final String kodeBank;
  final String nomorRekening;
  final String namaPemilik;
  final String statusAktif;
  final String jenis;
  final String? catatan;
  final String? thumbnail;
  final String? qr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChannelTransfer({
    required this.docId,
    required this.namaChannel,
    required this.kodeBank,
    required this.nomorRekening,
    required this.namaPemilik,
    required this.statusAktif,
    required this.jenis,
    this.catatan,
    this.thumbnail,
    this.qr,
    this.createdAt,
    this.updatedAt,
  });

  factory ChannelTransfer.fromFirestore(
      String docId, Map<String, dynamic> data) {
    return ChannelTransfer(
      docId: docId,
      namaChannel: data['namaChannel'] ?? '',
      kodeBank: data['kodeBank'] ?? '',
      nomorRekening: data['nomorRekening'] ?? '',
      namaPemilik: data['namaPemilik'] ?? '',
      statusAktif: data['statusAktif'] ?? 'Nonaktif',
      jenis: data['jenis'] ?? 'manual',
      catatan: data['catatan'],
      thumbnail: data['thumbnail'],
      qr: data['qr'],
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaChannel': namaChannel,
      'kodeBank': kodeBank,
      'nomorRekening': nomorRekening,
      'namaPemilik': namaPemilik,
      'statusAktif': statusAktif,
      'jenis': jenis,
      'catatan': catatan ?? '',
      'thumbnail': thumbnail ?? '',
      'qr': qr ?? '',
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
