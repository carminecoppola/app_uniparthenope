import 'package:appuniparthenope/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contatti',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactCard(
                  'assets/icon/contact/fb.png',
                  'https://www.facebook.com/Parthenope/?locale=it_IT',
                ),
                const SizedBox(width: 10),
                _buildContactCard(
                  'assets/icon/contact/ig.png',
                  'https://www.instagram.com/uniparthenope/',
                ),
                const SizedBox(width: 10),
                _buildContactCard(
                  'assets/icon/contact/linkedin.png',
                  "https://www.linkedin.com/school/universit%C3%A0-degli-studi-di-napoli-'parthenope'/",
                ),
                const SizedBox(width: 10),
                _buildContactCard(
                  'assets/icon/contact/parthenopeUnita.png',
                  'https://www.uniparthenope.it/',
                ),
                const SizedBox(width: 10),
                _buildContactCard(
                  'assets/icon/contact/youtube.png',
                  'https://www.youtube.com/channel/UCNBZALzU97MuIKSMS_gnO6A',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  '+39 081 1234567',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.place,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  'Indirizzo: Via Università, 1, Napoli',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.maps_home_work_outlined,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  'Sede centrale: Via Amm. F. Acton, 38\n80133 Napoli, ITALY',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.fileInvoice,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  'P.IVA 01877320638 - C.F. 80018240632',
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(String assetPath, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
