import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.detailsColor,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: profileImage != null
              ? AssetImage(profileImage)
              : const AssetImage('assets/user_profile_default.jpg'),
        ),
      ),
    );
  }
}
