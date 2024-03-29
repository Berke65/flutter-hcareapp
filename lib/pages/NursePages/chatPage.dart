import 'package:flutter/material.dart';
import 'package:hcareapp/pages/NursePages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/NursePages/BottomAppbarNurse.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Send message function
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // Clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Colors.white, // AppBar'ın arka plan rengi
        iconTheme:
            const IconThemeData(color: Colors.black), // Geri butonunun rengi
      ),
      body: Column(
        children: [
          // Tüm mesajları göster
          Expanded(
            child: _buildMessageList(),
          ),
          // Kullanıcı girişi
          _buildUserInput(),
        ],
      ),
      bottomNavigationBar: BottomAppbarNurse(context),
    );
  }

  // Alt gezinme öğesi oluşturma
  Widget _buildBottomNavItem(IconData icon, String label, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Mesaj listesini oluşturma
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // Hatalar
        if (snapshot.hasError) {
          return const Center(child: Text("Hata"));
        }

        // Yükleniyor
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Liste görünümü döndür
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isCurrentUser =
                data['senderID'] == _authService.getCurrentUser()!.uid;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  data['message'],
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                    backgroundColor: isCurrentUser ? Colors.blue : Colors.white,
                    // borderRadius: BorderRadius.circular(8),
                    // padding: EdgeInsets.all(12),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Kullanıcı girişi oluşturma
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text alanı en çok boşluğu kaplamalı
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Mesajınızı buraya yazın', // Placeholder metni
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8), // İçerik dolgusu
                border: OutlineInputBorder(
                  // Kenarlık
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Colors.blue), // Kenarlık rengi
                ),
              ),
            ),
          ),
          // Gönder butonu
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
