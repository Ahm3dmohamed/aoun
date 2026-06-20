// // data/models/case_model.dart
// import 'package:aoun/features/home/domain/entities/case_entity.dart';

// class CaseModel extends CaseEntity {
//   const CaseModel({
//     required super.id,
//     required super.title,
//     required super.description,
//     required super.targetAmount,
//     required super.donatedAmount,
//     required super.remainingAmount,
//     required super.status,
//     super.imagePath,
//     required super.category,
//     required super.urgency,
//     required super.location,
//     required super.createdAt,
//   });

//   factory CaseModel.fromJson(Map<String, dynamic> json) {
//     return CaseModel(
//       id: json['id'],
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       targetAmount: double.parse(json['target_amount'].toString()),
//       donatedAmount: double.parse(json['donated_amount'].toString()),
//       remainingAmount: double.parse(json['remaining_amount'].toString()),
//       status: json['status'] ?? '',
//       imagePath: json['image_path'],
//       category: json['category'] ?? '',
//       urgency: json['urgency'] ?? '',
//       location: json['location'] ?? '',
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
