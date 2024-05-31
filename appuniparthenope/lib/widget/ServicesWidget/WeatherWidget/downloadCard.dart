import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class DownloadCard extends StatelessWidget {
  const DownloadCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Link download
      },
      child: SizedBox(
        width: 350,
        height: 100,
        child: Card(
          color: AppColors.primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/meteoUniLogo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Text(
                    "Scarica la nostra app",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
