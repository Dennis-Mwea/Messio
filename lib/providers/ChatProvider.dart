import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/utils/SharedObjects.dart';

class ChatProvider extends BaseChatProvider {
  final Firestore fireStoreDb;
  ChatProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Stream<List<Chat>> getChats() {
    String uid = SharedObjects.prefs.getString(Constants.sessionUid);

    return fireStoreDb
        .collection(Paths.usersPath)
        .document(uid)
        .snapshots()
        .transform(StreamTransformer<DocumentSnapshot, List<Chat>>.fromHandlers(
            handleData: (DocumentSnapshot documentSnapshot,
                    EventSink<List<Chat>> sink) =>
                mapDocumentToChat(documentSnapshot, sink)));
  }

  void mapDocumentToChat(DocumentSnapshot snapshot, EventSink sink) async {
    List<Chat> chats = List();
    Map data = snapshot.data['chats'];
    if (data != null) {
      data.forEach((key, value) => chats.add(Chat(key, value)));
      sink.add(chats);
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection((Paths.messagesPath));

    return messagesCollection.snapshots().transform(
        StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
            handleData:
                (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
                    mapDocumentToMessage(querySnapshot, sink)));
  }

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    List<Message> messages = List();
    for (DocumentSnapshot document in querySnapshot.documents) {
      print(document.data);
      messages.add(Message.fromFirestore(document));
    }
    sink.add(messages);
  }

  Future<void> sendMessage(String chatId, Message message) async {
    DocumentReference chatDocRef =
        fireStoreDb.collection(Paths.chatsPath).document(chatId);
    CollectionReference messagesCollection =
        chatDocRef.collection(Paths.messagesPath);
    messagesCollection.add(message.toMap());
    await chatDocRef.updateData({'latestMessage': message.toMap()});
  }

  @override
  Future<String> getChatIdByUsername(String username) async {
    String uid = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
        SharedObjects.prefs.getString(Constants.sessionUsername);
    DocumentReference userRef =
        fireStoreDb.collection(Paths.usersPath).document(uid);
    DocumentSnapshot documentSnapshot = await userRef.get();
    String chatId = documentSnapshot.data['chats'][username];

    if (chatId == null) {
      chatId = await createChatIdForUsers(selfUsername, username);
      userRef.updateData({
        'chats': {username: chatId}
      });
    }

    return chatId;
  }

  @override
  Future<void> createChatIdForContact(User user) async {
    String contactUid = user.documentId;
    String contactUsername = user.username;
    String uid = SharedObjects.prefs.getString(Constants.sessionUid);
    String selfUsername =
        SharedObjects.prefs.getString(Constants.sessionUsername);

    CollectionReference usersCollection =
        fireStoreDb.collection(Paths.usersPath);
    DocumentReference userRef = usersCollection.document(uid);
    DocumentReference contactRef = usersCollection.document(contactUid);
    DocumentSnapshot userSnapShot = await userRef.get();

    if (userSnapShot.data['chats'] == null ||
        userSnapShot.data['chats'][contactUsername] == null) {
      String chatId = await createChatIdForUsers(selfUsername, contactUsername);
      await userRef.setData({
        'chats': {contactUsername: chatId}
      }, merge: true);
      await contactRef.setData({
        'chats': {selfUsername: chatId}
      }, merge: true);
    }
  }

  Future<String> createChatIdForUsers(
      String selfUsername, String contactUsername) async {
    CollectionReference collectionReference =
        fireStoreDb.collection(Paths.chatsPath);
    DocumentReference documentReference = await collectionReference.add({
      'members': [selfUsername, contactUsername]
    });

    return documentReference.documentID;
  }
}
