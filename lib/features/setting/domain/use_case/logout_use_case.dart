import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/app/use_case/usecase.dart';
import 'package:jeevandaan/core/error/failure.dart';

class LogoutUseCase implements Usecase<void> {
  final TokenSharedPrefs _tokenSharedPrefs;

  LogoutUseCase({required TokenSharedPrefs tokenSharedPrefs})
      : _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call() async {
    // In a real app, you might also want to clear other user data from prefs or Hive
    return await _tokenSharedPrefs.clearToken(); // Assumes you add a clearToken method
  }
}