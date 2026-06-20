import 'dart:ui';

import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/cases/data/models/case_model.dart';
import 'package:aoun/features/home/domain/entities/case_entity.dart';
import 'package:aoun/features/home/domain/repositories/home_repository.dart';
import 'package:flutter/material.dart';

class GetCasesUseCase {
  final HomeRepository repository;

  const GetCasesUseCase(this.repository);

  Future<Either<Failure, List<CaseModel>>> call({int page = 1}) =>
      repository.getCases(page: page);
}
// presentation/utils/case_ui_mapper.dart

class CaseUiMapper {
  static String category(String c, bool isAr) {
    switch (c.toLowerCase()) {
      case 'medical':
        return isAr ? 'طبي' : 'Medical';
      case 'food':
        return isAr ? 'طعام' : 'Food';
      default:
        return c;
    }
  }

  static (Color, String) urgency(String u, bool isAr) {
    if (u.toLowerCase() == 'high') {
      return (Colors.red, isAr ? 'عاجل' : 'Urgent');
    }
    return (Colors.orange, isAr ? 'عادي' : 'Normal');
  }
}
