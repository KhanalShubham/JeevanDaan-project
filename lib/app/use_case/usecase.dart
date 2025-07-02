// app/use_case/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart'; // Assuming this path exists

// Generic UseCase interface for operations without parameters
abstract class Usecase<Type> { // No Params argument here for parameterless use cases
  Future<Either<Failure, Type>> call();
}

// Generic UseCase interface for operations with parameters
abstract class UsecaseWithParams<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// A generic "no parameters" class, without Equatable
class NoParams {
  const NoParams();
}