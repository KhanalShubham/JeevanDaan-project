import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/use_case/usecase.dart'; // Ensure this is the correct path for UsecaseWithParams
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';

// Change UseCase to UsecaseWithParams
class DeleteRequestUseCase implements UsecaseWithParams<void, DeleteRequestParams> {
  final IRequestRepository repository;

  DeleteRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteRequestParams params) async {
    return await repository.deleteRequest(params.requestId);
  }
}

class DeleteRequestParams {
  final String requestId;

  const DeleteRequestParams({required this.requestId});

  // No @override List<Object?> get props => [...] for non-Equatable params
}