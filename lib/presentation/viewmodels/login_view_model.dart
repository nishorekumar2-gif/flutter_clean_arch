import 'package:flutter_clean_arch/data/datasources/auth_data_source.dart';
import 'package:flutter_clean_arch/data/datasources/dio_client.dart';
import 'package:flutter_clean_arch/data/models/user_model.dart';
import 'package:flutter_clean_arch/data/repository_impl/repository_impl.dart';
import 'package:flutter_clean_arch/domain/usecases/use_cases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

///////////Presentation layer///////
//ViewModel
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final dataSource = AuthRemoteDataSource(dioClient);
  final repository = AuthRepositoryImpl(dataSource);
  return LoginUseCase(repository);
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(ref.read(loginUseCaseProvider));
    });

class LoginState {
  bool? isLoading;
  UserModel? user;
  String? error;
  bool? isLoggedIn;
  LoginState({this.isLoading = false, this.user, this.error, this.isLoggedIn});

  LoginState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoggedIn: user != null,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase loginUseCase;
  LoginViewModel(this.loginUseCase) : super(LoginState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await loginUseCase.execute(username, password);
      print("User details: ${user.firstName}");
      state = state.copyWith(isLoading: false, error: null, user: user);
    } catch (ex) {
      state = state.copyWith(isLoading: false, error: "Login failed");
    }
  }
}

/////////Domain layer//////////
//Entities
class User {
  final int id;
  final String username;

  User({required this.id, required this.username});
}
