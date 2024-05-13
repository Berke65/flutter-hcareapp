import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/NursePages/BottomAppbarNurse.dart';
import 'package:hcareapp/services/notifi_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const NurseMedicine());
}


class NurseMedicine extends StatefulWidget {
  const NurseMedicine({super.key});

  @override
  State<NurseMedicine> createState() => _NurseMedicineState();
}

class _NurseMedicineState extends State<NurseMedicine> {
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
  void initState() {
    super.initState();
    _showSickUsers();
  }

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'İlaç Listesi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _showSickUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Veri yüklenirken gösterilecek widget
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Veri başarıyla yüklendiğinde
                      List<Map<String, dynamic>> sickUsers = snapshot.data!;
                      return sickUsers.isEmpty
                          ? Center(
                        child: Text(
                          'Henüz Eşleştildiğiniz bir hasta bulunmamaktadır.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                          : DataTable(
                        columns: const [
                          DataColumn(label: Text('İlaç Adı')),
                          DataColumn(label: Text('İlaç Dozu')),
                          DataColumn(label: Text('İlaç Saati')),
                        ],
                        rows: sickUsers.expand((user) {
                          final ilaclar = user['hastaKullanılanİlaclar'] as List<dynamic>;

                          return ilaclar.map((ilac) {
                            final ilacAdi = ilac['ilacAdi'];
                            final dozaj = ilac['dozaj'];
                            final saat = ilac['saat'];

                            return DataRow(cells: [
                              DataCell(Text(ilacAdi)),
                              DataCell(Text(dozaj.toString())),
                              DataCell(Text(saat)),
                            ]);
                          });
                        }).toList(),
                      );

                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //KODDDDDDD
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'ACİL DURUM',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppbarNurse(context),
      ),
    );
  }
  Future<List<Map<String, dynamic>>> _showSickUsers() async {

    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      String? currentUsername;
      userQuery.docs.forEach((doc) {
        if (doc.exists) {
          currentUsername = doc.data()['name'];
        } else {
          currentUsername = "Kullanıcı bulunamadı";
        }
      });
      print(currentUsername);

      // Firestore'dan kullanıcıları al
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('hastaBilgileri').where('connectedNurse', isEqualTo: currentUsername).get();

      // Alınan kullanıcı verilerini işleyerek görüntüleme işlemini yap
      List<Map<String, dynamic>> sickUsers = querySnapshot.docs.map((doc) => doc.data()).toList();

      return sickUsers;
    } catch (e) {
      print('Error fetching sick users: $e');
      // Hata durumunda kullanıcıya bilgi verme veya uygun bir şekilde işlem yapma
      throw e; // Hata durumunda döndürülen future'ı hata durumu ile işlemek için hatayı yeniden fırlatır
    }
  }
}
