import '../data/models/pengguna_model.dart';
import '../data/services/pengguna_service.dart';

class PenggunaController {
  final UserService _service = UserService();

  Future<List<User>> getAllUsers() async {
    return await _service.getAllUsers();
  }

  Future<bool> addUser(User user, String password) async {
    return await _service.addUser(user, password);
  }

  Future<bool> updateUser(String docId, Map<String, dynamic> data) async {
    return await _service.updateUser(docId, data);
  }

  Future<bool> deleteUser(String uid) async {
    return await _service.deleteUser(uid);
  }
}
