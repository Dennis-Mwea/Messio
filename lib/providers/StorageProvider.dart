import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/providers/BaseProviders.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage firebaseStorage;
  StorageProvider({FirebaseStorage firebaseStorage})
      : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadImage(File file, String path) async {
    StorageReference reference = firebaseStorage
        .ref()
        .child(path); // Get a reference to th path of the image directory
    StorageUploadTask uploadTask =
        reference.putFile(file); // puth the file in the path
    StorageTaskSnapshot result =
        await uploadTask.onComplete; // wait for the upload to complete

    return await result.ref
        .getDownloadURL(); // retrieve the download and return it
  }
}
