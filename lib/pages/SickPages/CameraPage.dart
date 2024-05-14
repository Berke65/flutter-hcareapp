import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:hcareapp/pages/SickPages/SickHomePage.dart';

void main() {
  runApp(const CameraPage());
}

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Kamera Video Görüntüleyici',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraPageState(),
    );
  }
}

class CameraPageState extends StatefulWidget {
  @override
  _CameraPageStateState createState() => _CameraPageStateState();
}

class _CameraPageStateState extends State<CameraPageState> {
  late final VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://admin:12345678Fb@192.168.1.45:554/onvif1',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SickAnasayfa(),
                ),
              );
            },
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text('Kamera'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
