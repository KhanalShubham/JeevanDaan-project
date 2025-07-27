// features/user/domain/use_case/user_login_use_case.dart (Revised)

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart'; // Keep Equatable here for UserLoginParams
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/app/use_case/usecase.dart'; // Updated import for the fixed UsecaseWithParams
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/domain/entity/login_response.dart';

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  const UserLoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUseCase implements UsecaseWithParams<LoginResponse, UserLoginParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLoginUseCase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _userRepository = userRepository,
        _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, LoginResponse>> call(UserLoginParams params) async {
    final result = await _userRepository.login(
      params.email,
      params.password,
    );

    return result.fold(
      (failure) => Left(failure),
      (loginResponse) async {
        await _tokenSharedPrefs.saveToken(loginResponse.token);
        return Right(loginResponse);
      },
    );
  }
}