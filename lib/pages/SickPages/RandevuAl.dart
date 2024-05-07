import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  runApp(const RandevuAl());
}

class RandevuAl extends StatelessWidget {
  const RandevuAl({Key? key}) : super(key: key);

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
      home: const RandevuPage(),
    );
  }
}

class RandevuPage extends StatefulWidget {
  const RandevuPage({Key? key}) : super(key: key);

  @override
  _RandevuPageState createState() => _RandevuPageState();
}

class _RandevuPageState extends State<RandevuPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  // Seçilen günü takip etmek için bir değişken oluşturalım
  DateTime selectedDate = DateTime.now();

  // Sağlık alanlarını temsil eden bir liste oluşturalım
  List<String> healthDepartments = [
    'Kardiyoloji',
    'Üroloji',
    'Dermatoloji',
    'Nöroloji',
    'Göz Hastalıkları'
  ];

  // Seçilen sağlık alanını takip etmek için bir değişken oluşturalım
  String? selectedDepartment;

  // Seçilen saat değerini tutmak için bir değişken oluşturalım
  String selectedHour = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Seçilen günün formatlı tarihini al
    String formattedDate =
        "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}";

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Takvim Görünümü
            TableCalendar(
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2128, 12, 31),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                });
              },
            ),
            const SizedBox(height: 20),
            // Seçilen Günün Tarihini Gösteren Text
            Text(
              "Seçilen Gün: $formattedDate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Sağlık Alanı Dropdown
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              hint: const Text('Sağlık Alanını Seçin'),
              onChanged: (newValue) {
                setState(() {
                  selectedDepartment = newValue;
                });
              },
              items: healthDepartments.map((department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Saat Girişi TextFormFied
            TextFormField(
              keyboardType: TextInputType.datetime,
              // Klavyede sadece saat girişi için saat formatını kullanmak için
              decoration: const InputDecoration(
                hintText: 'Saat Girin (Örn: 14.30)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                // Yalnızca rakam ve iki nokta karakterine izin verir
              ],
              onChanged: (value) {
                setState(() {
                  selectedHour = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Randevu Al Butonu
            ElevatedButton(
              onPressed: () async {
                // Kullanıcının adını al
                String? userName = await getUserName();

                // Boş alan kontrolü
                if (selectedDate == null || selectedDepartment == null || selectedHour.isEmpty || userName == null) {
                  // Kullanıcıya boş alanları doldurması gerektiğini belirten bir uyarı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen tüm alanları doldurunuz!')),
                  );
                } else {
                  // Firestore'a randevu bilgilerini ve kullanıcının adını ekleme fonksiyonunu çağır
                  addAppointmentToFirestore(selectedDate, selectedDepartment!, selectedHour, userName);
                }
              },
              child: const Text('Randevu Al'),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBarSick(context),
    );
  }
  void addAppointmentToFirestore(DateTime selectedDate, String selectedDepartment, String selectedHour ,String userName) {
    // Firestore'da yeni bir randevu dökümanı oluştur
    _firestore.collection('randevu').add({
      'tarih': selectedDate,
      'sağlıkAlanı': selectedDepartment,
      'saat': selectedHour,
      'userName': userName, // Kullanıcının adını ekle
    })
        .then((value) {
      // İşlem başarılı olduğunda yapılacak işlemler
      print('Randevu başarıyla eklendi!');
    })
        .catchError((error) {
      // Hata durumunda yapılacak işlemler
      print('Hata oluştu: $error');
    });
  }

  Future<String?> getUserName() async {
    String? userName;

    // Mevcut kullanıcının kimlik bilgilerini al
    User? user = _auth.currentUser;

    if (user != null) {
      // Firestore'dan belgeyi al
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(user.uid).get();

      // Belgeyi kontrol et ve kullanıcının adını al
      if (snapshot.exists) {
        userName = snapshot.data()?['name'];
      }
    }

    return userName;
  }

}
