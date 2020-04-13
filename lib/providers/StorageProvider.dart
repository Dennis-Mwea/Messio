import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:path/path.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage firebaseStorage;
  StorageProvider({FirebaseStorage firebaseStorage})
      : firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file, String path) async {
    String uid = SharedObjects.prefs.getString(Constants.sessionUid);
    String fileName = basename(file.path);
    StorageReference reference = firebaseStorage.ref().child(
        '$path/$uid-${DateTime.now().millisecondsSinceEpoch}-$fileName'); // get a reference to the path of the image directory
    String p = await reference.getPath();
    StorageUploadTask uploadTask =
        reference.putFile(file); // put the file in the path
    StorageTaskSnapshot result =
        await uploadTask.onComplete; // wait for the upload to complete
    String url = await result.ref
        .getDownloadURL(); //retrieve the download link and return it
    return url;
  }
}
