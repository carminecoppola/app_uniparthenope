import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appuniparthenope/main.dart';

class SingleExamCard extends StatelessWidget {
  final int index;
  final String cfuExam;
  final String titleExam;
  final String voteExam;
  final String dateExam;
  final Color colorCard;
  final bool withHonors; // Flag per indicare se è presente la lode

  const SingleExamCard({
    super.key,
    required this.index,
    required this.cfuExam,
    required this.titleExam,
    required this.voteExam,
    required this.dateExam,
    required this.colorCard,
    required this.withHonors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: colorCard,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Cerchio per il voto e la coccarda
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Visualizza l'icona della coccarda solo se withHonors è true
                      if (withHonors)
                        Positioned(
                          child: SvgPicture.asset(
                            'assets/icon/coccarda.svg', // Percorso dell'icona SVG
                            width: 50, // Larghezza dell'icona
                            height: 50, // Altezza dell'icona
                            color: AppColors.successColor,
                          ),
                        ),
                      // Visualizza il voto solo se withHonors è false
                      if (!withHonors)
                        Positioned(
                          child: Text(
                            voteExam,
                            style: TextStyle(
                              color: voteExam == "??"
                                  ? Colors.white
                                  : AppColors.detailsColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleExam.split(' CFU')[0],
                      style: const TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dateExam,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Riquadro CFU
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.backgroundColor,
                  border: Border.all(
                    color: AppColors.backgroundColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textColor.withOpacity(0.3),
                      spreadRadius: -3,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$cfuExam\nCFU',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      color: AppColors.lightGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
