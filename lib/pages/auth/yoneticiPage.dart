import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/main.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/pages/auth/ana_sayfa.dart';
import 'package:hcareapp/services/auth_services.dart';

void main() {
  runApp(const yoneticiPage());
}

class yoneticiPage extends StatefulWidget {
  const yoneticiPage({super.key});

  @override
  State<yoneticiPage> createState() => _yoneticiPageState();
}

class _yoneticiPageState extends State<yoneticiPage> {

  late String email , passwd;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

  TextEditingController forgotPasswdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bakalım1.png'), // Arka plan deseni
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.asset('images/gero1.jpg'), // Logo resmi
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 100,
                            ),
                            Icon(Icons.business_center),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Yönetici Girişi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        emailTextField(),
                        customSizedBox(),
                        passwdTxtField(),
                        customSizedBox(),
                        customSizedBox(),
                        CustomButton(
                          icon: Icons.admin_panel_settings_outlined,
                          text: 'Giriş Yap',
                          onPressed: signIn,
                        ),
                        customSizedBox(),
                        CustomButton(
                          icon: Icons.lock_outlined,
                          text: 'Şifremi Unuttum',
                          onPressed: forgotPasswd,
                        ),
                        customSizedBox(),
                        CustomButton(
                          icon: Icons.home_outlined,
                          text: 'Ana Ekrana Dön',
                          onPressed: () {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      controller: forgotPasswdController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Bilgileri Eksiksiz Doldurunuz";
        } else {}
      },
      onSaved: (value) {
        email = value!;
      },
    );
  }

  TextFormField passwdTxtField() {
    return TextFormField(
      validator: (value){
        if(value!.isEmpty)
        {
          return 'Bilgileri Eksiksiz Doldurunuz';
        }
      },
      onSaved: (value){
        passwd = value!;
      },
      obscureText: true,
    );
  }

  void forgotPasswd() async {
      try {
        await firebaseAuth.sendPasswordResetEmail(email: forgotPasswdController.text.trim());
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: Text('Şifre Yenileme linki gönderildi. Lütfen Email Gelen Kutunuzu Kontrol Ediniz'),
          );
        }
        );
      } on FirebaseAuthException catch (e) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: Text('Lütfen email kısmını bos bırakmayınız'),
          );
        }
        );
      }
}

  Future<String?> signInHataYakalama(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email": // calısıyor
          res = "Lütfen dogru email biciminde girin";
          break;
        case "invalid-credential":
          res = "Kullanıcı adı veya şifre hatalı";
          break;
        case "invalid-credential":
          res = "Kullanıcı adı veya şifre hatalı";
          break;
        case "user-disabled": // calısıyor
          res = "Kullanici Pasif";
          break;
        default:
          res ='Failed with error code: ${e.code}';
          break;
      }
    }
    return res;
  }


  void signIn() async{
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await signInHataYakalama(email, passwd);
      if(result == 'success')
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnaSayfa()));
      }
      else {
        showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Hata'),
                content: Text(result!),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context),
                      child: Text('Geri dön'))
                ],
              );
            }
        );
      }
    }
  }

  //textfield'lar
  TextFormField txtfield(String hinttext, bool obsocureText) {
    return TextFormField(
      decoration: textfielddec(hinttext),
      obscureText: obsocureText,
    );
  }
}



//textfieldların decoration;
InputDecoration textfielddec(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.black45,
      fontSize:18,
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder:const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
  );
}

Widget customSizedBox() => const SizedBox(
  height: 20,
);

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      height: 55,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Colors.black,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Arial',
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
