import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart'; // ✅ Import Repository
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';
import 'package:jeevandaan/features/chat/domain/use_case/get_chat_history_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/listen_for_messages_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_chat_file_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_text_message_use_case.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatHistoryUseCase _getChatHistory;
  final SendChatFileUseCase _sendChatFile;
  final SendTextMessageUseCase _sendTextMessage;
  final ListenForMessagesUseCase _listenForMessages;
  // ✅ ADDED: A dependency on the repository for connect/disconnect.
  final IChatRepository _chatRepository;
  StreamSubscription? _messageSubscription;

  // ✅ CHANGED: Made `currentUserId` public by removing the underscore.
  final String currentUserId;
  final String _currentUserName; // This can remain private if only used here.

  ChatBloc({
    required GetChatHistoryUseCase getChatHistory,
    required SendChatFileUseCase sendChatFile,
    required SendTextMessageUseCase sendTextMessage,
    required ListenForMessagesUseCase listenForMessages,
    required IChatRepository chatRepository, // ✅ ADDED: Require repository in constructor.
    required UserEntity currentUser,
  })  : _getChatHistory = getChatHistory,
        _sendChatFile = sendChatFile,
        _sendTextMessage = sendTextMessage,
        _listenForMessages = listenForMessages,
        _chatRepository = chatRepository, // ✅ ADDED: Initialize the repository.
        currentUserId = currentUser.userId!, // ✅ CHANGED: Initialize the public variable.
        _currentUserName = currentUser.name,
        super(const ChatState()) {
    
    // ✅ ADDED: Register handlers for the new socket lifecycle events.
    on<ConnectSocket>(_onConnectSocket);
    on<DisconnectSocket>(_onDisconnectSocket);

    // --- Existing Event Handlers ---
    on<FetchHistory>(_onFetchHistory);
    on<SendTextMessage>(_onSendTextMessage);
    on<SendFileMessage>(_onSendFileMessage);
    on<MessageReceived>(_onMessageReceived);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
  }

  // ✅ ADDED: Handler for the ConnectSocket event.
  void _onConnectSocket(ConnectSocket event, Emitter<ChatState> emit) {
    _chatRepository.connect();
    // Start listening for messages only after connecting.
    _messageSubscription?.cancel();
    _messageSubscription = _listenForMessages().listen(
      (message) => add(MessageReceived(message)),
      onError: (error) => print("Error in message stream: $error"),
    );
  }

  // ✅ ADDED: Handler for the DisconnectSocket event.
  void _onDisconnectSocket(DisconnectSocket event, Emitter<ChatState> emit) {
    _chatRepository.disconnect();
    _messageSubscription?.cancel();
  }

  Future<void> _onFetchHistory(FetchHistory event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    final result = await _getChatHistory(event.otherUserId);
    result.fold(
      (failure) => emit(state.copyWith(status: ChatStatus.failure, error: failure.message)),
      (messages) => emit(state.copyWith(status: ChatStatus.success, messages: messages)),
    );
  }

  void _onSendTextMessage(SendTextMessage event, Emitter<ChatState> emit) {
    _sendTextMessage(message: event.message, toId: event.toId);
    final optimisticMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId, // Use the public variable
      senderName: _currentUserName,
      message: event.message,
      messageType: 'text',
      timestamp: DateTime.now(),
    );
    final updatedMessages = List<MessageEntity>.from(state.messages)..add(optimisticMessage);
    emit(state.copyWith(messages: updatedMessages, status: ChatStatus.success));
  }

  Future<void> _onSendFileMessage(SendFileMessage event, Emitter<ChatState> emit) async {
    final result = await _sendChatFile(event.file);
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (fileData) {
        // TODO: Implement file message sending logic
      },
    );
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    final isAlreadyPresent = state.messages.any((m) => m.id == event.message.id);
    if (!isAlreadyPresent) {
      final newMessages = List.of(state.messages)..add(event.message);
      emit(state.copyWith(status: ChatStatus.success, messages: newMessages));
    }
  }
  
  void _onStartRecording(StartRecording event, Emitter<ChatState> emit) {
    emit(state.copyWith(recordingStatus: AudioRecordingStatus.recording));
  }

  void _onStopRecording(StopRecording event, Emitter<ChatState> emit) {
    emit(state.copyWith(recordingStatus: AudioRecordingStatus.initial));
  }

  @override
  Future<void> close() {
    // Ensure the socket is disconnected when the BLoC is closed.
    add(DisconnectSocket());
    return super.close();
  }
}