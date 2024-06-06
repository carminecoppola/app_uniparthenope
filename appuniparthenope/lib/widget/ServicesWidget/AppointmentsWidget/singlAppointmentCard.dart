import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/ServicesWidget/AppointmentsWidget/detailsAppointmentsCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/studentService/reservation_data.dart';

class SingleAppointmentCard extends StatelessWidget {
  final IconData iconData;
  final ReservationInfo reservation;

  const SingleAppointmentCard({
    super.key,
    required this.iconData,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    String examTitle = reservation.nomeAppello?.split(' CFU')[0] ?? '';
    String teacherName =
        '${toCamelCase(reservation.nomePres ?? "")} ${toCamelCase(reservation.cognomePres ?? "")}';
    String date = reservation.dataEsa != null
        ? DateFormat('dd/MM/yy')
            .format(DateFormat('yyyy/MM/dd HH:mm').parse(reservation.dataEsa!))
        : 'Data non disponibile';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DetailsAppointmentCard(reservation: reservation),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryColor, width: 2),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: AppColors.primaryColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      examTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      teacherName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
