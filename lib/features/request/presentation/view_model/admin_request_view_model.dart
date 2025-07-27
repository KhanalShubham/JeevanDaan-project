import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_state.dart';
import 'package:jeevandaan/core/error/failure.dart';

class AdminRequestViewModel extends Bloc<AdminRequestEvent, AdminRequestState> {
  final IRequestRepository requestRepository;

  AdminRequestViewModel({required this.requestRepository}) : super(const AdminRequestState.initial()) {
    on<GetAllRequestsForAdminEvent>(_onGetAllRequestsForAdmin);
    on<UpdateRequestStatusEvent>(_onUpdateRequestStatus);
    on<AdminLogoutEvent>(_onAdminLogout);
  }

  Future<void> _onGetAllRequestsForAdmin(GetAllRequestsForAdminEvent event, Emitter<AdminRequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));
    final result = await requestRepository.getAllRequestsForAdmin(token: event.token);
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

  Future<void> _onUpdateRequestStatus(UpdateRequestStatusEvent event, Emitter<AdminRequestState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isOperationSuccess: false, successMessage: null));
    final result = await requestRepository.updateRequestStatus(
      requestId: event.requestId,
      status: event.status,
      neededAmount: event.neededAmount,
      feedback: event.feedback,
      token: event.token,
    );
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
          successMessage: "Request status updated successfully!",
          errorMessage: null,
        ));
        // Reset success state after acknowledging
        emit(state.copyWith(isOperationSuccess: false, successMessage: null));
      },
    );
  }

  void _onAdminLogout(AdminLogoutEvent event, Emitter<AdminRequestState> emit) {
    emit(const AdminRequestState.initial());
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message ?? 'An unknown error occurred';
  }
} 