import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/bottom_nav_bar_provider.dart';
import '../widget/ServicesWidget/WeatherWidget/carousel_card.dart';
import '../widget/ServicesWidget/WeatherWidget/download_card.dart';
import '../widget/bottom_nav_bar_prof.dart';
import '../widget/navbar.dart';
import '../widget/bottom_nav_bar.dart';
import 'package:appuniparthenope/main.dart';

class WeatherUniPage extends StatefulWidget {
  const WeatherUniPage({super.key});

  @override
  State<WeatherUniPage> createState() => _WeatherUniPageState();
}

class _WeatherUniPageState extends State<WeatherUniPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nessun selettore attivo - pagina esterna alle 3 principali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<BottomNavBarProvider>(context, listen: false)
            .updateIndex(3); // Indice 3 = nessun selettore
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser =
        Provider.of<AuthProvider>(context).authenticatedUser;

    return Scaffold(
      appBar: const NavbarComponent(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              AppLocalizations.of(context).translate('weather'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              '@Uniparthenope',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Container(
              width: 150,
              height: 2,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 20),
            const CarouselCard(),
            const SizedBox(height: 50),
            const DownloadCard(),
          ],
        ),
      ),
      bottomNavigationBar: authenticatedUser!.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }
}
