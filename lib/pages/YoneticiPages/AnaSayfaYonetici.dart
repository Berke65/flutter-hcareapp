import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:hcareapp/pages/YoneticiPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/services/auth_services.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcareapp/services/auth_services.dart';


void main() {
  runApp(const AnaSayfaYonetici());
}

class AnaSayfaYonetici extends StatefulWidget {
  const AnaSayfaYonetici({Key? key}) : super(key: key);

  @override
  State<AnaSayfaYonetici> createState() => _AnaSayfaYoneticiState();
}

class _AnaSayfaYoneticiState extends State<AnaSayfaYonetici> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white54,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.white,
        ),
      ),
      home: const YoneticiHomePage(),
    );
  }
}

class YoneticiHomePage extends StatefulWidget {
  const YoneticiHomePage({Key? key}) : super(key: key);

  @override
  _YoneticiHomePageState createState() => _YoneticiHomePageState();
}

class _YoneticiHomePageState extends State<YoneticiHomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Image.asset('images/gero1.jpg', fit: BoxFit.cover, height: 38),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app_outlined,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Main(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          _buildUserList()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
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
      ),
    );
  }

  Widget _buildUserList() {
    String? selectedNurse;
    String? selectedSick;

    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Kullanıcı verilerini al
        List<Map<String, dynamic>> usersData = snapshot.data as List<Map<String, dynamic>>;

        // Hemşire rolüne sahip kullanıcıları filtrele
        List<Map<String, dynamic>> nurseUsersData = usersData.where((userData) => userData['roleName'] == 'Hemşire').toList();
        List<Map<String, dynamic>> sickUsersData = usersData.where((userData) => userData['roleName'] == 'Hasta').toList();


        // Hemşire rolüne sahip kullanıcıların isimlerini al
        List<String> nurseUserNames = nurseUsersData.map<String>((userData) => userData['name']).toList();
        List<String> sickUserNames = sickUsersData.map<String>((userData) => userData['name']).toList();

        // Hemşire ve hasta listelerini ayrı dropdownlarla oluştur
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdownlist('Hemşire seçmek için tıklayınız', nurseUserNames, context, (value) {
              selectedNurse = value;
            }),
            _dropdownlist('Hasta seçmek için tıklayınız', sickUserNames, context, (value) {
              selectedSick = value;
            }),
            const SizedBox(height: 20), // Buton ile dropdown arasında bir boşluk ekledim
            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      authService().addDropdownValuesToFirestore(
                        context: context,
                        selectedNurse: selectedNurse,
                        selectedSick: selectedSick,
                      );

                      setState(() {
                        selectedNurse = null;
                        selectedSick = null;
                      });

                    },
                    child: Text(
                      'Kaydet',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextButton(
                    onPressed: () {
                        authService().showPairedValuesPopup(context);
                    },
                    child: Text(
                      'Eşleştirilmiş Kişileri Gör',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),

            ),

          ],
        );
      },
    );
  }
//sabir
  Widget _dropdownlist(String hintText, List<String> userNames, BuildContext context, Function(String?) onValueChanged) {
    String? selectedValue;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      onChanged: (value) {
        onValueChanged(value);
        selectedValue = value; // Seçilen değeri güncelle
      },
      items: userNames.map((userName) {
        return DropdownMenuItem<String>(
          value: userName,
          child: Text(userName),
        );
      }).toList(),
    );
  }




}
