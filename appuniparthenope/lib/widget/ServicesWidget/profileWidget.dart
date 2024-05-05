import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/user_data_anagrafic.dart';
import 'package:appuniparthenope/widget/ServicesWidget/infoStudentTemplate.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Student Card',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.detailsColor,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: profileImage != null
              ? FileImage(profileImage)
                  as ImageProvider<Object>? // Cast esplicito del tipo
              : const AssetImage('assets/user_profile.jpg'),
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final UserAnagrafe userAnagrafe;

  const UserInfoWidget(this.userAnagrafe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            '${userAnagrafe.nome.toUpperCase()} ${userAnagrafe.cognome.toUpperCase()}',
            style: const TextStyle(
              fontSize: 16.0,
              color: AppColors.detailsColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Center(
          child: Text(
            ' ${userAnagrafe.codFis}',
            style: const TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}

class InfoGridView extends StatelessWidget {
  final String? matricola;
  final UserAnagrafe userAnagrafe;

  const InfoGridView(this.userAnagrafe, {super.key, this.matricola});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1.8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Id',
              contentText: '\t\t\t $matricola',
            ),
          ),
          const GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Ruolo',
              contentText: '\t\t\t\tSTUDENT',
            ),
          ),
          GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Data Nascita',
              contentText: '\t\t\t\t${userAnagrafe.dataNascita.split(" ")[0]}',
            ),
          ),
          GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Cellulare',
              contentText: '\t\t\t\t${userAnagrafe.telRes}',
            ),
          ),
          GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Username',
              contentText: '\t\t\t\t${userAnagrafe.nome}',
            ),
          ),
          GridTile(
            child: InfoStudentTemplate(
              idText: '\u2022 Sesso',
              contentText: '\t\t\t\t${userAnagrafe.sesso}',
            ),
          ),
        ],
      ),
    );
  }
}

class EmailWidget extends StatelessWidget {
  final UserAnagrafe userAnagrafe;

  const EmailWidget(this.userAnagrafe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InfoStudentTemplate(
        idText: '\u2022 E-mail Universitaria',
        contentText: userAnagrafe.emailAte,
      ),
    );
  }
}
