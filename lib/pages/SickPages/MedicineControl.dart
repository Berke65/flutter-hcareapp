import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/BottomAppBarSick.dart';
import 'package:hcareapp/main.dart';
void main() {
  runApp(MedicineControl());
}

class MedicineControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hemşire İlaç Takip'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Bir önceki sayfaya geri dön
          },
        ),
      ),
      body: MedicationList(),
      bottomNavigationBar: BottomAppBarSick(context),
    );
  }
}


class MedicationSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hemşire İlaç Takip'),
      ),
      body: MedicationList(),
      bottomNavigationBar: BottomAppBarSick(context),

    );
  }
}

class MedicationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Örnek olarak 5 ilaç listelendi
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('İlaç ${index + 1}'),
          subtitle: Text('Saatler: Sabah, Öğle, Akşam'),
          onTap: () {
            // İlaç detayları sayfasına yönlendirme eklenebilir
          },
        );
      },
    );
  }
}
