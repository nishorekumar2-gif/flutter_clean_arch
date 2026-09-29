import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_arch/data/models/home_details_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

///Presentation layer
final homeScreenUseCasesProvider = Provider<HomeScreenUseCases>((ref) {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://dummyjson.com",
      sendTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  final dataSource = HomeDataSource(dio);
  final repository = HomeRepositoryImpl(dataSource);

  return HomeScreenUseCases(repository);
});

final homeScreenViewModelProvider =
    StateNotifierProvider<HomeScreenViewModel, HomeScreenState>((ref) {
      return HomeScreenViewModel(ref.read(homeScreenUseCasesProvider));
    });

class HomeScreenViewModel extends StateNotifier<HomeScreenState> {
  HomeScreenUseCases homeScreenUseCases;
  HomeScreenViewModel(this.homeScreenUseCases)
    : super(HomeScreenState.initial());

  Future<void> execute(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      HomeDetailsModel homedetails = await homeScreenUseCases.execute(userId);
      debugPrint("HomeDetails : ${homedetails.limit}");
      debugPrint("HomeDetails : ${homedetails.products![0].title}");
      state = state.copyWith(isLoading: false, homedetails: homedetails);
    } catch (ex) {
      state = state.copyWith(
        isLoading: false,
        error: "Something went to wrong",
      );
    }
  }
}

////// Domain layer /////////

class HomeScreenState {
  bool? isLoading;
  String? error;
  HomeDetailsModel? homedetails;

  HomeScreenState({this.isLoading, this.error, this.homedetails});

  HomeScreenState copyWith({
    bool? isLoading,
    String? error,
    HomeDetailsModel? homedetails,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      homedetails: homedetails ?? this.homedetails,
    );
  }

  factory HomeScreenState.initial() {
    return HomeScreenState(isLoading: false, error: null, homedetails: null);
  }
}

abstract class HomeRepository {
  Future<HomeDetailsModel> getHomeDetails(String userId);
}

class HomeRepositoryImpl extends HomeRepository {
  HomeDataSource homeDataSource;
  HomeRepositoryImpl(this.homeDataSource);
  @override
  Future<HomeDetailsModel> getHomeDetails(String userId) {
    return homeDataSource.getHomeDetails(userId);
  }
}

class HomeScreenUseCases {
  HomeRepository homeRepository;
  HomeScreenUseCases(this.homeRepository);
  Future<HomeDetailsModel> execute(String userId) {
    return homeRepository.getHomeDetails(userId);
  }
}

class HomeDataSource {
  Dio dio;
  HomeDataSource(this.dio);

  Future<HomeDetailsModel> getHomeDetails(String userId) async {
    final response = await dio.get("/products");
    // print("Response home details : $response");
    debugPrint("Response home details: $response");
    return HomeDetailsModel.fromJson(response.data as Map<String, dynamic>);
  }
}

/*
class HomeDetailsModel {
  List<String>? carouselImages;
  String? userId;
  List<String>? productImages;
  List<ProductModel>? productList;
  HomeDetailsModel({
    this.carouselImages,
    this.userId,
    this.productImages,
    this.productList,
  });

  factory HomeDetailsModel.fromJson(Map<String, dynamic> json) {
    return HomeDetailsModel(
      carouselImages: json["carouselImages"] ?? [],
      userId: json["id"] ?? '',
      productImages: json["productImages"] ?? [],
      productList: (json["productList"] ?? [])
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductModel {
  String? productName;
  String? id;
  String? price;

  ProductModel({this.productName, this.id, this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json["productName"] ?? '',
      id: json["id"] ?? '',
      price: json["price"] ?? '',
    );
  }
}
*/
