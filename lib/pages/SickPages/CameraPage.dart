import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Kamera Video Görüntüleyici',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final FijkPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = FijkPlayer();
    _player.setDataSource(
      'rtsp://admin:12345678Fb@192.168.1.142:554/onvif1',
      autoPlay: true,
    ).catchError((error) {
      print('Hata: $error');
    });
  }

  @override
  void dispose() {
    _player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
      ),
      body: Center(
        child: FijkView(
          player: _player,
          panelBuilder: (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
            return const SizedBox.shrink();
          },
          fit: FijkFit.cover,
        ),
      ),
    );
  }
}