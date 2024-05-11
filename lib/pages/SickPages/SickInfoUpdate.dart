import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';

void main() => runApp(SickUpdate());

class SickUpdate extends StatelessWidget {
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

  final List<String> ilaclar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          'Sağlık Bilgilerinizi Güncelleyin.',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
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
              value: null,
              items: kanGruplari.map((String kanGrubu) {
                return DropdownMenuItem<String>(
                  value: kanGrubu,
                  child: Text(kanGrubu),
                );
              }).toList(),
              onChanged: (_) {},
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
                    onSelected: (_) {},
                    selected: false,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            _buildIlaclarDropdown(),
            const SizedBox(height: 20.0),
            const Text(
              'Eklemek İstediğiniz Notları Yazabilirsiniz',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              maxLines: 3,
              onChanged: (_) {},
              decoration: const InputDecoration(
                hintText: 'Eklemek İstediğiniz Notları Yazabilirsiniz',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Kaydetme işlevini buraya ekleyebilirsiniz.
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 50.0),
                  backgroundColor: Colors.blueGrey[100],
                  elevation: 2,
                  shadowColor: Colors.blueGrey,
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
                selected: false,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 50.0),
            backgroundColor: Colors.blueGrey[100],
            elevation: 3, // Gölgelenme miktarı
            shadowColor: Colors.blueGrey, // Gölgelenme rengi

          ),
          child: const Text('İlaç Ekle', style: TextStyle(color: Colors.black),),
        ),
      ],
    );
  }
}
