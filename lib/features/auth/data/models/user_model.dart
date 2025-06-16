import 'package:hive_flutter/adapters.dart';
import 'package:jeevandaan/app/constant/hive/hive_table_constant.dart';
import 'package:jeevandaan/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@HiveType(typeId:HiveTableConstant.userTableId)
class UserModel extends Equatable{
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  UserModel({required this.email, required this.password});

  factory UserModel.fromEntity(UserEntity user){
    return UserModel(email: user.email, password: user.password);
  }
  UserEntity toEntity()=>UserEntity(email: email, password: password);
  
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}