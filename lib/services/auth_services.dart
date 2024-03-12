import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/pages/auth/kayitOlPage.dart';

class AuthService { // bütün giris islemleri burada yapılacak , kayıt ol  , giris yap , misafir girisi vb.
  final firebaseAuth = FirebaseAuth.instance;

  Future signInAnonymous() async { // uzun süreli bir islem olacaksa giris islemleri gibi async yani asenkron kullanılır
    try {
      final result = await firebaseAuth.signInAnonymously(); // await ve async ye tam olarak bakılacak
      print(result.user!.uid);
      return result.user;
    } catch(e) {
      print('Anonymous error .$e');
      return null;
    }
  }

  Future ForgotPasswd(String email) async {
    try {
      final result = firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(e) {}
  }

  Future<String?> signIn(String email, String passwd) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: passwd);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          res = "Kullanici Bulunamadi";
          break;
        case "wrong-password":
          res = "Hatali Sifre";
          break;
        case "user-disabled":
          res = "Kullanici Pasif";
          break;
        default:
          res = "error: $e";
          break;
      }
    }
    return res;
  }

}