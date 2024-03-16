import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/auth/ana_sayfa.dart';
import 'package:hcareapp/services/auth_services.dart';

class kayitOlPage extends StatefulWidget {
  const kayitOlPage({Key? key}) : super(key: key);

  @override
  _kayitOlPageState createState() => _kayitOlPageState();
}

class _kayitOlPageState extends State<kayitOlPage> {
  late String ad, soyad, telNo, email, password;
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;



  String? selectedOption;
  String? adHataMesaji;
  String? soyadHataMesaji;
  String? telNoHataMesaji;
  String? emailHataMesaji;
  String? sifreHataMesaji;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bakalım1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.15,
                  child: Image.asset('images/gero1.jpg'),
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
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      adTxtField(),
                      adHataMesaji != null ? Text(adHataMesaji!, style: TextStyle(color: Colors.red)) : Container(),
                      customSizedBox(),
                      soyadTxtField(),
                      soyadHataMesaji != null ? Text(soyadHataMesaji!, style: TextStyle(color: Colors.red)) : Container(),
                      customSizedBox(),
                      telNoTxtField(),
                      telNoHataMesaji != null ? Text(telNoHataMesaji!, style: TextStyle(color: Colors.red)) : Container(),
                      customSizedBox(),
                      emailTxtField(),
                      emailHataMesaji != null ? Text(emailHataMesaji!, style: TextStyle(color: Colors.red)) : Container(),
                      customSizedBox(),
                      passwdTxtField(),
                      sifreHataMesaji != null ? Text(sifreHataMesaji!, style: TextStyle(color: Colors.red)) : Container(),
                      customSizedBox(),

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
                        decoration: textfielddec('Kullanıcı Tipi Seçiniz.'),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        icon: Icons.person_add_alt,
                        text: 'Kayıt Ol',
                        onPressed: signUp,
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
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lütfen adınızı girin';
        }
        return null;
      },
      onSaved: (value) {
        ad = value!;
      },
    );
  }

  TextFormField soyadTxtField() {
    return TextFormField(
      decoration: textfielddec('Soyad'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lütfen soyadınızı girin';
        }
        return null;
      },
      onSaved: (value) {
        soyad = value!;
      },
    );
  }

  TextFormField telNoTxtField() {
    return TextFormField(
      decoration: textfielddec('Telefon No'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lütfen telefon numaranızı girin';
        }
        return null;
      },
      onSaved: (value) {
        telNo = value!;
      },
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
            color: Colors.grey,
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

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
        final result = await authService().signupHataYakalama(email, password, ad, soyad);
        if (result == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AnaSayfa()),
          );
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
                    child: const Text('Geri dön'),
                  )
                ],
              );
            },
          );
        }
      }
    }
  }


  Widget customSizedBox() => const SizedBox(
    height: 8,
  );

  InputDecoration textfielddec(String hintText) {
    return InputDecoration(
      hintText: hintText,
      labelText: hintText,
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

