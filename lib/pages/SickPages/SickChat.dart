import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/pages/SickPages/SickInformation.dart';
import 'package:hcareapp/pages/SickPages/Sickinfopage.dart';
import 'package:hcareapp/pages/SickPages/authService.dart';
import 'package:hcareapp/pages/SickPages/chatService.dart';
import 'package:hcareapp/pages/SickPages/userTile.dart';
import 'ChatPage.dart';
import 'Profile.dart';
import 'SickHomePage.dart';

void main() {
  runApp(const SickChat());
}

class SickChat extends StatefulWidget {
  const SickChat({Key? key}) : super(key: key);

  @override
  _SickChatState createState() => _SickChatState();
}

class _SickChatState extends State<SickChat> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  String selectedRole = 'Yönetim'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        titleSpacing: 22,
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0), // Container'ın kenar boşlukları
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Container'ı daire şeklinde yap
              color: Colors.blueGrey[200], // Container'ın arka plan rengi
            ),
            child: IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.message_outlined),
            SizedBox(width: 8),
            Text('Sohbet'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: buildStyleFrom(),
                onPressed: () {
                  setState(() {
                    selectedRole = 'Yönetim';
                  });
                },
                child: const Text(
                  'Yönetim',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 25,
                color: Colors.black,
              ),
              ElevatedButton(
                style: buildStyleFrom(),
                onPressed: () {
                  setState(() {
                    selectedRole = 'Hemşire';
                  });
                },
                child: const Text(
                  'Hemşire',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildUserList(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey.shade300,
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SickAnasayfa(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    color: Colors.white,
                    Icons.home_outlined,
                    size: 30,
                  ),
                  Text(
                    'Anasayfa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SickInfoPage(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    'Sağlık Bilgilerim',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.white,
            ),
            InkWell(
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.message,
                    size: 30,
                    color: Colors.white,
                  ),
                  Text(
                    'Sohbet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle buildStyleFrom() {
    return ElevatedButton.styleFrom(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.blueGrey[400],
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Filtreleme işlemi
        final filteredUsers = snapshot.data!
            .where((userData) => userData['roleName'] == selectedRole)
            .toList();
        return Expanded(
          child: ListView(
            children: filteredUsers
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['name'],
        roleTxt: userData['roleName'],
        imageProvider: NetworkImage(userData['image']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['name'],
                receiverID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
