import 'package:appuniparthenope/widget/ServicesWidget/PersonalCardWidget/profile_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';

class ProfileInfoDisplay extends StatelessWidget {
  final int index;

  const ProfileInfoDisplay({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final userAnagrafe = Provider.of<AuthProvider>(context).anagrafeUser;
    final role = authenticatedUser?.user.grpDes;
    final carriera = authenticatedUser?.user.trattiCarriera[0];
    final identificativoLabel = role == 'Docenti' ? 'ID Docente' : 'Matricola';
    final identificativo = carriera!.matricola;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Permette lo scorrimento in verticale
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
          //Blocco Personale
          if (index == 0) ...[
            ProfileInfoWidget(
              label: 'Nome:',
              value: toCamelCase(userAnagrafe!.nome),
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
              value: toCamelCase(userAnagrafe.desCittadinanza),
            ),
            ProfileInfoWidget(
              label: 'Data di Nascita:',
              value: userAnagrafe.dataNascita.split(" ")[0],
            ),
            ProfileInfoWidget(
              label: 'Sesso:',
              value: userAnagrafe.sesso,
            ),
            ProfileInfoWidget(
              label: 'Cellulare',
              value: userAnagrafe.telRes,
            ),
            ProfileInfoWidget(
              label: 'E-mail:',
              value: userAnagrafe.email,
            ),
          ],
          if (index == 1) ...[
            //Blocco Universitario
            ProfileInfoWidget(
              label: 'Username:',
              value: authenticatedUser!.user.userId,
            ),
            ProfileInfoWidget(
              label: 'Ruolo:',
              value: toCamelCase(role!),
            ),
            ProfileInfoWidget(
              label: '$identificativoLabel:',
              value: identificativo,
            ),
            if (role == 'Studenti') ...[
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
            ProfileInfoWidget(
              label: 'E-mail Ateneo:',
              value: userAnagrafe!.emailAte,
            ),
          ]
        ],
      ),
    );
  }
}
