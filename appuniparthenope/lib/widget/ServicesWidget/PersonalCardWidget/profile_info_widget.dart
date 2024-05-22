import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2022 $label',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.lightGray,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
          width: 5,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.detailsColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, size: 50),
    );
  }
}
