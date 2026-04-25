import 'package:flutter/material.dart';
import 'package:appuniparthenope/widget/bottom_nav_bar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:provider/provider.dart';
import '../../provider/bottom_nav_bar_provider.dart';
import '../../widget/ServicesWidget/TaxWidget/student_fees_list.dart';

class FeesUniStudentPage extends StatefulWidget {
  const FeesUniStudentPage({super.key});

  @override
  State<FeesUniStudentPage> createState() => _FeesUniStudentState();
}

class _FeesUniStudentState extends State<FeesUniStudentPage>
    with SingleTickerProviderStateMixin {
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
    return const Scaffold(
      extendBody: true,
      appBar: NavbarComponent(),
      body: FeesStudent(),
      bottomNavigationBar: BottomNavBarComponent(),
    );
  }
}
