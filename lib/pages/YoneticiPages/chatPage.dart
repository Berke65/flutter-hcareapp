import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/YoneticiPages/AnaSayfaYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/RandevuYonetici.dart';
import 'package:hcareapp/pages/YoneticiPages/Profile.dart';
import 'package:hcareapp/pages/YoneticiPages/YoneticiChat.dart';
import 'package:google_fonts/google_fonts.dart';

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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // BottomAppBar'ın arka plan rengi
        elevation: 1.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(
                Icons.home_outlined,
                'Anasayfa',
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnaSayfaYonetici()))),
            _buildBottomNavItem(
                Icons.calendar_today,
                'Randevu',
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RandevuYonetici()))),
            _buildBottomNavItem(
                Icons.chat,
                'Sohbet',
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsersChat()))),
            _buildBottomNavItem(
                Icons.account_circle_outlined,
                'Profil',
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileYonetici()))),
          ],
        ),
      ),
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
            bool isCurrentUser = data['senderId'] ==
                receiverID; // Gönderici, alıcı ile eşleşiyorsa, bu mesaj mevcut kullanıcı tarafından gönderildi demektir.
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: isCurrentUser
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    data['message'],
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.5,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// data['message']
/* Container(
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 17),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.person_outline),
            const SizedBox(width: 20,),
            Text(
              text,
              style: GoogleFonts.tauri(
                textStyle: TextStyle(color: Colors.black, letterSpacing: .5),
              ),
            ),
          ],
        ),
      ),*/

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
