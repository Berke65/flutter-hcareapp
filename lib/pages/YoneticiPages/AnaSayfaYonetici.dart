import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/bottomAppBarYonetici.dart';

void main() {
  runApp(const AnaSayfaYonetici());
}

class AnaSayfaYonetici extends StatelessWidget {
  const AnaSayfaYonetici({Key? key}) : super(key: key);

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Hemsire> hemsireListesi = [
    Hemsire(adSoyad: 'Hemşire 1', unvan: 'Başhemşire'),
    Hemsire(adSoyad: 'Hemşire 2', unvan: 'Hemşire'),
    Hemsire(adSoyad: 'Hemşire 3', unvan: 'Hemşire'),
  ];

  final List<Hasta> hastaListesi = [
    Hasta(adSoyad: 'Hasta 1'),
    Hasta(adSoyad: 'Hasta 2'),
    Hasta(adSoyad: 'Hasta 3'),
  ];

  Hemsire? secilenHemsire;
  Hasta? secilenHasta;
  List<Esipariser> esiparisler = [];

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Hemsire>(
              decoration: InputDecoration(
                labelText: 'Hemşire Seç',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200], // Açık tonlu gri
              ),
              value: secilenHemsire,
              onChanged: (Hemsire? newValue) {
                setState(() {
                  secilenHemsire = newValue;
                });
              },
              items: hemsireListesi.map((Hemsire hemsire) {
                return DropdownMenuItem<Hemsire>(
                  value: hemsire,
                  child: Text(hemsire.adSoyad),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<Hasta>(
              decoration: InputDecoration(
                labelText: 'Hasta Seç',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200], // Açık tonlu gri
              ),
              value: secilenHasta,
              onChanged: (Hasta? newValue) {
                setState(() {
                  secilenHasta = newValue;
                });
              },
              items: hastaListesi.map((Hasta hasta) {
                return DropdownMenuItem<Hasta>(
                  value: hasta,
                  child: Text(hasta.adSoyad),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (secilenHemsire != null && secilenHasta != null) {
                  setState(() {
                    esiparisler.add(Esipariser(
                        hemHemHemsire: secilenHemsire!.adSoyad,
                        hemHemHasta: secilenHasta!.adSoyad));
                    hemsireListesi.remove(secilenHemsire);
                    hastaListesi.remove(secilenHasta);
                    secilenHemsire = null;
                    secilenHasta = null;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen hemşire ve hasta seçiniz.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text(
                'Görevlendir',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Arka plan rengi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: esiparisler.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      '${esiparisler[index].hemHemHemsire} , ${esiparisler[index].hemHemHasta} için görevlendirilmiştir.',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarYonetici(context),
    );
  }
}

class Hemsire {
  final String adSoyad;
  final String unvan;

  Hemsire({required this.adSoyad, required this.unvan});
}

class Hasta {
  final String adSoyad;

  Hasta({required this.adSoyad});
}

class Esipariser {
  final String hemHemHemsire;
  final String hemHemHasta;

  Esipariser({required this.hemHemHemsire, required this.hemHemHasta});
}
