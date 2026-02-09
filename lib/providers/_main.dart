import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:urology_waiting_list/api/auth/api_auth.dart';
import 'package:urology_waiting_list/api/doctors/doctors_api.dart';
import 'package:urology_waiting_list/providers/px_auth.dart';
import 'package:urology_waiting_list/providers/px_doctors.dart';
import 'package:urology_waiting_list/providers/px_theme.dart';
import 'package:urology_waiting_list/router/app_router.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider(
    create: (context) => PxTheme(),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAuth(
      api: const AuthApi(),
    ),
  ),
  ChangeNotifierProvider.value(
    value: AppRouter.router.routeInformationProvider,
  ),
  ChangeNotifierProvider(
    create: (context) => PxDoctors(
      api: const DoctorsApi(),
    ),
  ),
];
