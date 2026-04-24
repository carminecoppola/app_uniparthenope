import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';

import 'profile_info_widget.dart';

class ProfileInfoDisplay extends StatelessWidget {
  final int index;

  const ProfileInfoDisplay({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;
    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;
    final role = authenticatedUser?.user.grpDes;
    final localizations = AppLocalizations.of(context);
    final title = index == 0
        ? localizations.translate('personal_label')
        : localizations.translate('career_label');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    index == 0
                        ? FontAwesomeIcons.idCard
                        : FontAwesomeIcons.graduationCap,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (userAnagrafe != null && authenticatedUser != null) ...[
              if (index == 0) ...[
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.fingerprint,
                  label: localizations.translate('cf_label'),
                  value: userAnagrafe.codFis.toString(),
                ),
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.calendarDay,
                  label: localizations.translate('dob_label'),
                  value: userAnagrafe.dataNascita!.split(" ")[0],
                ),
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.flag,
                  label: localizations.translate('nationality_label'),
                  value: toCamelCase(userAnagrafe.desCittadinanza ?? ''),
                ),
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.phone,
                  label: localizations.translate('phone_label'),
                  value: userAnagrafe.telRes.toString(),
                ),
              ],
              if (index == 1) ...[
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.user,
                  label: localizations.translate('username_label'),
                  value: authenticatedUser.user.userId ?? '',
                ),
                ProfileSingleInfoRow(
                  icon: FontAwesomeIcons.userTag,
                  label: localizations.translate('role_label'),
                  value: role == 'Studenti'
                      ? (role ?? '')
                      : (userAnagrafe.ruolo ?? ''),
                ),
                if (role == 'Studenti' && selectedCareer != null) ...[
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.hashtag,
                    label: localizations.translate('course_id_label'),
                    value: selectedCareer['cdsId'].toString(),
                  ),
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.bookOpen,
                    label: localizations.translate('course_label'),
                    value: toCamelCase(selectedCareer['cdsDes']),
                  ),
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.envelope,
                    label: localizations.translate('university_email_label'),
                    value: userAnagrafe.emailAte ?? '',
                  ),
                ],
                if (role == 'Docenti') ...[
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.chalkboardUser,
                    label: localizations.translate('teacher_id_label'),
                    value: authenticatedUser.user.docenteId.toString(),
                  ),
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.layerGroup,
                    label: localizations.translate('sector_label'),
                    value: toCamelCase(userAnagrafe.settore.toString()),
                  ),
                  ProfileSingleInfoRow(
                    icon: FontAwesomeIcons.envelope,
                    label: localizations.translate('university_email_label'),
                    value: userAnagrafe.emailAte ?? '',
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  String getGenderDescription(String? gender, context) {
    if (gender == 'M') {
      return AppLocalizations.of(context).translate('male_label');
    } else if (gender == 'F') {
      return AppLocalizations.of(context).translate('female_label');
    } else {
      return AppLocalizations.of(context).translate('undefined_gender_label');
    }
  }
}
