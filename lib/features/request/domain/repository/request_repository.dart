// lib/features/request/domain/repository/request_repository.dart (Verify this)

import 'package:dartz/dartz.dart';
// import 'package:jeevandaan/features/request/domain/entity/request_entity.dart'; // Not directly used in addRequest signature
import 'dart:io';

import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart'; // For File

abstract interface class IRequestRepository {
  Future<Either<Failure, void>> addRequest(
    String description,
    num neededAmount,
    String condition,
    String inDepthStory,
    String citizen,
    File supportingDoc,
    File userImage,
    File citizenshipImage,
  );
  Future<Either<Failure, List<RequestEntity>>> getMyRequests(); // Assuming RequestEntity exists
  Future<Either<Failure, void>> deleteRequest(String requestId);
}