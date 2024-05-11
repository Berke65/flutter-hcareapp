import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; // Ekleme

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;

class authService {
  Future<List<Map<String, dynamic>>> getPairedValues() async {
    try {
      List<Map<String, dynamic>> pairedValues = [];

      // Veritabanından belirli koleksiyondaki tüm belgeleri al
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('nurseSickMatch').get();

      // Her bir belgeyi dön ve eşleştirilmiş değerleri listeye ekle
      querySnapshot.docs.forEach((doc) {
        pairedValues.add({
          'nurse': doc['nurseName'],
          'sick': doc['SickName'],
        });
      });

      return pairedValues;
    } catch (e) {
      print('Error getting paired values: $e');
      return [];
    }
  }

  Future<void> showPairedValuesPopup(BuildContext context) async {
    try {
      List<Map<String, dynamic>> pairedValues = await getPairedValues();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eşleştirilmiş Kişiler'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Genişliği ayarla
              child: pairedValues.isEmpty
                  ? const Text('Eşleştirilmiş kişiler bulunamadı.')
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: pairedValues.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Hemşire: ${pairedValues[index]['nurse']}, Hasta: ${pairedValues[index]['sick']}',
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing paired values popup: $e');
    }
  }

  Future<void> removePairedValuesPopup(BuildContext context) async {
    try {
      List<Map<String, dynamic>> pairedValues = await getPairedValues();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eşleştirilmiş Kişiler'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Genişliği ayarla
              child: pairedValues.isEmpty
                  ? const Text('Eşleştirilmiş kişiler bulunamadı.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: pairedValues.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Hemşire: ${pairedValues[index]['nurse']}',
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Hasta: ${pairedValues[index]['sick']}',
                              ),
                              trailing: TextButton(
                                onPressed: () {
                                  // Burada kaldırma işlemi yapılacak
                                },
                                child: const Text(
                                  'Kaldır',
                                  style: TextStyle(
                                      color: Colors.red), // Kırmızı renkte metin
                                ),
                              ),
                            ),
                            const Divider(), // Her öğe arasına bir ayırıcı ekleyelim
                          ],
                        );
                      },
                    ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error showing paired values popup: $e');
    }
  }

  Future<void> addDropdownValuesToFirestore({
    required BuildContext context,
    required String? selectedNurse,
    required String? selectedSick,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('nurseSickMatch').add({
        'SickName': selectedNurse,
        'nurseName': selectedSick,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Başarıyla Eşleştirildi')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'), // const kaldırıldı
        ),
      );
    }
  }

  Future<String?> signupHataYakalama(String email, String password, String ad,
      String soyad, String telNo, String roleName, String bosImage) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      bosImage =
          'https://firebasestorage.googleapis.com/v0/b/hcareapp-ee339.appspot.com/o/images%2Fdefaul_user.jpg?alt=media&token=9758a7d1-027e-4a31-901e-40bd6b1d5ad6';

      // Kullanıcı başarıyla kaydedildiyse
      if (result.user != null) {
        String uid = result.user!.uid; // Kullanıcının UID'sini al

        // Firestore'a kullanıcı bilgilerini ekle
        try {
          await firebaseFirestore.collection('users').doc(uid).set({
            'uid': uid, // Kullanıcının UID'sini ekleyin
            'email': email,
            'name': ad,
            'surname': soyad,
            'telNo': telNo,
            'roleName': roleName,
            'image': bosImage,
          });
          res = "success";
        } catch (e) {
          print('Firestore veri ekleme hatası: $e');
          res = "Bir hata oluştu, lütfen tekrar deneyin.";
        }
      } else {
        res = "Kullanıcı kaydedilirken bir hata oluştu.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          res = "Lütfen doğru email biçiminde girin";
          break;
        case "email-already-in-use":
          res = "Bu Email Zaten Kullanımda";
          break;
        case "weak-password":
          res = "Lütfen 8 karakter üstünde bir parola giriniz";
          break;
        default:
          res = 'Hata kodu: ${e.code}';
          break;
      }
    } catch (e) {
      print('Bilinmeyen bir hata oluştu: $e');
      res = "Bir hata oluştu, lütfen tekrar deneyin.";
    }
    return res;
  }
}
