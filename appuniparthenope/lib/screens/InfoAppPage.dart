import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import '../main.dart';
import '../provider/auth_provider.dart';
import '../widget/bottomNavBar.dart';
import '../widget/navbar.dart';

class InfoAppPage extends StatelessWidget {
  const InfoAppPage({super.key});

  Future<String> _getAppVersion() async {
    try {
      final yamlString = await rootBundle.loadString('pubspec.yaml');
      final yaml = loadYaml(yamlString);
      final version = yaml['version']?.toString() ?? 'Unknown version';
      // Troncamento del build number
      final versionWithoutBuildNumber = version.split('+')[0];
      return versionWithoutBuildNumber;
    } catch (e) {
      print('Error loading app version: $e');
      return 'Unknown version';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = Provider.of<AuthProvider>(context, listen: false)
        .authenticatedUser!
        .user;

    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final versionApp = snapshot.data ?? 'Unknown version';

          return Scaffold(
            appBar: const NavbarComponent(),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo dell'università
                      Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'app@Uniparthenope',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Version: $versionApp',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 190,
                    height: 2,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 360,
                      height: 300,
                      child: Card(
                        color: AppColors.primaryColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: _buildDeveloperInfoList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.email,
                              color: AppColors.primaryColor, size: 30),
                          onPressed: () {
                            if (authenticatedUser != null) {
                              _sendEmail(
                                authenticatedUser.firstName,
                                authenticatedUser.lastName,
                                versionApp,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Contatta gli sviluppatori se hai notato\nun problema nell\'applicazione',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavBarComponent(),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error loading app version')),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<Widget> _buildDeveloperInfoList() {
    final developers = [
      {
        'name': 'Raffaele Montela',
        'asset': 'assets/team/team_leader.jpg',
        'role': 'Team leader'
      },
      {
        'name': 'Carmine Coppola',
        'asset': 'assets/team/cc.png',
        'role': 'Developer'
      },
      {
        'name': 'Ciro Giuseppe De Vita',
        'asset': 'assets/team/cgdv.png',
        'role': 'Developer'
      },
      {
        'name': 'Gennaro Mellone',
        'asset': 'assets/team/gm.jpg',
        'role': 'Developer'
      },
    ];

    List<Widget> developerInfoList = [];
    for (var i = 0; i < developers.length; i++) {
      developerInfoList.add(DeveloperInfo(
        name: developers[i]['name']!,
        asset: developers[i]['asset']!,
        role: developers[i]['role']!,
      ));
      if (i < developers.length - 1) {
        developerInfoList.add(const SizedBox(height: 5));
        developerInfoList.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 26.0),
            child: const Divider(
              color: Colors.white,
              thickness: 0.5,
            ),
          ),
        );
        developerInfoList.add(const SizedBox(height: 5));
      }
    }
    return developerInfoList;
  }

  void _sendEmail(String? nome, String? cognome, String versioneApp) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String dispositivo = '';
    String versioneOS = '';

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      dispositivo = iosInfo.name ?? 'Dispositivo iOS';
      versioneOS = iosInfo.systemVersion ?? 'Versione iOS sconosciuta';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      dispositivo = androidInfo.model ?? 'Dispositivo Android';
      versioneOS =
          androidInfo.version.release ?? 'Versione Android sconosciuta';
    }

    final String body = '''
Descrizione Problema: ...

Dispositivo Utilizzato: $dispositivo (Versione OS: $versioneOS)

Utente: $nome $cognome

Versione App: $versioneApp
  ''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'developer@uniparthenope.it',
      query:
          'subject=${Uri.encodeComponent('Errore: ...')}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String role;
  final String asset;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.asset,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.detailsColor,
          child: CircleAvatar(
            radius: 38,
            backgroundImage: AssetImage(asset),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.detailsColor,
              ),
            ),
            Text(
              '\t\t\t$role',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
