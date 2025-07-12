import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/core/error/exceptions.dart';
import 'package:jeevandaan/core/error/failure.dart';
import 'package:jeevandaan/features/chat/data/data_source/chat_remote_data_source.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart'; // Import this

class ChatRepositoryImpl implements IChatRepository {
  // ✅ FIX: Remove SocketService, we only need the data source.
  final IChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  // ✅ NEW: Add a method to initialize the socket connection.
  @override
  Future<void> connect() async {
    // Get the token from SharedPreferences to authorize the socket connection
    final tokenResult = await serviceLocator<TokenSharedPrefs>().getToken();
    tokenResult.fold(
      (failure) => print("Failed to get token for socket connection: ${failure.message}"),
      (token) {
        if (token != null) {
          remoteDataSource.connectSocket(token);
        } else {
          print("Cannot connect socket: User is not logged in.");
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getChatHistory(String otherUserId) async {
    try {
      final messageModels = await remoteDataSource.getChatHistory(otherUserId);
      return Right(messageModels.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<MessageEntity> getMessages() {
    // ✅ FIX: Get the stream directly from the data source.
    return remoteDataSource.getMessages().map((model) => model.toEntity());
  }

  @override
  void sendTextMessage({required String message, required String toId}) {
    // ✅ FIX: Call the method on the data source.
    remoteDataSource.sendMessage(message: message, toId: toId);
  }

  // --- No changes needed for file sending ---
  @override
  Future<Either<Failure, Map<String, dynamic>>> sendChatFile(File file) async {
    try {
      final fileData = await remoteDataSource.uploadChatFile(file);
      return Right(fileData);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  void sendFileMessageAfterUpload({required Map<String, dynamic> fileData, required String toId}) {
     // This would also be sent via the remoteDataSource if implemented
     // remoteDataSource.sendMessage(...) with file data
  }

  @override
  void disconnect() {
    remoteDataSource.disconnectSocket();
  }
}