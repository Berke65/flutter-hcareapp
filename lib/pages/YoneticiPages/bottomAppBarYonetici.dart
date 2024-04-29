import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/SickPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';

BottomAppBar BottomAppBarYonetici(BuildContext context) {
  return BottomAppBar(
    color: Colors.white, // BottomAppBar'ın arka plan rengini beyaza ayarladık
    elevation: 1.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnaSayfaYonetici(),
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
                builder: (context) => const RandevuYonetici(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today),
              Text(
                'Randevu',
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
                builder: (context) => const YoneticiChat(),
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
                builder: (context) => ProfileScreen(),
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
