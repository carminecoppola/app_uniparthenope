import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:appuniparthenope/widget/ServicesWidget/PersonalCardWidget/profile_info_widget.dart';

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
    final trattiCarriera = authenticatedUser?.user.trattiCarriera;
    final carriera = trattiCarriera != null && trattiCarriera.isNotEmpty
        ? trattiCarriera[0]
        : null;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        // Blocco Personale
        if (userAnagrafe != null && authenticatedUser != null) ...[
          //Blocco Personale
          if (index == 0) ...[
            ProfileDoubleInfoRow(
              label1: AppLocalizations.of(context).translate('name_label'),
              value1: toCamelCase(userAnagrafe.nome),
              label2: AppLocalizations.of(context).translate('surname_label'),
              value2: toCamelCase(userAnagrafe.cognome),
            ),
            ProfileDoubleInfoRow(
              label1: AppLocalizations.of(context).translate('cf_label'),
              value1: userAnagrafe.codFis.toString(),
              label2:
                  AppLocalizations.of(context).translate('nationality_label'),
              value2: toCamelCase(userAnagrafe.desCittadinanza ?? ''),
            ),
            ProfileDoubleInfoRow(
              label1: AppLocalizations.of(context).translate('dob_label'),
              value1: userAnagrafe.dataNascita!.split(" ")[0],
              label2: AppLocalizations.of(context).translate('phone_label'),
              value2: userAnagrafe.telRes.toString(),
            ),
            // ProfileDoubleInfoRow(
            //   // label1: AppLocalizations.of(context).translate('phone_label'),
            //   // value1: userAnagrafe.telRes.toString(),
            //   // label2: AppLocalizations.of(context).translate('email_label'),
            //   // value2: userAnagrafe.email ?? '',
            // ),
          ],
          // Blocco Universitario
          if (index == 1) ...[
            ProfileDoubleInfoRow(
              label1: AppLocalizations.of(context).translate('username_label'),
              value1: authenticatedUser.user.userId ?? '',
              label2: AppLocalizations.of(context).translate('role_label'),
              value2: role == 'Studenti' ? role : userAnagrafe.ruolo,
            ),
            if (role == 'Studenti' && selectedCareer != null) ...[
              ProfileDoubleInfoRow(
                label1:
                    AppLocalizations.of(context).translate('student_id_label'),
                value1: selectedCareer['matricola'] ?? '',
                label2: AppLocalizations.of(context).translate('course_label'),
                value2: toCamelCase(selectedCareer['cdsDes']),
              ),
              ProfileDoubleInfoRow(
                label1:
                    AppLocalizations.of(context).translate('course_id_label'),
                value1: selectedCareer['cdsId'].toString(),
                label2: AppLocalizations.of(context)
                    .translate('university_email_label'),
                value2: userAnagrafe.emailAte,
              ),
              // ProfileDoubleInfoRow(
              //   label1: AppLocalizations.of(context)
              //       .translate('academic_year_label'),
              //   value1:
              //       selectedCareer['dettaglioTratto']['aaIscrId'].toString(),
              //   label2: AppLocalizations.of(context)
              //       .translate('university_email_label'),
              //   value2: userAnagrafe.emailAte,
              // ),
            ],
            if (role == 'Docenti') ...[
              ProfileDoubleInfoRow(
                label1:
                    AppLocalizations.of(context).translate('teacher_id_label'),
                value1: authenticatedUser.user.docenteId.toString(),
                label2: AppLocalizations.of(context).translate('sector_label'),
                value2: toCamelCase(userAnagrafe.settore.toString()),
              ),
              ProfileDoubleInfoRow(
                label1: AppLocalizations.of(context)
                    .translate('university_email_label'),
                value1: userAnagrafe.emailAte ?? '',
              ),
            ],
          ],
        ]
      ]),
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
