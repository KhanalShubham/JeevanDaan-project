import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';
import 'package:jeevandaan/features/setting/domain/repository/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockSettingsRepository extends Mock implements ISettingsRepository {}

void main() {
  test('calls changePassword on repository', () async {
    final repo = MockSettingsRepository();
    final usecase = ChangePasswordUseCase(repo);
    final params = ChangePasswordParams(currentPassword: 'old', newPassword: 'new');
    when(() => repo.changePassword(currentPassword: 'old', newPassword: 'new')).thenAnswer((_) async => const Right(null));
    await usecase(params);
    verify(() => repo.changePassword(currentPassword: 'old', newPassword: 'new')).called(1);
  });
}