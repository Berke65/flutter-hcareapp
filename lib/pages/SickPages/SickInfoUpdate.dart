import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(SickUpdate());

class Medicine {
  String name;
  int dosage; // Dozaj bilgisini ekledik
  String time; // Saat bilgisini ekliyoruz



  Medicine(this.name, this.dosage, this.time);
}

class SickUpdate extends StatefulWidget {
  @override
  _SickUpdateState createState() => _SickUpdateState();
}

class _SickUpdateState extends State<SickUpdate> {
  final List<String> kanGruplari = [
    'A Rh(+)',
    'A Rh(-)',
    'B Rh(+)',
    'B Rh(-)',
    'AB Rh(+)',
    'AB Rh(-)',
    '0 Rh(+)',
    '0 Rh(-)',
  ];

  final List<String> kaliciHastaliklar = [
    'Diyabet',
    'Hipertansiyon',
    'Kanser',
    'Astım',
    'Obezite',
    'Tiroid Hastalıkları',
    'Yüksek Kolesterol',
    // İstediğiniz kadar hastalık ekleyebilirsiniz
  ];

  final List<String> selectedKaliciHastaliklar = [];
  final List<Medicine> ilaclar = [];
  final List<String> hastaliklar = [];
  String? selectedKanGrubu;
  String? kullaniciNot;
  final firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        leading: Container(
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SickAnasayfa(),
                ),
              );
            },
          ),
        ),
        title: const Text('Sağlık Bilgilerini Güncelle',style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kan Grubu',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: selectedKanGrubu,
              // Seçilen kan grubunu burada gösteriyoruz
              items: kanGruplari.map((String kanGrubu) {
                return DropdownMenuItem<String>(
                  value: kanGrubu,
                  child: Text(kanGrubu),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedKanGrubu =
                      value; // Seçilen kan grubunu değişkene atıyoruz
                });
              },
              decoration: const InputDecoration(
                hintText: 'Kan grubunuzu seçin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Kalıcı Hastalıklar',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Wrap(
              children: kaliciHastaliklar.map((String hastalik) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilterChip(
                    label: Text(hastalik),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedKaliciHastaliklar.add(hastalik);
                        } else {
                          selectedKaliciHastaliklar.remove(hastalik);
                        }
                      });
                    },
                    selected: selectedKaliciHastaliklar.contains(hastalik),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            _buildIlaclarDropdown(),
            const SizedBox(height: 20.0),
            _not(),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50.0),
                  backgroundColor: Colors.blueGrey[300],
                  elevation: 3, // Gölgelenme miktarı
                  shadowColor: Colors.black, // Gölgelenme rengi
                ),
                onPressed: hastaBilgileriKayit,

                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 18.0, color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIlaclarDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kullanılan İlaçlar',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Wrap(
          children: ilaclar.map((Medicine ilac) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilterChip(
                label: Text(ilac.name), // İlaç adını burada kullanıyoruz
                onSelected: (_) {},
                selected: true,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 50.0),
            backgroundColor: Colors.blueGrey[300],
            elevation: 3, // Gölgelenme miktarı
            shadowColor: Colors.black, // Gölgelenme rengi
          ),
          onPressed: () {
            _showIlaclarDialog();
          },
          child: const Text('İlaç Ekle',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Future<void> _showIlaclarDialog() async {
    final TextEditingController ilacController = TextEditingController();
    final TextEditingController dozajController = TextEditingController();
    final TextEditingController saatController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İlaç Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: ilacController,
                decoration: const InputDecoration(
                  hintText: 'İlacı girin',
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: dozajController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Dozajı girin',
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: saatController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  hintText: 'Saat bilgisini girin (HH:MM)',
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

              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // İlaç adı, dozajı ve saat bilgisinin boş olmadığını kontrol et
                if (ilacController.text.isNotEmpty &&
                    dozajController.text.isNotEmpty &&
                    saatController.text.isNotEmpty) {
                  // Saat bilgisinin uygun formatta olduğunu kontrol et
                  if (saatController.text.length == 5 &&
                      saatController.text.contains('.')) {
                    setState(() {
                      // İlaç adı, dozajı ve saat bilgisini ekleyerek ilaç listesine ekleyin
                      ilaclar.add(Medicine(
                        ilacController.text,
                        int.parse(dozajController.text),
                        saatController.text,
                      ));
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Lütfen saat bilgisini HH:MM formatında girin'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Lütfen tüm ilaç bilgilerini doldurun'),
                  ));
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  Widget _not() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eklemek İstediğiniz Notları Yazabilirsiniz',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          maxLines: 3,
          onChanged: (String value) {
            setState(() {
              kullaniciNot = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Eklemek İstediğiniz Notları Yazabilirsiniz',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void hastaBilgileriKayit() async {
    String? res;
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

    QuerySnapshot<Map<String, dynamic>> sickQuery = await FirebaseFirestore
        .instance
        .collection('nurseSickMatch')
        .where('SickName', isEqualTo: currentUsername)
        .get();


    String? NurseName;
    sickQuery.docs.forEach((doc) {
      if (doc.exists) {
        NurseName = doc.data()['nurseName'];
      } else {
        NurseName = "Kullanıcı bulunamadı";
      }
    });
    print(NurseName);

    String currentUserEmail = userQuery.docs.first.data()['email'];

    try {
      // İlaçları Firestore'a kaydetme
      List<Map<String, dynamic>> ilacBilgileri = [];
      ilaclar.forEach((ilac) {
        ilacBilgileri.add({
          'ilacAdi': ilac.name,
          'dozaj': ilac.dosage,
          'saat': ilac.time, // Saat bilgisini de Firestore'a ekliyoruz
        });
      });

      if (selectedKanGrubu == null || kullaniciNot == null || ilaclar.isEmpty ) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen tüm alanları doldurunuz')));
      } else {
        await firebaseFirestore.collection('hastaBilgileri').doc(uid).set({
          'hastaMail': currentUserEmail,
          'hastaKaliciHastalik': selectedKaliciHastaliklar,
          'hastaKanGrup': selectedKanGrubu,
          'hastaKullanılanİlaclar': ilacBilgileri,
          // İlaç bilgileri buraya eklendi
          'hastaNot': kullaniciNot,
          'connectedNurse': NurseName,
          'SickName': currentUsername,
        });
        res = "success";
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
            'Bilgileriniz başarıyla kaydedildi. Hasta Anasayfasına yönlendiriliyorsunuz')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SickAnasayfa()));
      }
    } catch (e) {
      print('Firestore veri ekleme hatası: $e');
      res = "Bir hata oluştu, lütfen tekrar deneyin.";
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          'Bilinmeyen bir hata oluştu lütfen tekrar deneyiniz')));
    }
  }
}
