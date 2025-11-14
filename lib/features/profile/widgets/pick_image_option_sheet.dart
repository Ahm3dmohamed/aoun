import 'package:aoun/core/extensions/localization_extension.dart';
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
            title: Text(context.l10n.photoLibrary),
            onTap: () {
              Navigator.of(context).pop();
              onGalleryTap();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.teal),
            title: Text(context.l10n.camera),
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
