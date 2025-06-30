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
      await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      // SIMPLIFIED LOGIC:
      // By default, if dio.post() does NOT throw an exception, it means the
      // status code was in the 2xx range (a success).
      // So, we don't need to check the status code manually here.
      // If the server returned 4xx or 5xx, Dio would have already thrown a DioException,
      // which is caught below.
      return; 

    } on DioException catch (e) {
      // This provides a much more specific and helpful error message.
      throw Exception("API Error on registration: ${e.response?.data['message'] ?? e.message}");
    } catch (e) {
      // This will catch other errors, like a problem with toJson().
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
