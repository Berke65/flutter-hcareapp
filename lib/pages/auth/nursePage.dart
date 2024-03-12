import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/main.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/auth/ana_sayfa.dart';

void main() {
  runApp(const nursePage());
}

class nursePage extends StatefulWidget {
  const nursePage({super.key});

  @override
  State<nursePage> createState() => _nursePageState();
}

class _nursePageState extends State<nursePage> {

  late String email , passwd;
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
                      const Row(
                        children: [
                          SizedBox(width: 100,),
                          Icon(Icons.local_hospital_rounded),
                          SizedBox(width: 5),
                          Text(
                            'Hemşire Girişi',
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
                          icon: Icons.local_hospital_outlined,
                          text: 'Giriş Yap',
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/anaSayfa');

                          }),
                      customSizedBox(),
                      CustomButton(
                        icon: Icons.lock_outline,
                        text: 'Şifremi Unuttum',
                        onPressed: () {},
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
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
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

  void signIn() async{
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        var userResult = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: passwd);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnaSayfa()));      }
      catch(e) {
        print(e.toString());
        // buraya hata yakalama gelecek , scaffold messenger ile
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
