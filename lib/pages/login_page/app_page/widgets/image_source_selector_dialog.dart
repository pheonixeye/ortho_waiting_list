import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSelectorDialog extends StatelessWidget {
  ImageSourceSelectorDialog({super.key});
  final _notifier = ValueNotifier<ImageSource?>(null);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(2),
      insetPadding: const EdgeInsets.all(2),
      title: Row(
        children: [
          const Text('اختر كاميرا او ملف'),
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: RadioGroup<ImageSource>(
        groupValue: _notifier.value,
        onChanged: (value) {
          if (value != null) {
            _notifier.value = value;
            Navigator.pop(context, _notifier.value);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ...ImageSource.values.map((e) {
              return RadioListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    switch (e) {
                      ImageSource.camera => const Icon(Icons.camera),
                      ImageSource.gallery => const Icon(Icons.image),
                    },
                    Text(e.name.split('.').last),
                  ],
                ),
                value: e,
              );
            })
          ],
        ),
      ),
    );
  }
}
