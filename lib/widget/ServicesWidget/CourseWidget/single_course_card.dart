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
    final normalizedStatus = _normalizeStatusLabel(status);
    final statusColor = getStatusColor(normalizedStatus);
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
                        Row(
                          children: [
                            Expanded(
                              child: _CourseMetaChip(
                                icon: Icons.tag_rounded,
                                text:
                                    '${AppLocalizations.of(context).translate('code')}: $codiceCorso',
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _CourseMetaChip(
                              icon: Icons.verified_outlined,
                              text: normalizedStatus,
                              textColor: statusColor,
                              compact: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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

    if (normalizedStatus.contains('pianific')) {
      return const Color(0xFF5E7486);
    }

    if (normalizedStatus.contains('frequent')) {
      return const Color(0xFFB06A1D);
    }

    return AppColors.lightGray;
  }

  String _normalizeStatusLabel(String rawStatus) {
    final normalized = rawStatus.trim().toLowerCase();

    if (normalized.contains('super')) return 'Superata';
    if (normalized.contains('riconos')) return 'Riconosciuta';
    if (normalized.contains('pianific')) return 'Pianificata';
    if (normalized.contains('frequent') || normalized.contains('attivit')) {
      return 'Frequentata';
    }
    if (normalized.isEmpty) return 'Non disponibile';
    return rawStatus;
  }
}

class _CourseMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final bool compact;

  const _CourseMetaChip({
    required this.icon,
    required this.text,
    this.textColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 6 : 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 14 : 16,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: compact ? 4 : 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor ?? AppColors.primaryDarkColor,
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
