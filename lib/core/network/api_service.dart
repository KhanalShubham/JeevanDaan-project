// lib/core/network/api_service.dart

import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
      // The custom DioErrorInterceptor is now REMOVED.
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final tokenResult = await _tokenSharedPrefs.getToken();
            tokenResult.fold(
              (failure) => print('Token not found: ${failure.message}'),
              (token) {
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              },
            );
            return handler.next(options);
          },
        ),
      )
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
  }
}

class ConnectivityService {
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}