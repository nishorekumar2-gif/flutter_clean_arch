import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// Shared HTTP client used by all data sources and direct API calls.
final Dio dioClient =
    Dio(
        BaseOptions(
          baseUrl: 'https://dummyjson.com/',
          connectTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          headers: const {'Content-Type': 'application/json'},
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            request.headers["Authorization"] = "Bearer ";
            print(
              "Request : ${request.uri} , ${request.data}, ${request.headers}",
            );
            debugPrint("handler : $handler");
            return handler.next(request);
          },
          onResponse: (response, handler) {
            debugPrint(
              "Request : ${response.realUri} , ${response.data}, ${response.headers}",
            );
            return handler.next(response);
          },
          onError: (error, handler) {
            debugPrint("Request : ${error.error} , ${error.message}");
            return handler.next(error);
          },
        ),
      );
