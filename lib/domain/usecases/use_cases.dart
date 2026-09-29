//Usecases
import 'package:flutter_clean_arch/data/models/user_model.dart';
import 'package:flutter_clean_arch/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserModel> execute(String username, String password) {
    return repository.login(username, password);
  }
}
