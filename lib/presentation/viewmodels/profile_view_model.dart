import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/data/models/user_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Profile view model ///
///// Presentation layer //////
final profileUsecaseProvider = Provider<ProfileUseCase>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://dummyjson.com",
      receiveTimeout: const Duration(seconds: 3),
      sendTimeout: const Duration(seconds: 3),
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  final dataSource = ProfileDataSource(dio);
  final repository = ProfileRepositoryImpl(dataSource);

  return ProfileUseCase(repository);
});

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
      return ProfileViewModel(ref.read(profileUsecaseProvider));
    });

class ProfileViewModel extends StateNotifier<ProfileState> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ProfileUseCase profileUsecases;

  ProfileViewModel(this.profileUsecases) : super(const ProfileState());

  void viewUpdate(User userDetails) {
    firstNameController.text = userDetails.firstName ?? '';
    lastNameController.text = userDetails.lastName ?? '';
    emailController.text = userDetails.email ?? '';
  }

  Future<void> getProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userDetails = await profileUsecases.executeGetProfile(userId);
      state = state.copyWith(
        isLoading: false,
        userDetails: userDetails,
        error: null,
      );
      viewUpdate(userDetails);
    } catch (ex) {
      state = state.copyWith(isLoading: false, error: 'Get Profile failed');
    }
  }

  Future<void> updateProfile(
    String? firstName,
    String? lastName,
    String? email,
  ) async {
    if (firstName == null || lastName == null || email == null) {
      state = state.copyWith(isLoading: false, error: 'Update Profile error');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final userDetails = await profileUsecases.executeUpdateProfile(
        firstName,
        lastName,
        email,
      );
      state = state.copyWith(
        isLoading: false,
        userDetails: userDetails,
        error: null,
      );
      viewUpdate(userDetails);
    } catch (ex) {
      state = state.copyWith(isLoading: false, error: 'Update Profile error');
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

///// Domain layer //////
//Entities
class ProfileState {
  final bool isLoading;
  final User? userDetails;
  final String? error;

  const ProfileState({this.isLoading = false, this.userDetails, this.error});

  ProfileState copyWith({bool? isLoading, User? userDetails, String? error}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userDetails: userDetails ?? this.userDetails,
      error: error ?? this.error,
    );
  }
}

abstract class ProfileRepository {
  Future<User> getProfile(String userId);
  Future<User> updateProfile(
    String? firstName,
    String? lastName,
    String? email,
  );
}

class ProfileUseCase {
  final ProfileRepository profileRepository;

  ProfileUseCase(this.profileRepository);

  Future<User> executeGetProfile(String userId) {
    return profileRepository.getProfile(userId);
  }

  Future<User> executeUpdateProfile(
    String? firstName,
    String? lastName,
    String? email,
  ) {
    return profileRepository.updateProfile(firstName, lastName, email);
  }
}

///// Data layer /////
class ProfileDataSource {
  final Dio dio;

  ProfileDataSource(this.dio);

  Future<User> updateProfile(
    String? firstName,
    String? lastName,
    String? email,
  ) async {
    final pref = await SharedPreferences.getInstance();
    final userId = pref.getInt("user_id");
    print("Update profile userId : $userId");

    final response = await dio.put(
      '/users/$userId',
      data: {'firstName': firstName, 'lastName': lastName, 'email': email},
      options: Options(headers: {'content-type': 'application/json'}),
    );
    print("Update Response :$response");
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> getProfile(String userId) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final accessToken = sharedPreferences.getString("access_token");
    print("Access Token Get: $accessToken");
    final response = await dio.get(
      '/user/me',
      options: Options(
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    print("Get Profile :$response");
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}

// class UserDetailsModel {
//   final String? userId;
//   final String? userName;
//   final String? firstName;
//   final String? lastName;
//   final String? image;
//   final String? email;

//   UserDetailsModel({
//     this.userId,
//     this.userName,
//     this.firstName,
//     this.lastName,
//     this.image,
//     this.email,
//   });

//   factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
//     return UserDetailsModel(
//       userId: json['userId']?.toString() ?? '',
//       userName: json['userName']?.toString() ?? '',
//       firstName: json['firstName']?.toString() ?? '',
//       lastName: json['lastName']?.toString() ?? '',
//       image: json['image']?.toString(),
//       email: json['email']?.toString() ?? '',
//     );
//   }
// }

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDataSource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<User> getProfile(String userId) {
    return profileDataSource.getProfile(userId);
  }

  @override
  Future<User> updateProfile(
    String? firstName,
    String? lastName,
    String? email,
  ) {
    return profileDataSource.updateProfile(firstName, lastName, email);
  }
}
