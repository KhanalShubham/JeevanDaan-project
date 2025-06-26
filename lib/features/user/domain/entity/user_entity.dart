import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String disease;
  final String password;
  final String contact;
  final String description;

  const UserEntity({ this.userId, required this.name, required this.email, required this.disease, required this.password, required this.contact, required this.description});
  
  @override
  List<Object?> get props => [userId,name,email,disease,password, contact, description];
}