import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';

void main() {
  runApp(const kayitOlPage());
}

class kayitOlPage extends StatefulWidget {
  const kayitOlPage({Key? key}) : super(key: key);

  @override
  _kayitOlPageState createState() => _kayitOlPageState();
}

class _kayitOlPageState extends State<kayitOlPage> {
  late String email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;

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
                      const SizedBox(height: 20),
                      const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: textfielddec('E-Posta'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Lütfen e-posta adresinizi girin';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: textfielddec('Şifre'),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Lütfen şifrenizi girin';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                icon: Icons.person_add_alt,
                                text: 'Kayıt Ol',
                                onPressed: () {
                                  _submitForm();
                                },
                              ),
                              const SizedBox(height: 20),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Kayıt başarılı olduğunda bir sonraki sayfaya yönlendirme yapılabilir.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kayıt başarılı , Giriş Sayfasına Yönlendiriliyorsunuz'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/girisYap');
      } catch (e) {
        print('Kayıt olma hatası: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt olma hatası: $e'),
          ),
        );
      }
    }
  }

  //textfieldların decoration
  InputDecoration textfielddec(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.black45,
        fontSize: 18,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
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
