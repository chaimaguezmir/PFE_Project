import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._sharedPreferences, this._connectivity)
    : super(const AuthInitial()) {
    print('object');
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(ConnectivityChanged(result: results));
    });
    on<LoginEvent>(_loginEventHandler);
    on<LogoutEvent>(_logoutEventHandler);

    on<ConnectivityChanged>(_onConnectivityChanged);
  }
  final SharedPreferences _sharedPreferences;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final Connectivity _connectivity;
  Future<void> _loginEventHandler(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthAuthenticated());
  }

  Future<void> _logoutEventHandler(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
    print(state.status);
  }

  FutureOr<void> _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<AuthState> emit,
  ) {
    print('function called');
    if (event.result.contains(ConnectivityResult.none)) {
      emit(const AuthNoNetwork());
      print(state.status);
    } else {
      emit(const AuthBackOnLine());
      print(state.status);
    }

  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
