import 'package:ortho_waiting_list/api/rank_api/rank_api.dart';
import 'package:ortho_waiting_list/api/specialities_api/spec_api.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ortho_waiting_list/api/auth/api_auth.dart';
import 'package:ortho_waiting_list/api/doctors/doctors_api.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';
import 'package:ortho_waiting_list/providers/px_constants.dart';
import 'package:ortho_waiting_list/providers/px_theme.dart';
import 'package:ortho_waiting_list/router/app_router.dart';

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
    create: (context) => PxConstants(
      doctors_api: const DoctorsApi(),
      ranks_api: const RankApi(),
      spec_api: const SpecApi(),
    ),
  ),
];
