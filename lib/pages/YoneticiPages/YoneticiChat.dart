import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/userTile.dart';
import 'package:hcareapp/services/auth_services.dart';

import 'chatPage.dart';
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
    );
  }
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context , snapshot) {
        if(snapshot.hasError)
          {
            return const Text('Error');
          }
        if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Text('loading');
          }
        return ListView(
          children:
            snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData , context)).toList(),
        );
      },
    );
  }
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {

    if(userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData['email'],
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
              receiverEmail: userData['email'],
              receiverID: userData['uid'],
            ),));
          }
      );
    } else {
      return Container();
    }
  }
}


