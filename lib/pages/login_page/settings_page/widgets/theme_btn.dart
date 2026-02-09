import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/providers/px_theme.dart';

class ThemeBtn extends StatelessWidget {
  const ThemeBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxTheme>(
      builder: (context, t, _) {
        final _isDark = t.mode == ThemeMode.dark;
        return Switch.adaptive(
          value: _isDark,
          onChanged: (value) async {
            if (_isDark) {
              await t.switchTheme(ThemeMode.light);
            } else {
              await t.switchTheme(ThemeMode.dark);
            }
          },
        );
      },
    );
  }
}
