import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcareapp/main.dart';
import 'package:hcareapp/pages/YoneticiPages/authService.dart';
import 'package:hcareapp/pages/YoneticiPages/chatService.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  //text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //send message

  void sendMessage() async {
    // if there is something inside the textfield
    if(_messageController.text.isNotEmpty)
      {
        //send the message
        await _chatService.sendMessage(receiverID, _messageController.text);

        // clear textcontroller
        _messageController.clear();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          //display all messages
            Expanded(
              child: _buildMessageList(),
            ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(

        stream: _chatService.getMessages(receiverID, senderID),
        builder: (context , snapshot) {
          //errors
          if(snapshot.hasError)
            {
              return const Text("error");
            }

          //loading
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Text("loading...");
            }
              //return list view
          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );

        },
    );
}
// build message item
Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic>data = doc.data() as Map<String, dynamic>;

    //is current user

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message to the right if sender is the current user, otherwise left

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(data['message']),
          ],
        ));
}
//build message input
Widget _buildUserInput() {
    return Row(
      children: [
        // textfield should take up most of the space
          Expanded(
            child: TextField( // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            controller: _messageController,
              //HINT TEXT GELECEK
              obscureText: false,
          ),
          ),
        //send button
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward),),
      ],
    );
}
}
