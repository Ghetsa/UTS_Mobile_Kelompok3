import '../data/models/pengguna_model.dart';
import '../data/services/pengguna_service.dart';

class PenggunaController {
  final UserService _service = UserService();

  Future<List<User>> getAllUsers() async {
    return await _service.getAllUsers();
  }

  Future<bool> addUser(User user) async {
    return await _service.addUser(user);
  }

  Future<bool> updateUser(String docId, Map<String, dynamic> data) async {
    return await _service.updateUser(docId, data);
  }

  Future<bool> deleteUser(String docId) async {
    return await _service.deleteUser(docId);
  }
}
