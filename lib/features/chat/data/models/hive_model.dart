import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ChatModel extends HiveObject {
  @HiveField(0)
  String role;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  ChatModel({
    required this.role,
    required this.content,
    required this.createdAt,
  });
}
