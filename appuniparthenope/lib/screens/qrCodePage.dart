import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widget/bottomNavBarProf.dart';
import '../widget/navbar.dart';
import '../widget/bottomNavBar.dart';
import '../widget/qrCode_widget.dart';
import '../provider/auth_provider.dart';
import '../utilityFunctions/authUtilsFunction.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class QRCodePage extends StatelessWidget {
  final String? profileImage;

  const QRCodePage({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;
    final user = authenticatedUser?.user;
    final trattiCarriera = user?.trattiCarriera.isNotEmpty == true
        ? user!.trattiCarriera[0]
        : null;
    final profileImage = Provider.of<AuthProvider>(context).profileImage;

    ImageProvider<Object>? profileImageProvider;

    if (profileImage != null && profileImage.isNotEmpty) {
      if (kIsWeb) {
        profileImageProvider = NetworkImage(profileImage);
      } else {
        profileImageProvider = FileImage(File(profileImage));
      }
    } else {
      profileImageProvider =
          const AssetImage('assets/user_profile_default.jpg');
    }

    return Scaffold(
      appBar: const NavbarComponent(),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            child: Card(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: AppColors.detailsColor,
                  width: 4,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              elevation: 20.0,
              shadowColor: Colors.grey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/textLogo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user?.grpDes == 'Docenti'
                              ? 'Faculty Card'
                              : 'Student Card',
                          style: const TextStyle(
                            fontSize: 25,
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Image(
                                      image: profileImageProvider!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: profileImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: AppColors.detailsColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${toCamelCase(user?.firstName ?? '')} ${toCamelCase(user?.lastName ?? '')}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.detailsColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Id: ',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: user?.grpDes == 'Docenti'
                                              ? user?.docenteId?.toString() ??
                                                  'N/A'
                                              : trattiCarriera?.matricola ??
                                                  'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.detailsColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Role: ',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: translateText(
                                                  user!.grpDes.toString()) ??
                                              'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.detailsColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  if (trattiCarriera != null)
                                    Text.rich(
                                      TextSpan(
                                        text: 'Cds: ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: toCamelCase(trattiCarriera
                                                .cdsDes
                                                .toString()),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.detailsColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 50),
                            const Center(
                              child: SizedBox(
                                width: 170,
                                height: 170,
                                child: QRCodeWidget(),
                              ),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              icon: const Icon(
                                Icons.refresh,
                                size: 40,
                                color: AppColors.detailsColor,
                              ),
                              onPressed: () {
                                // Aggiorna il QR Code
                                AuthUtilsFunction.qrCodeImg(context);
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Click per ingrandire',
                          style: TextStyle(color: AppColors.lightGray),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: authenticatedUser!.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }

  translateText(String role) {
    switch (role) {
      case 'Docenti':
        return 'Professor';
      case 'Studenti':
        return 'Student';
      default:
        return 'Unknown';
    }
  }
}
