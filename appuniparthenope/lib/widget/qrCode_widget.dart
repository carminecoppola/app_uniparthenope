import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/auth_provider.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  _QRCodeWidgetState createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final qrCode = Provider.of<AuthProvider>(context).qrCode;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: SizedBox(
              width: 300,
              height: 300,
              child: qrCode != null
                  ? Image.asset(qrCode, fit: BoxFit.cover)
                  : const CustomLoadingIndicator(
                      text: 'Caricamento QR-Code',
                      myColor: AppColors.detailsColor,
                    ),
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isExpanded ? 280 : 140,
        height: _isExpanded ? 280 : 140,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: AppColors.detailsColor,
            width: 5,
          ),
        ),
        child: qrCode != null
            ? Image.asset(qrCode, fit: BoxFit.cover)
            : const CircularProgressIndicator(
                color: AppColors.detailsColor,
                strokeWidth: 3,
              ),
      ),
    );
  }
}
