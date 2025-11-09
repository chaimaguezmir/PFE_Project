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
    on<ProfileImageUpdated>(_profileImageUpdatedHandler);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Load profile image URL from SharedPreferences on initialization
    _loadProfileImageUrl();
  }
  final SharedPreferences _sharedPreferences;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final Connectivity _connectivity;

  void _loadProfileImageUrl() {
    final profileImageUrl = _sharedPreferences.getString('profileImageUrl');
    if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      add(ProfileImageUpdated(imageUrl: profileImageUrl));
    }
  }

  Future<void> _loginEventHandler(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final profileImageUrl = _sharedPreferences.getString('profileImageUrl');
    emit(AuthAuthenticated(profileImageUrl: profileImageUrl));
  }

  Future<void> _logoutEventHandler(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
    print(state.status);
  }

  Future<void> _profileImageUpdatedHandler(
    ProfileImageUpdated event,
    Emitter<AuthState> emit,
  ) async {
    // Maintain current status while updating profile image URL
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(profileImageUrl: event.imageUrl));
    } else if (state is AuthNoNetwork) {
      emit(AuthNoNetwork(profileImageUrl: event.imageUrl));
    } else if (state is AuthBackOnLine) {
      emit(AuthBackOnLine(profileImageUrl: event.imageUrl));
    } else if (state is AuthInitial) {
      emit(AuthInitial(profileImageUrl: event.imageUrl));
    }
  }

  FutureOr<void> _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<AuthState> emit,
  ) {
    print('function called');
    final currentImageUrl = state.profileImageUrl;
    if (event.result.contains(ConnectivityResult.none)) {
      emit(AuthNoNetwork(profileImageUrl: currentImageUrl));
      print(state.status);
    } else {
      emit(AuthBackOnLine(profileImageUrl: currentImageUrl));
      print(state.status);
    }

  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
