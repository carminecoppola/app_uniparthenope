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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                index == 0
                    ? FontAwesomeIcons.person
                    : FontAwesomeIcons.university,
                color: AppColors.primaryColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Text(
                index == 0
                    ? AppLocalizations.of(context).translate('personal_label')
                    : AppLocalizations.of(context).translate('career_label'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (userAnagrafe != null && authenticatedUser != null) ...[
            // --- PERSONAL INFO ---
            if (index == 0) ...[
              ProfileSingleInfoRow(
                label: AppLocalizations.of(context).translate('cf_label'),
                value: userAnagrafe.codFis.toString(),
              ),
              ProfileSingleInfoRow(
                label: AppLocalizations.of(context).translate('dob_label'),
                value: userAnagrafe.dataNascita!.split(" ")[0],
              ),
              ProfileSingleInfoRow(
                label:
                    AppLocalizations.of(context).translate('nationality_label'),
                value: toCamelCase(userAnagrafe.desCittadinanza ?? ''),
              ),
              ProfileSingleInfoRow(
                label: AppLocalizations.of(context).translate('phone_label'),
                value: userAnagrafe.telRes.toString(),
              ),
            ],

            // --- UNIVERSITY INFO ---
            if (index == 1) ...[
              ProfileSingleInfoRow(
                label: AppLocalizations.of(context).translate('username_label'),
                value: authenticatedUser.user.userId ?? '',
              ),
              ProfileSingleInfoRow(
                label: AppLocalizations.of(context).translate('role_label'),
                value: role == 'Studenti'
                    ? (role ?? '')
                    : (userAnagrafe.ruolo ?? ''),
              ),
              if (role == 'Studenti' && selectedCareer != null) ...[
                ProfileSingleInfoRow(
                  label:
                      AppLocalizations.of(context).translate('course_id_label'),
                  value: selectedCareer['cdsId'].toString(),
                ),
                ProfileSingleInfoRow(
                  label: AppLocalizations.of(context).translate('course_label'),
                  value: toCamelCase(selectedCareer['cdsDes']),
                ),
                ProfileSingleInfoRow(
                  label: AppLocalizations.of(context)
                      .translate('university_email_label'),
                  value: userAnagrafe.emailAte ?? '',
                ),
              ],
              if (role == 'Docenti') ...[
                ProfileSingleInfoRow(
                  label: AppLocalizations.of(context)
                      .translate('teacher_id_label'),
                  value: authenticatedUser.user.docenteId.toString(),
                ),
                ProfileSingleInfoRow(
                  label: AppLocalizations.of(context).translate('sector_label'),
                  value: toCamelCase(userAnagrafe.settore.toString()),
                ),
                ProfileSingleInfoRow(
                  label: AppLocalizations.of(context)
                      .translate('university_email_label'),
                  value: userAnagrafe.emailAte ?? '',
                ),
              ],
            ],
          ],
        ],
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
