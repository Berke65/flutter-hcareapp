import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/SickPages/BottomAppBarSick.dart';
void main() {
  runApp(const SickAnasayfa());
}

class SickAnasayfa extends StatelessWidget {
  const SickAnasayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white54,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Colors.white,
          )
      ),
      home: const NursePage(),
    );
  }
}

class NursePage extends StatefulWidget {
  const NursePage({Key? key}) : super(key: key);

  @override
  _NursePageState createState() => _NursePageState();
}

class _NursePageState extends State<NursePage> {
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
      body: const Center(
        child: Text(
          'Boş Hasta Ana Ekranı',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBarSick(context),
    );
  }
}
