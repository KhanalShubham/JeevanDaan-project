import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/request/domain/usecase/delete_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  test('calls deleteRequest on repository', () async {
    final repo = MockRequestRepository();
    final usecase = DeleteRequestUseCase(repo);
    when(() => repo.deleteRequest('id')).thenAnswer((_) async => const Right(null));
    await usecase(const DeleteRequestParams(requestId: 'id'));
    verify(() => repo.deleteRequest('id')).called(1);
  });
}