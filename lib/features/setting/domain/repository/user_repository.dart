import 'dart:core';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure,void>> registerUser(UserEntity user);
  
  Future<Either<Failure, String>> login(
    String email,
    String password,
  );
}