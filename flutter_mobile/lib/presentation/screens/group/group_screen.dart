import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/injection_container.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/group/group_cubit.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final String token = sl<SharedPreferences>().getString('token') ?? '';
    return  BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state.status.isInitial && state.status != FormzSubmissionStatus.inProgress) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<GroupCubit>().fetchGroups(token);
            });
          }

          if (state.status == FormzSubmissionStatus.inProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FormzSubmissionStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }
          if (state.groups.isEmpty) {
            return const Center(child: Text('No groups found.'));
          }
          return RefreshIndicator(
            onRefresh: () => context.read<GroupCubit>().fetchGroups(token),
            child: ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, i) {
                final group = state.groups[i];
                return ListTile(onTap:(){
                  context.read<GroupCubit>().selectedGroupIdChanged(group.groupId);
                  context.pushNamed(AppRouteName.groupMembersScreen, pathParameters: {'selectedGroupId': group.groupId});

                },title: Text(group.name));
              },
            ),
          );
        },

    );
  }
}
