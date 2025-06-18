import 'package:hive_flutter/adapters.dart';
import 'package:jeevandaan/app/constant/hive/hive_table_constant.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@HiveType(typeId:HiveTableConstant.userTableId)
class UserModel extends Equatable{
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final String password;

  UserModel({
    String?userId,
    required this.email,
    required this.phone,
    required this.gender,
    required this.password
  }):userId=userId??const Uuid().v4();

  const UserModel.initial():
    userId="",
    email="",
    phone="",
    gender="",
    password="";

    factory UserModel.fromEntity(UserEntity entity){
      return UserModel(userId: entity.userId, email: entity.email, phone: entity.phone, gender: entity.gender, password: entity.password);
    }
    UserEntity toEntity(){
      return UserEntity(userId: userId, email: email, password: password, phone: phone, gender: gender);
    }

  
  @override
  List<Object?> get props => [userId, email, phone, gender, password];

  
}