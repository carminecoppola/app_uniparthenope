import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String surname;
  final String id;
  final String userImage;

  const UserInfoCard({
    required this.name,
    required this.surname,
    required this.id,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviga a '/profile' quando la card viene cliccata
        Navigator.pushNamed(context, '/profile');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage(userImage),
            ),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name $surname',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: $id',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
