import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Material(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            _ProfileTabButton(
              text: localizations.translate('personal_label'),
              icon: Icons.person_outline,
              selected: selectedIndex == 0,
              onTap: () => onTabTapped(0),
            ),
            const SizedBox(width: 4),
            _ProfileTabButton(
              text: localizations.translate('career_label'),
              icon: Icons.school_outlined,
              selected: selectedIndex == 1,
              onTap: () => onTabTapped(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTabButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileTabButton({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? Colors.white : AppColors.primaryColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
