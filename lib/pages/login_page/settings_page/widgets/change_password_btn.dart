import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/components/main_snackbar.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';

class ChangePasswordBtn extends StatelessWidget {
  const ChangePasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'reset-password-btn',
      onPressed: () async {
        await shellFunction(
          context,
          toExecute: () async {
            await context.read<PxAuth>().changePassword();
            if (context.mounted) {
              showInfoSnackbar(
                context,
                'تم ارسال بريد الكتروني برابط تغيير كلمة السر',
              );
            }
          },
        );
      },
      child: const Icon(Icons.lock),
    );
  }
}
