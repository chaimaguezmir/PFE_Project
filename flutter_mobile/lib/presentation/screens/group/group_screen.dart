import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/custom_app_bar.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/group/group_cubit.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(screenSize);

    return Scaffold(
      appBar: const CustomAppBar(title: "Groupes", showLeading: false),

      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom du groupe',
                        errorText: state.errorMessage,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          context.read<GroupCubit>().groupNameChanged(value),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: state.newGroupName,
                          selection: TextSelection.collapsed(
                            offset: state.newGroupName.length,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: state.status.isInProgress
                          ? null
                          : () => context.read<GroupCubit>().createGroup(),
                      child: state.status.isInProgress
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Créer le groupe'),
                    ),
                    if (state.successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    if (state.errorMessage != null && state.status.isFailure)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: state.status.isInProgress
                    ? const Center(child: CircularProgressIndicator())
                    : state.groups.isEmpty
                    ? const Center(child: Text('No groups found.'))
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<GroupCubit>().fetchGroups(),
                        child: ListView.builder(
                          itemCount: state.groups.length,
                          itemBuilder: (context, i) {
                            final group = state.groups[i];
                            return ListTile(
                              onTap: () {
                                context
                                    .read<GroupCubit>()
                                    .currentGroupIdChanged(group.groupId);
                                context
                                    .read<GroupCubit>()
                                    .currentGroupUserRoleChanged(group.role);
                                context
                                    .read<GroupCubit>()
                                    .currentGroupNameChanged(group.name);
                                context.pushNamed(
                                  AppRouteName.groupMembersScreen,
                                );
                              },
                              title: Text(group.name),
                              subtitle: Text(group.role),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
