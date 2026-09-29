//Data Source
import 'package:dio/dio.dart';
import 'package:flutter_clean_arch/data/models/user_model.dart';

class AuthRemoteDataSource {
  Dio dio;
  AuthRemoteDataSource(this.dio);

  Future<UserModel> loginAPI(String username, String password) async {
    final response = await dio.post(
      "auth/login",
      data: {"username": username, "password": password, "expiresInMins": 30},
      options: Options(headers: {"Content-Type": "application/json"}),
    );

    //print("Response :$response");

    return UserModel.fromJson(response.data);
  }
}
