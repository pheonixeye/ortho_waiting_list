import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/logic/constants.dart';
import 'package:ortho_waiting_list/pages/login_page/settings_page/widgets/change_password_btn.dart';
import 'package:ortho_waiting_list/pages/login_page/settings_page/widgets/logout_btn.dart';
import 'package:ortho_waiting_list/pages/login_page/settings_page/widgets/theme_btn.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('الاعدادات'),
              subtitle: Divider(),
            ),
          ),
          Expanded(
            child: ListView(
              cacheExtent: 1000,
              children: [
                Consumer<PxAuth>(
                  builder: (context, auth, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  if (auth.user == null)
                                    const SizedBox(
                                      height: 10,
                                      child: LinearProgressIndicator(),
                                    )
                                  else ...[
                                    Text('${auth.user?.name}'),
                                  ]
                                ],
                              ),
                            ),
                            subtitle: const Divider(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("ثمة البرنامج"),
                        ),
                        trailing: ThemeBtn(),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("تغيير كلمة السر"),
                        ),
                        trailing: ChangePasswordBtn(),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("تسجيل الخروج"),
                        ),
                        trailing: LogoutBtn(),
                        subtitle: Divider(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: AppConstants.appVersion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
