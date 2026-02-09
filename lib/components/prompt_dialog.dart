import 'package:flutter/material.dart';

class PromptDialog extends StatelessWidget {
  const PromptDialog({
    super.key,
    required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Expanded(
            child: Text("نافذة تأكيدة"),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, true);
          },
          label: const Text('تاكيد'),
          icon: Icon(
            Icons.check,
            color: Colors.green.shade100,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, false);
          },
          label: const Text('الغاء'),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
