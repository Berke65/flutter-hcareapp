import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/Profile.dart';
import 'package:hcareapp/pages/SickPages/SickChat.dart';
import 'package:hcareapp/pages/SickPages/SickInformation.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';
import 'package:hcareapp/pages/SickPages/MedicineControl.dart';

BottomAppBar BottomAppBarSick(BuildContext context) {
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
                builder: (context) => const SickAnasayfa(),
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
                builder: (context) => MedicineControl(),
              ),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.medical_information_outlined),
              Text(
                'İlaç Kontrol',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => SickInformation(),
        //       ),
        //     );
        //   },
        //   child: const Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.info_outline),
        //       Text(
        //         'Sağlık Bilgileri',
        //         style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SickChat(),
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
      ],
    ),
  );
}
