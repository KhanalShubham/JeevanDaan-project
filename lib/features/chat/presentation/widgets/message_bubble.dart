import 'package:flutter/material.dart';
import 'package:jeevandaan/app/constant/api_endpoints.dart';
import 'package:jeevandaan/features/chat/domain/entity/message_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        // This function call is now safe
        child: _buildMessageContent(context),
      ),
    );
  }

  // ✅ THIS WIDGET LOGIC IS NOW FIXED
  Widget _buildMessageContent(BuildContext context) {
    // The logic is moved inside the switch cases to prevent errors.
    switch (message.messageType) {
      case 'image':
        // Only build the URL if the message is an image.
        final fullFileUrl = "${ApiEndpoints.serverAddress}${message.fileUrl}";
        return Image.network(fullFileUrl);

      case 'document':
        // Only build the URL if the message is a document.
        final fullFileUrl = "${ApiEndpoints.serverAddress}${message.fileUrl}";
        final uri = Uri.parse(fullFileUrl);
        return InkWell(
          onTap: () async {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not open the file: $fullFileUrl')),
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insert_drive_file, color: isMe ? Colors.white : Colors.black),
              const SizedBox(width: 8),
              Text(
                message.fileName ?? 'Document',
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ],
          ),
        );

      case 'audio':
         // TODO: Implement audio player logic here.
         // For now, it just displays the file name.
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.audiotrack, color: isMe ? Colors.white : Colors.black),
            const SizedBox(width: 8),
            Text(
              message.fileName ?? 'Voice Note',
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ],
        );

      // The 'text' case is now the default.
      case 'text':
      default:
        // For plain text messages, just show the text. No URL is built.
        return Text(
          message.message ?? '',
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        );
    }
  }
}