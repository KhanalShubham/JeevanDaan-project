// lib/features/dashboard/data/data_source/dashboard_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/request/data/dto/get_all_requests_dto.dart';
import 'package:jeevandaan/features/request/data/models/request_api_model.dart';
import 'package:jeevandaan/features/user/data/models/user_api_model.dart';

abstract class IDashboardRemoteDataSource {
  Future<UserApiModel> getUserDetails();
  Future<List<RequestApiModel>> getRecentRequests();
}

class DashboardRemoteDataSourceImpl implements IDashboardRemoteDataSource {
  final ApiService apiService;

  DashboardRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserApiModel> getUserDetails() async {
    try {
      final response = await apiService.dio.get(ApiEndpoints.getMe);
      return UserApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _convertDioException(e);
    }
  }

  @override
  Future<List<RequestApiModel>> getRecentRequests() async {
    try {
      final response = await apiService.dio.get(ApiEndpoints.getDashboardRequests);
      final dto = GetAllRequestsDto.fromJson(response.data);
      return dto.data;
    } on DioException catch (e) {
      throw _convertDioException(e);
    }
  }

  ServerException _convertDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const ServerException(message: 'Connection timed out or network error');
    }

    String errorMessage = 'An unknown server error occurred';

    if (e.response?.data is Map) {
      errorMessage = e.response!.data['message']?.toString() ?? e.message ?? errorMessage;
    } else {
      errorMessage = e.response?.statusMessage ?? e.message ?? errorMessage;
    }

    return ServerException(message: errorMessage);
  }
}