import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class AvatarWidget extends StatelessWidget {
  final size;
  const AvatarWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<AuthProvider>(context).profileImage;
    ImageProvider<Object>? backgroundImage;

    if (kIsWeb && profileImage != null) {
      backgroundImage = NetworkImage(profileImage);
    } else if (profileImage != null) {
      backgroundImage = FileImage(File(profileImage));
    } else {
      backgroundImage = const AssetImage('assets/user_profile_default.jpg');
    }

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
