import 'package:dio/dio.dart';

/// Shared HTTP client used by all data sources and direct API calls.
final Dio dioClient = Dio(
  BaseOptions(
    baseUrl: 'https://dummyjson.com/',
    connectTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
    headers: const {'Content-Type': 'application/json'},
  ),
);
