import 'package:appuniparthenope/app_localizations.dart';
import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';

class SingleCourseCard extends StatelessWidget {
  final int index;
  final String cfuExam;
  final String titleExam;
  final String status;
  final String codiceCorso;
  final String annoAccademico;

  const SingleCourseCard({
    super.key,
    required this.index,
    required this.cfuExam,
    required this.titleExam,
    required this.status,
    required this.codiceCorso,
    required this.annoAccademico,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(status);
    final cleanTitle = titleExam.split(' CFU').first;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.26),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarkColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              statusColor.withValues(alpha: 0.10),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cfuExam,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.primaryDarkColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'CFU',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: AppColors.primaryDarkColor
                                .withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cleanTitle,
                          style: const TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _CourseMetaChip(
                              icon: Icons.tag_rounded,
                              text:
                                  '${AppLocalizations.of(context).translate('code')}: $codiceCorso',
                            ),
                            _CourseMetaChip(
                              icon: Icons.workspace_premium_outlined,
                              text: '$cfuExam CFU',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.14),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${AppLocalizations.of(context).translate('state')}: ',
                      style: const TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    final normalizedStatus = status.toLowerCase();

    if (normalizedStatus.contains('super') ||
        normalizedStatus.contains('riconos')) {
      return AppColors.successColor;
    }

    if (normalizedStatus.contains('pian')) {
      return AppColors.detailsColor;
    }

    if (normalizedStatus.contains('frequen') ||
        normalizedStatus.contains('attivit')) {
      return AppColors.accentColor;
    }

    return AppColors.lightGray;
  }
}

class _CourseMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CourseMetaChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primaryDarkColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
