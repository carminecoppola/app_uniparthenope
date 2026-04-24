import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';
import '../main.dart';
import '../provider/auth_provider.dart';
import '../provider/bottomNavBar_provider.dart';
import '../widget/bottomNavBar.dart';
import '../widget/navbar.dart';

class InfoAppPage extends StatefulWidget {
  const InfoAppPage({super.key});

  @override
  State<InfoAppPage> createState() => _InfoAppPageState();
}

class _InfoAppPageState extends State<InfoAppPage> {
  static const String _supportEmail = 'developer@uniparthenope.it';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nessun selettore attivo - pagina esterna alle 3 principali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<BottomNavBarProvider>(context, listen: false)
            .updateIndex(3); // Indice 3 = nessun selettore
      }
    });
  }

  Future<String> _getAppVersion() async {
    try {
      final yamlString = await rootBundle.loadString('pubspec.yaml');
      final yaml = loadYaml(yamlString);
      final version = yaml['version']?.toString() ?? 'Unknown version';
      // Troncamento del build number
      final versionWithoutBuildNumber = version.split('+')[0];
      return versionWithoutBuildNumber;
    } catch (e) {
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
                            _openIssueReportSheet(
                              authenticatedUser,
                              versionApp,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context).translate('contact'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
        'name': 'Raffaele Montella',
        'asset': 'assets/team/team_leader.jpg',
        'role': 'Team leader'
      },
      {
        'name': 'Carmine Coppola',
        'asset': 'assets/team/cc.jpeg',
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

  Future<void> _openIssueReportSheet(
      dynamic authenticatedUser, String versioneApp) async {
    final localizations = AppLocalizations.of(context);
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final expectedBehaviorController = TextEditingController();
    final actualBehaviorController = TextEditingController();
    String severity = 'medium';
    bool includeTechnicalDetails = true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 640),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('report_problem_title'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.translate('report_problem_subtitle'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildReportField(
                        controller: titleController,
                        label: localizations.translate('problem_title_label'),
                        minLines: 1,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      _buildReportField(
                        controller: descriptionController,
                        label: localizations
                            .translate('problem_description_label'),
                        minLines: 4,
                        maxLines: 6,
                      ),
                      const SizedBox(height: 14),
                      _buildReportField(
                        controller: expectedBehaviorController,
                        label:
                            localizations.translate('expected_behavior_label'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      _buildReportField(
                        controller: actualBehaviorController,
                        label: localizations.translate('actual_behavior_label'),
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: severity,
                        decoration: _reportDecoration(
                          context,
                          localizations.translate('severity_label'),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        items: [
                          DropdownMenuItem(
                            value: 'low',
                            child: Text(
                              localizations.translate('severity_low'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'medium',
                            child: Text(
                              localizations.translate('severity_medium'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'high',
                            child: Text(
                              localizations.translate('severity_high'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'blocking',
                            child: Text(
                              localizations.translate('severity_blocking'),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() => severity = value);
                          }
                        },
                      ),
                      const SizedBox(height: 6),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: AppColors.primaryColor,
                        title: Text(
                          localizations.translate('include_technical_details'),
                        ),
                        value: includeTechnicalDetails,
                        onChanged: (value) {
                          setModalState(
                            () => includeTechnicalDetails = value,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            child: Text(
                              localizations.translate('cancel'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () async {
                              if (titleController.text.trim().isEmpty ||
                                  descriptionController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localizations.translate(
                                        'fill_required_fields',
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }

                              await _sendIssueEmail(
                                authenticatedUser: authenticatedUser,
                                versioneApp: versioneApp,
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                expectedBehavior:
                                    expectedBehaviorController.text.trim(),
                                actualBehavior:
                                    actualBehaviorController.text.trim(),
                                severity: severity,
                                includeTechnicalDetails:
                                    includeTechnicalDetails,
                              );

                              if (mounted && sheetContext.mounted) {
                                Navigator.of(sheetContext).pop();
                              }
                            },
                            child: Text(
                              localizations.translate('send_report'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
    expectedBehaviorController.dispose();
    actualBehaviorController.dispose();
  }

  InputDecoration _reportDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primaryColor),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.4),
      ),
    );
  }

  Widget _buildReportField({
    required TextEditingController controller,
    required String label,
    required int minLines,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: _reportDecoration(context, label),
    );
  }

  Future<Map<String, String>> _getTechnicalDetails(
      dynamic authenticatedUser, String versioneApp) async {
    final locale = Localizations.localeOf(context);
    final routeName = ModalRoute.of(context)?.settings.name;
    final deviceInfo = DeviceInfoPlugin();

    String platformName = Platform.operatingSystem;
    String deviceName = 'Unknown';
    String osVersion = Platform.operatingSystemVersion;

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      platformName = 'iOS';
      deviceName = iosInfo.name;
      osVersion = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      platformName = 'Android';
      deviceName = androidInfo.model;
      osVersion = androidInfo.version.release;
    }

    final firstName = authenticatedUser.firstName?.toString() ?? '';
    final lastName = authenticatedUser.lastName?.toString() ?? '';
    final userName = authenticatedUser.user?.toString() ?? '';

    return {
      'appVersion': versioneApp,
      'platform': platformName,
      'osVersion': osVersion,
      'device': deviceName,
      'locale': locale.languageCode,
      'screen': routeName?.isNotEmpty == true
          ? routeName!
          : widget.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'role': authenticatedUser.grpDes?.toString() ?? '',
      'userName': userName,
      'fullName': '$firstName $lastName'.trim(),
    };
  }

  Future<void> _sendIssueEmail({
    required dynamic authenticatedUser,
    required String versioneApp,
    required String title,
    required String description,
    required String expectedBehavior,
    required String actualBehavior,
    required String severity,
    required bool includeTechnicalDetails,
  }) async {
    final localizations = AppLocalizations.of(context);
    final technicalDetails =
        await _getTechnicalDetails(authenticatedUser, versioneApp);

    final buffer = StringBuffer()
      ..writeln(
        '${localizations.translate('problem_title_label')}: $title',
      )
      ..writeln()
      ..writeln(
        '${localizations.translate('severity_label')}: ${_localizedSeverity(severity)}',
      )
      ..writeln()
      ..writeln(
        '${localizations.translate('problem_description_label')}:',
      )
      ..writeln(description);

    if (expectedBehavior.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('${localizations.translate('expected_behavior_label')}:')
        ..writeln(expectedBehavior);
    }

    if (actualBehavior.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('${localizations.translate('actual_behavior_label')}:')
        ..writeln(actualBehavior);
    }

    if (includeTechnicalDetails) {
      buffer
        ..writeln()
        ..writeln(localizations.translate('technical_details'))
        ..writeln(
          '${localizations.translate('app_version_label')}: ${technicalDetails['appVersion']}',
        )
        ..writeln(
          '${localizations.translate('platform_label')}: ${technicalDetails['platform']}',
        )
        ..writeln(
          '${localizations.translate('os_version_label')}: ${technicalDetails['osVersion']}',
        )
        ..writeln(
          '${localizations.translate('device_label')}: ${technicalDetails['device']}',
        )
        ..writeln(
          '${localizations.translate('language_label')}: ${technicalDetails['locale']}',
        )
        ..writeln(
          '${localizations.translate('current_screen_label')}: ${technicalDetails['screen']}',
        )
        ..writeln(
          '${localizations.translate('user_label')}: ${technicalDetails['fullName']}',
        )
        ..writeln(
          '${localizations.translate('username_label')}: ${technicalDetails['userName']}',
        )
        ..writeln(
          '${localizations.translate('role_label')}: ${technicalDetails['role']}',
        )
        ..writeln(
          '${localizations.translate('report_date_label')}: ${technicalDetails['timestamp']}',
        );
    }

    final subject =
        '${localizations.translate('report_subject_prefix')}: $title';

    final emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(buffer.toString())}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.translate('unable_to_open_email_client'),
        ),
      ),
    );
  }

  String _localizedSeverity(String value) {
    final localizations = AppLocalizations.of(context);
    switch (value) {
      case 'low':
        return localizations.translate('severity_low');
      case 'high':
        return localizations.translate('severity_high');
      case 'blocking':
        return localizations.translate('severity_blocking');
      case 'medium':
      default:
        return localizations.translate('severity_medium');
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
