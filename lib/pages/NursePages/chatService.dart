import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hcareapp/pages/YoneticiPages/message.dart';

class ChatService{
  // get instance of service
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user Stream
  Stream<List<Map<String , dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }
// send message
  Future<void> sendMessage(String receiverId, message) async {

    //get current user info

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct chatroom id for the two users (sorted to ensure uniqueness)

    List<String> ids = [currentUserId , receiverId];
    ids.sort(); // sort the ids (this ensure the chatroomID is the same for any 2 people)

    String chatRoomID = ids.join("_");

    //add new message to database

    await _firestore.collection('chat_rooms').doc(chatRoomID).collection('messages').add(newMessage.toMap());

  }
  //get messages

  Stream<QuerySnapshot> getMessages(String userID , otherUserID) {
    // construct a chatroomID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join("_");

    return _firestore.collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp',descending: false)
        .snapshots();


  }
}