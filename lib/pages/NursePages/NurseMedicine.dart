import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/NursePages/BottomAppbarNurse.dart';

void main() {
  runApp(const NurseMedicine());
}

class NurseMedicine extends StatefulWidget {
  const NurseMedicine({super.key});

  @override
  State<NurseMedicine> createState() => _NurseMedicineState();
}

class _NurseMedicineState extends State<NurseMedicine> {
  // Örnek ilaçlar listesi
  final List<Map<String, dynamic>> medications = [
    {'isim': 'Parol', 'dozaj': '500 mg', 'zaman': '08:00 AM'},
    {'isim': 'Aspirin', 'dozaj': '100 mg', 'zaman': '12:00 PM'},
    {'isim': 'Amoklavin', 'dozaj': '625 mg', 'zaman': '04:00 PM'},
  ];

  // Seçilen ilacın zamanını tutacak değişken
  String? selectedMedication;

  // Saat girişi için kontrolcü
  final TextEditingController _timeController = TextEditingController();

  // Seçilen ilaçların ve zamanların listesi
  List<Map<String, String>> selectedMedications = [];

  // Hata durumunu kontrol etmek için bir değişken
  String? errorText;

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bakalım1.png'), // Arka plan deseni
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'İlaç Listesi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('İlaç İsmi')),
                    DataColumn(label: Text('Dozaj')),
                    DataColumn(label: Text('Zaman')),
                  ],
                  rows: medications.map((medication) {
                    return DataRow(cells: [
                      DataCell(Text(medication['isim'])),
                      DataCell(Text(medication['dozaj'])),
                      DataCell(Text(medication['zaman'])),
                    ]);
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownButton<String>(
                            value: selectedMedication,
                            onChanged: (String? value) {
                              setState(() {
                                selectedMedication = value;
                              });
                            },
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Verilen İlacı Seçiniz'),
                              ),
                              for (var medication in medications)
                                DropdownMenuItem(
                                  value: medication['isim'],
                                  child: Text(medication['isim']),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: _timeController,
                              decoration: InputDecoration(
                                hintText: 'Saat Girin (HH.MM)',
                                errorText: errorText,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        // Saat girilip girilmediğini kontrol et
                        if (_timeController.text.isEmpty ||
                            _timeController.text.trim().length < 5 ||
                            !_timeController.text.contains('.')) {
                          setState(() {
                            errorText = 'Geçerli bir saat girin (HH.MM).';
                          });
                        } else {
                          final timeParts = _timeController.text.split('.');
                          final hour = int.tryParse(timeParts[0]);
                          final minute = int.tryParse(timeParts[1]);

                          // Saat ve dakika kontrolü
                          if (hour == null ||
                              hour > 23 ||
                              hour < 0 ||
                              minute == null ||
                              minute > 59 ||
                              minute < 0) {
                            setState(() {
                              errorText = 'Geçerli bir saat girin (HH.mm).';
                            });
                          } else {
                            setState(() {
                              selectedMedications.add({
                                'isim': selectedMedication!,
                                'zaman': _timeController.text,
                              });
                              selectedMedication = null;
                              _timeController.clear();
                              errorText = null; // Hata mesajını temizle
                            });
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text('Kaydet', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                for (var med in selectedMedications)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seçilen İlaç: ${med['isim']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Seçilen Zaman: ${med['zaman']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Acil durum butonuna basıldığında yapılacak işlemler
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'ACİL DURUM',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppbarNurse(context),
      ),
    );
  }
}
