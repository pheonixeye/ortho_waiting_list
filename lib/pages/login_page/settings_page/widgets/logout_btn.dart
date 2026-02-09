import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/components/prompt_dialog.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';
import 'package:ortho_waiting_list/router/app_router.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxAuth>(
      builder: (context, a, _) {
        return FloatingActionButton.small(
          tooltip: "تسجيل الخروج",
          heroTag: 'logout-btn',
          onPressed: () async {
            final _toLogout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return const PromptDialog(message: "تاكيد تسجيل الخروج ؟");
              },
            );
            if (_toLogout == null || !_toLogout) {
              return;
            }
            a.logout();
            if (context.mounted) {
              GoRouter.of(context).goNamed(
                AppRouter.login,
              );
            }
          },
          child: const Icon(Icons.logout),
        );
      },
    );
  }
}
