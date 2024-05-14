import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/pages/NursePages/authService.dart';
import 'package:hcareapp/pages/NursePages/chatService.dart';
import 'package:hcareapp/pages/NursePages/userTile.dart';
import 'ChatPage.dart';
import 'Profile.dart';
import 'NurseMedicine.dart';
import 'NursePageHome.dart';

void main() {
  runApp(const NurseChat());
}

class NurseChat extends StatefulWidget {
  const NurseChat({Key? key}) : super(key: key);

  @override
  _NurseChatState createState() => _NurseChatState();
}

class _NurseChatState extends State<NurseChat> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  String selectedRole = 'Yönetim'; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 22,
        actions: [
          Container(
            margin: EdgeInsets.all(5.0), // Container'ın kenar boşlukları
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Container'ı daire şeklinde yap
              color: Colors.grey[200], // Container'ın arka plan rengi
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
              Container(
                width: 1,
                height: 25,
                color: Colors.black,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole = 'Hasta';
                  });
                },
                child: Text('Hasta'),
              ),
              Container(
                width: 1,
                height: 25,
                color: Colors.black,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // BottomAppBar'ın arka plan rengini beyaza ayarladık
        elevation: .0,
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
                  Icon(Icons.home_outlined,size: 30,),
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
                  Icon(Icons.local_pharmacy_outlined,size: 30,),
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
              onTap: () {},
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.message,size: 30,),
                  Text(
                    'Sohbet',
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
