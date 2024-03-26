import 'package:flutter/material.dart';
import 'package:hcareapp/pages/NursePages/NursePageHome.dart';
import 'package:hcareapp/pages/NursePages/NurseChat.dart';
import 'package:hcareapp/pages/NursePages/NurseMedicine.dart';
import 'package:hcareapp/pages/NursePages/Profile.dart';

BottomAppBar BottomAppbarNurse(BuildContext context) {
  return BottomAppBar(
    color: Colors.white, // BottomAppBar'ın arka plan rengini beyaza ayarladık
    elevation: .0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NursePageHome(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home_outlined),
              Text(
                'Anasayfa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NurseMedicine(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_pharmacy),
              Text(
                'İlaç Kontrolü',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UsersChat(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat),
              Text(
                'Sohbet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_circle_outlined),
              Text(
                'Profil',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
