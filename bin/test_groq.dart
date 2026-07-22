import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:aoun/core/utils/secrets.dart';

void main() async {
  final dio = Dio();
  print('Starting Groq test...');
  try {
    final response = await dio.post<ResponseBody>(
      'https://api.groq.com/openai/v1/chat/completions',
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${Secrets.apiKey}',
          HttpHeaders.contentTypeHeader: 'application/json',
          // HttpHeaders.acceptHeader: 'text/event-stream',
        },
        responseType: ResponseType.stream,
      ),
      data: {
        'model': 'llama-3.3-70b-versatile',
        'stream': true,
        'messages': [
          {'role': 'user', 'content': 'Hello, are you there?'},
        ],
      },
    );

    print('Got response stream');
    response.data!.stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            print('LINE: $line');
          },
          onError: (e) => print('ERROR: $e'),
          onDone: () => print('DONE'),
        );
  } on DioException catch (e) {
    print('STATUS: ${e.response?.statusCode}');
    print('DATA: ${e.response?.data}');
    print('URI: ${e.requestOptions.uri}');
  }
}
