import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefs {
  final SharedPreferences _sharedPreferences;
  AuthPrefs({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  // Keys for storing data
  static const String _authTokenKey = 'authToken';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';

  Future<Either<Failure, bool>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString(_authTokenKey, token);
      return const Right(true);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString(_authTokenKey);
      return Right(token);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to retrieve token: $e'));
    }
  }

  // --- NEW METHODS TO SAVE AND GET USER DATA ---

  Future<Either<Failure, bool>> saveUserData({
    required String userId,
    required String userName,
  }) async {
    try {
      await _sharedPreferences.setString(_userIdKey, userId);
      await _sharedPreferences.setString(_userNameKey, userName);
      return const Right(true);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getUserId() async {
    try {
      final userId = _sharedPreferences.getString(_userIdKey);
      return Right(userId);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: 'Failed to retrieve user ID: $e'));
    }
  }

  // Optional: A method to clear all auth data on logout
  Future<Either<Failure, bool>> clearAuthData() async {
    try {
      await _sharedPreferences.remove(_authTokenKey);
      await _sharedPreferences.remove(_userIdKey);
      await _sharedPreferences.remove(_userNameKey);
      return const Right(true);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: e.toString()));
    }
  }
}