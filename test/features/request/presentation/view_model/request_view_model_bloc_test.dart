import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_view_model.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_state.dart';
import 'package:jeevandaan/features/request/domain/usecase/add_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/get_my_requests_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/delete_request_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockAddRequestUseCase extends Mock implements AddRequestUseCase {}
class MockGetMyRequestsUseCase extends Mock implements GetMyRequestsUseCase {}
class MockDeleteRequestUseCase extends Mock implements DeleteRequestUseCase {}

void main() {
  group('RequestViewModel Bloc Test', () {
    late MockAddRequestUseCase addRequestUseCase;
    late MockGetMyRequestsUseCase getMyRequestsUseCase;
    late MockDeleteRequestUseCase deleteRequestUseCase;
    setUp(() {
      addRequestUseCase = MockAddRequestUseCase();
      getMyRequestsUseCase = MockGetMyRequestsUseCase();
      deleteRequestUseCase = MockDeleteRequestUseCase();
    });
    blocTest<RequestViewModel, RequestState>(
      'emits loading and error when GetMyRequestsEvent fails',
      build: () {
        when(() => getMyRequestsUseCase()).thenAnswer((_) async => Left(ServerFailure(message: 'fail')));
        return RequestViewModel(
          addRequestUseCase: addRequestUseCase,
          getMyRequestsUseCase: getMyRequestsUseCase,
          deleteRequestUseCase: deleteRequestUseCase,
          getAllRequestsForAdminUseCase: ({String? status, String? date, required String token}) async => Left(ServerFailure(message: 'not implemented')),
        );
      },
      act: (bloc) => bloc.add(GetMyRequestsEvent()),
      expect: () => [
        isA<RequestState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RequestState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );
  });
} 