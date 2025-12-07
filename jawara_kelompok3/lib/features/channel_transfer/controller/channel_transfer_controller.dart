import '../data/models/channel_transfer_model.dart';
import '../data/services/channel_transfer_service.dart';

class ChannelTransferController {
  final ChannelTransferService _service = ChannelTransferService();

  Future<bool> addChannel(ChannelTransfer channel) async {
    return await _service.addChannel(channel);
  }

  Future<bool> updateChannel(String docId, Map<String, dynamic> data) async {
    return await _service.updateChannel(docId, data);
  }

  Future<List<ChannelTransfer>> getAllChannels() async {
    return await _service.getAllChannels();
  }

  Future<bool> deleteChannel(String docId) async {
    return await _service.deleteChannel(docId);
  }
}
