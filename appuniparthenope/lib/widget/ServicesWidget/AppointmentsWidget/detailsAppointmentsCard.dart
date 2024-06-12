import 'package:appuniparthenope/model/studentService/reservation_data.dart';
import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';
import 'package:intl/intl.dart';

class DetailsAppointmentCard extends StatelessWidget {
  final ReservationInfo reservation;

  const DetailsAppointmentCard({
    super.key,
    required this.reservation,
  });

  // Funzione per selezionare l'asset in base al valore di courseInfo
  String getAssetForCourseInfo(String courseInfo) {
    if (courseInfo.toLowerCase().contains('pratica') ||
        courseInfo.toLowerCase().contains('pratico') ||
        courseInfo.toLowerCase().contains('intercorso') ||
        courseInfo.toLowerCase().contains('scritta') ||
        courseInfo.toLowerCase().contains('scritto')) {
      return 'assets/icon/practicalTest.png';
    } else if (courseInfo.toLowerCase().contains('orale')) {
      return 'assets/icon/discussionIcon.png';
    } else {
      return 'assets/icon/appointmentIcon.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    String examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    String teacherName =
        '${toCamelCase(reservation.nomePres ?? "")} ${toCamelCase(reservation.cognomePres ?? "")}';
    String date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : 'Data non disponibile';
    String formattedTime = reservation.dataEsa != null
        ? DateFormat('HH:mm')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : 'Orario non disponibile';
    String courseInfo = reservation.desApp ?? '';
    String room = reservation.aulaDes ?? '';

    return IntrinsicHeight(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryColor, width: 3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sezione superiore
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Data Prenotazione',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        toCamelCase(date),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primaryColor,
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Linea grigia sottile
            const Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ),
            // Sezione inferiore
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                examTitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Parte sinistra con asset
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(getAssetForCourseInfo(courseInfo)),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Parte centrale con info esame
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            teacherName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.lightGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            courseInfo,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.lightGray,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Aula: $room',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.lightGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Prenotati: ${reservation.numIscritti}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
