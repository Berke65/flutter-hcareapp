import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hcareapp/pages/NursePages/BottomAppbarNurse.dart';
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
      appBar: AppBar(
        title: const Text('Kullanıcı Profilim'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(_auth.currentUser!.uid).get(),
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
      bottomNavigationBar: BottomAppbarNurse(context),
    );
  }

  Widget _buildUserProfile(Map<String, dynamic> userData) {
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
                    padding: const EdgeInsets.all(8.0),
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
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil Resminizin aktifleşmesi icin lütfen sayfayı yenileyin')));
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
                      child: const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
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
          Text("rol: " +
            userData['roleName'],
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(userData['email']),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(userData['telNo']),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(userData['name'] + " " + userData['surname']),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _showEditProfileDialog();
            },
            child: const Text('Profil Düzenle'),
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
            initialValue: userData['name'],
            onChanged: (value) {
              _editedProfileData['name'] = value;
            },
            decoration: const InputDecoration(
              labelText: 'Ad',
            ),
          ),
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
          ElevatedButton(
            onPressed: () {
              _saveProfileChanges(_editedProfileData);
            },
            child: const Text('Değişiklikleri Kaydet'),
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
      await FirebaseFirestore.instance.collection('users').doc(userID).update(newProfileData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil başarıyla güncellendi')));
      setState(() {
        _isEditingProfile = false;
      });
    } catch (error) {
      print('Profil güncelleme hatası: $error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil güncellenirken bir hata oluştu')));
    }
  }
}
