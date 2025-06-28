import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.homeState());

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void selectUser(String userId, String chatId) {
    emit(state.copyWith(selectedUserId: userId, selectedChatId: chatId));
  }

  void clearSelectedUser() {
    emit(state.copyWith(selectedUserId: null, selectedChatId: null));
  }
}

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.homeState({
    @Default(0) int currentIndex,
    String? selectedUserId,
    String? selectedChatId,
  }) = _HomeState;
}
