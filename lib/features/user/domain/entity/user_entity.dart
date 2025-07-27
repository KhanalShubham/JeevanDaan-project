import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String disease;
  final String password;
  final String contact;
  final String description;
  final String? photoUrl;
  final String role; // 'user' or 'admin'

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.disease,
    required this.password,
    required this.contact,
    required this.description,
    this.photoUrl,
    required this.role,
  });
  
  UserEntity copyWith({
    String? userId,
    String? name,
    String? email,
    String? disease,
    String? password,
    String? contact,
    String? description,
    String? photoUrl,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      disease: disease ?? this.disease,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
    );
  }
  
  @override
  List<Object?> get props => [userId, name, email, password, description, contact, photoUrl, role];
}