import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/notification/domain/entities/notification_entity.dart';
import 'package:jeevandaan/features/notification/domain/usecase/get_notifications_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:jeevandaan/features/notification/domain/usecase/mark_all_notifications_as_read_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;

  NotificationViewModel(
    this._getNotificationsUseCase,
    this._markNotificationAsReadUseCase,
    this._markAllNotificationsAsReadUseCase,
  ) : super(NotificationInitial()) {
    on<GetNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await _getNotificationsUseCase();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkNotificationAsRead>((event, emit) async {
      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;
        emit(NotificationLoading());
        try {
          await _markNotificationAsReadUseCase(event.notificationId);
          // Optionally, you can update the local state instead of refetching all
          final updated = current.map((n) =>
            n.id == event.notificationId ?
              NotificationEntity(
                id: n.id,
                title: n.title,
                body: n.body,
                isRead: true,
              ) : n
          ).toList();
          emit(NotificationLoaded(updated));
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      }
    });

    on<MarkAllNotificationsAsRead>((event, emit) async {
      if (state is NotificationLoaded) {
        final current = (state as NotificationLoaded).notifications;
        emit(NotificationLoading());
        try {
          await _markAllNotificationsAsReadUseCase();
          final updated = current.map((n) =>
            NotificationEntity(
              id: n.id,
              title: n.title,
              body: n.body,
              isRead: true,
            )
          ).toList();
          emit(NotificationLoaded(updated));
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      }
    });
  }
} 