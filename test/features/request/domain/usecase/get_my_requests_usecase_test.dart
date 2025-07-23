import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/request/domain/usecase/get_my_requests_usecase.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockRequestRepository extends Mock implements IRequestRepository {}

void main() {
  test('returns requests from repository', () async {
    final repo = MockRequestRepository();
    final usecase = GetMyRequestsUseCase(repo);
    final requests = [
      const RequestEntity(
        filename: 'file',
        filePath: '/path',
        fileType: 'pdf',
        userImage: 'user.png',
        citizenshipImage: 'citizen.png',
        neededAmount: 100,
        originalAmount: 100,
        condition: 'Good',
        inDepthStory: 'Story',
        citizen: 'Citizen',
        description: 'desc',
        uploadedBy: 'user',
        status: 'pending',
      ),
    ];
    when(() => repo.getMyRequests()).thenAnswer((_) async => Right(requests));
    final result = await usecase();
    expect(result, Right(requests));
    verify(() => repo.getMyRequests()).called(1);
  });
}