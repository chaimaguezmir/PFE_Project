import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/group/add_member_entity.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._groupRepository) : super(const GroupState());

  final GroupRepository _groupRepository;

  void selectedGroupIdChanged(String value) {
    emit(state.copyWith(selectedGroupId: value, errorMessage: null));
  }

  void toggleIconSelected() {
    emit(state.copyWith(isIconSelected: !state.isIconSelected));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  bool _isFormValid() {
    if (state.email == sl<SharedPreferences>().getString('email')) {
      emit(state.copyWith(errorMessage: 'Vous êtes déjà membre de ce groupe'));
      return false;
    }
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'L\'adresse e-mail est requise'));
      return false;
    }

    if (!_isValidEmail(state.email)) {
      emit(state.copyWith(errorMessage: 'Adresse e-mail invalide'));
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> fetchGroups(String token) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );
    final result = await _groupRepository.getUserGroups(token);
    if (result is DataSuccess<List<GroupEntity>>) {
      emit(
        state.copyWith(
          groups: result.data ?? [],
          status: FormzSubmissionStatus.success,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed to fetch groups',
        ),
      );
    }
  }

  Future<void> fetchGroupMembers(String token, String groupId) async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );
    final result = await _groupRepository.getGroupMembers(token, groupId);
    if (result is DataSuccess<List<MemberEntity>>) {
      emit(
        state.copyWith(
          members: result.data ?? [],
          status: FormzSubmissionStatus.success,
          errorMessage: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed to fetch group members',
        ),
      );
    }
  }

  Future<void> addMember(String token, String groupId, String email) async {
    emit(state.copyWith(errorMessage: null));

    if (!_isFormValid()) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _groupRepository.addMember(token, groupId, email);
    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          errorMessage: null,
          successMessage: 'User added successfully',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed to add member',
        ),
      );
    }
  }

  Future<void> toggleRole(
    String token,
    String groupId,
    String targetUserId,
  ) async {
    emit(
      state.copyWith(
        errorMessage: null,
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    final result = await _groupRepository.toggleRole(
      token,
      groupId,
      targetUserId,
    );
    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          errorMessage: null,
          successMessage: result.data?.message ?? 'Role toggled successfully',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed to toggle role',
        ),
      );
    }
  }

  Future<void> removeMember(
      String token,
      String groupId,
      String memberId,
      ) async {
    emit(
      state.copyWith(
        errorMessage: null,
        status: FormzSubmissionStatus.inProgress,
      ),
    );
    final result = await _groupRepository.removeMember(
      token,
      groupId,
      memberId,
    );
    if (result is DataSuccess) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          errorMessage: null,
          successMessage: result.data?.message ?? 'User removed successfully',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: result.error ?? 'Failed to remove member',
        ),
      );
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
