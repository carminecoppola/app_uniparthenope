import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/core/logger.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AvatarWidget extends StatelessWidget {
  final double? size;
  const AvatarWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<AuthProvider>(context).profileImage;
    final hasProfileImage =
        profileImage != null && profileImage.trim().isNotEmpty;
    ImageProvider<Object>? backgroundImage;

    if (kIsWeb && hasProfileImage) {
      backgroundImage = NetworkImage(profileImage);
    } else if (hasProfileImage) {
      backgroundImage = FileImage(File(profileImage));
    } else {
      backgroundImage = const AssetImage('assets/user_profile_default.jpg');
    }

    AppLogger.info(
      'IMG UI Avatar hasProfileImage=$hasProfileImage kIsWeb=$kIsWeb valueLen=${profileImage?.length ?? 0}',
    );

    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.detailsColor,
            width: 6,
          ),
        ),
        child: CircleAvatar(
          radius: size,
          backgroundColor: Colors.transparent,
          backgroundImage: backgroundImage,
        ),
      ),
    );
  }
}
