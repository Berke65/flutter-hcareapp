import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';

void main() {
  runApp(const NursePage());
}

class NursePage extends StatefulWidget {
  const NursePage({super.key});

  @override
  State<NursePage> createState() => _NursePageState();
}

class _NursePageState extends State<NursePage> {
  // Örnek ilaçlar listesi
  final List<Map<String, dynamic>> medications = [
    {'isim': 'Parol', 'dozaj': '500 mg', 'zaman': '08:00 AM'},
    {'isim': 'Aspirin', 'dozaj': '100 mg', 'zaman': '12:00 PM'},
    {'isim': 'Amoklavin', 'dozaj': '625 mg', 'zaman': '04:00 PM'},
  ];

  // Seçilen ilacın zamanını tutacak değişken
  String? selectedMedication;

  // Saat girişi için kontrolcü
  final TextEditingController _timeController = TextEditingController();

  // Seçilen ilaçların ve zamanların listesi
  List<Map<String, String>> selectedMedications = [];

  // Hata durumunu kontrol etmek için bir değişken
  String? errorText;

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}
