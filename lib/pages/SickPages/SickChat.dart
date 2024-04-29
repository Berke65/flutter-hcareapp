import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/SickPages/BottomAppBarSick.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/userTile.dart';
import 'ChatPage.dart';

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
      appBar: AppBar(
        titleSpacing: 21,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                //style:  ButtonStyle(textStyle:  ),
                onPressed: () {
                  setState(() {
                    selectedRole = 'Yönetim';
                  });
                },
                child: Text('Yönetim'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole = 'Hasta';
                  });
                },
                child: Text('Hasta'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole = 'Hemşire';
                  });
                },
                child: Text('Hemşire'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildUserList(),
        ],
      ),
      bottomNavigationBar: BottomAppBarSick(context),
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
        final filteredUsers = snapshot.data!.where((userData) =>
        userData['roleName'] == selectedRole
        ).toList();
        return Expanded(
          child: ListView(
            children: filteredUsers
                .map<Widget>((userData) =>
                _buildUserListItem(userData, context))
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
        txt: '...',
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
