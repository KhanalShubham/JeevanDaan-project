import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/request/data/dto/get_all_requests_dto.dart'; // New DTO import
import 'package:jeevandaan/features/request/data/models/request_api_model.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';

abstract interface class IRequestRemoteDataSource {
  Future<void> addRequest(
    String description,
    num neededAmount,
    String condition,
    String inDepthStory,
    String citizen,
    File supportingDoc,
    File userImage,
    File citizenshipImage,
  );
  Future<List<RequestEntity>> getMyRequests();
  Future<void> deleteRequest(String requestId);
}

class RequestRemoteDataSourceImpl implements IRequestRemoteDataSource {
  final ApiService apiService;

  RequestRemoteDataSourceImpl({required this.apiService});

  @override
  Future<void> addRequest(
    String description,
    num neededAmount,
    String condition,
    String inDepthStory,
    String citizen,
    File supportingDoc,
    File userImage,
    File citizenshipImage,
  ) async {
    try {
       print(userImage);
      final formData = FormData.fromMap({
        'description': description,
        'neededAmount': neededAmount,
        'condition': condition,
        'inDepthStory': inDepthStory,
        'citizen': citizen,
        'file': await MultipartFile.fromFile(supportingDoc.path,
            filename: supportingDoc.path.split('/').last),
        'userImage': await MultipartFile.fromFile(userImage.path,
            filename: userImage.path.split('/').last),
        'citizenshipImage': await MultipartFile.fromFile(citizenshipImage.path,
            filename: citizenshipImage.path.split('/').last),
      });
     

      final response = await apiService.dio.post(
        ApiEndpoints.baseUrl + ApiEndpoints.addRequest,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
        

      if (response.statusCode == 201) {
        return;
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to add request');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message ?? 'Dio error adding request');
    } catch (e) {
      throw ServerException(message: 'Unknown error adding request: $e');
    }
  }

  @override
  Future<List<RequestEntity>> getMyRequests() async {
    try {
      final response = await apiService.dio.get(
        ApiEndpoints.baseUrl + ApiEndpoints.getMyRequests,
      );

      if (response.statusCode == 200) {
        final GetAllRequestsDto getAllRequestsDto = GetAllRequestsDto.fromJson(response.data);
        return RequestApiModel.toEntityList(getAllRequestsDto.data);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to fetch my requests');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message ?? 'Dio error fetching my requests');
    } catch (e) {
      throw ServerException(message: 'Unknown error fetching my requests: $e');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      final response = await apiService.dio.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.deleteRequest}$requestId',
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to delete request');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message ?? 'Dio error deleting request');
    } catch (e) {
      throw ServerException(message: 'Unknown error deleting request: $e');
    }
  }
}