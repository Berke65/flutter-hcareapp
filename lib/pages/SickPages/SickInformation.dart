import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/SickAnasayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(SickInformation());

class Medicine {
  String name;


  Medicine(this.name);
}

class SickInformation extends StatefulWidget {
  @override
  _SickInformationState createState() => _SickInformationState();
}

class _SickInformationState extends State<SickInformation> {
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
  final List<String> ilaclar = [];
  final List<String> hastaliklar = [];
  String? selectedKanGrubu;
  String? kullaniciNot;
  final firebaseFirestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlık Bilgileri'),
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
              value: selectedKanGrubu, // Seçilen kan grubunu burada gösteriyoruz
              items: kanGruplari.map((String kanGrubu) {
                return DropdownMenuItem<String>(
                  value: kanGrubu,
                  child: Text(kanGrubu),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedKanGrubu = value; // Seçilen kan grubunu değişkene atıyoruz
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
                onPressed: hastaBilgileriKayit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50.0),
                  backgroundColor: Colors.blueGrey[100],
                  elevation: 3, // Gölgelenme miktarı
                  shadowColor: Colors.black, // Gölgelenme rengi
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(fontSize: 18.0, color: Colors.black54),
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
          children: ilaclar.map((String ilac) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: FilterChip(
                label: Text(ilac),
                onSelected: (_) {},
                selected: true,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
            _showIlaclarDialog();
          },
          child: const Text('İlaç Ekle'),
        ),
      ],
    );
  }

  Future<void> _showIlaclarDialog() async {
    final TextEditingController ilacController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İlaç Ekle'),
          content: TextFormField(
            controller: ilacController,
            decoration: const InputDecoration(
              hintText: 'İlacı girin',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  ilaclar.add(ilacController.text);
                });
                Navigator.of(context).pop();
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

    QuerySnapshot<Map<String, dynamic>> sickMail = await FirebaseFirestore.instance
        .collection('users')
        .where('email')
        .get();

    try {
      await firebaseFirestore.collection('hastaBilgileri').doc(uid).set({
        'hastaAd' : sickMail,
        'hastaKaliciHastalik': selectedKaliciHastaliklar,
        'hastaKanGrup' : selectedKanGrubu,
        'hastaKullanılanİlaclar' : ilaclar,
        'hastaNot' : kullaniciNot
      });
      res = "success";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Bilgileriniz başarıyla kaydedildi. Hasta Anasayfasına yönlendiriliyorsunuz')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SickAnasayfa()));
    } catch (e) {
      print('Firestore veri ekleme hatası: $e');
      res = "Bir hata oluştu, lütfen tekrar deneyin.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Bilinmeyen bir hata oluştu lütfen tekrar deneyiniz')));
    }
  }


}
