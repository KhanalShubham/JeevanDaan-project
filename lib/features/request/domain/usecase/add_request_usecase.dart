// lib/features/request/domain/usecases/add_request_usecase.dart (Corrected)

import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart'; // No longer needed for params
import 'package:jeevandaan/app/use_case/usecase.dart'; // Use UsecaseWithParams from here
import 'package:jeevandaan/core/error/failure.dart'; // Assuming this path
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'dart:io'; // For File

// AddRequestParams remains the same as before (without Equatable if that's the chosen pattern for these specific params)
// If you want AddRequestParams to be Equatable, add 'extends Equatable' and override props.
class AddRequestParams { // Keeping it non-equatable as per previous request for generic use cases
  final String description;
  final num neededAmount;
  final String condition;
  final String inDepthStory;
  final String citizen;
  final File supportingDoc;
  final File userImage;
  final File citizenshipImage;

  const AddRequestParams({
    required this.description,
    required this.neededAmount,
    required this.condition,
    required this.inDepthStory,
    required this.citizen,
    required this.supportingDoc,
    required this.userImage,
    required this.citizenshipImage,
  });
}

// Change `UseCase` to `UsecaseWithParams`
class AddRequestUseCase implements UsecaseWithParams<void, AddRequestParams> {
  final IRequestRepository repository;

  AddRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddRequestParams params) async {
    // Ensure the parameters passed to repository.addRequest match its signature
    return await repository.addRequest(
      params.description,
      params.neededAmount,
      params.condition,
      params.inDepthStory,
      params.citizen,
      params.supportingDoc,
      params.userImage,
      params.citizenshipImage,
    );
  }
}