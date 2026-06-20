import 'package:aoun/core/storage/hive_service.dart';

class ChatLocalDataSource {
  final HiveService hiveService;

  ChatLocalDataSource(this.hiveService);

  List<Map<dynamic, dynamic>> loadMessages() {
    return hiveService.loadMessages();
  }

  Future<void> saveMessage(Map<dynamic, dynamic> message) async {
    await hiveService.saveMessage(message);
  }
}
