import 'package:jeevandaan/features/auth/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:jeevandaan/features/auth/data/models/user_model.dart';
import 'package:jeevandaan/features/auth/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/auth/domain/repository/user_repository.dart';

class UserLocalRepositoryImpl implements UserRepository{
  final UserLocalDataSource localDataSource;

  UserLocalRepositoryImpl(this.localDataSource);
  @override
  Future<void> Login(UserEntity user)async {
    await localDataSource.addUser(UserModel.fromEntity(user));
  }

  @override
  UserEntity? getUser(String email) {
    final userModel=localDataSource.getUser(email);
    return userModel?.toEntity();
  }
}