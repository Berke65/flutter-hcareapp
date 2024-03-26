import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/NursePages/chatService.dart';
import 'package:hcareapp/pages/NursePages/userTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatPage.dart';

import 'package:flutter/material.dart';
import 'package:hcareapp/pages/NursePages/NursePageHome.dart';
import 'package:hcareapp/pages/NursePages/NurseMedicine.dart';
import 'package:hcareapp/pages/NursePages/NurseChat.dart';
import 'package:hcareapp/pages/NursePages/Profile.dart';

void main() {
  runApp(UsersChat());
}

class UsersChat extends StatefulWidget {
  const UsersChat({super.key});

  @override
  State<UsersChat> createState() => _UsersChatState();
}

class _UsersChatState extends State<UsersChat> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: _buildUserList(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NursePageHome(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_outlined),
                  Text(
                    'Anasayfa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NurseMedicine(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_pharmacy),
                  Text(
                    'İlaç Kontrolü',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersChat(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat),
                  Text(
                    'Sohbet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle_outlined),
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData['email'],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData['email'],
                  receiverID: userData['uid'],
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}
