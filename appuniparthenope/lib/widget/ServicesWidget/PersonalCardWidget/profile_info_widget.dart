import 'package:flutter/material.dart';
import 'package:appuniparthenope/main.dart';

class ProfileDoubleInfoRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String? label2;
  final String? value2;

  const ProfileDoubleInfoRow({
    super.key,
    required this.label1,
    required this.value1,
    this.label2,
    this.value2,
  });

  @override
  Widget build(BuildContext context) {
    // Cambia il CrossAxisAlignment a center su Row e Column!
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Prima colonna
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 4),
                Text(
                  value1,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.detailsColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Seconda colonna
          Expanded(
            child: (label2 != null && label2!.isNotEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        label2!,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.lightGray,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        value2 ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.detailsColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
