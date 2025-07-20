import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/themes/themes.dart';
import 'package:jeevandaan/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Notifications',
          style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.mark_email_read, color: theme.colorScheme.primary),
              tooltip: 'Mark all as read',
              onPressed: () {
                context.read<NotificationViewModel>().add(MarkAllNotificationsAsRead());
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotificationViewModel, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/loading.json', width: 120, height: 120, repeat: true),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications yet!',
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll see important updates here.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 12),
                  color: theme.cardColor,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: notification.isRead 
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                        color: notification.isRead 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification.body,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    onTap: () {
                      // Mark as read and handle tap
                      if (!notification.isRead) {
                        context.read<NotificationViewModel>().add(MarkNotificationAsRead(notification.id));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Notification tapped: ${notification.title}'),
                          backgroundColor: theme.colorScheme.primary,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 80, color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load notifications',
                    style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 