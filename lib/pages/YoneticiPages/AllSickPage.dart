import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Profile.dart';
import 'AnaSayfaYonetici.dart';
import 'RandevuYonetici.dart';
import 'YoneticiChat.dart';
import 'package:hcareapp/pages/YoneticiPages/SickDetailsPage.dart';

void main() {
  runApp(const AllSickPage());
}

class AllSickPage extends StatelessWidget {
  const AllSickPage({Key? key}) : super(key: key);

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
      home: const NursePage(),
    );
  }
}

class NursePage extends StatefulWidget {
  const NursePage({Key? key}) : super(key: key);

  @override
  _NursePageState createState() => _NursePageState();
}

class _NursePageState extends State<NursePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _allSickUsers;
  late List<Map<String, dynamic>> _displayedSickUsers;

  @override
  void initState() {
    super.initState();
    _fetchSickUsers();
  }

  Future<void> _fetchSickUsers() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      String? currentUsername;
      for (var doc in userQuery.docs) {
        if (doc.exists) {
          currentUsername = doc.data()['name'];
        } else {
          currentUsername = "Kullanıcı bulunamadı";
        }
      }
      print(currentUsername);

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('hastaBilgileri').get();

      List<Map<String, dynamic>> sickUsers =
      querySnapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        _allSickUsers = sickUsers;
        _displayedSickUsers = sickUsers;
      });
    } catch (e) {
      print('Error fetching sick users: $e');
      // Hata durumunda kullanıcıya bilgi verme veya uygun bir şekilde işlem yapma
    }
  }

  void _searchSickUsers(String query) {
    setState(() {
      _displayedSickUsers = _allSickUsers.where((user) {
        final sickName = user['SickName'].toString().toLowerCase();
        return sickName.contains(query.toLowerCase());
      }).toList();
    });
  }

  TextStyle bottomAppBarTxtStyle() {
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        automaticallyImplyLeading: false,
        title: const Text(
          'Tüm Hastalar',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[200],
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
                    builder: (context) =>  ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Hasta Ara',
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchSickUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _displayedSickUsers.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = _displayedSickUsers[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.5),
                        side: BorderSide(
                          color: Colors.blueGrey.shade100,
                          width: 5.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: const Icon(Icons.person,
                            color: Colors.white, size: 40),
                        tileColor: Colors.blueGrey[400],
                        title: Text(
                          "Hasta Adı: " + (user['SickName'] ?? ""),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SickDetailsPage(sickData: user),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[300],
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomAppBarItem(
              icon: Icons.home_outlined,
              label: 'Anasayfa',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnaSayfaYonetici(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildBottomAppBarItem(
              icon: Icons.calendar_today_outlined,
              label: 'Randevu',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RandevuYonetici(),
                  ),
                );
              },
            ),
            _buildDivider(),
            _buildBottomAppBarItem(
              icon: Icons.message_outlined,
              label: 'Sohbet',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YoneticiChat(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBarItem({
    required IconData icon,
    required String label,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          Text(
            label,
            style: bottomAppBarTxtStyle(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white,
    );
  }
}
