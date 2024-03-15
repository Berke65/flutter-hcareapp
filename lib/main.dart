import 'package:hcareapp/pages/auth/GirisYap.dart';
import 'package:hcareapp/pages/auth/kayitOlPage.dart';
import 'package:hcareapp/pages/auth/passwd.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // forgot password ve kullanııc tipleri ayarlanacak

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
        "/passwd":(context) => passwd(),
        "/girisYap": (context) => Main(),
      },
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(

              resizeToAvoidBottomInset: false,
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bakalım1.png'),
                    // Arka plan deseni
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset('images/gero1.jpg'), // Logo resmi
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
      // Sabit genişlik
      height: 90,
      // Sabit yükseklik
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
          backgroundColor: Colors.white, // Düğme arka plan rengi
          elevation: 0, // Düğmenin gölgesi olmasın
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
