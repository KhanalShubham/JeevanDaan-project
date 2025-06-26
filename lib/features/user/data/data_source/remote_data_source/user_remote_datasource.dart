import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/user/data/data_source/user_data_source.dart';
import 'package:jeevandaan/features/user/data/models/user_api_model.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        final str = response.data["token"] as String;
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception("Failed to login user: ${e.message}");
    } catch (e) {
      throw Exception("Failed to login user: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity userdata) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userdata);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
          "Failed to register user: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to register user: ${e.message}");
    } catch (e) {
      throw Exception("Failed to register user: $e");
    }
  }
}
