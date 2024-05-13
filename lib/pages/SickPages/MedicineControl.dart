import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/BottomAppBarSick.dart';
import 'package:hcareapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Profile.dart';

void main() {
  runApp(MedicineControl());
}

class MedicineControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Bilgilerim'),
        actions: [
          Container(
            margin: EdgeInsets.all(5.0), // Container'ın kenar boşlukları
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Container'ı daire şeklinde yap
              color: Colors.grey[200], // Container'ın arka plan rengi
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
      await FirebaseFirestore.instance.collection('hastaBilgileri').where('SickName', isEqualTo: currentUsername).get();

      // Alınan kullanıcı verilerini işleyerek görüntüleme işlemini yap
      List<Map<String, dynamic>> sickUsers = querySnapshot.docs.map((doc) => doc.data()).toList();

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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Hata durumunda gösterilecek widget
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Veriler başarıyla alındıysa gösterilecek widget
          List<Map<String, dynamic>> sickUsers = snapshot.data!;
          if (sickUsers.isEmpty) {
            // Veri yoksa gösterilecek uyarı mesajı
            return Center(child: Text('Henüz eşleştirildiğiniz bir hasta bulunmamaktadır.'));
          } else {
            // Veriler varsa ListView.builder içinde gösterilecek widget
            return ListView.builder(
              itemCount: sickUsers.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = sickUsers[index];
                List<dynamic> kaliciHastaliklar = user['hastaKaliciHastalik'] ?? [];
                List<dynamic> kullanilanIlaclar = user['hastaKullanılanİlaclar'] ?? [];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      title: Text("Ad: " + user['SickName'] ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Column(
                        children: [
                          Text("Hasta Notu: " + user['hastaNot']),
                          Text("Kalıcı Hastalıklar: " + kaliciHastaliklar.join(', ')),
                          Text("Kullanılan İlaçlar: " + kullanilanIlaclar.join(', ')),
                          Text("Hasta Kan Grubu: " + user['hastaKanGrup']),
                        ],
                      ),
                      onTap: () {
                        // Kullanıcıya tıklandığında yapılacak işlemler buraya eklenir
                      },
                    ),
                    Divider(), // Satırlar arasına ayırıcı ekler
                  ],
                );
              },
            );
          }
        }
      },
    );
  }






}

