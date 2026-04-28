import 'package:appuniparthenope/widget/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../provider/auth_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final qrCode = Provider.of<AuthProvider>(context).qrCode;
    final hasQrValue = qrCode != null && qrCode.isNotEmpty;
    final hasLocalQr = !kIsWeb && hasQrValue && File(qrCode).existsSync();

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: SizedBox(
              width: 300,
              height: 300,
              child: (kIsWeb && hasQrValue) || hasLocalQr
                  ? Image(
                      image: kIsWeb
                          ? NetworkImage(qrCode)
                          : FileImage(File(qrCode)) as ImageProvider,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CustomLoadingIndicator(
                        text: 'QR-Code non disponibile',
                        myColor: AppColors.detailsColor,
                      ),
                    )
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
        child: hasQrValue
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ((kIsWeb && hasQrValue) || hasLocalQr)
                    ? Image(
                        image: kIsWeb
                            ? NetworkImage(qrCode)
                            : FileImage(File(qrCode)) as ImageProvider,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            color: AppColors.detailsColor,
                            size: 56,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.detailsColor,
                          size: 56,
                        ),
                      ),
              )
            : const CircularProgressIndicator(
                color: AppColors.detailsColor,
                strokeWidth: 3,
              ),
      ),
    );
  }
}
