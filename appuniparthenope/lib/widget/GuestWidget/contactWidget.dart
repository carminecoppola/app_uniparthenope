import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contatti',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.facebook,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
                SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.instagram,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
                SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.envelope,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
                SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.linkedin,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
                SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.youtube,
                  color: AppColors.primaryColor,
                  size: 50,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  '+39 081 1234567',
                  style: TextStyle(fontSize: 10, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.place,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  'Indirizzo: Via Università, 1, Napoli',
                  style: TextStyle(fontSize: 10, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.maps_home_work_outlined,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  'Sede centrale: Via Amm. F. Acton, 38 - 80133 Napoli, ITALY',
                  style: TextStyle(fontSize: 10, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.fileInvoice,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  'P.IVA 01877320638 - C.F. 80018240632',
                  style: TextStyle(fontSize: 10, color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
