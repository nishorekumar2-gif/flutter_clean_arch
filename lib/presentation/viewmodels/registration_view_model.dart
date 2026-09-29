import 'package:dio/dio.dart';
import 'package:flutter_clean_arch/data/datasources/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/////Registration view model//////

///////Presentation layer//////
final registrationUseCaseProvider = Provider<RegistrationUseCase>((ref) {
  final registrationDataStore = RegistrationDataSource(dioClient);
  final repository = RegistrationRepositoryImpl(registrationDataStore);
  return RegistrationUseCase(repository);
});

final registrationViewModelProvider =
    StateNotifierProvider<RegistrationViewModel, RegistrationState>((ref) {
      return RegistrationViewModel(ref.read(registrationUseCaseProvider));
    });

class RegistrationState {
  final UserModel? user;
  final String? error;
  final bool isLoading;

  const RegistrationState({this.user, this.error, this.isLoading = false});

  RegistrationState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  final RegistrationUseCase registrationUseCase;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegistrationViewModel(this.registrationUseCase)
    : super(const RegistrationState());

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      state = state.copyWith(isLoading: false, error: 'Passwords do not match');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await registrationUseCase.execute(
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      );
      state = state.copyWith(isLoading: false, user: user, error: null);
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      emailController.text = user.email ?? '';
    } catch (ex) {
      state = state.copyWith(isLoading: false, error: 'Registration failed');
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

/////// Domain layer //////
class RegistrationUseCase {
  final RegistrationRepository registrationRepository;

  RegistrationUseCase(this.registrationRepository);

  Future<UserModel> execute(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) {
    return registrationRepository.registrationCall(
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
    );
  }
}

abstract class RegistrationRepository {
  Future<UserModel> registrationCall(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  );
}

///// Data layer//////
class RegistrationRepositoryImpl extends RegistrationRepository {
  final RegistrationDataSource registrationDataStore;

  RegistrationRepositoryImpl(this.registrationDataStore);

  @override
  Future<UserModel> registrationCall(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) {
    return registrationDataStore.registrationCall(
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
    );
  }
}

class RegistrationDataSource {
  final Dio dio;

  RegistrationDataSource(this.dio);

  Future<UserModel> registrationCall(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final response = await dio.post(
      '/users',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
