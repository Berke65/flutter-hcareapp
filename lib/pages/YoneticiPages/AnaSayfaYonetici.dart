import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hcareapp/pages/YoneticiPages/AllSickPage.dart';
import 'package:hcareapp/pages/YoneticiPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const AnaSayfaYonetici());
}

class AnaSayfaYonetici extends StatefulWidget {
  const AnaSayfaYonetici({Key? key}) : super(key: key);

  @override
  State<AnaSayfaYonetici> createState() => _AnaSayfaYoneticiState();
}

class _AnaSayfaYoneticiState extends State<AnaSayfaYonetici> {
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
      home: const YoneticiHomePage(),
    );
  }
}

class YoneticiHomePage extends StatefulWidget {
  const YoneticiHomePage({Key? key}) : super(key: key);

  @override
  _YoneticiHomePageState createState() => _YoneticiHomePageState();
}

class _YoneticiHomePageState extends State<YoneticiHomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('images/gero1.jpg', fit: BoxFit.cover, height: 38),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0), // Container'ın kenar boşlukları
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
      body: Column(
        children: [_buildUserList()],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandevuYonetici(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 30,
                  ),
                  Text(
                    'Randevu',
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
              color: Colors.black45, // Çizgi rengi
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

  Widget _buildUserList() {
    String? selectedNurse;
    String? selectedSick;

    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Kullanıcı verilerini al
        List<Map<String, dynamic>> usersData =
            snapshot.data as List<Map<String, dynamic>>;

        // Hemşire rolüne sahip kullanıcıları filtrele
        List<Map<String, dynamic>> nurseUsersData = usersData
            .where((userData) => userData['roleName'] == 'Hemşire')
            .toList();
        List<Map<String, dynamic>> sickUsersData = usersData
            .where((userData) => userData['roleName'] == 'Hasta')
            .toList();

        // Hemşire rolüne sahip kullanıcıların isimlerini al
        List<String> nurseUserNames =
            nurseUsersData.map<String>((userData) => userData['name']).toList();
        List<String> sickUserNames =
            sickUsersData.map<String>((userData) => userData['name']).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Hoşgeldin ', //username çekilecek yanına yazılacak
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white54,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Hemşire Görevlendirme Sayfası',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(
                      color: Colors.black87,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.healing_outlined,
                              size: 22,
                            ),
                            Text(
                              'Hemşire',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 500,
                      height: 70,
                      child: _dropdownlist(
                        '',
                        nurseUserNames,
                        context,
                        (value) {
                          selectedNurse = value;
                        },
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.sick,
                          size: 22,
                        ),
                        Text(
                          'Hasta',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 22),
                        )
                      ],
                    ),
                    const SizedBox(height: 10), // Dropdownlar arası boşluk
                    SizedBox(
                      width: 500,
                      height: 70,
                      child: _dropdownlist(
                        '',
                        sickUserNames,
                        context,
                        (value) {
                          selectedSick = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            authService().addDropdownValuesToFirestore(
                              context: context,
                              selectedNurse: selectedNurse,
                              selectedSick: selectedSick,
                            );

                            setState(() {
                              selectedNurse = null;
                              selectedSick = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 80,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Kaydet',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            removePairedValuesPopup(context);
                          },
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 38,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Görüntüle Ve Düzenle',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllSickPage(),
                    ),
                  );
                },
                child: const Text(
                  'Tüm Hastaları Görmek için tıklayınız',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> removePairedValuesPopup(BuildContext context) async {
    try {
      List<Map<String, dynamic>> pairedValues = await getPairedValues();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Eşleştirilmiş Kişiler"),
            content: Container(
              width:
                  MediaQuery.of(context).size.width * 0.8, // Genişliği ayarla
              child: pairedValues.isEmpty
                  ? const Text('Eşleştirilmiş kişiler bulunamadı.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: pairedValues.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Hasta: ${pairedValues[index]['sick']}',
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Hemşire: ${pairedValues[index]['nurse']}',
                              ),
                              trailing: TextButton(
                                onPressed: () async {
                                  // Belirli bir eşleşmiş değeri silmek için ilgili veritabanı işlemlerini yap
                                  String nurseName =
                                      pairedValues[index]['nurse'];
                                  String sickName = pairedValues[index]['sick'];
                                  await deletePairFromDatabase(
                                      nurseName, sickName);
                                  // Listeyi güncelle ve alert dialogu yeniden göster
                                  setState(() {
                                    pairedValues.removeAt(index);
                                  });
                                },
                                child: const Text(
                                  'Kaldır',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                            const Text(
                                'Pencereyi kapatıp açtığınızda işlemin sonuçları gözükecektir'),
                          ],
                        );
                      },
                    ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing paired values popup: $e');
    }
  }

  Future<void> deletePairFromDatabase(String nurseName, String sickName) async {
    try {
      // Veritabanından belirli bir eşleşmiş değeri sil
      await FirebaseFirestore.instance
          .collection('nurseSickMatch')
          .where('nurseName', isEqualTo: nurseName)
          .where('SickName', isEqualTo: sickName)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
    } catch (e) {
      print('Error deleting paired values: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPairedValues() async {
    try {
      List<Map<String, dynamic>> pairedValues = [];

      // Veritabanından belirli koleksiyondaki tüm belgeleri al
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('nurseSickMatch').get();

      // Her bir belgeyi dön ve eşleştirilmiş değerleri listeye ekle
      querySnapshot.docs.forEach((doc) {
        pairedValues.add({
          'nurse': doc['nurseName'],
          'sick': doc['SickName'],
        });
      });

      return pairedValues;
    } catch (e) {
      print('Error getting paired values: $e');
      return [];
    }
  }

  Widget _dropdownlist(String hintText, List<String> userNames,
      BuildContext context, Function(String?) onValueChanged) {
    String? selectedValue;

    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value; // Seçilen değeri güncelle
            });
            onValueChanged(value);
          },
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          items: userNames.map((userName) {
            // Eşleştirilmiş kişileri kontrol et ve seçilemez yap
            bool isMatched = userName.contains('(Eşleştirilmiş)');
            return DropdownMenuItem<String>(
              value: userName,
              child: Text(
                userName,
                style: TextStyle(
                  color: isMatched
                      ? Colors.grey
                      : Colors.black, // Eşleştirilmişse gri renkte göster
                ),
              ),
              onTap: isMatched
                  ? null
                  : () => onValueChanged(
                      userName), // Eşleştirilmişse tıklanamaz yap
            );
          }).toList(),
        );
      },
    );
  }
}
