import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/settings_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/settings_view_model.dart';
import 'package:jeevandaan/features/setting/domain/use_case/logout_use_case.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetUserDetailsUseCase extends Mock implements GetUserDetailsUseCase {}

void main() {
  group('SettingsViewModel Bloc Test', () {
    late MockLogoutUseCase logoutUseCase;
    late MockGetUserDetailsUseCase getUserDetailsUseCase;
    setUp(() {
      logoutUseCase = MockLogoutUseCase();
      getUserDetailsUseCase = MockGetUserDetailsUseCase();
    });
    blocTest<SettingsViewModel, SettingsState>(
      'emits loading and success when LoadUserDetails is added',
      build: () {
        when(() => getUserDetailsUseCase()).thenAnswer((_) async => Right(UserEntity(
          name: 'Test',
          email: 'test@example.com',
          disease: 'None',
          password: 'password',
          contact: '1234567890',
          description: 'desc',
        )));
        return SettingsViewModel(
          logoutUseCase: logoutUseCase,
          getUserDetailsUseCase: getUserDetailsUseCase,
        );
      },
      act: (bloc) => bloc.add(LoadUserDetails()),
      expect: () => [
        isA<SettingsState>().having((s) => s.status, 'status', SettingsStatus.loading),
        isA<SettingsState>().having((s) => s.status, 'status', SettingsStatus.success),
      ],
    );
  });
} 