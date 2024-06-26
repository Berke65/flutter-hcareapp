import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Profile.dart';

void main() {
  runApp(const RandevuYonetici());
}

class RandevuYonetici extends StatelessWidget {
  const RandevuYonetici({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: YoneticiHomePage(),
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
  late DateTime _selectedDay;

  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _getRandevular(); // initState içinde randevu bilgilerini almak için çağrı yapılıyor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        automaticallyImplyLeading: false,
        title: const Text(
          'Randevular',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0),
            // Container'ın kenar boşlukları
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
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  TableCalendar(
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: Colors.black),
                      weekendStyle: TextStyle(color: Colors.red),
                    ),
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _selectedDay,
                    calendarFormat: CalendarFormat.month,
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    availableGestures: AvailableGestures.horizontalSwipe,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: date.isAtSameMomentAs(_selectedDay)
                                ? Colors.blueGrey[100]
                                : null,
                          ),
                          child: Text(date.day.toString()),
                        );
                      },
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Seçilen Gün: ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      color: Colors.blueGrey[100],
                      // Gri arkaplan rengini ayarla
                      child: ListView.builder(
                        itemCount: randevular.length,
                        itemBuilder: (context, index) {
                          final randevu = randevular[index];
                          if (randevu.dateTime.day == _selectedDay.day &&
                              randevu.dateTime.month == _selectedDay.month &&
                              randevu.dateTime.year == _selectedDay.year) {
                            return ListTile(
                              title: Text(
                                '${randevu.saat} --> ${randevu.detay}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                'Randevu Alan Kişi: ${randevu.userName}',
                                // userName'i görüntüle
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Randevuyu iptal etmek istediğinize emin misiniz?"),
                                        content: const Text(
                                            "Bu işlem geri alınamaz, emin misiniz?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("İptal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                // Tıklanan satırdaki randevuyu Firestore'dan kaldır
                                                await FirebaseFirestore.instance
                                                    .collection('randevu')
                                                    .where('tarih',
                                                        isEqualTo:
                                                            randevu.dateTime)
                                                    .where('sağlıkAlanı',
                                                        isEqualTo:
                                                            randevu.detay)
                                                    .where('userName',
                                                        isEqualTo:
                                                            randevu.userName)
                                                    .where('saat',
                                                        isEqualTo: randevu.saat)
                                                    .get()
                                                    .then((querySnapshot) {
                                                  querySnapshot.docs
                                                      .forEach((doc) {
                                                    doc.reference.delete();
                                                  });
                                                });
                                                // Liste içinden tıklanan randevuyu kaldır
                                                setState(() {
                                                  randevular.remove(
                                                      randevu); // Randevuyu listeden kaldır
                                                });
                                                // İletişim kutusunu kapat
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                print("Hataaaaaaaa: $e");
                                                // Hata durumunda kullanıcıya bilgi vermek için gerekli işlemler yapılabilir
                                              }
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
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[300],
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnaSayfaYonetici(),
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
                    Icons.calendar_today,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    'Randevu',
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
                    builder: (context) => const YoneticiChat(),
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

  Future<void> _removeRandevu() async {}

  // _getRandevular fonksiyonu _YoneticiHomePageState sınıfının bir parçası olarak tanımlanmalıdır
  Future<void> _getRandevular() async {
    // Firestore'dan randevu bilgilerini al
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('randevu').get();

    setState(() {
      // Alınan randevu bilgilerini listeye ekle
      randevular = querySnapshot.docs
          .map((doc) => Randevu(
              doc['tarih'].toDate(),
              doc['sağlıkAlanı'],
              doc['userName'] ?? '',
              // Eğer userName alanı null ise boş bir string olarak ata
              doc['saat']))
          .toList();
    });
  }
}

class Randevu {
  final DateTime dateTime;
  final String detay;
  final String userName;
  final String saat;

  Randevu(this.dateTime, this.detay, this.userName, this.saat);
}

List<Randevu> randevular = [
  Randevu(DateTime(2024, 3, 12, 10, 0), 'Kardiyoloji', 'isim1', ''),
  Randevu(DateTime(2024, 3, 12, 14, 30), 'Dahiliye', 'isim2', ''),
  Randevu(DateTime(2024, 3, 13, 9, 0), 'Ortopedi', 'isim3', ''),
  Randevu(DateTime(2024, 3, 14, 11, 0), 'Göz Hastalıkları', 'isim4', ''),
];
