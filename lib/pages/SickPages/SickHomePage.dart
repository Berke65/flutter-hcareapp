
import 'dart:ui';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:hcareapp/pages/SickPages/CameraPage.dart';
import 'package:hcareapp/pages/SickPages/RandevuAl.dart';
import 'package:hcareapp/pages/SickPages/SickInfoUpdate.dart';

import 'Profile.dart';
import 'SickChat.dart';
import 'Sickinfopage.dart';

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
        ),
      ),
      home: const SickHomePage(),
    );
  }
}

class SickHomePage extends StatefulWidget {
  const SickHomePage({Key? key}) : super(key: key);

  @override
  _SickHomePageState createState() => _SickHomePageState();
}

class _SickHomePageState extends State<SickHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = AuthService();
  late String? currentUsername; // Kullanıcı adını saklamak için değişken
  List<Map<String, dynamic>> _displayedSickUsers = []; // Hasta verilerini saklamak için liste

  @override
  void initState() {
    super.initState();
    _fetchSickUsers();
    // Kullanıcı adını Firestore'dan al ve currentUsername değişkenine ata
    userNameGetFirestore().then((value) {
      setState(() {
        currentUsername = value;
      });
    });
    // Hasta verilerini çek ve listeye ekle
    userName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20,),
                Text(
                  'Hoşgeldin ${currentUsername ?? ''}!',
                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black87),),
              ],
            ),
            const Divider(),
            customsizedbox(),
            SizedBox(
              child: SizedBox(
                width: 395,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(1, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SickUpdate(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage('images/icone2.png'),
                            height: 42,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sağlık Bilgilerini Güncelle',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            customsizedbox(),
            SizedBox(
              width: 395,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CameraPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // Butonun yüksekliği
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueGrey
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.video_camera_back,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Kamerayı Görüntüle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Buton metni
                      ],
                    ),
                  ),
                ),
              ),
            ),
            customsizedbox(),
            SizedBox(
              width: 395,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RandevuAl(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5, // Butonun yüksekliği
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image(
                          image: AssetImage('images/icone3.png'),
                          height: 42,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          'Randevu Al',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Buton metni
                      ],
                    ),
                  ),
                ),
              ),
            ),
            customsizedbox(),
            const Divider(),
            const Text('Randevularım', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0),),
            Expanded(
              child: _displayedSickUsers.isEmpty
                  ? const Center(
                child: Text(
                  'Randevunuz bulunamamaktadır',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
                  : ListView.builder(
                itemCount: _displayedSickUsers.length,
                itemBuilder: (context, index) {
                  final user = _displayedSickUsers[index];
                  DateTime date = user['tarih'].toDate();
                  String formattedDate = "${date.day}/${date.month}/${date.year}";
                  return ListTile(
                    title: Text(user['saat'] ?? 'Anonim'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['sağlıkAlanı'] ?? 'Email yok'),
                        Text(formattedDate),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Randevu İptali'),
                              content: const Text('Randevuyu iptal etmek istediğinize emin misiniz?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      // Tıklanan satırdaki randevuyu Firestore'dan kaldır
                                      await FirebaseFirestore
                                          .instance
                                          .collection('randevu')
                                          .where('tarih', isEqualTo: user['tarih'])
                                          .where('sağlıkAlanı', isEqualTo: user['sağlıkAlanı'])
                                          .where('userName', isEqualTo: user['userName'])
                                          .where('saat', isEqualTo: user['saat'])
                                          .get()
                                          .then((querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          doc.reference.delete();
                                        });
                                      });
                                      // İptal edilen randevuyu listeden kaldır
                                      setState(() {
                                        _displayedSickUsers.removeAt(index);
                                      });
                                    } catch (e) {
                                      print("Hata: $e");
                                      // Hata durumunda kullanıcıya bilgi vermek için gerekli işlemler yapılabilir
                                    }
                                    Navigator.of(context).pop(); // İletişim kutusunu kapat
                                  },
                                  child: const Text("Evet, İptal Et"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey.shade300,
        elevation: 1.0,
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
                    builder: (context) => SickInfoPage(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_information_outlined,
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

  Future<void> userName() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

  }

  Future<void> _fetchSickUsers() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Kullanıcı adı almak için Firestore sorgusu
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    String? currentUsername = userDoc.data()?['name'];
    if (currentUsername == null) return;

    // Randevuları almak için Firestore sorgusu
    QuerySnapshot<Map<String, dynamic>> randevuSnapshot = await FirebaseFirestore.instance
        .collection('randevu')
        .where('userName', isEqualTo: currentUsername)
        .get();

    List<Map<String, dynamic>> randevuList = randevuSnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _displayedSickUsers = randevuList;
    });

    String formatDate(Timestamp? timestamp) {
      if (timestamp == null) return '';

      DateTime date = timestamp.toDate();
      String day = date.day.toString();
      String month = date.month.toString();
      String year = date.year.toString();

      return '$day/$month/$year';
    }

  }



  Future<String?> userNameGetFirestore() async {
    String currentUserId = _authService.getCurrentUser()!.uid;

    QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUserId)
        .get();

    String? currentUsername;
    if (userQuery.docs.isNotEmpty) {
      currentUsername = userQuery.docs.first.data()['name'];
    } else {
      currentUsername = "Kullanıcı bulunamadı";
    }

    return currentUsername;
  }



  SizedBox customsizedbox() => const SizedBox(height: 20);
}
