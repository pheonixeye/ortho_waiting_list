import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:urology_waiting_list/api/waiting_list/waiting_list_api.dart';
import 'package:urology_waiting_list/pages/login_page/app_page/app_page.dart';
import 'package:urology_waiting_list/pages/login_page/login_page.dart';
import 'package:urology_waiting_list/pages/login_page/settings_page/settings_page.dart';
import 'package:urology_waiting_list/providers/px_auth.dart';
import 'package:urology_waiting_list/providers/px_operations.dart';
import 'package:urology_waiting_list/utils/utils.dart';

class AppRouter {
  static const login = '/';
  static const app = 'app';
  static const settings = 'settings';

  static final GoRouter router = GoRouter(
    initialLocation: '/', //login
    debugLogDiagnostics: true,
    navigatorKey: Utils.navigatorKey,

    routes: [
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) {
          return LoginPage(
            key: state.pageKey,
          );
        },
        redirect: (context, state) async {
          final _auth = context.read<PxAuth>();
          if (_auth.isLoggedIn && state.fullPath == '/') {
            return '/$app';
          }
          if (!_auth.isLoggedIn) {
            try {
              await _auth.loginWithToken();
              print(
                  'authWithToken(LoginPage-Redirect)(isLoggedIn=${_auth.isLoggedIn})');
              return '${state.fullPath}';
            } catch (e) {
              print('not logged in - redirecting');
              return login;
            }
          }
          if (_auth.isLoggedIn && state.fullPath != '/') {
            return null;
          }
          print('no redirect - logged in: ${_auth.isLoggedIn}');
          return null;
        },
        routes: [
          GoRoute(
            path: app,
            name: app,
            builder: (context, state) {
              return ChangeNotifierProvider(
                create: (context) => PxOperations(
                  api: const WaitingListApi(),
                ),
                child: AppPage(
                  key: state.pageKey,
                ),
              );
            },
            routes: [
              GoRoute(
                path: settings,
                name: settings,
                builder: (context, state) {
                  return SettingsPage(
                    key: state.pageKey,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
