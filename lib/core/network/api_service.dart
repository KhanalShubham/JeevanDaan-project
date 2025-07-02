// lib/core/network/api_service.dart

import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/core/network/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';

class ApiService {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  Dio get dio => _dio;

  ApiService(Dio dio, {required TokenSharedPrefs tokenSharedPrefs})
      : _dio = dio,
        _tokenSharedPrefs = tokenSharedPrefs {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor()) // This interceptor is added correctly.
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final tokenResult = await _tokenSharedPrefs.getToken();
            tokenResult.fold(
              (failure) {
                print('Failed to get token from shared preferences: ${failure.message}');
              },
              (token) {
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                  print('Token attached: ${token.substring(0, 10)}...');
                }
              },
            );
            return handler.next(options);
          },
          onError: (DioException err, handler) {
            return handler.next(err);
          },
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}