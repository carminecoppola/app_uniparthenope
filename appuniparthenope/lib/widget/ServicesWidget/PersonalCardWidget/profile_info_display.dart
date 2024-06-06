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
    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;
    final role = authenticatedUser?.user.grpDes;
    final trattiCarriera = authenticatedUser?.user.trattiCarriera;
    final carriera = trattiCarriera != null && trattiCarriera.isNotEmpty
        ? trattiCarriera[0]
        : null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
              index == 0 ? 'Personali' : 'Accademiche',
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
          if (index == 0) ...[
            ProfileInfoWidget(
              label: 'Nome:',
              value: toCamelCase(userAnagrafe.nome),
            ),
            ProfileInfoWidget(
              label: 'Cognome:',
              value: toCamelCase(userAnagrafe.cognome),
            ),
            ProfileInfoWidget(
              label: 'CF:',
              value: userAnagrafe.codFis,
            ),
            ProfileInfoWidget(
              label: 'Nazionalità:',
              value: toCamelCase(userAnagrafe.desCittadinanza ?? ''),
            ),
            ProfileInfoWidget(
              label: 'Data di Nascita:',
              value: userAnagrafe.dataNascita!.split(" ")[0],
            ),
            ProfileInfoWidget(
              label: 'Sesso:',
              value: getGenderDescription(userAnagrafe.sesso),
            ),
            ProfileInfoWidget(
              label: 'Cellulare:',
              value: userAnagrafe.telRes,
            ),
            ProfileInfoWidget(
              label: 'E-mail:',
              value: userAnagrafe.email ?? '',
            ),
          ],
          // Blocco Universitario
          if (index == 1) ...[
            ProfileInfoWidget(
              label: 'Username:',
              value: authenticatedUser.user.userId,
            ),
            ProfileInfoWidget(
              label: 'Ruolo:',
              value: role == 'Studenti' ? role : userAnagrafe.ruolo,
            ),
            if (role == 'Studenti' && carriera != null) ...[
              ProfileInfoWidget(
                label: 'Matricola:',
                value: carriera.matricola,
              ),
              ProfileInfoWidget(
                label: 'Corso di studi:',
                value: toCamelCase(carriera.cdsDes),
              ),
              ProfileInfoWidget(
                label: 'Id Corso:',
                value: carriera.cdsId.toString(),
              ),
              ProfileInfoWidget(
                label: 'Immatricolazione:',
                value: carriera.dettaglioTratto.aaRegId.toString(),
              ),
              ProfileInfoWidget(
                label: 'Anno Accademico:',
                value: carriera.dettaglioTratto.aaIscrId.toString(),
              ),
            ],
            if (role == 'Docenti') ...[
              ProfileInfoWidget(
                label: 'Id Docente:',
                value: authenticatedUser.user.docenteId.toString(),
              ),
              ProfileInfoWidget(
                label: 'Settore:',
                value: toCamelCase(userAnagrafe.settore.toString()),
              ),
            ],
            ProfileInfoWidget(
              label: 'E-mail Ateneo:',
              value: userAnagrafe.emailAte,
            ),
          ],
        ],
      ]),
    );
  }

  String getGenderDescription(String? gender) {
    if (gender == 'M') {
      return 'Maschile';
    } else if (gender == 'F') {
      return 'Femminile';
    } else {
      return 'Non definito';
    }
  }
}
