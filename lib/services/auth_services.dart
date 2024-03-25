import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseAuth = FirebaseAuth.instance;
final firebaseFirestore = FirebaseFirestore.instance;

class authService {
  Future<String?> signupHataYakalama(String email, String password, String ad,
      String soyad, String telNo, String roleName) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

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
