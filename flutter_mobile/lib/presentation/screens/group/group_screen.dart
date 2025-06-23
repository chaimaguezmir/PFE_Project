import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';

import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:formz/formz.dart';


import '../../bloc/group/group_cubit.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Groupes",
        username: "Walid Zaroui",
        email: "zarwi.walid@gmail.com",
        avatarPath: "lib/config/assets/images/default_avatar.jpg",
        showLeading: false,
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state.status.isInitial &&
              state.status != FormzSubmissionStatus.inProgress) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<GroupCubit>().fetchGroups();
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
            onRefresh: () => context.read<GroupCubit>().fetchGroups(),
            child: ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, i) {
                final group = state.groups[i];
                return ListTile(
                  onTap: () {
                    context.read<GroupCubit>().currentGroupIdChanged(
                      group.groupId,
                    );
                    context.read<GroupCubit>().currentGroupUserRoleChanged(
                      group.role,
                    );
                    context.read<GroupCubit>().currentGroupNameChanged(
                      group.name,
                    );

                    Navigator.of(
                      context,
                    ).pushNamed(AppRouteName.groupMembersScreen);
                  },
                  title: Text(group.role),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
