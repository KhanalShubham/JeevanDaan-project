import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/user/data/models/user_api_model.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract class ISettingsRemoteDataSource {
  Future<UserApiModel> updateUserDetails(UserEntity user);
  Future<void> changePassword({required String currentPassword, required String newPassword});
}

class SettingsRemoteDataSourceImpl implements ISettingsRemoteDataSource {
  final ApiService _apiService;

  SettingsRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<UserApiModel> updateUserDetails(UserEntity user) async {
    try {
      final response = await _apiService.dio.put(
        ApiEndpoints.updateMe,
        data: {
          'name': user.name,
          'contact': user.contact,
          'disease': user.disease,
          'description': user.description,
        },
      );
      return UserApiModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update profile');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.dio.put(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to change password');
    }
  }
}