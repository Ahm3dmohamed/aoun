import 'package:aoun/core/error/exceptions.dart';
import 'package:aoun/features/chatbot/data/models/chat_message_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Remote data source for the chatbot feature.
/// Uses the shared Dio instance (with AuthInterceptor already attached).
class ChatbotRemoteDatasource {
  final Dio _dio;

  static const String _baseUrl =
      'https://untakable-tien-unwadable.ngrok-free.dev/api/chatbot';
  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  ChatbotRemoteDatasource(this._dio);

  Future<List<ChatMessageModel>> getHistory() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/history',
        options: Options(headers: _defaultHeaders),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        List<dynamic> rawList;
        if (data is List) {
          rawList = data;
        } else if (data is Map) {
          rawList =
              (data['data'] ?? data['messages'] ?? data['history'] ?? [])
                  as List;
        } else {
          rawList = [];
        }

        return rawList
            .map(
              (item) => ChatMessageModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
      } else {
        throw ServerException(
          message: _extractMessage(response.data) ?? 'Failed to load history',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Sends a user message to POST /api/chatbot/send
  /// Returns the AI response as a ChatMessageModel.
  Future<ChatMessageModel> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/send',
        data: {'message': message},
        options: Options(headers: _defaultHeaders),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data == null) {
          throw const ServerException(message: 'Empty response from server');
        }
        debugPrint('====================');
        debugPrint('CHATBOT RESPONSE');
        debugPrint('Status: ${response.statusCode}');
        debugPrint('Data: ${response.data}');
        debugPrint('====================');
        // The response may be the AI message object directly,
        // or nested under 'data', 'response', 'reply', 'message'
        Map<String, dynamic> messageData;
        if (data is Map) {
          final inner =
              data['data'] ??
              data['response'] ??
              data['reply'] ??
              data['message'];
          if (inner is Map) {
            messageData = Map<String, dynamic>.from(inner);
          } else if (inner is String) {
            // Server returned the message text directly as a string field
            messageData = {
              'message': inner,
              'sender': 'ai',
              'timestamp': DateTime.now().toIso8601String(),
            };
          } else {
            // Use the root data map as the message object
            messageData = Map<String, dynamic>.from(data);
            // If it doesn't have a 'sender', default to 'ai'
            messageData['sender'] ??= 'ai';
          }
        } else {
          throw ServerException(
            message: 'Unexpected response format',
            statusCode: response.statusCode,
          );
        }

        return ChatMessageModel.fromJson(messageData);
      } else {
        throw ServerException(
          message: _extractMessage(response.data) ?? 'Failed to send message',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Clears chat history on the remote server by sending a DELETE request to /api/chatbot/history.
  Future<void> clearHistory() async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/history',
        options: Options(headers: _defaultHeaders),
      );

      if (response.statusCode != 200 && response.statusCode != 204 && response.statusCode != 201) {
        throw ServerException(
          message: _extractMessage(response.data) ?? 'Failed to clear history on server',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }

  String _parseDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data['message'] != null) return data['message'].toString();
        if (data['error'] != null) return data['error'].toString();
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Check your connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401)
          return 'Session expired. Please log in again.';
        if (e.response?.statusCode == 429)
          return 'Too many requests. Please wait a moment.';
        return 'Server error (${e.response?.statusCode}). Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
