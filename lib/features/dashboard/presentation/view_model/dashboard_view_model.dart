// features/dashboard/presentation/view_model/dashboard_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_user_details_usecase.dart';
import 'package:jeevandaan/features/dashboard/domain/usecase/get_recent_requests_usecase.dart';
import 'package:jeevandaan/features/request/presentation/view/request_view.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final GetRecentRequestsUseCase getRecentRequestsUseCase;

  DashboardViewModel({
    required this.getUserDetailsUseCase,
    required this.getRecentRequestsUseCase,
  }) : super(const DashboardState.initial()) {
    on<FetchDashboardData>(_onFetchDashboardData);
    on<SearchRequests>(_onSearchRequests);
  }

  Future<void> _onFetchDashboardData(
      FetchDashboardData event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final userResult = await getUserDetailsUseCase();
    final requestsResult = await getRecentRequestsUseCase();

    userResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (user) {
        requestsResult.fold(
          (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
          (requests) {
            emit(state.copyWith(
              isLoading: false,
              user: user,
              requests: requests,
              filteredRequests: requests,
            ));
          },
        );
      },
    );
  }

  void _onSearchRequests(SearchRequests event, Emitter<DashboardState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredRequests: state.requests));
    } else {
      final filtered = state.requests
          .where((request) =>
              request.description.toLowerCase().contains(event.query.toLowerCase()) ||
              request.condition.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredRequests: filtered));
    }
  }
  void _onNavigateToNewRequest(NavigateToNewRequest event, Emitter<DashboardState> emit) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<DashboardViewModel>(event.context),
          child: const RequestView(isAddForm: true),
        ),
      ),
    );
  }
}