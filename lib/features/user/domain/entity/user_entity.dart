import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String email;
  final String password;
  final String phone;
  final String gender;

  const UserEntity({ this.userId, required this.email, required this.password, required this.phone, required this.gender});
  
  @override
  List<Object?> get props => [userId,email,password, phone, gender];
}