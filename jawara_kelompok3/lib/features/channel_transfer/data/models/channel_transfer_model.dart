import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelTransfer {
  final String docId;
  final String namaChannel;
  final String nomorRekening;
  final String namaPemilik;
  final String jenis;
  final String? catatan;
  final String? thumbnail;
  final String? qr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChannelTransfer({
    required this.docId,
    required this.namaChannel,
    required this.nomorRekening,
    required this.namaPemilik,
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
      namaChannel: data['nama_channel'] ?? '',
      nomorRekening: data['no_rekening'] ?? '',
      namaPemilik: data['nama_pemilik'] ?? '',
      jenis: data['tipe'] ?? 'manual',
      catatan: data['catatan'],
      thumbnail: data['thumbnail_url'],
      qr: data['qr_url'],
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
      'nama_channel': namaChannel,
      'no_rekening': nomorRekening,
      'nama_pemilik': namaPemilik,
      'tipe': jenis,
      'catatan': catatan ?? '',
      'thumbnail_url': thumbnail ?? '',
      'qr_url': qr ?? '',
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
