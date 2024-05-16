import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/auth/GirisYap.dart';
import 'package:hcareapp/services/auth_services.dart';
//as
void main() {
  runApp(const kayitOlPage());
}
class kayitOlPage extends StatefulWidget   {
  const kayitOlPage({Key? key}) : super(key: key);

  @override
  _kayitOlPageState createState() => _kayitOlPageState();
}

class _kayitOlPageState extends State<kayitOlPage> {
  late String ad, soyad, telNo, email, password;
  String bosImage =
      'https://firebasestorage.googleapis.com/v0/b/hcareapp-ee339.appspot.com/o/images%2Fdefaul_user.jpg?alt=media&token=9758a7d1-027e-4a31-901e-40bd6b1d5ad6';
  final formKey = GlobalKey<FormState>();
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? girilenKod;
  String? rolName;
  String? adHataMesaji;
  String? soyadHataMesaji;
  String? telNoHataMesaji;
  String? emailHataMesaji;
  String? sifreHataMesaji;
  String? kodHataMesaji;

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
          // scrollDirection: Axis.vertical,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Yeni ekleme
                  children: [
                    Icon(
                      Icons.add_circle_outline_sharp,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                customSizedBox(),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      adTxtField(),
                      adHataMesaji != null
                          ? Text(adHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
                      soyadTxtField(),
                      soyadHataMesaji != null
                          ? Text(soyadHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
                      telNoTxtField(),
                      telNoHataMesaji != null
                          ? Text(telNoHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
                      emailTxtField(),
                      emailHataMesaji != null
                          ? Text(emailHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
                      passwdTxtField(),
                      sifreHataMesaji != null
                          ? Text(sifreHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
                      DropdownButtonFormField<String>(
                        value: rolName,
                        onChanged: (value) {
                          setState(() {
                            rolName = value;
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
                      customSizedBox(),
                      kodTxtField(),
                      kodHataMesaji != null
                          ? Text(kodHataMesaji!,
                              style: const TextStyle(color: Colors.red))
                          : Container(),
                      customSizedBox(),
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

  TextFormField kodTxtField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration:textfielddec('Verilen Kodu Giriniz'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Lütfen kodu giriniz';
        }
        return null;
      },
      onSaved: (value) {
        girilenKod = value!;
      },
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

  Future<void> getDataFromFirestore(String documentId) async {
    if (rolName == 'Yönetim') {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('Yönetim').doc(documentId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? userData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('code')) {
            String userCode = userData['code'] as String;
            print('Firestore Verisi (code): $userCode');
            print('$userCode');
          } else {
            print('Belge verisi veya code alanı bulunamadı.');
          }
        } else {
          print('Belirtilen belge bulunamadı.');
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else if (rolName == 'Hemşire') {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('hemsire').doc(documentId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? userData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('code')) {
            String userCode = userData['code'] as String;
            print('Firestore Verisi (code): $userCode');
            print('$userCode');
          } else {
            print('Belge verisi veya code alanı bulunamadı.');
          }
        } else {
          print('Belirtilen belge bulunamadı.');
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else if (rolName == 'Hasta') {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('hasta').doc(documentId).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic>? userData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('code')) {
            String userCode = userData['code'] as String;
            print('Firestore Verisi (code): $userCode');
            print('$userCode');
          } else {
            print('Belge verisi veya code alanı bulunamadı.');
          }
        } else {
          print('Belirtilen belge bulunamadı.');
        }
      } catch (e) {
        print('Hata oluştu: $e');
      }
    } else {
      print('Belirtilen rol için veri çekme izni yok.');
    }
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        // Firestore'dan veriyi doğrudan çekme
        DocumentSnapshot<Map<String, dynamic>> kodData;

        if (rolName == 'Yönetim') {
          kodData = await FirebaseFirestore.instance
              .collection('yonetim')
              .doc('aaa')
              .get();
        } else if (rolName == 'Hemşire') {
          kodData = await FirebaseFirestore.instance
              .collection('hemsire')
              .doc('aaa')
              .get();
        } else if (rolName == 'Hasta') {
          kodData = await FirebaseFirestore.instance
              .collection('hasta')
              .doc('aaa')
              .get();
        } else {
          // Tanımlı olmayan rol için işlem yapma
          print('Hatalı rol seçimi!');
          return;
        }

        if (kodData.exists && kodData.data()!['code'] == girilenKod) {
          // Kodlar eşleştiğinde kayıt işlemi devam eder
          final result = await authService().signupHataYakalama(
            email,
            password,
            ad,
            soyad,
            telNo,
            rolName!,
            bosImage,
          );
          if (result == 'success') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GirisYap()),
            );
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text('Kayıt'),
                    content: Text('Kayıt İşlemi Başarılı'),
                  );
                });
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
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Kodlar eşleşmezse hata mesajı göster
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Hata'),
                content:
                    const Text('Girilen kod yanlış! Lütfen tekrar deneyin.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tamam'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Hata oluştu: $e');
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
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

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


