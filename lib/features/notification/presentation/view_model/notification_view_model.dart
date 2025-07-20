import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';
import 'package:jeevandaan/features/notification/domain/usecase/get_notifications_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationViewModel(this._getNotificationsUseCase)
      : super(NotificationInitial()) {
    on<GetNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await _getNotificationsUseCase();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
} 