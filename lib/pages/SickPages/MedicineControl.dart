import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/BottomAppBarSick.dart';
import 'package:hcareapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MedicineControl());
}

class MedicineControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hemşire İlaç Takip'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Bir önceki sayfaya geri dön
          },
        ),
      ),
      body: MedicationList(),
      bottomNavigationBar: BottomAppBarSick(context),
    );
  }
}


class MedicationSchedulePage extends StatefulWidget {
  @override
  State<MedicationSchedulePage> createState() => _MedicationSchedulePageState();
}

class _MedicationSchedulePageState extends State<MedicationSchedulePage> {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hemşire İlaç Takip'),
      ),
      body: MedicationList(),
      bottomNavigationBar: BottomAppBarSick(context),

    );
  }
}

class MedicationList extends StatefulWidget {
  @override
  _MedicationListState createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  late List<Map<String, dynamic>> ilacListesi = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('hastaBilgileri').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Bekletici göster
          );
        } else {
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'), // Hata göster
            );
          } else {
            // İlaç bilgileri başarıyla alındıysa
            List<Map<String, dynamic>> ilacListesi = [];
            snapshot.data!.docs.forEach((doc) {
              Map<String, dynamic> ilacBilgileri = doc.data();
              ilacListesi.add(ilacBilgileri);
            });

            return ListView.builder(
              itemCount: ilacListesi.length,
              itemBuilder: (context, index) {
                final ilacBilgileri = ilacListesi[index];
                final kullanilanIlaclar = ilacBilgileri['hastaKullanılanİlaclar'] as List<dynamic>;

                return ListTile(
                  title: Text(kullanilanIlaclar.join(', ')),
                  onTap: () {
                    // İlaç detayları sayfasına yönlendirme eklenebilir
                  },
                );
              },
            );
          }
        }
      },
    );
  }






}

