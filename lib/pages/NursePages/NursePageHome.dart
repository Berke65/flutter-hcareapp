import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Profile.dart';
import 'NurseChat.dart';
import 'NurseMedicine.dart';

void main() {
  runApp(const NursePageHome());
}

class NursePageHome extends StatelessWidget {
  const NursePageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white54,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
            color: Colors.white,
          )),
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
      backgroundColor: Colors.blueGrey[50],

      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        automaticallyImplyLeading: false,
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _showSickUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Veriler yüklenirken gösterilecek widgeth
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Hata durumunda gösterilecek widget
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Veriler başarıyla alındıysa gösterilecek widget
            List<Map<String, dynamic>> sickUsers = snapshot.data!;
            if (sickUsers.isEmpty) {
              // Veri yoksa gösterilecek uyarı mesajı
              return const Center(
                  child: Text(
                      'Henüz eşleştirildiğiniz bir hasta bulunmamaktadır.'));
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

                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 2,
                          ), // Add padding
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(
                                12), // Add rounded corners
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            // Verileri sola dayalı olarak göstermek için contentPadding kullanılıyor
                            title: Center(
                              child: Text(
                                "Hasta Adı: " + user['SickName'],
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.black,),
                                const SizedBox(height: 12),
                                Text(
                                  "Kalıcı Hastalıklar: ",
                                  style: buildTextbaslik(),
                                ),
                                Text('${kaliciHastaliklar.join(', ')}',
                                    style: CustomTxtStyle()),
                                const SizedBox(height: 8),
                                Text("Kullanılan İlaçlar:",
                                    style: buildTextbaslik()),
                                Text('${kullanilanIlaclar.join(', ')}',
                                    style: CustomTxtStyle()),
                                const SizedBox(height: 8),
                                Text("Hasta Kan Grubu: ",
                                    style: buildTextbaslik()),
                                Text('${user['hastaKanGrup']}',
                                    style: CustomTxtStyle()),
                                const SizedBox(height: 8),
                                Text("Hasta Notu: ", style: buildTextbaslik()),
                                Text('${user['hastaNot']}',
                                    style: CustomTxtStyle()),
                              ],
                            ),
                            onTap: () {
                              // Kullanıcıya tıklandığında yapılacak işlemler buraya eklenir
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      // Noktalı virgül burada olmamalı
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[300],
        // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: .0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NurseMedicine(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_pharmacy_outlined,
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
    );
  }

  TextStyle buildTextbaslik() => TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87);

  TextStyle CustomTxtStyle() =>
      const TextStyle(fontSize: 16, color: Colors.black54);

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
              .where('connectedNurse', isEqualTo: currentUsername)
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
}
