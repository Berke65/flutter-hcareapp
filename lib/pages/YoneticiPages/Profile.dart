import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:hcareapp/services/auth_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profilim'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Veri bulunamadı"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(userData['image']),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {

                          final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (file == null) return;

                          String fileName = DateTime.now().microsecondsSinceEpoch.toString();

                          Reference referenceRoot = FirebaseStorage.instance.ref();
                          Reference referenceDirImages = referenceRoot.child('images');
                          Reference referenceImagesToUpload = referenceDirImages.child(fileName);

                          try {
                            await referenceImagesToUpload.putFile(File(file.path));
                            imageUrl = await referenceImagesToUpload.getDownloadURL();

                            // Burada veritabanına ekleme yapılacak
                            User? user = _auth.currentUser;
                            String userID = user!.uid;

                            await FirebaseFirestore.instance.collection('users').doc(userID).update({
                              'image': imageUrl, // Ekstra alanı ve değerini güncelle
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profil Resminizin aktifleşmesi icin lütfen sayfayı yenileyin')));
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
                                    fit: BoxFit.contain, // Resmi AlertDialog içinde büyük göster
                                  ),
                                );
                              },
                            );
                          },
                        child: SizedBox(), // Metni kaldırmak için boş bir SizedBox kullanıyoruz
                      ),
                    ),
                  ),
                ],
              ),
            ),
              SizedBox(height: 16.0),
                Text(
                  userData['name'],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  userData['roleName'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.0),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(userData['email']),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(userData['telNo']),
                ),
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(userData['surname']),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Profil düzenleme ekranına yönlendirme işlemleri
                  },
                  child: Text('Profil Düzenle'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: 1.0,
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
                    builder: (context) => const YoneticiChat(),
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
                    builder: (context) => ProfileScreen(),
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
