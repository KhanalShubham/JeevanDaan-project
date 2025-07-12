import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}
class ConnectSocket extends ChatEvent {}

// ✅ ADD THIS EVENT
class DisconnectSocket extends ChatEvent {}

class FetchHistory extends ChatEvent {
  final String otherUserId;
  const FetchHistory(this.otherUserId);
  @override
  List<Object?> get props => [otherUserId];
}

class SendTextMessage extends ChatEvent {
  final String message;
  final String toId;
  const SendTextMessage({required this.message, required this.toId});
  @override
  List<Object?> get props => [message, toId];
}

class SendFileMessage extends ChatEvent {
  final File file;
  final String toId;
  const SendFileMessage({required this.file, required this.toId});
  @override
  List<Object?> get props => [file, toId];
}

class MessageReceived extends ChatEvent {
  final MessageEntity message;
  const MessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}

class StartRecording extends ChatEvent {}

class StopRecording extends ChatEvent {
  final String toId;
  const StopRecording({required this.toId});
  @override
  List<Object?> get props => [toId];
}