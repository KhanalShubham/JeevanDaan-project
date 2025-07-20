import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/chat/data/model/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// The "interface" or "contract" - no changes needed here.
abstract class IChatRemoteDataSource {
  Future<List<MessageModel>> getChatHistory(String otherUserId);
  Future<Map<String, dynamic>> uploadChatFile(File file);
  void connectSocket(String token);
  void sendMessage({required String message, required String toId});
  Stream<MessageModel> getMessages();
  void disconnectSocket();
}

// The concrete implementation of the interface. This is where we make the changes.
class ChatRemoteDataSourceImpl implements IChatRemoteDataSource {
  final ApiService apiService;
  IO.Socket? _socket;
  final StreamController<MessageModel> _messageStreamController = StreamController.broadcast();
  
  ChatRemoteDataSourceImpl({required this.apiService, required TokenSharedPrefs tokenSharedPrefs});
  
  @override
  void connectSocket(String token) {
    final serverUrl = 'http://10.0.2.2:5050'; 
    
    print('----------------------------------------------------');
    print('[SOCKET DEBUG] Attempting to connect to: $serverUrl');
    print('[SOCKET DEBUG] Auth Token being sent: $token');
    print('----------------------------------------------------');

    if (_socket?.connected ?? false) {
      print("[SOCKET DEBUG] Socket is already connected. Ignoring request.");
      return;
    }
    
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket?.onConnect((_) {
      print('✅✅✅ [SOCKET SUCCESS] Socket Connected! ID: ${_socket?.id} ✅✅✅');
    });
    _socket?.onConnectError((data) {
      print('❌❌❌ [SOCKET ERROR] Connection Failed. Reason: $data ❌❌❌');
    });
    _socket?.onDisconnect((_) {
      print('🔌 [SOCKET INFO] Socket Disconnected.');
    });

    // ✅ FIX #1: Listen for the 'message' event from the server.
    // Your backend's socketController.js broadcasts new messages using io.to(...).emit('message', ...).
    // So, the client must listen for 'message'.
    _socket?.on('message', (data) {
      print("📬 [SOCKET RECEIVE] Received 'message' event with data: $data");
      try {
        _messageStreamController.add(MessageModel.fromJson(data));
      } catch (e) {
        print("Error parsing incoming message: $e");
      }
    });

    _socket?.connect();
  }
  
  @override
  void sendMessage({required String message, required String toId}) {
    // ✅ FIX #2: Change the event name and payload to match the backend.
    // The backend's socketController.js is listening for `socket.on('message', ...)`.
    // It also expects the payload to have 'to' and 'text' keys.

    final payload = {
      'to': toId,       // Changed from 'receiverId' to match backend.
      'text': message,  // Changed from 'message' to match backend.
    };
    
    final eventName = 'message'; // Changed from 'sendMessage' to match backend.

    print("🚀 [SOCKET SEND] Emitting '$eventName' with payload: $payload");
    _socket?.emit(eventName, payload);
  }

  // --- No other changes are needed in this file ---

  @override
  Future<List<MessageModel>> getChatHistory(String otherUserId) async {
    final endpoint = 'chat/history/$otherUserId';
    print('[HTTP DEBUG] Attempting to GET chat history from: ${apiService.dio.options.baseUrl}$endpoint');

    try {
      final response = await apiService.dio.get(endpoint);
      print('✅ [HTTP SUCCESS] Got response for chat history: ${response.statusCode}');
      final messages = (response.data['messages'] as List)
          .map((msg) => MessageModel.fromJson(msg))
          .toList();
      return messages;
    } on DioException catch (e) {
      print('❌ [HTTP ERROR] Failed to load history. DioException: ${e.message}');
      print('❌ [HTTP ERROR] Response data: ${e.response?.data}');
      throw ServerException(message: e.message ?? 'Failed to load history');
    }
  }

  @override
  Future<Map<String, dynamic>> uploadChatFile(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });
      // IMPORTANT: Your backend route is '/chat/upload', not 'chat/upload'.
      // Dio automatically handles the base URL, but if your upload route is defined at the root
      // of another router file (e.g., app.use('/api', uploadRouter)), then this is correct.
      // If it's defined as app.use('/api/chat/upload', ...), this is also correct.
      // Just double-check that the final URL is correct.
      final response = await apiService.dio.post(
        'chat/upload', 
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'File upload failed');
    }
  }

  @override
  Stream<MessageModel> getMessages() => _messageStreamController.stream;

  @override
  void disconnectSocket() {
    print("🔌 [SOCKET INFO] Disposing socket connection.");
    _socket?.dispose();
    _messageStreamController.close();
  }
}