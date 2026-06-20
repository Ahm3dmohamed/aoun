import 'dart:convert';
import 'dart:io';
import 'package:aoun/core/utils/secrets.dart';
import 'package:aoun/features/chat/domain/entities/chat_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  ChatRemoteDataSource(this.dio, this.storage);

  Future<void> sendStream(
    String message,
    Function(String) onChunk, {
    String? filePath,
    MessageType? type,
  }) async {
    final apiKey = await storage.read(key: "apiKey");
    final response = await dio.post(
      "https://api.groq.com/openai/v1/chat/completions",
      options: Options(
        headers: {
          "Authorization": "Bearer ${Secrets.apiKey}",
          "Content-Type": "application/json",
        },
        responseType: ResponseType.stream,
      ),
      data: {
        // Use a Vision-capable model if sending an image
        "model": type == MessageType.image
            ? "llama-3.2-11b-vision-preview"
            : "llama-3.3-70b-versatile",
        "stream": true,
        "messages": [
          {
            "role": "user",
            "content": type == MessageType.image
                ? [
                    {"type": "text", "text": message},
                    {
                      "type": "image_url",
                      "image_url": {
                        "url":
                            "data:image/jpeg;base64,${convertImageToBase64(filePath!)}",
                      },
                    },
                  ]
                : message,
          },
        ],
      },
    );

    response.data.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            if (line.isEmpty) return;

            if (line.startsWith("data: ")) {
              final data = line.substring(6);
              if (data == "[DONE]") return;

              try {
                final jsonData = json.decode(data);
                if (jsonData['choices'] != null &&
                    jsonData['choices'].isNotEmpty) {
                  final delta = jsonData['choices'][0]['delta'];
                  if (delta != null && delta['content'] != null) {
                    onChunk(delta['content']);
                  }
                }
              } catch (e) {
                print("Error parsing chunk: $e");
              }
            }
          },
          onError: (error) {
            print("Chat Stream Error: $error");
          },
        );
  }

  String convertImageToBase64(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return base64Encode(bytes);
  }
}
