import 'package:appuniparthenope/widget/CustomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../provider/auth_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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

    ImageProvider<Object>? qrCodeImage;

    if (kIsWeb && qrCode != null) {
      qrCodeImage = NetworkImage(qrCode);
    } else if (qrCode != null) {
      qrCodeImage = FileImage(File(qrCode));
    } else {
      qrCodeImage = const AssetImage('assets/user_profile_default.jpg');
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: SizedBox(
              width: 300,
              height: 300,
              child: qrCode != null
                  ? Image(image: qrCodeImage!, fit: BoxFit.cover)
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
        width: _isExpanded ? 280 : 170,
        height: _isExpanded ? 280 : 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.detailsColor,
            width: 5,
          ),
        ),
        child: qrCode != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: qrCodeImage!, fit: BoxFit.cover),
              )
            : const CircularProgressIndicator(
                color: AppColors.detailsColor,
                strokeWidth: 3,
              ),
      ),
    );
  }
}
