import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';

class AdminRequestState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<RequestEntity> requests;
  final bool isOperationSuccess;
  final String? successMessage;

  const AdminRequestState({
    this.isLoading = false,
    this.errorMessage,
    this.requests = const [],
    this.isOperationSuccess = false,
    this.successMessage,
  });

  const AdminRequestState.initial()
      : isLoading = false,
        errorMessage = null,
        requests = const [],
        isOperationSuccess = false,
        successMessage = null;

  AdminRequestState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RequestEntity>? requests,
    bool? isOperationSuccess,
    String? successMessage,
  }) {
    return AdminRequestState(
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