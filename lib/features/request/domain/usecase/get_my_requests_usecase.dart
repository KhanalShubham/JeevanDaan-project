import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/use_case/usecase.dart'; // Ensure this is the correct path for Usecase and NoParams
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';

// Change UseCase to Usecase (without the second type argument for params)
class GetMyRequestsUseCase implements Usecase<List<RequestEntity>> {
  final IRequestRepository repository;

  GetMyRequestsUseCase(this.repository);

  @override
  // Remove the 'NoParams params' argument from the call method signature
  Future<Either<Failure, List<RequestEntity>>> call() async { // No 'params' argument here
    return await repository.getMyRequests();
  }
}