import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'NurseChat.dart';
import 'NursePageHome.dart';
import 'Profile.dart';
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
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade300,
          title: Image.asset('images/gero1.jpg', fit: BoxFit.cover, height: 38),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.all(5.0), // Container'ın kenar boşlukları
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Container'ı daire şeklinde yap
                color: Colors.blueGrey[200], // Container'ın arka plan rengi
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                customSizedBox(),
                const Center(
                  child: Text(
                    'İlaç Listesi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),

                const SizedBox(height: 10),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _showSickUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Veri yüklenirken gösterilecek widget
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Veri başarıyla yüklendiğinde
                      List<Map<String, dynamic>> sickUsers = snapshot.data!;
                      return sickUsers.isEmpty
                          ? const Center(
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
                    launchUrl(Uri.parse('tel://112'));
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
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueGrey[300],
          // BottomAppBar'ın arka plan rengini beyaza ayarladık
          elevation: .0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NursePageHome(),
                  ),
                );},
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      'Anasayfa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {

                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_pharmacy,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      'İlaç Takip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NurseChat(),
                    ),
                  );
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.message_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      'Sohbet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
