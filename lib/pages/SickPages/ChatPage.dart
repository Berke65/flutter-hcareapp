import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/YoneticiPages/bottomAppBarYonetici.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // fbase messaging

  // for textfield focus

  FocusNode myFocusNode = FocusNode();
  String userProfileImageURL = '';

  @override
  void initState() {
    super.initState();
    //add listener to focus mode
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time show up
        //then the amount of remaining space will be calculated,
        // the scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
              () => scrollDown(),
        );
      }
    });
    // wait a bit for listview to be built , then scroll the bottom
    Future.delayed(
      const Duration(milliseconds: 500),
          () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  // Send message function
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      // Send the message
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      scrollDown();

      // Clear text controller
      _messageController.clear();
    }
    getUserProfileImageURL(widget.receiverID).then((url) {
      setState(() {
        userProfileImageURL = url;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Profil resmi
            CircleAvatar(
              backgroundImage: userProfileImageURL.isNotEmpty
                  ? NetworkImage(userProfileImageURL)
                  : AssetImage('assets/default_avatar.jpg') as ImageProvider, // Varsayılan bir avatar ekleyebilirsiniz
              radius: 20,
            ),

            SizedBox(width: 8), // Resim ile başlık arasındaki boşluk
            Text(widget.receiverEmail),
          ],
        ),
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
      bottomNavigationBar: BottomAppBarYonetici(context),
    );
  } // resim sonra bakılacak !!!!!!!

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
  // Firestore'dan kullanıcının profil resim URL'sini almak için bir metod
  Future<String> getUserProfileImageURL(String userID) async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    // Kullanıcının belgesinden "image" alanını döndür
    return userDoc['image'] ?? ''; // Eğer image alanı yoksa veya boşsa, boş bir string döndürür
  }


// Mesaj listesini oluşturma
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isCurrentUser = data['senderId'] == widget.receiverID;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: isCurrentUser
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          0.7, // Max genişlik ayarı
                    ),
                    decoration: BoxDecoration(
                      color:
                      isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['message'],
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.5,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                  // Saat bilgisinden mesaj kutusuna bir boşluk ekleyin
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(data['timestamp'].toDate()),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 2), // İki column arasına boşluk ekleyin
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //okundu bilgisi



// data['message']
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text alanı en çok boşluğu kaplamalı
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
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
            focusNode: myFocusNode,
            onPressed: sendMessage,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}

// static - tanımlanan degisken sınıf seklinde tanımlandır
// final  - tanımlanan degisken bir kere deger aldıktan sonra degistirilemez
// future - tanımlanan degisken uzun süren islemler icin kullanılır
