import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../main.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../widget/ServicesWidget/PersonalCardWidget/avatar_widget.dart';
import '../widget/qrCode_widget.dart';
import '../widget/waveWidget.dart';

class PersonalCardPage extends StatelessWidget {
  const PersonalCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final authenticatedUser = authProvider.authenticatedUser;
    final user = authenticatedUser?.user;
    final trattiCarriera = user?.trattiCarriera.isNotEmpty == true
        ? user!.trattiCarriera[0]
        : null;
    final userAnagrafe = authProvider.anagrafeUser;
    final profileImage = authProvider.profileImage;

    // Controllo generale per dati null
    if (authenticatedUser == null ||
        user == null ||
        trattiCarriera == null ||
        userAnagrafe == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(), // Caricamento
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).translate('loading_personal_card'),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.detailsColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Gestione immagine profilo
    ImageProvider<Object>? profileImageProvider;

    if (profileImage != null && profileImage.isNotEmpty) {
      if (kIsWeb) {
        profileImageProvider = NetworkImage(profileImage);
      } else {
        profileImageProvider = FileImage(File(profileImage));
      }
    } else {
      profileImageProvider =
          const AssetImage('assets/user_profile_default.jpg');
    }

    return Scaffold(
      body: Stack(
        children: [
          // Sfondo con le onde
          Positioned.fill(
            child: CustomPaint(
              painter: WavePainter(),
            ),
          ),
          Positioned(
            top: 70, // Posizione verticale
            left: 130, // Posizione orizzontale
            child: Image.asset('assets/textLogo.png', width: 160, height: 50),
          ),
          // Freccia per tornare alla home
          Positioned(
            top: 60, // Posizione verticale
            left: 15, // Posizione orizzontale
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/homePage', (route) => false);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                const AvatarWidget(
                  size: 70.0,
                ),
                const SizedBox(height: 20),
                // Nome e cognome con sfumatura
                AppColors().gradientText(
                    '${userAnagrafe.nome} ${userAnagrafe.cognome}',
                    const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    false),
                const SizedBox(height: 10),
                // Ruolo con sfumatura
                AppColors().gradientText(
                    getRole(user.grpDes, context),
                    const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    true),
                const SizedBox(height: 20),
                // Campi anagrafici
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField(
                          "\u2022 University ID",
                          authenticatedUser.user.trattiCarriera[0].matricola
                              .toString()),
                      _buildField("\u2022 CF", userAnagrafe.codFis),
                      _buildField("\u2022 DoB",
                          userAnagrafe.dataNascita!.split(" ")[0]),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50),
                          const Center(
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: QRCodeWidget(),
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              size: 40,
                              color: AppColors.detailsColor,
                            ),
                            onPressed: () {
                              // Aggiorna il QR Code
                              AuthUtilsFunction.qrCodeImg(context);
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                          child: Text(
                        AppLocalizations.of(context)
                            .translate('click_to_big_image'),
                        style: const TextStyle(color: AppColors.lightGray),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getRole(String? grpDes, BuildContext context) {
    if (grpDes == 'Studenti') {
      return AppLocalizations.of(context).translate('student_role');
    } else if (grpDes == 'Docenti') {
      return AppLocalizations.of(context).translate('teacher_role');
    } else if (grpDes == 'PTA') {
      return AppLocalizations.of(context).translate('pta');
    } else {
      return 'N/A';
    }
  }

  // Widget per costruire i campi anagrafici
  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AppColors().gradientText(
              '$label: ',
              const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              false),
          Flexible(
            child: AppColors().gradientText(
              value ?? "-",
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              true,
            ),
          ),
        ],
      ),
    );
  }
}
