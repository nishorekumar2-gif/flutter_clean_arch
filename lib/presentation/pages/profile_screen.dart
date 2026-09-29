import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/viewmodels/profile_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => ProfileState();
}

class ProfileState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(profileViewModelProvider.notifier).getProfile('userId'),
    );
  }

  void updateProfile() {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final firstName = viewModel.firstNameController.text.trim();
    final lastName = viewModel.lastNameController.text.trim();
    final email = viewModel.emailController.text.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty && email.isNotEmpty) {
      viewModel.updateProfile(firstName, lastName, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            state.userDetails!.image!,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'First Name',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          TextField(
            controller: viewModel.firstNameController,
            decoration: const InputDecoration(
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Last Name',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          TextField(
            controller: viewModel.lastNameController,
            decoration: const InputDecoration(
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Email',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
          TextField(
            controller: viewModel.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (state.isLoading) const CircularProgressIndicator(),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ElevatedButton(
            onPressed: updateProfile,
            style: ElevatedButton.styleFrom(side: const BorderSide(width: 2.0)),
            child: const Text(
              'Profile Update',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/*
getProfileAPICall({
  String _username = 'emilys',
  String _password = 'emilyspass',
}) {
  Dio dio = Dio();
  final response = dio.post(
    "https://dummyjson.com/auth/login",
    headers: {
      "content-type": "appplication-json",
      params: {
        "username": 'emilys',
        'password': 'emilyspass',
        'expiresInMins': '30',
      },
    },
  );
  return response;
}

updateProfileAPICall(
  String userId,
  String firstName,
  String lastName,
  String email,
) {
  Dio dio = Dio();
  final response = dio.put(
    "https://dummyjson.com/users/$userId",
    headers: {"content-Type": "application-json"},
    body: {"firstName": firstName, "lastName": lastName, "email": email},
  );
  return response;
}

deleteUserAPICall(String userId) {
  Dio dio = Dio();
  final response = dio.delete("https://dummyjson.com/users/$userid");
  return response;
}
*/
