import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const AnaSayfa());
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: SizedBox(
        width: 240,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  child: Text(
                    'Yönetim Ekibi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Randevular'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Hasta Bilgileri'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: const Text('Sohbet'),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: const Text('Çıkış Yap'),
                leading: const Icon(Icons.exit_to_app_outlined),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GirisYap(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.pop(context);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bakalım1.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                        daysOfWeekStyle: DaysOfWeekStyle(
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
                                    ? Colors.red
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
                      SizedBox(height: 16),
                      Text(
                        'Seçilen Gün: ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
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
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
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
