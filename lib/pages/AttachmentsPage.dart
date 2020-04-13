import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:messio/blocs/attachments/Bloc.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/models/VideoWrapper.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:messio/widgets/BottomSheetFixed.dart';
import 'package:messio/widgets/ImageFullScreen.dart';
import 'package:messio/widgets/VideoPlayerWidget.dart';

class AttachmentsPage extends StatefulWidget {
  final String chatId;
  final FileType fileType;
  AttachmentsPage(this.chatId, this.fileType);

  @override
  _AttachmentsPageState createState() =>
      _AttachmentsPageState(this.chatId, this.fileType);
}

class _AttachmentsPageState extends State<AttachmentsPage>
    with SingleTickerProviderStateMixin {
  final String chatId;
  final FileType initialFileType;
  List<ImageMessage> photos;
  List<VideoWrapper> videos;
  List<FileMessage> files;
  AttachmentsBloc attachmentsBloc;
  String temThumbnailPath;
  TabController tabController;

  _AttachmentsPageState(this.chatId, this.initialFileType);

  @override
  void initState() {
    super.initState();
    attachmentsBloc = BlocProvider.of<AttachmentsBloc>(context);
    int initialTab = SharedObjects.getTypeFromFileType(initialFileType);
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTab - 1,
    );
    tabController.addListener(() {
      int index = tabController.index;

      if (index == 0 &&
          photos ==
              null) // if photos are not initialized and we're on the first tab then trigger a fetch event for photos
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.image));
      else if (index == 1 &&
          videos ==
              null) // if videos are not initialized and we're on the second tab then trigger a fetch event for photos
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.video));
      else if (index == 2 &&
          files ==
              null) // if files are not initialized and we're on the third tab then trigger a fetch event for photos
        attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, FileType.any));
    });
    attachmentsBloc.dispatch(FetchAttachmentsEvent(chatId, initialFileType));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.primaryBackgroundColor,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Palette.primaryBackgroundColor,
                  expandedHeight: 180.0,
                  pinned: true,
                  elevation: 0.0,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Attachments",
                      style: Styles.appBarTitle,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TabBar(
                      controller: tabController,
                      indicatorColor: Palette.accentColor,
                      labelColor: Palette.accentColor,
                      unselectedLabelColor: Palette.primaryTextColor,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.photo),
                          text: "Photos",
                        ),
                        Tab(
                          icon: Icon(Icons.videocam),
                          text: "Videos",
                        ),
                        Tab(
                          icon: Icon(Icons.insert_drive_file),
                          text: "Files",
                        ),
                      ]),
                ),
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: <Widget>[
                buildPhotosGrid(),
                buildVideosGrid(),
                buildFilesGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocBuilder buildPhotosGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
      builder: (context, state) {
        if (state is FetchedAttachmentsState &&
            state.fileType == FileType.image) {
          photos = List();
          state.attachments.forEach((message) {
            if (message is ImageMessage) {
              photos.add(message);
            }
          });
        }
        if (photos == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (photos.length == 0) {
          return Center(
            child: Text(
              'No photos',
              style: Styles.hintText,
            ),
          );
        }

        return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children: List.generate(
              photos.length, (index) => imageItem(context, index)),
        );
      },
    );
  }

  GestureDetector imageItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImageFullScreen(index, photos[index].imageUrl))),
      child: Hero(
        tag: 'AttachmentImage_$index',
        child: Image.network(
          photos[index].imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  BlocBuilder buildVideosGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
      builder: (context, state) {
        if (state is FetchedVideosState) {
          videos = state.videos;
        }

        if (videos == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (videos.length == 0) {
          return Center(
            child: Text(
              'No Videos',
              style: Styles.hintText,
            ),
          );
        }

        return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          children:
              List.generate(videos.length, (index) => videoItem(videos[index])),
        );
      },
    );
  }

  GestureDetector videoItem(VideoWrapper video) {
    return GestureDetector(
      onTap: () => showVideoPlayer(context, video.videoMessage.videoUrl),
      child: Container(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Image.file(
              video.file,
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xAA000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0x00000000),
                    const Color(0xAA000000),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.play_circle_filled,
            ),
          ],
        ),
      ),
    );
  }

  void showVideoPlayer(BuildContext context, String url) async {
    await showModalBottomSheetApp(
      context: context,
      builder: (BuildContext bc) => VideoPlayerWidget(url),
    );
  }

  BlocBuilder buildFilesGrid() {
    return BlocBuilder<AttachmentsBloc, AttachmentsState>(
      builder: (context, state) {
        if (state is FetchedAttachmentsState &&
            state.fileType == FileType.any) {
          files = List();
          state.attachments.forEach((file) {
            if (file is FileMessage) {
              files.add(file);
            }
          });
        }
        if (files == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (files.length == 0) {
          return Center(
            child: Text(
              'No Files',
              style: Styles.hintText,
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          itemBuilder: (context, index) => fileItem(files[index]),
          separatorBuilder: (context, index) => Divider(
            height: 5.0,
            color: Color(0xFFd3d3d3),
          ),
          itemCount: files.length,
        );
      },
    );
  }

  Padding fileItem(FileMessage message) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Icon(
              Icons.insert_drive_file,
            ),
          ),
          Expanded(
            flex: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message.fileName,
                      style: Styles.subHeading,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              message.timeStamp)),
                      style: Styles.date,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: Palette.otherMessageColor,
                  ),
                  onPressed: () => SharedObjects.downloadFile(
                    message.fileUrl,
                    message.fileName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
