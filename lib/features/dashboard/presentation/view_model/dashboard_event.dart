// features/dashboard/presentation/view_model/dashboard_event.dart

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class FetchDashboardData extends DashboardEvent {}

class SearchRequests extends DashboardEvent {
  final String query;

  const SearchRequests(this.query);

  @override
  List<Object?> get props => [query];
}