import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/bottomAppBarYonetici.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  runApp(const AnaSayfaYonetici());
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
      bottomNavigationBar: BottomAppBarYonetici(context),
    );
  }
}





