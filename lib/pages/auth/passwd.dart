import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(passwd());
}

class passwd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //halledersin buraları hata yorum satırı yaptım yavru
      // title: 'Geropital',
      // routes: {
      //   "/girisYap": (context) => GirisYap(),
      //   "/kayitOl": (context) => kayitOlPage(),
      //   "/anaSayfa": (context) => AnaSayfa(),
      // },
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bakalım1.png'),
                      // Arka plan deseni
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 100,
                          child: Image.asset('images/gero1.jpg'), // Logo resmi
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
