import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/group/group_entity.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';
import 'package:formz/formz.dart';

part 'group_state.dart';



class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this._groupRepository) : super(const GroupState());

  final GroupRepository _groupRepository;

  void selectedGroupIdChanged(String value) {
    emit(state.copyWith(selectedGroupId: value, errorMessage: null));
  }

  Future<void> fetchGroups(String token) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null));
    final result = await _groupRepository.getUserGroups(token);
    if (result is DataSuccess<List<GroupEntity>>) {
      emit(state.copyWith(
        groups: result.data ?? [],
        status: FormzSubmissionStatus.success,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: result.error ?? 'Failed to fetch groups',
      ));
    }
  }

  Future<void> fetchGroupMembers(String token, String groupId) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null));
    final result = await _groupRepository.getGroupMembers(token, groupId);
    if (result is DataSuccess<List<MemberEntity>>) {
      emit(state.copyWith(
        members: result.data ?? [],
        status: FormzSubmissionStatus.success,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: result.error ?? 'Failed to fetch group members',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}