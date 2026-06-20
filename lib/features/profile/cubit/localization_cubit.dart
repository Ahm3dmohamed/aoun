import 'package:aoun/features/profile/cubit/localization_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  static const String _settingsBoxName = 'settingsBox';
  static const String _langKey = 'language_code';

  LocalizationCubit() : super(LocalizationState(const Locale('ar'))) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    // Open the box (or use Hive.box if you opened it in main.dart)
    var box = await Hive.openBox(_settingsBoxName);
    final String? languageCode = box.get(_langKey);

    if (languageCode != null) {
      emit(LocalizationState(Locale(languageCode)));
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (state.locale == locale) return;

    var box = await Hive.openBox(_settingsBoxName);
    await box.put(_langKey, locale.languageCode);

    emit(LocalizationState(locale));
  }
}
