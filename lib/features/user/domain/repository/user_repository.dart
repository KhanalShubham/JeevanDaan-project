import 'dart:core';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/login_response.dart';


abstract interface class IUserRepository {
  Future<Either<Failure,void>> registerUser(UserEntity user);
  
  Future<Either<Failure, LoginResponse>> login(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getMe(String token);
  Future<Either<Failure, UserEntity>> updateMe(
    String token, {
      required String name,
      required String description,
      required String contact,
      required String disease,
      String? photoUrl,
    }
  );
}