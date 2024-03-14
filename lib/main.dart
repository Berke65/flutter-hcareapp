import 'package:hcareapp/pages/auth/ana_sayfa.dart';
import 'package:hcareapp/pages/auth/yoneticiPage.dart';
import 'package:hcareapp/pages/auth/kayitOlPage.dart';
import 'package:hcareapp/pages/auth//nursePage.dart';
import 'package:hcareapp/pages/auth/sickPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // forgot password ve kullanııc tipleri ayarlanacak

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GirisYap());
}

class GirisYap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geropital',
      routes: {
        "/girisYap": (context) => GirisYap(),
        "/kayitOl": (context) => kayitOlPage(),
        "/anaSayfa": (context) => AnaSayfa(),
      },
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => SafeArea(
              child: Scaffold(
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
                          text: 'Yönetici Girişi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const yoneticiPage(),
                              ),
                            );
                          },
                        ),
                        customSizedBox(),
                        buildGirisKutusu(
                          icon: Icons.local_hospital_outlined,
                          text: 'Hemşire Girişi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const nursePage(),
                              ),
                            );
                          },
                        ),
                        customSizedBox(),
                        buildGirisKutusu(
                          icon: Icons.person_outline,
                          text: 'Hasta Girişi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const sickPage(),
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
