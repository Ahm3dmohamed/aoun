// data/datasources/home_remote_data_source.dart
import 'package:aoun/features/cases/data/models/case_model.dart';
import 'package:aoun/features/cases/domain/entities/case_entity.dart';
import 'package:aoun/features/home/data/models/case_model.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);

  Future<List<CaseModel>> getCases() async {
    final response = await dio.get(
      'https://untakable-tien-unwadable.ngrok-free.dev/api/cases',
    );

    final data = response.data as List;

    return data.map((e) => CaseModel.fromJson(e)).toList();
  }
}
