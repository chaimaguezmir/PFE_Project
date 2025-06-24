import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/core/utils/DialogService.dart';
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

  void selectedMemberIdChanged(String value) {
    emit(state.copyWith(selectedMemberId: value, errorMessage: null));
  }
  void currentGroupIdChanged(String value) {
    emit(state.copyWith(currentGroupId: value, errorMessage: null));
  }

  void selectedMemberRoleChanged(String value) {
    emit(state.copyWith(selectedMemberRole: value, errorMessage: null));
  }

  void selectedMemberUsernameChanged(String value) {
    emit(state.copyWith(selectedMemberUsername: value, errorMessage: null));
  }

  void currentGroupNameChanged(String? value) {
    emit(state.copyWith(currentGroupName: value, errorMessage: null));
  }

  void currentGroupUserRoleChanged(String value) {
    emit(state.copyWith(currentGroupUserRole: value, errorMessage: null));
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

    if (!_isValidEmail(state.email.trim())) {
      emit(state.copyWith(errorMessage: 'Adresse e-mail invalide'));
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> fetchGroups() async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );
    final result = await _groupRepository.getUserGroups();
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

  Future<void> fetchGroupMembers() async {
    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
        errorMessage: null,
      ),
    );
    final result = await _groupRepository.getGroupMembers(
      state.currentGroupId,
    );
    final sortedMembers = List<MemberEntity>.from(result.data ?? [])
      ..sort((a, b) {
        const roleOrder = {'MANAGER': 0, 'RESPONSIBLE': 1, 'MEMBER': 2};
        return (roleOrder[a.role.toUpperCase()] ?? 3).compareTo(
          roleOrder[b.role.toUpperCase()] ?? 3,
        );
      });
    if (result is DataSuccess<List<MemberEntity>>) {
      emit(
        state.copyWith(
          members: sortedMembers,
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

  Future<void> addMember() async {
    emit(state.copyWith(errorMessage: null));

    if (!_isFormValid()) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await _groupRepository.addMember(state.currentGroupId, state.email);
    if (result is DataSuccess) {
      fetchGroupMembers();
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
    BuildContext context,


  ) async {
    DialogService.showRemoveMemberDialog(
      context: context,
      avatarPath: 'lib/config/assets/images/default_avatar.jpg',
      message: state.selectedMemberRole == 'MEMBER'
          ? 'Êtes-vous sûr de vouloir Assigner ${state.selectedMemberUsername} responsable du groupe ?'
          : 'Êtes-vous sûr de vouloir désassigner ${state.selectedMemberUsername} du rôle de responsable du groupe ?',
      groupName: state.currentGroupName,
      onConfirm: () async {
        emit(
          state.copyWith(
            errorMessage: null,
            status: FormzSubmissionStatus.inProgress,
          ),
        );
        final result = await _groupRepository.toggleRole(state.currentGroupId, state.selectedMemberId);
        if (result is DataSuccess) {
          fetchGroupMembers();

          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              errorMessage: null,
              successMessage:
                  result.data?.message ?? 'Role toggled successfully',
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
      },
    );
  }

  Future<void> removeMember(
    BuildContext context,


  ) async {
    if (!context.mounted)
      return; // Check if context is mounted before showing dialog

    DialogService.showRemoveMemberDialog(
      context: context,
      avatarPath: 'lib/config/assets/images/default_avatar.jpg',
      message:
          'Êtes-vous sûr de vouloir retirer ${state.selectedMemberUsername} du groupe ?',
      groupName: state.currentGroupName,
      onConfirm: () async {
        emit(
          state.copyWith(
            errorMessage: null,
            status: FormzSubmissionStatus.inProgress,
          ),
        );

        final result = await _groupRepository.removeMember(state.currentGroupId, state.selectedMemberId);

        if (result is DataSuccess) {
          await fetchGroupMembers();
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
              errorMessage: null,
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
      },
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
