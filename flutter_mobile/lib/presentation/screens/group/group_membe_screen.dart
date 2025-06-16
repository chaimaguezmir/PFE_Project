import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/domain/entities/group/member_entity.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({super.key,required this.selectedGroupId});
  final String selectedGroupId;
  @override
  Widget build(BuildContext context) {
    final String token = sl<SharedPreferences>().getString('token') ?? '';
    context.read<GroupCubit>().selectedGroupIdChanged(selectedGroupId);
    // 👈 This will now work because it's the same GroupCubit instance


    // Fetch members when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupCubit>().fetchGroupMembers(token, selectedGroupId);
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Group Members')),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state.status.isInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status.isFailure) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }
          if (state.members.isEmpty) {
            return const Center(child: Text('No members found.'));
          }
          return ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              final MemberEntity member = state.members[index];
              return ListTile(
                title: Text(member.username),
                subtitle: Text(member.role),
                leading: const Icon(Icons.person),
              );
            },
          );
        },
      ),
    );
  }
}
