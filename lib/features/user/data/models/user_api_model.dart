import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String name;
  final String email;
  final String disease;
  final String contact;
  final String description;
  final String? password;

  const UserApiModel({
    this.userId,
    required this.name,
    required this.email,
    required this.disease,
    required this.contact,
    required this.description,
    this.password,
  });

  const UserApiModel.empty()
      : userId = '',
        name = '',
        email = '',
        disease = '',
        contact = '',
        description = '',
        password = '';

  factory UserApiModel.fromJson(Map<String, dynamic> json) => UserApiModel(
        userId: json['_id'] as String?,
        name: json['name'] as String,
        email: json['email'] as String,
        disease: json['disease'] as String,
        contact: json['contact'] as String,
        description: json['description'] as String,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        '_id': userId,
        'name': name,
        'email': email,
        'disease': disease,
        'contact': contact,
        'description': description,
        'password': password,
      };

  static UserApiModel fromEntity(UserEntity entity) => UserApiModel(
        name: entity.name,
        email: entity.email,
        disease: entity.disease,
        contact: entity.contact,
        description: entity.description,
      );

  UserEntity toEntity() => UserEntity(
        userId: userId,
        name: name,
        email: email,
        disease: disease,
        password: password ?? "",
        contact: contact,
        description: description,
      );

  static List<UserEntity> toEntityList(List<UserApiModel> model) =>
      model.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        disease,
        contact,
        description,
        password,
      ];
}
