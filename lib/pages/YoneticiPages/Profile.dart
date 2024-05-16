import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String imageUrl = '';

  bool _isEditingProfile = false;
  Map<String, dynamic> _editedProfileData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        leading: Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Container'ı daire şeklinde yap
              color: Colors.blueGrey[200], // Container'ın arka plan rengi
            ),
            child: IconButton(
              icon: const Icon(
                Icons.home_outlined,
                size: 30,
                // color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YoneticiHomePage(),
                  ),
                );
              },
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 72,
        color: Colors.blueGrey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Emin misiniz?"),
                      content:
                          const Text("Çıkış yapmak istediğinize emin misiniz?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("İptal"),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context)
                                .pop(); // Önce alert dialogu kapat

                            // Firebase Auth çıkış yapma işlemi
                            await _auth.signOut();

                            // SharedPreferences verilerini temizle
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();

                            // Kullanıcıyı giriş sayfasına yönlendir
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Main(),
                              ),
                            );
                          },
                          child: const Text("Evet"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ), // Çıkış ikonu
                  SizedBox(width: 5.0),
                  Text(
                    'Çıkış Yap',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600),
                  ), // Çıkış yazısı
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Hata"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Veri bulunamadı"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return _isEditingProfile
              ? _buildEditProfileForm(userData)
              : _buildUserProfile(userData);
        },
      ),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Image.asset(
              //   'images/profile.jpg', // Arka plan resmi
              //   fit: BoxFit.fill,
              // ),
              CircleAvatar(
                radius: 58.0,
                backgroundImage: NetworkImage(userData['image']),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            final file = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (file == null) return;

                            String fileName = DateTime.now()
                                .microsecondsSinceEpoch
                                .toString();

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');
                            Reference referenceImagesToUpload =
                                referenceDirImages.child(fileName);

                            try {
                              await referenceImagesToUpload
                                  .putFile(File(file.path));
                              imageUrl = await referenceImagesToUpload
                                  .getDownloadURL();

                              // Burada veritabanına ekleme yapılacak
                              User? user = _auth.currentUser;
                              String userID = user!.uid;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userID)
                                  .update({
                                'image': imageUrl,
                                // Ekstra alanı ve değerini güncelle
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Profil Resminizin aktifleşmesi icin lütfen sayfayı yenileyin')));
                            } catch (error) {
                              // Hata durumunda yapılacak işlemler
                              print('Hata oluştu: $error');
                            }
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Image.network(
                                    userData['image'],
                                    fit: BoxFit
                                        .contain, // Resmi AlertDialog içinde büyük göster
                                  ),
                                );
                              },
                            );
                          },
                          child: const SizedBox(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            userData['name'],
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Rol: " + userData['roleName'],
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(
              userData['email'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(
              userData['telNo'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(
              userData['name'] + " " + userData['surname'],
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.blueGrey[200],
            ),
            onPressed: () {
              _showEditProfileDialog();
            },
            child: const Text(
              'Profil Düzenle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm(Map<String, dynamic> userData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            initialValue: userData['surname'],
            onChanged: (value) {
              _editedProfileData['surname'] = value;
            },
            decoration: const InputDecoration(
              labelText: 'Soyad',
            ),
          ),
          TextFormField(
            initialValue: userData['email'],
            onChanged: (value) {
              _editedProfileData['email'] = value;
            },
            decoration: const InputDecoration(
              labelText: 'E-posta',
            ),
          ),
          TextFormField(
            initialValue: userData['telNo'],
            onChanged: (value) {
              _editedProfileData['telNo'] = value;
            },
            decoration: const InputDecoration(
              labelText: 'Telefon Numarası',
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueGrey[200],
              ),
              onPressed: () {
                _saveProfileChanges(_editedProfileData);
              },
              child: const Text(
                'Değişiklikleri Kaydet',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 0.0),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueGrey[200],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: const Text(
                'İptal Et',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    setState(() {
      _isEditingProfile = true;
    });
  }

  void _saveProfileChanges(Map<String, dynamic> newProfileData) async {
    User? user = _auth.currentUser;
    String userID = user!.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update(newProfileData);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi')));
      setState(() {
        _isEditingProfile = false;
      });
    } catch (error) {
      print('Profil güncelleme hatası: $error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profil güncellenirken bir hata oluştu')));
    }
  }
}
