import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/domain/usecase/add_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/delete_request_usecase.dart';
import 'package:jeevandaan/features/request/domain/usecase/get_my_requests_usecase.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_state.dart'; // For Navigator.push/pop
import 'package:dartz/dartz.dart';

class RequestViewModel extends Bloc<RequestEvent, RequestState> {
  final AddRequestUseCase addRequestUseCase;
  final GetMyRequestsUseCase getMyRequestsUseCase;
  final DeleteRequestUseCase deleteRequestUseCase;
  final Future<Either<Failure, List<RequestEntity>>> Function({String? status, String? date, required String token}) getAllRequestsForAdminUseCase;

  RequestViewModel({
    required this.addRequestUseCase,
    required this.getMyRequestsUseCase,
    required this.deleteRequestUseCase,
    required this.getAllRequestsForAdminUseCase,
  }) : super(const RequestState.initial()) {
    on<AddRequestEvent>(_onAddRequest);
    on<GetMyRequestsEvent>(_onGetMyRequests);
    on<DeleteRequestEvent>(_onDeleteRequest);
    on<NavigateToAddRequestEvent>(_onNavigateToAddRequest);
    on<NavigateBackFromAddRequestEvent>(_onNavigateBackFromAddRequest);
    on<GetAllRequestsForAdminEvent>(_onGetAllRequestsForAdmin);
  }

  Future<void> _onAddRequest(AddRequestEvent event, Emitter<RequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));

    final result = await addRequestUseCase(AddRequestParams(
      description: event.description,
      neededAmount: event.neededAmount,
      condition: event.condition,
      inDepthStory: event.inDepthStory,
      citizen: event.citizen,
      supportingDoc: event.supportingDoc,
      userImage: event.userImage,
      citizenshipImage: event.citizenshipImage,
    ));

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isOperationSuccess: false,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (_) {
        emit(state.copyWith(
          isLoading: false,
          isOperationSuccess: true,
          successMessage: "Request submitted successfully!",
          errorMessage: null,
        ));
        // Reset success state after acknowledging
        // This is important so the listener doesn't trigger again on subsequent rebuilds
        emit(state.copyWith(isOperationSuccess: false, successMessage: null));
      },
    );
  }

  Future<void> _onGetMyRequests(GetMyRequestsEvent event, Emitter<RequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));

    final result = await getMyRequestsUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
          requests: [], // Clear requests on error
        ));
      },
      (requests) {
        emit(state.copyWith(
          isLoading: false,
          requests: requests,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onDeleteRequest(DeleteRequestEvent event, Emitter<RequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));

    final result = await deleteRequestUseCase(DeleteRequestParams(requestId: event.requestId));

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isOperationSuccess: false,
          errorMessage: _mapFailureToMessage(failure),
        ));
      },
      (_) {
        // Optimistically remove the item from the current list
        final updatedRequests = List<RequestEntity>.from(state.requests)
          ..removeWhere((req) => req.id == event.requestId);
        emit(state.copyWith(
          isLoading: false,
          isOperationSuccess: true,
          successMessage: "Request deleted successfully!",
          requests: updatedRequests,
          errorMessage: null,
        ));
        // Reset success state after acknowledging
        emit(state.copyWith(isOperationSuccess: false, successMessage: null));
      },
    );
  }

  // Navigation events
  void _onNavigateToAddRequest(NavigateToAddRequestEvent event, Emitter<RequestState> emit) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<RequestViewModel>(event.context),
            child: RequestView(isAddForm: true),
          ),
        ),
      );
    }
  }

  void _onNavigateBackFromAddRequest(NavigateBackFromAddRequestEvent event, Emitter<RequestState> emit) {
    if (event.context.mounted) {
      Navigator.pop(event.context);
    }
  }

  Future<void> _onGetAllRequestsForAdmin(GetAllRequestsForAdminEvent event, Emitter<RequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));
    final result = await getAllRequestsForAdminUseCase(token: event.token);
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: _mapFailureToMessage(failure),
          requests: [],
        ));
      },
      (requests) {
        emit(state.copyWith(
          isLoading: false,
          requests: requests,
          errorMessage: null,
        ));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is RemoteDatabaseFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred.';
    }
  }
}