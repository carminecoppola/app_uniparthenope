import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class PersonalCardUser extends StatelessWidget {
  static const String heroTag = 'personal-profile-card-hero';

  final VoidCallback onTap;
  final String firstName;
  final String lastName;
  final String? identificativoLabel;
  final String? id;
  final String? profileImage;

  const PersonalCardUser({
    super.key,
    required this.onTap,
    required this.firstName,
    required this.lastName,
    this.identificativoLabel,
    this.id,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? backgroundImage;

    if (kIsWeb && profileImage != null) {
      backgroundImage = NetworkImage(profileImage!);
    } else if (profileImage != null) {
      backgroundImage = FileImage(File(profileImage!));
    } else {
      backgroundImage = const AssetImage('assets/user_profile_default.jpg');
    }

    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Ink(
            width: kIsWeb ? 800 : double.infinity,
            height: 120,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.blueGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarkColor.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$firstName $lastName',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        identificativoLabel ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.88),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        id ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.detailsColor,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 33,
                    backgroundImage: backgroundImage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
