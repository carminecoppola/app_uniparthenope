import 'package:appuniparthenope/provider/bottomNavBar_provider.dart';
import 'package:appuniparthenope/widget/bottomNavBar.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);

    //Chiamata al metodo getUserDetails nel auth_controller,
    //che mi deve stampare i dati presi dall'API.

    return Scaffold(
        appBar: const NavbarComponent(),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informazioni personali',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Nome: John Doe',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Matricola: 123456',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Corso di Laurea: Ingegneria Informatica',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Contatti',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Email: john.doe@example.com',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                'Telefono: +1234567890',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarComponent());
  }
}
