import 'package:flutter/material.dart';

class SickDetailsPage extends StatelessWidget {
  final Map<String, dynamic> sickData;

  const SickDetailsPage({Key? key, required this.sickData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasta Detayları'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hasta Adı: ${sickData['SickName']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Hasta Notu: ${sickData['hastaNot'] ?? ""}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Sorumlu Olduğu Hemşire: ${sickData['connectedNurse'] ?? ""}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Kalıcı Hastalıklar: ${(sickData['hastaKaliciHastalik'] as List<dynamic>?)?.join(', ') ?? ""}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Kullanılan İlaçlar: ${(sickData['hastaKullanılanİlaclar'] as List<dynamic>?)?.join(', ') ?? ""}',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Hasta Kan Grubu: ${sickData['hastaKanGrup'] ?? ""}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
