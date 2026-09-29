import 'package:dio/dio.dart';
import 'package:flutter_clean_arch/data/datasources/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/pages/home_screen.dart';
import 'package:flutter_clean_arch/presentation/pages/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pages = [HomeScreen(), ProfileScreen(), Container()];
    final selectedIndex = ref.watch(selectedIndexProvider);
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

Future<ProductDetails> getProductList() async {
  final response = await dioClient.get(
    "https://dummyjson.com/products",
    options: Options(headers: {"content-type": "application/json"}),
  );
  //print("Response : $response");
  return response as ProductDetails;
}

Future<ProductDetails> addProduct(
  int userId,
  int productId,
  int quantity,
) async {
  final product = {"id": productId, "quantity": quantity};

  final productList = [];
  productList.add(product);

  final response = await dioClient.post(
    "https://dummyjson.com/carts/add",
    options: Options(
      headers: {"content-type": "applicaton/json"},
      extra: {"userId": userId, "products": productList},
    ),
  );
  return response as ProductDetails;
}

class ProductDetails {
  int? userId;
  int? productId;
  int? quantity;
}
