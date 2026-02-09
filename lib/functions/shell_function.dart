import 'package:flutter/material.dart';
import 'package:urology_waiting_list/components/central_loading.dart';
import 'package:urology_waiting_list/components/main_snackbar.dart';

///Shell function encapsulating loading & error handling logic in the UI
Future<void> shellFunction(
  BuildContext context, {
  required Function toExecute,
  String sucessMsg = '',
  Function? onCatch,
  Duration duration = const Duration(seconds: 10),
}) async {
  late BuildContext _loadingContext;
  try {
    if (sucessMsg.isEmpty) {
      sucessMsg = 'تم بنجاح...';
    }
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) {
            _loadingContext = context;
            return const CentralLoading();
          });
    }
    await Future.delayed(const Duration(milliseconds: 100));
    await toExecute();
    if (_loadingContext.mounted) {
      Navigator.pop(_loadingContext);
    }
    if (context.mounted) {
      showInfoSnackbar(context, sucessMsg);
    }
  } catch (e) {
    if (_loadingContext.mounted) {
      Navigator.pop(_loadingContext);
    }
    if (context.mounted) {
      showInfoSnackbar(
        context,
        e.toString(),
        Colors.red,
        duration,
      );
      if (onCatch != null) {
        onCatch();
      }
    }
  }
}
