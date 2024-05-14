import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; // Ekleme

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;

class authService {

  Future<void> addDropdownValuesToFirestore({
    required BuildContext context,
    required String? selectedNurse,
    required String? selectedSick,
  }) async {
    try {


      await FirebaseFirestore.instance.collection('nurseSickMatch').add({
        'nurseName': selectedNurse,
        'SickName': selectedSick,
      });



      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('hastaBilgileri')
          .where('SickName', isEqualTo: selectedSick)
          .get();

// Belirli bir sorgu sonucunda dönen belgeleri doğrudan kullanarak yeni sütun ekleyin
      await Future.forEach(querySnapshot.docs, (DocumentSnapshot<Map<String, dynamic>> doc) async {
        await FirebaseFirestore.instance.collection('hastaBilgileri').doc(doc.id).set({
          'connectedNurse': selectedNurse
        }, SetOptions(merge: true));
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
          res = "Lütfen doğru E-Mail biçiminde girin";
          break;
        case "email-already-in-use":
          res = "Bu E-mail Zaten Kullanımda";
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
