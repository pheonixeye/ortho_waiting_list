import 'package:flutter/material.dart';
import 'package:urology_waiting_list/functions/shell_function.dart';

class CentralError extends StatelessWidget {
  const CentralError({
    super.key,
    required this.error,
    required this.toExecute,
  });
  final String? error;
  final Future<void> Function() toExecute;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              const Icon(
                Icons.error,
                size: 75,
              ),
              Text(
                error ?? '',
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await toExecute();
                    },
                  );
                },
                label: const Text("اعادة المحاولة"),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.green.shade100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
