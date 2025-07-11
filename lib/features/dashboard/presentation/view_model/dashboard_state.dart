// features/dashboard/presentation/view_model/dashboard_state.dart

import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;
  final List<RequestEntity> requests;
  final List<RequestEntity> filteredRequests;

  const DashboardState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.requests = const [],
    this.filteredRequests = const [],
  });

  const DashboardState.initial()
      : isLoading = false,
        errorMessage = null,
        user = null,
        requests = const [],
        filteredRequests = const [];

  DashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
    List<RequestEntity>? requests,
    List<RequestEntity>? filteredRequests,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      requests: requests ?? this.requests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, user, requests, filteredRequests];
}