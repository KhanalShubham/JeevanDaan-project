import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
   import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/setting/domain/use_case/get_profile_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_profile_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';
import 'package:jeevandaan/core/error/failure.dart';

class SettingViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  UserEntity? user;
  bool isLoading = false;
  String? error;
  String? successMessage;

  SettingViewModel({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  });

  Future<void> loadProfile(String token) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    final Either<Failure, UserEntity> result = await getProfileUseCase(token);
    result.fold((l) {
      error = l.message;
    }, (r) {
      user = r;
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(String token, {required String name, required String description, required String contact, required String disease}) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    final Either<Failure, UserEntity> result = await updateProfileUseCase(token, name: name, description: description, contact: contact, disease: disease);
    result.fold((l) {
      error = l.message;
    }, (r) {
      user = r;
      successMessage = "Profile updated successfully!";
    });
    isLoading = false;
    notifyListeners();
  }

  Future<void> changePassword(String token, String currentPassword, String newPassword) async {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
    final Either<Failure, void> result = await changePasswordUseCase(ChangePasswordParams(currentPassword: currentPassword, newPassword: newPassword));
    result.fold((l) {
      error = l.message;
    }, (r) {
      successMessage = "Password changed successfully!";
    });
    isLoading = false;
    notifyListeners();
  }
} 