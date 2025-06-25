import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/utils/shared_prefs_utils.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/auth/auth/auth_bloc.dart';
import 'package:formz/formz.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(const ProfileState());
  final AuthRepository _authRepository;
  final SharedPrefsUtils _sharedPrefsUtils = SharedPrefsUtils();

  Future<void> logout() async {
    emit(state.copyWith(errorMessage: null));

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final request = await getSignOutRequestModel();

    final result = await _authRepository.signOut(request);

    if (result is DataSuccess) {
      await _sharedPrefsUtils.clearSharedPref();
      sl<AuthBloc>().add(LogoutEvent());
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          errorMessage: null,
          successMessage: 'logout successful',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed logging out',
        ),
      );
    }
  }
}
