import 'package:equatable/equatable.dart';

abstract class AdminRequestEvent extends Equatable {
  const AdminRequestEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch all requests for admin
class GetAllRequestsForAdminEvent extends AdminRequestEvent {
  final String token;
  const GetAllRequestsForAdminEvent({required this.token});
  @override
  List<Object?> get props => [token];
}

// Event to update a request's status (approve/decline)
class UpdateRequestStatusEvent extends AdminRequestEvent {
  final String requestId;
  final String status;
  final num neededAmount;
  final String feedback;
  final String token;
  const UpdateRequestStatusEvent({
    required this.requestId,
    required this.status,
    required this.neededAmount,
    required this.feedback,
    required this.token,
  });
  @override
  List<Object?> get props => [requestId, status, neededAmount, feedback, token];
}

// Event to log out admin
class AdminLogoutEvent extends AdminRequestEvent {} 