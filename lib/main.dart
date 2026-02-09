import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:urology_waiting_list/localization/app_localizations.dart';
import 'package:urology_waiting_list/providers/_main.dart';
import 'package:urology_waiting_list/providers/px_theme.dart';
import 'package:urology_waiting_list/router/app_router.dart';
import 'package:urology_waiting_list/utils/shared_prefs.dart';
import 'package:urology_waiting_list/utils/theme_data.dart';
import 'package:urology_waiting_list/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initAsyncPrefs();

  await initializeDateFormatting('en');
  await initializeDateFormatting('ar');

  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxTheme>(
      builder: (context, t, _) {
        return MaterialApp.router(
          title: 'قسم جراحة المسالك البولية - مجمع الرحاب الطبي',
          theme: lightThemeData(context),
          darkTheme: darkThemeData(context),
          themeMode: t.mode,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          scaffoldMessengerKey: Utils.scaffoldMessengerKey,
        );
      },
    );
  }
}
