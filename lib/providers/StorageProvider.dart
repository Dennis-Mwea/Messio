import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:path/path.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage firebaseStorage;
  StorageProvider({FirebaseStorage firebaseStorage})
      : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = basename(file.path);
    final milliSecs = DateTime.now().millisecondsSinceEpoch;
    StorageReference reference = firebaseStorage.ref().child(
        '$path/$milliSecs\_$fileName'); // get a reference to the path of the image directory
    String uploadPath = await reference.getPath();
    StorageUploadTask uploadTask =
        reference.putFile(file); // put the file in the path
    StorageTaskSnapshot result =
        await uploadTask.onComplete; // wait for the upload to complete
    String url = await result.ref
        .getDownloadURL(); //retrieve the download link and return it

    return url;
  }
}
