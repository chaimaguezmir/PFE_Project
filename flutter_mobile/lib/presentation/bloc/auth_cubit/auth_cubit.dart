import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._sharedPreferences) : super(const AuthState());
  final SharedPreferences _sharedPreferences;

  void setPage(int index) {
    //print('AuthCubit: Setting page to $index'); // Debug print
    emit(state.copyWith(currentPage: index));
  }

  void setOnboardingDone(BuildContext context) {
    //print('has seen onboarding $hasSeenOnboarding'); // Debug print
    //print('AuthCubit: Setting onboarding done'); // Debug print
    _sharedPreferences.setBool('hasSeenOnboarding', true);
    context.go('/login');
  }

  void isOnboardingDone() {}
}
