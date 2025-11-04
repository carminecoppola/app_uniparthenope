import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:appuniparthenope/widget/ServicesWidget/CalendarWidget/calendarCard.dart';
import 'package:appuniparthenope/widget/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../provider/auth_provider.dart';
import '../provider/bottomNavBar_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import '../utilityFunctions/studentUtilsFunction.dart';
import '../widget/HomeWidget/sectionTitle.dart';
import '../widget/ServicesWidget/AppointmentsWidget/homeAppointmentsWidget.dart';
import '../widget/HomeWidget/personalHomeWidget.dart';
import '../widget/HomeWidget/serviceUserGroup.dart';
import '../widget/bottomNavBar.dart';
import '../widget/bottomNavBarProf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setNavBarIndex();
  }

  void _setNavBarIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomNavBarProvider =
          Provider.of<BottomNavBarProvider>(context, listen: false);
      bottomNavBarProvider.updateIndex(1);
    });
  }

  Future<void> _loadData() async {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    if (authenticatedUser != null) {
      if (!mounted) return;

      if (authenticatedUser.user.grpDes == 'Studenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
        if (!mounted) return;
        await StudentUtils.allReservationStudent(
            context, authenticatedUser.user);
      } else if (authenticatedUser.user.grpDes == 'Docenti') {
        await StudentUtils.anagrafeUser(context, authenticatedUser.user);
      } else {
        if (!mounted) return;
        CustomAlertDialog(
          title: AppLocalizations.of(context).translate('error_anagrafic'),
          content:
              AppLocalizations.of(context).translate('error_loading_anagrafic'),
          buttonText: AppLocalizations.of(context).translate('close'),
          color: AppColors.errorColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final anagrafeUser = Provider.of<AuthProvider>(context).anagrafeUser;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;
    final selectedCareer =
        Provider.of<AuthProvider>(context, listen: false).selectedCareer;

    if (authenticatedUser == null) {
      return Scaffold(
        body: Container(
          color: Colors.white,
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            if (authenticatedUser.user.grpDes == 'Studenti') ...[
              PersonalCardUser(
                onTap: () async {
                  await StudentUtils.anagrafeUser(
                      context, authenticatedUser.user);
                  AuthUtilsFunction.userImg(context);
                  if (anagrafeUser != null) {
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  } else {
                    CustomLoadingIndicator(
                      text: AppLocalizations.of(context)
                          .translate('loading_personal_date'),
                      myColor: AppColors.primaryColor,
                    );
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel:
                    '${AppLocalizations.of(context).translate('studentid')}:',
                id: selectedCareer!['matricola'].toString(),
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('reservation')),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/reservationStudent');
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppLocalizations.of(context).translate('showall'),
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const HomeAppointmentsCard(),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('services')),
              ServiceGroupStudentCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ] else ...[
              PersonalCardUser(
                onTap: () async {
                  await StudentUtils.anagrafeUser(
                      context, authenticatedUser.user);
                  if (anagrafeUser != null) {
                    Navigator.pushReplacementNamed(context, '/profileStudent',
                        arguments: anagrafeUser);
                  } else {
                    CustomLoadingIndicator(
                        text: AppLocalizations.of(context)
                            .translate('loading_personal_date'),
                        myColor: AppColors.primaryColor);
                  }
                },
                firstName: authenticatedUser.user.firstName ?? '',
                lastName: authenticatedUser.user.lastName ?? '',
                identificativoLabel:
                    '${AppLocalizations.of(context).translate('profid')}:',
                id: authenticatedUser.user.docenteId != null
                    ? authenticatedUser.user.docenteId.toString()
                    : 'N/A',
                profileImage: profileImage,
              ),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('calendar')),
              const CalendarCard(),
              const SizedBox(height: 20),
              SectionTitle(
                  title: AppLocalizations.of(context).translate('services')),
              ServiceGroupProfCard(
                authenticatedUser: authenticatedUser,
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }
}
