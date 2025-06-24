import 'package:flutter/material.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/presentation/screens/group/add_member_screen.dart';
import 'package:flutter_mobile/presentation/screens/group/group_membe_screen.dart';
import 'package:flutter_mobile/presentation/screens/group/group_screen.dart';
class GroupShell extends StatelessWidget {

  const GroupShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case AppRouteName.mainScreen:
            page = const GroupScreen();
            break;

          case AppRouteName.groupMembersScreen:
            page = const GroupMembersScreen();
            break;
          case AppRouteName.addMemberScreen:
            page = const AddMemberScreen();
            break;
          default:
            page = const GroupScreen();
        }

        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}