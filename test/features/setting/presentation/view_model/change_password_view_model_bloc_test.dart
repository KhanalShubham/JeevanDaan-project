import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/change_password_view_model.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';
import 'package:dartz/dartz.dart';

class MockChangePasswordUseCase extends Mock implements ChangePasswordUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ChangePasswordParams(currentPassword: '', newPassword: ''));
  });
  group('ChangePasswordViewModel Bloc Test', () {
    late MockChangePasswordUseCase changePasswordUseCase;
    setUp(() {
      changePasswordUseCase = MockChangePasswordUseCase();
    });
    blocTest<ChangePasswordViewModel, ChangePasswordState>(
      'emits submitting and success when PasswordChangeSubmitted is added',
      build: () {
        when(() => changePasswordUseCase(any())).thenAnswer((_) async => Right(null));
        return ChangePasswordViewModel(changePasswordUseCase: changePasswordUseCase);
      },
      act: (bloc) => bloc.add(const PasswordChangeSubmitted(currentPassword: 'old', newPassword: 'new')),
      expect: () => [
        isA<ChangePasswordState>().having((s) => s.status, 'status', ChangePasswordStatus.submitting),
        isA<ChangePasswordState>().having((s) => s.status, 'status', ChangePasswordStatus.success),
      ],
    );
  });
} 