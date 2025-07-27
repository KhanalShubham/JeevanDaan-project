import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/chat/domain/repository/chat_repository.dart'; // ✅ Import Repository
import 'package:jeevandaan/features/chat/domain/use_case/get_chat_history_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/listen_for_messages_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_chat_file_use_case.dart';
import 'package:jeevandaan/features/chat/domain/use_case/send_text_message_use_case.dart';
import 'package:jeevandaan/features/chat/presentation/view_model/chat_bloc.dart';
import 'package:jeevandaan/features/chat/presentation/view_model/chat_event.dart';
import 'package:jeevandaan/features/chat/presentation/view_model/chat_state.dart';
import 'package:jeevandaan/features/chat/presentation/widgets/message_bubble.dart';
import 'package:jeevandaan/core/network/api_service.dart';


class ChatView extends StatefulWidget {
  final String adminId = "686c20af7c56d92f3cfd9153";

  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService().isOnline;
    setState(() {
      _isOffline = !online;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wifi_off, size: 64, color: Colors.orange),
              SizedBox(height: 24),
              Text('Connect to the internet and try again.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return BlocProvider(
      create: (context) {
        // --- Start of Dummy Data (REPLACE THIS with your actual user logic) ---
        final UserEntity dummyCurrentUser = UserEntity(
          userId: '687069107aa9d7f660175f37',
          name: 'Ram',
          email: 'ram@gmail.com',
          disease: '',
          password: '',
          contact: '',
          description: '',
          role: 'user', // Added required role parameter
        );
        // --- End of Dummy Data ---

        return ChatBloc(
          // ✅ ADDED: Provide the repository instance from the service locator.
          chatRepository: serviceLocator<IChatRepository>(),

          // Provide UseCases from the service locator.
          getChatHistory: serviceLocator<GetChatHistoryUseCase>(),
          sendTextMessage: serviceLocator<SendTextMessageUseCase>(),
          sendChatFile: serviceLocator<SendChatFileUseCase>(),
          listenForMessages: serviceLocator<ListenForMessagesUseCase>(),
          
          // Provide the runtime UserEntity.
          currentUser: dummyCurrentUser,
        )
        // ✅ The errors are now fixed. These events can be added successfully.
        ..add(ConnectSocket())
        ..add(FetchHistory(widget.adminId));
      },
      child: ChatPage(adminId: widget.adminId),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String adminId;
  const ChatPage({super.key, required this.adminId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    context.read<ChatBloc>().add(DisconnectSocket());
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Admin')),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state.status == ChatStatus.success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                }
              },
              builder: (context, state) {
                if (state.status == ChatStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ChatStatus.failure) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    // ✅ The error here is now fixed.
                    final isMe = message.senderId == context.read<ChatBloc>().currentUserId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles();
              if (result != null && result.files.single.path != null) {
                final file = File(result.files.single.path!);
                context.read<ChatBloc>().add(SendFileMessage(file: file, toId: widget.adminId));
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(hintText: 'Type a message...'),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(SendTextMessage(
                  message: _textController.text.trim(),
                  toId: widget.adminId,
                ));
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}