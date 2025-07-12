import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  final TokenSharedPrefs _tokenSharedPrefs;
  IO.Socket? _socket;
  final StreamController<dynamic> _messageStreamController = StreamController.broadcast();

  Stream<dynamic> get messageStream => _messageStreamController.stream;
  IO.Socket? get socket => _socket;

  SocketService(this._tokenSharedPrefs, {required TokenSharedPrefs tokenSharedPrefs});

  Future<void> connect() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.getOrElse(() => null);

    if (token == null) {
      print("SocketService: No token found, cannot connect.");
      return;
    }

    _socket = IO.io(
      ApiEndpoints.serverAddress,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ SOCKET CONNECTED: ${_socket!.id}');
      _setupListeners();
    });

    _socket!.onDisconnect((_) => print('❌ SOCKET DISCONNECTED'));
    _socket!.onConnectError((err) => print('SOCKET CONNECT ERROR: $err'));
  }

  void _setupListeners() {
    _socket!.on('message', (data) {
      _messageStreamController.add(data);
    });
    // Add other global listeners here (e.g., 'incoming-admin-call')
  }
  
  void sendMessage(Map<String, dynamic> data) {
    _socket?.emit('message', data);
  }

  void dispose() {
    _messageStreamController.close();
    _socket?.dispose();
  }
}