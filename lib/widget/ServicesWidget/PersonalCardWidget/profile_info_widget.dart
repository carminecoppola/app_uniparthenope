import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class ProfileSingleInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool allowCopy;

  const ProfileSingleInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.allowCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightGray,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  allowCopy
                      ? SelectableText(
                          value,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(
                          value,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
