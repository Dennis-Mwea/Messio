import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/providers/BaseProviders.dart';

class ChatProvider extends BaseChatProvider {
  final Firestore fireStoreDb;
  ChatProvider({Firestore fireStoreDb})
      : fireStoreDb = fireStoreDb ?? Firestore.instance;

  @override
  Stream<List<Chat>> getChats() {
    // TODO: implement getHhats
    return null;
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    print('hereeeeeeeeeeeeeeee');
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
    print('hereeeeeeeeeeeeeeeeee');
    print(querySnapshot);
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
  }
}
