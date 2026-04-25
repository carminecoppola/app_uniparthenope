import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class CustomCareerSelectionDialog extends StatelessWidget {
  final List<Map<String, dynamic>> careers;

  const CustomCareerSelectionDialog({super.key, required this.careers});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              decoration: const BoxDecoration(
                gradient: AppColors.blueGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/logoWhite.png'),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    AppLocalizations.of(context).translate('select_career'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: careers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final career = careers[index];
                    final isActive = career['staStuDes'].toString() == 'Attivo';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFF),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.10),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          _toCamelCase(career['cdsDes']),
                          style: const TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _CareerMetaChip(
                                icon: Icons.badge_outlined,
                                text:
                                    '${AppLocalizations.of(context).translate('studentid')}: ${career['matricola']}',
                              ),
                              _CareerStatusChip(
                                text: career['staStuDes'].toString(),
                                isActive: isActive,
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        onTap: () {
                          Navigator.of(context).pop(career['cdsId'].toString());
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _toCamelCase(String text) {
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }
}

class _CareerMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CareerMetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryDarkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerStatusChip extends StatelessWidget {
  final String text;
  final bool isActive;

  const _CareerStatusChip({
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.successColor : AppColors.errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
