import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setPage(int index) {
    print('OnboardingCubit: Setting page to $index'); // Debug print
    emit(index);
  }
}
