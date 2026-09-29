//Repository implementation
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch/data/datasources/auth_data_source.dart';
import 'package:flutter_clean_arch/data/models/user_model.dart';
import 'package:flutter_clean_arch/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);
  @override
  Future<UserModel> login(String username, String password) async {
    final json = await authRemoteDataSource.loginAPI(username, password);
    debugPrint("json resp: $json");
    return json;
  }
}
