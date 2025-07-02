import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';

class RequestState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<RequestEntity> requests;
  final bool isOperationSuccess; // Combines add/delete success
  final String? successMessage; // Specific message for success

  const RequestState({
    this.isLoading = false,
    this.errorMessage,
    this.requests = const [],
    this.isOperationSuccess = false,
    this.successMessage,
  });

  const RequestState.initial()
      : isLoading = false,
        errorMessage = null,
        requests = const [],
        isOperationSuccess = false,
        successMessage = null;

  RequestState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RequestEntity>? requests,
    bool? isOperationSuccess,
    String? successMessage,
  }) {
    return RequestState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Explicitly null if not provided
      requests: requests ?? this.requests,
      isOperationSuccess: isOperationSuccess ?? this.isOperationSuccess,
      successMessage: successMessage, // Explicitly null if not provided
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        requests,
        isOperationSuccess,
        successMessage,
      ];
}