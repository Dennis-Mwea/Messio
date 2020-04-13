import 'dart:io';

import 'package:messio/models/Message.dart';

class VideoWrapper {
  final File file;
  final VideoMessage videoMessage;
  VideoWrapper(this.file, this.videoMessage);
}
