import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/YoneticiPages/bottomAppBarYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/userTile.dart';
import 'chatPage.dart';
// import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';

void main() {
  runApp(const YoneticiChat());
}

class YoneticiChat extends StatefulWidget {
  const YoneticiChat({super.key});

  @override
  State<YoneticiChat> createState() => _YoneticiChatState();
}

class _YoneticiChatState extends State<YoneticiChat> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 21, // Başlık ile diğer öğeler arasındaki boşluğu sıfıra ayarlar
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.message_outlined),
            SizedBox(width: 8), // İkon ile başlık arasına bir boşluk ekler
            Text('Sohbet'),
          ],
        ),
        automaticallyImplyLeading: false, // Geri tuşunu kaldırır
      ),

      body: _buildUserList(),
      bottomNavigationBar: BottomAppBarYonetici(context),

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
          text: userData['name'],
          txt: '...',
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
          });
    } else {
      return Container();
    }
  }
}
