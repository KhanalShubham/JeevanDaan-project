import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/update_profile_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/update_profile_view_model.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_user_details_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class MockGetUserDetailsUseCase extends Mock implements GetUserDetailsUseCase {}
class MockUpdateUserDetailsUseCase extends Mock implements UpdateUserDetailsUseCase {}

void main() {
  group('UpdateProfileViewModel Bloc Test', () {
    late MockGetUserDetailsUseCase getUserDetailsUseCase;
    late MockUpdateUserDetailsUseCase updateUserDetailsUseCase;
    setUp(() {
      getUserDetailsUseCase = MockGetUserDetailsUseCase();
      updateUserDetailsUseCase = MockUpdateUserDetailsUseCase();
    });
    blocTest<UpdateProfileViewModel, UpdateProfileState>(
      'emits loading and success when LoadProfile is added',
      build: () {
        when(() => getUserDetailsUseCase()).thenAnswer((_) async => Right(UserEntity(
          name: 'Test',
          email: 'test@example.com',
          disease: 'None',
          password: 'password',
          contact: '1234567890',
          description: 'desc',
        )));
        return UpdateProfileViewModel(
          getUserDetailsUseCase: getUserDetailsUseCase,
          updateUserDetailsUseCase: updateUserDetailsUseCase,
        );
      },
      act: (bloc) => bloc.add(LoadProfile()),
      expect: () => [
        isA<UpdateProfileState>().having((s) => s.status, 'status', UpdateProfileStatus.loading),
        isA<UpdateProfileState>().having((s) => s.status, 'status', UpdateProfileStatus.success),
      ],
    );
  });
} 