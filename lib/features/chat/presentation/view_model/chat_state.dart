import 'package:equatable/equatable.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';


enum ChatStatus { initial, loading, success, failure }

enum AudioRecordingStatus { initial, recording, sending, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageEntity> messages;
  final String? error;
  final AudioRecordingStatus recordingStatus;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.error,
    this.recordingStatus = AudioRecordingStatus.initial,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageEntity>? messages,
    String? error,
    AudioRecordingStatus? recordingStatus,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error, // Allow setting error to null
      recordingStatus: recordingStatus ?? this.recordingStatus,
    );
  }

  @override
  List<Object?> get props => [status, messages, error, recordingStatus];
}