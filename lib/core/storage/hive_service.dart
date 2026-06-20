import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final _box = Hive.box('chatBox');

  List<Map<dynamic, dynamic>> loadMessages() {
    final messages = _box.get(
      'messages',
      defaultValue: <Map<dynamic, dynamic>>[],
    );
    return List<Map<dynamic, dynamic>>.from(messages);
  }

  Future<void> saveMessage(Map<dynamic, dynamic> message) async {
    final messages = loadMessages();
    messages.add(message);
    await _box.put('messages', messages);
  }
}
