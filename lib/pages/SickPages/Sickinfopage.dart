import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Profile.dart';
import 'SickHomePage.dart';
import 'SickChat.dart';

void main() {
  runApp(SickInfoPage());
}

class SickInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        automaticallyImplyLeading: false,
        title: const Text('Bilgilerim'),
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
      body: MedicationList(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey.shade300,
        // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SickAnasayfa(),
                  ),
                );
              },
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
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_information,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    'Sağlık Bilgilerim',
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
                    builder: (context) => const SickChat(),
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
    );
  }
}

class sickInfostate extends StatefulWidget {
  @override
  State<sickInfostate> createState() => _sickInfostateState();
}

class _sickInfostateState extends State<sickInfostate> {
  final firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hemşire İlaç Takip'),
      ),
      body: MedicationList(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SickAnasayfa(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                  Text(
                    'Anasayfa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.black45,
            ),
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_information,
                    size: 30,
                  ),
                  Text(
                    'Sağlık Bilgilerim',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.black45,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SickChat(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 30,
                  ),
                  Text(
                    'Sohbet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Future<List<Map<String, dynamic>>> _showSickUsers() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
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
          await FirebaseFirestore.instance
              .collection('hastaBilgileri')
              .where('SickName', isEqualTo: currentUsername)
              .get();

      // Alınan kullanıcı verilerini işleyerek görüntüleme işlemini yap
      List<Map<String, dynamic>> sickUsers =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return sickUsers;
    } catch (e) {
      print('Error fetching sick users: $e');
      // Hata durumunda kullanıcıya bilgi verme veya uygun bir şekilde işlem yapma
      throw e; // Hata durumunda döndürülen future'ı hata durumu ile işlemek için hatayı yeniden fırlatır
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _showSickUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Veriler yüklenirken gösterilecek widget
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Hata durumunda gösterilecek widget
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Veriler başarıyla alındıysa gösterilecek widget
          List<Map<String, dynamic>> sickUsers = snapshot.data!;
          if (sickUsers.isEmpty) {
            // Veri yoksa gösterilecek uyarı mesajı
            return const Center(child: Text('Henüz bilgi girmediniz.'));
          } else {
            // Veriler varsa ListView.builder içinde gösterilecek widget
            return ListView.builder(
              itemCount: sickUsers.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = sickUsers[index];
                List<dynamic> kaliciHastaliklar =
                    user['hastaKaliciHastalik'] ?? [];
                List<dynamic> kullanilanIlaclar =
                    user['hastaKullanılanİlaclar'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text("Ad: ${user['SickName']}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          const SizedBox(
                            height: 0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kalıcı Hastalıklar: ",
                                style: builListTileBaslik(),
                              ),
                              Text('${kaliciHastaliklar.join(', ')}',
                                  style: buildListTileIcerik(),)
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kullanılan İlaçlar:",
                                style: builListTileBaslik(),
                              ),
                              Text(
                                '${kullanilanIlaclar.join(', ')}',
                                style: buildListTileIcerik(),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hasta Kan Grubu: ",
                                style: builListTileBaslik(),
                              ),
                              Text(
                                '${user['hastaKanGrup']}',
                                style: buildListTileIcerik(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hasta Notu: ",
                                style: builListTileBaslik(),
                              ),
                              Text(
                                '${user['hastaNot']}',
                                style: buildListTileIcerik(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(), // Satırlar arasına ayırıcı ekler
                  ],
                );
              },
            );
          }
        }
      },
    );
  }

  TextStyle buildListTileIcerik() {
    return TextStyle(fontSize: 16, color: Colors.black54);
  }

  TextStyle builListTileBaslik() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }
}
