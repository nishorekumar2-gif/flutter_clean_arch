//Repository

import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String username, String password);
}
