import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';

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
      backgroundColor: Colors.blueGrey.shade50,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SickHomePage(),
              ),
            );
          },
        ),
        title: const Text(
          'Randevu Al',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
            Divider(),
            const SizedBox(height: 10),
            // Sağlık Alanı Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonFormField<String>(
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
            ),
            const SizedBox(height: 20),
            // Saat Girişi TextFormFied
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                // Klavyede sadece saat girişi için saat formatını kullanmak için
                decoration: const InputDecoration(
                  hintText: 'Saat Girin (Örn: 14.30)',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;

                    // Eğer metin 5 karakterden fazla veya 5 karakter olup '.' içermiyorsa, eski değeri geri döndür
                    if (text.length > 5 ||
                        (text.length == 5 && !text.contains('.'))) {
                      return oldValue;
                    }

                    StringBuffer newText = StringBuffer();
                    for (int i = 0; i < text.length; i++) {
                      newText.write(text[i]);
                      // 2. karakterden sonra '.' ekle
                      if (i == 1 && text.length > 2) {
                        newText.write('.');
                      }
                    }
                    // Metni saat ve dakika olarak böl ve kontrol et
                    final parts = newText.toString().split('.');
                    if (parts.length == 2) {
                      final hour = int.tryParse(parts[0]) ?? 0;
                      final minute = int.tryParse(parts[1]) ?? 0;
                      // Saat 23'ten büyükse eski değeri geri döndür
                      if (hour > 23) {
                        return oldValue;
                      }
                      // Dakika 59'dan büyükse eski değeri geri döndür
                      if (minute > 59) {
                        return oldValue;
                      }
                    }
                    return TextEditingValue(
                      text: newText.toString(),
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedHour = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Randevu Al Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 50.0),
                backgroundColor: Colors.blueGrey[300],
                elevation: 3, // Gölgelenme miktarı
                shadowColor: Colors.black, // Gölgelenme rengi
              ),
              onPressed: () async {
                // Kullanıcının adını al
                String? userName = await getUserName();

                // Boş alan kontrolü
                if (selectedDate == null ||
                    selectedDepartment == null ||
                    selectedHour.isEmpty ||
                    selectedHour.length != 5 ||
                    userName == null) {
                  // Kullanıcıya boş alanları doldurması gerektiğini belirten bir uyarı göster
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Lütfen tüm alanları doğru bir şekilde doldurunuz!',
                      ),
                    ),
                  );
                } else {
                  // Firestore'a randevu bilgilerini ve kullanıcının adını ekleme fonksiyonunu çağır
                  addAppointmentToFirestore(selectedDate, selectedDepartment!,
                      selectedHour, userName);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Randevunuz Başarıyla oluşturuldu")));
                }
              },
              child: const Text(
                'Randevu Al',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addAppointmentToFirestore(DateTime selectedDate,
      String selectedDepartment, String selectedHour, String userName) {
    // Firestore'da yeni bir randevu dökümanı oluştur
    _firestore.collection('randevu').add({
      'tarih': selectedDate,
      'sağlıkAlanı': selectedDepartment,
      'saat': selectedHour,
      'userName': userName, // Kullanıcının adını ekle
    }).then((value) {
      // İşlem başarılı olduğunda yapılacak işlemler
      print('Randevu başarıyla eklendi!');
    }).catchError((error) {
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
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      // Belgeyi kontrol et ve kullanıcının adını al
      if (snapshot.exists) {
        userName = snapshot.data()?['name'];
      }
    }

    return userName;
  }
}
