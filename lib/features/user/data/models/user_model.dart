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
  final String? name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String disease;

  @HiveField(4)
  final String contact;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String password;

  UserModel({
    String? userId,
    required this.name,
    required this.email,
    required this.disease,
    required this.contact,
    required this.description,
    required this.password
  }) : userId = userId ?? const Uuid().v4();

  const UserModel.initial():
    userId="",
    name="",
    email="",
    disease="",
    contact="",
    description="",
    password="";

    factory UserModel.fromEntity(UserEntity entity){
      return UserModel(userId: entity.userId, name: entity.name, email: entity.email, disease: entity.disease, contact: entity.contact, description: entity.description, password: entity.password);
    }
    UserEntity toEntity(){
      return UserEntity(
        userId: userId ?? '',
        name: name ?? '',
        email: email,
        disease: disease,
        password: password,
        contact: contact,
        description: description,
      );
    }

  
  @override
  List<Object?> get props => [userId, name, email, disease, contact, description, password];

  
}