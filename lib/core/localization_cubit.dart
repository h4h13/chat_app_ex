import 'package:chat_app_ex/core/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'localization_cubit.freezed.dart';

@injectable
class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(this.pref)
    : super(
        LocalizationState.loaded(
          locale: pref.getString(selectedLanguageKey) ?? 'en',
        ),
      );

  final SharedPreferences pref;

  void changeLocale(String locale) {
    pref.setString(selectedLanguageKey, locale);
    emit(state.copyWith(locale: locale));
  }
}

@freezed
abstract class LocalizationState with _$LocalizationState {
  const factory LocalizationState.loaded({required String locale}) =
      _LocalizationState;
}
