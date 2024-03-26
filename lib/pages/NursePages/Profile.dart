import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/NursePages/BottomAppbarNurse.dart';
void main() {
  runApp(Profile());
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Profile UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app_outlined,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Main(),
              ),
            );
          },
        ),
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Software Developer',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text('john.doe@example.com'),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text('+1234567890'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('New York, USA'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle edit profile button tap
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppbarNurse(context),
    );
  }
}


