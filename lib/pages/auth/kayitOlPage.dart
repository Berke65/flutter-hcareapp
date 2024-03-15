import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/auth/ana_sayfa.dart';

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
  String? selectedOption; // Eklenen yeni combobox değeri

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
                        height: 80,
                        child: Image.asset('images/gero1.jpg'), // Logo resmi
                      ),
                      const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      customSizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              adTxtField(),
                              customSizedBox(),
                              soyadTxtField(),
                              customSizedBox(),
                              telNoTxtField(),
                              customSizedBox(),
                              emailTxtField(),
                              customSizedBox(),
                              passwdTxtField(),
                              customSizedBox(),

                              // Yeni combobox
                              DropdownButtonFormField<String>(
                                value: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOption = value;
                                  });
                                },
                                items: <String>[
                                  'Yönetim',
                                  'Hemşire',
                                  'Hasta',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration:
                                    textfielddec('Kullanıcı Tipi Seçiniz.'),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                icon: Icons.person_add_alt,
                                text: 'Kayıt Ol',
                                onPressed: () {
                                  signUp();
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
                                      builder: (context) => Main(),
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

  TextFormField adTxtField() {
    return TextFormField(
      decoration: textfielddec('Ad'),
    );
  }

  TextFormField soyadTxtField() {
    return TextFormField(
      decoration: textfielddec('Soyad'),
    );
  }

  TextFormField telNoTxtField() {
    return TextFormField(
      decoration: textfielddec('Telefon No'),
    );
  }

  TextFormField emailTxtField() {
    return TextFormField(
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
    );
  }

  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  TextFormField passwdTxtField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Şifre',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey, // Görme butonunun rengi
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lütfen şifrenizi girin';
        }
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
    );
  }

  Future<String?> signupHataYakalama(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          res = "Lütfen dogru email biciminde girin";
          break;
        case "email-already-in-use":
          res = "Bu Email Zaten Kullanımda";
          break;
        default:
          res = 'Failed with error code: ${e.code}';
          break;
      }
    }
    return res;
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await signupHataYakalama(email, password);
      if (result == 'success') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Hata'),
                content: Text(result!),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Geri dön'))
                ],
              );
            });
      }
    }
  }

  Widget customSizedBox() => const SizedBox(
        height: 8,
      );

  //textfieldların decoration
  InputDecoration textfielddec(String hintText) {
    return InputDecoration(
      // constraints: BoxConstraints(
      //   maxHeight: ,
      // ),
      hintText: hintText,
      labelText: hintText,
      // Label text'i burada ayarlayın
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
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 227,
      height: 45,
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
