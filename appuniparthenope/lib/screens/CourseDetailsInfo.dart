import 'package:appuniparthenope/model/teacherService/course_professor_data.dart';
import 'package:appuniparthenope/provider/professor_provider.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widget/alertDialog.dart';

class CourseDetailsPage extends StatefulWidget {
  final String adDes;
  final String cdsDes;
  final String inizio;
  final String fine;
  final String sede;
  final int adLogId;

  const CourseDetailsPage({
    super.key,
    required this.adDes,
    required this.cdsDes,
    required this.inizio,
    required this.fine,
    required this.sede,
    required this.adLogId,
  });

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  String? selectedTab = '...seleziona...';

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    final detailsCourse =
        Provider.of<ProfessorDataProvider>(context, listen: false)
            .detailsCourse;

    Widget bodyContent;

    if (detailsCourse != null) {
      bodyContent = _buildTabContent(selectedTab ?? "Contenuti", detailsCourse);
    } else {
      bodyContent = const CustomAlertDialog(
        title: 'Errore caricamento info del corso',
        content:
            'Si è verificato un errore durante il caricamento dei dettagli del corso, ci scusiamo. ',
        buttonText: 'Chiudi',
        color: AppColors.errorColor,
      );
    }

    return Scaffold(
      appBar: NavbarComponent(
        role: authenticatedUser!.user.grpDes.toString(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.asset(
            'assets/logo.png',
            width: 100,
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              toCamelCase(widget.adDes.split('CFU')[0]),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: AppColors.primaryColor,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.all(10),
              child: customDropdownButton(
                value: selectedTab,
                items: const [
                  DropdownMenuItem<String>(
                    value: "...seleziona...",
                    child: Center(child: Text("...seleziona...")),
                  ),
                  DropdownMenuItem<String>(
                    value: "Contenuti",
                    child: Center(child: Text("Contenuti")),
                  ),
                  DropdownMenuItem<String>(
                    value: "Metodi",
                    child: Center(child: Text("Metodi")),
                  ),
                  DropdownMenuItem<String>(
                    value: "Verifica",
                    child: Center(child: Text("Verifica")),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedTab = value;
                  });
                },
              )),
          if (selectedTab == "...seleziona...") ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Seleziona un\'opzione per visualizzare i dettagli del corso',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.detailsColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ] else
            const SizedBox(height: 20),
          Expanded(child: bodyContent),
        ],
      ),
    );
  }

  Widget _buildTabContent(String label, DetailsCourseInfo details) {
    String content = '';

    switch (label) {
      case "Contenuti":
        content = details.contenuti.toString();
        break;
      case "Metodi":
        content = details.metodi.toString();
        break;
      case "Verifica":
        content = details.verifica.toString();
        break;
    }

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != '...seleziona...')
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DropdownButtonHideUnderline customDropdownButton({
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonHideUnderline(
    child: Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButton<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    ),
  );
}
