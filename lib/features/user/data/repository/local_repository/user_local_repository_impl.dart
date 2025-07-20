import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';

class UserLocalRepositoryImpl implements IUserRepository{
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepositoryImpl({required UserLocalDataSource userLocalDataSource}):_userLocalDataSource=userLocalDataSource;

  @override
  Future<Either<Failure, String>> login(String email, String password)async {
    try{
      final result=await _userLocalDataSource.login(email, password);
      return Right(result);
    }catch(e){
      return left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try{ 
      await _userLocalDataSource.registerUser(user);
      return Right(null);

    }catch(e){
      return Left(LocalDatabaseFailure(message: "failed to register: $e"));

    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> getMe(String token) async {
    try {
      // For local, you may not use the token, just fetch the user from local storage
      // This is a placeholder; adjust as needed for your local logic
      throw UnimplementedError('Local getMe not implemented');
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to fetch user profile: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateMe(
    String token, {
      required String name,
      required String description,
      required String contact,
      required String disease,
    }
  ) async {
    // Implement your local update logic or return an error for now
    return Left(LocalDatabaseFailure(message: "Local updateMe not implemented"));
  }
}