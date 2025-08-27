// dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'welcome_screen_state.dart';

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  WelcomeScreenCubit() : super(const WelcomeScreenState());

  Future<void> loadWelcomeData() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      // Simulate async work for loading welcome data.
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void updateSelectedTime(int index) {
    emit(state.copyWith(selectedTimeIndex: index));
  }
}