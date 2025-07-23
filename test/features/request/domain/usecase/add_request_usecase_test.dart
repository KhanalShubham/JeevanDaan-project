import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/request/domain/usecase/add_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}
class MockFile extends Mock implements File {}

void main() {
  test('calls addRequest on repository with correct params', () async {
    final repo = MockRequestRepository();
    final usecase = AddRequestUseCase(repo);
    final file = MockFile();
    final params = AddRequestParams(
      description: 'desc',
      neededAmount: 100,
      condition: 'Good',
      inDepthStory: 'Story',
      citizen: 'Citizen',
      supportingDoc: file,
      userImage: file,
      citizenshipImage: file,
    );
    when(() => repo.addRequest(
      'desc',
      100,
      'Good',
      'Story',
      'Citizen',
      file,
      file,
      file,
    )).thenAnswer((_) async => const Right(null));
    await usecase(params);
    verify(() => repo.addRequest(
      'desc',
      100,
      'Good',
      'Story',
      'Citizen',
      file,
      file,
      file,
    )).called(1);
  });
}