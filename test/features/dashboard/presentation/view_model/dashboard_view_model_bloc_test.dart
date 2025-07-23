import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_recent_requests_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockGetUserDetailsUseCase extends Mock implements GetUserDetailsUseCase {}
class MockGetRecentRequestsUseCase extends Mock implements GetRecentRequestsUseCase {}

void main() {
  group('DashboardViewModel Bloc Test', () {
    late MockGetUserDetailsUseCase getUserDetailsUseCase;
    late MockGetRecentRequestsUseCase getRecentRequestsUseCase;
    setUp(() {
      getUserDetailsUseCase = MockGetUserDetailsUseCase();
      getRecentRequestsUseCase = MockGetRecentRequestsUseCase();
    });
    blocTest<DashboardViewModel, DashboardState>(
      'emits loading and error when FetchDashboardData fails',
      build: () {
        when(() => getUserDetailsUseCase()).thenAnswer((_) async => Left(ServerFailure(message: 'fail')));
        when(() => getRecentRequestsUseCase()).thenAnswer((_) async => Left(ServerFailure(message: 'fail')));
        return DashboardViewModel(
          getUserDetailsUseCase: getUserDetailsUseCase,
          getRecentRequestsUseCase: getRecentRequestsUseCase,
        );
      },
      act: (bloc) => bloc.add(FetchDashboardData()),
      expect: () => [
        isA<DashboardState>().having((s) => s.isLoading, 'isLoading', true),
        isA<DashboardState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });
} 