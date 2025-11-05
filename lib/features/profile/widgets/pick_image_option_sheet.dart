import 'package:flutter/material.dart';

class PickImageOptionsSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const PickImageOptionsSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.teal),
            title: const Text('Photo Library'),
            onTap: () {
              Navigator.of(context).pop();
              onGalleryTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.teal),
            title: const Text('Camera'),
            onTap: () {
              Navigator.of(context).pop();
              onCameraTap();
            },
          ),
        ],
      ),
    );
  }
}
