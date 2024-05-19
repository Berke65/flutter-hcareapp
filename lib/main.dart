import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/auth/GirisYap.dart';
import 'package:hcareapp/pages/auth/kayitOlPage.dart';
import 'package:hcareapp/pages/auth/passwd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'package:hcareapp/pages/SickPages/SickInformation.dart';
import 'package:hcareapp/pages/NursePages/NursePageHome.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geropital',
      routes: {
        "/passwd": (context) => const Passwd(),
        "/girisYap": (context) => Main(),
      },
      home: FutureBuilder(
        future: checkIfLoggedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data == true) {
            return const HomePage(); // Giriş yapmış kullanıcının ana sayfası
          } else {
            return const MainScreen();
          }
        },
      ),
    );
  }

  Future<bool> checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email');
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bakalım1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 200),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('images/gero1.jpg'),
              ),
              customSizedBox(),
              buildGirisKutusu(
                icon: Icons.admin_panel_settings_outlined,
                text: 'Giriş Yap',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GirisYap(),
                    ),
                  );
                },
              ),
              customSizedBox(),
              buildGirisKutusu(
                icon: Icons.person_add_alt,
                text: 'Kayıt Ol',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const kayitOlPage(),
                    ),
                  );
                },
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    'Designed and developed by Beker Software',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGirisKutusu({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 280,
      height: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 50,
          color: Colors.black,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'Arial',
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

Widget customSizedBox() => const SizedBox(
  height: 20,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? roleName;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getUserRole();
  }

  Future<void> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty && userQuery.docs.length == 1) {
        setState(() {
          roleName = userQuery.docs.first.data()['roleName'];
        });

        if (roleName == "Yönetim") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AnaSayfaYonetici()));
        } else if (roleName == "Hemşire") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const NursePageHome()));
        } else if (roleName == "Hasta") {
          QuerySnapshot<Map<String, dynamic>> sickQuery = await FirebaseFirestore
              .instance
              .collection('hastaBilgileri')
              .where('hastaMail', isEqualTo: email)
              .get();

          if (sickQuery.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Bilgilerinizi Eksiksiz Doldurunuz! (GEROPİTAL EVDE SAĞLIK HİZMETLERİ)',
              ),
            ));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SickInformation()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SickAnasayfa()));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: roleName == null
            ? const CircularProgressIndicator()
            : const Text('Bu biraz zaman alabilir!',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0),),
      ),
    );
  }
}

