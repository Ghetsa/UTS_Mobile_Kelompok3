import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/channel_transfer_model.dart';

class ChannelTransferService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('channel_transfer');

  Future<List<ChannelTransfer>> getAllChannels() async {
    try {
      final snapshot = await _col.orderBy('created_at', descending: true).get();
      return snapshot.docs
          .map((doc) => ChannelTransfer.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e, st) {
      print('ERROR GET ALL CHANNELS: $e');
      print(st);
      return [];
    }
  }

  Future<ChannelTransfer?> getDetail(String docId) async {
    try {
      final doc = await _col.doc(docId).get();
      if (!doc.exists) return null;
      return ChannelTransfer.fromFirestore(doc.id, doc.data()!);
    } catch (e, st) {
      print('ERROR GET DETAIL CHANNEL: $e');
      print(st);
      return null;
    }
  }

  Future<bool> addChannel(ChannelTransfer channel) async {
    try {
      final map = channel.toMap();
      map['created_at'] = FieldValue.serverTimestamp();
      map['updated_at'] = FieldValue.serverTimestamp();
      await _col.add(map);
      return true;
    } catch (e, st) {
      print('ERROR ADD CHANNEL: $e');
      print(st);
      return false;
    }
  }

  Future<bool> updateChannel(String docId, Map<String, dynamic> newData) async {
    try {
      newData['updated_at'] = FieldValue.serverTimestamp();
      await _col.doc(docId).update(newData);
      return true;
    } catch (e, st) {
      print('ERROR UPDATE CHANNEL: $e');
      print(st);
      return false;
    }
  }

  Future<bool> deleteChannel(String docId) async {
    try {
      await _col.doc(docId).delete();
      return true;
    } catch (e, st) {
      print('ERROR DELETE CHANNEL: $e');
      print(st);
      return false;
    }
  }
}
