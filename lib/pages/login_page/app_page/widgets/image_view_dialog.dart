import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewDialog extends StatelessWidget {
  const ImageViewDialog({
    super.key,
    required this.url,
  });
  final String url;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(2),
      insetPadding: const EdgeInsets.all(2),
      title: Row(
        children: [
          const Text('مناظرة الاشاعة'),
          const Spacer(),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: InteractiveViewer(
          alignment: Alignment.center,
          maxScale: 8.0,
          child: CachedNetworkImage(
            imageUrl: url,
          ),
        ),
      ),
    );
  }
}
