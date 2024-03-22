import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:hcareapp/pages/YoneticiPages/ProfileYonetici.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Image.asset('images/gero1.jpg', fit: BoxFit.cover, height: 38),
        centerTitle: true,
        leading: Column(
          children: [
            IconButton(
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
            //const Text('Çıkış Yap'),
          ],
        ),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        // image: DecorationImage(
        // image: AssetImage('images/bakalım1.png'),
        // fit: BoxFit.cover,
        // ),
        // ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Randevular',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TableCalendar(
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.cyan),
                        weekendStyle: TextStyle(color: Colors.redAccent),
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
                                  ? Colors.blueGrey[200]
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
                      child: ListView.builder(
                        itemCount: randevular.length,
                        itemBuilder: (context, index) {
                          final randevu = randevular[index];
                          if (randevu.dateTime.day == _selectedDay.day &&
                              randevu.dateTime.month == _selectedDay.month &&
                              randevu.dateTime.year == _selectedDay.year) {
                            return ListTile(
                              title: Text(
                                '${randevu.dateTime.hour}.${randevu.dateTime.minute} --> ${randevu.detay}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnaSayfaYonetici(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined),
                  Text(
                    'Anasayfa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandevuYonetici(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today),
                  Text(
                    'Randevu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YoneticiChat(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat),
                  Text(
                    'Sohbet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileYonetici(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle_outlined),
                  Text(
                    'Profil',
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
}

class Randevu {
  final DateTime dateTime;
  final String detay;

  Randevu(this.dateTime, this.detay);
}

List<Randevu> randevular = [
  Randevu(DateTime(2024, 3, 12, 10, 0), 'Kardiyoloji'),
  Randevu(DateTime(2024, 3, 12, 14, 30), 'Dahiliye'),
  Randevu(DateTime(2024, 3, 13, 9, 0), 'Ortopedi'),
  Randevu(DateTime(2024, 3, 14, 11, 0), 'Göz Hastalıkları'),
];
