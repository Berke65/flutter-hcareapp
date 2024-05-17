import 'package:flutter/material.dart';

class SickDetailsPage extends StatelessWidget {
  final Map<String, dynamic> sickData;

  const SickDetailsPage({Key? key, required this.sickData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: const Text(
          'Hasta Detayları',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16), // Add padding
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade200,
            borderRadius: BorderRadius.circular(12), // Add rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hasta Adı: ${sickData['SickName']}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Colors.black,
              ),
              buildSizedBox(),
              Text(
                'Hasta Notu: ',
                style: buildTextStyleBaslik(),
              ),
              Text(
                '${sickData['hastaNot'] ?? ""}',
                style: buildTextStyleIcerik(),
              ),
              buildSizedBox(),
              Text(
                'Sorumlu Olduğu Hemşire: ',
                style: buildTextStyleBaslik(),
              ),
              Text(
                '${sickData['connectedNurse'] ?? ""}',
                style: buildTextStyleIcerik(),
              ),
              buildSizedBox(),
              Text(
                'Kalıcı Hastalıklar: ',
                style: buildTextStyleBaslik(),
              ),
              Text(
                '${(sickData['hastaKaliciHastalik'] as List<dynamic>?)?.join(', ') ?? ""}',
                style: buildTextStyleIcerik(),
              ),
              buildSizedBox(),
              Text(
                'Kullanılan İlaçlar: ',
                style: buildTextStyleBaslik(),
              ),
              Text(
                '${(sickData['hastaKullanılanİlaclar'] as List<dynamic>?)?.join(', ') ?? ""}',
                style: buildTextStyleIcerik(),
              ),
              buildSizedBox(),
              Text(
                'Hasta Kan Grubu: ',
                style: buildTextStyleBaslik(),
              ),
              Text(
                '${sickData['hastaKanGrup'] ?? ""}',
                style: buildTextStyleIcerik(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle buildTextStyleIcerik() => TextStyle(
      color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400);

  TextStyle buildTextStyleBaslik() => TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87);

  SizedBox buildSizedBox() => const SizedBox(height: 10);
}
