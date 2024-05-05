import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/bottomAppBarYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/services/auth_services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        automaticallyImplyLeading: false,
        title: Image.asset('images/gero1.jpg', fit: BoxFit.cover, height: 38),
        centerTitle: true,
        actions: [

          Container(
            margin: EdgeInsets.all(5.0), // Container'ın kenar boşlukları
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Container'ı daire şeklinde yap
              color: Colors.grey[200], // Container'ın arka plan rengi
            ),
            child: IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [_buildUserList()],
      ),
      bottomNavigationBar: BottomAppBarYonetici(context),
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
        List<Map<String, dynamic>> usersData =
            snapshot.data as List<Map<String, dynamic>>;

        // Hemşire rolüne sahip kullanıcıları filtrele
        List<Map<String, dynamic>> nurseUsersData = usersData
            .where((userData) => userData['roleName'] == 'Hemşire')
            .toList();
        List<Map<String, dynamic>> sickUsersData = usersData
            .where((userData) => userData['roleName'] == 'Hasta')
            .toList();

        // Hemşire rolüne sahip kullanıcıların isimlerini al
        List<String> nurseUserNames =
            nurseUsersData.map<String>((userData) => userData['name']).toList();
        List<String> sickUserNames =
            sickUsersData.map<String>((userData) => userData['name']).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Mobil Uygulamamıza Hoşgeldiniz!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white54,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Hemşire Görevlendirme Sayfası',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 240,
                      height: 55,
                      child: _dropdownlist(
                        'Hemşire seçmek için tıklayınız',
                        nurseUserNames,
                        context,
                        (value) {
                          selectedNurse = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 10), // Dropdownlar arası boşluk
                    SizedBox(
                      width: 240,
                      height: 55,
                      child: _dropdownlist(
                        'Hasta seçmek için tıklayınız',
                        sickUserNames,
                        context,
                        (value) {
                          selectedSick = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
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
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 80,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Kaydet',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            authService().showPairedValuesPopup(context);
                          },
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 38,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Eşleştirilmiş Kişileri Gör',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _dropdownlist(String hintText, List<String> userNames,
      BuildContext context, Function(String?) onValueChanged) {
    String? selectedValue;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
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
