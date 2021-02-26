import 'dart:io';

import 'package:SkypeClone/constants/strings.dart';
import 'package:SkypeClone/enum/view_state.dart';
import 'package:SkypeClone/models/message.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/provider/image_upload_provider.dart';
import 'package:SkypeClone/resources/firebase_repository.dart';
import 'package:SkypeClone/screens/chatscreens/widgets/cached_image.dart';
import 'package:SkypeClone/utils/call_utilities.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:SkypeClone/utils/utilities.dart';
import 'package:SkypeClone/widgets/appbar.dart';
import 'package:SkypeClone/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  ChatScreen({Key key, this.receiver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textFieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();

  ScrollController _listScrollController = ScrollController();

  FocusNode textFieldFocus = FocusNode();

  ImageUploadProvider _imageUploadProvider;

  UserModel sender;
  String _currentUserId;

  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(child: messageList()),
          _imageUploadProvider.getViewState == ViewState.LOADING
              ? Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.centerRight,
                  child: CircularProgressIndicator())
              : Container(),
          chatControls(),
          showEmojiPicker
              ? Container(
                  child: emojiContainer(),
                )
              : Container()
        ],
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // go to bottom if hot reload or text sth new
        // SchedulerBinding.instance.addPostFrameCallback((_) {
        //   _listScrollController.animateTo(
        //     _listScrollController.position.minScrollExtent,
        //     duration: Duration(milliseconds: 250),
        //     curve: Curves.easeInOut,
        //   );
        // });

        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            controller: _listScrollController,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.docs[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: message.senderId == _currentUserId
            ? senderLayout(message)
            : receiverLayout(message),
      ),
    );
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        // this ensures that no matter how long the message is
        // it doesn't take more than 65% of the screen width
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: BorderRadius.only(
            topLeft: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          )),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != MESSAGE_TYPE_IMAGE
        ? Text(
            message != null ? message.message : "",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250,
                width: 250,
                radius: 10,
              )
            : Text("Url is null");
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        // this ensures that no matter how long the message is
        // it doesn't take more than 65% of the screen width
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
          color: UniversalVariables.receiverColor,
          borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius,
          )),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setIsWriting(String val) {
      if (val.length > 0 && val.trim() != "") {
        setState(() {
          isWriting = true;
        });
      } else {
        setState(() {
          isWriting = false;
        });
      }
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      FlatButton(
                          onPressed: () => Navigator.maybePop(context),
                          child: Icon(Icons.close)),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                  children: [
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.image,
                      onTap: () => pickImage(source: ImageSource.gallery),
                    ),
                    ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contacts",
                        subtitle: "Share contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll),
                  ],
                ))
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: Stack(alignment: Alignment.centerRight, children: <Widget>[
            TextField(
                controller: textFieldController,
                focusNode: textFieldFocus,
                onTap: () => hideEmojiContainer(),
                style: TextStyle(color: Colors.white),
                onChanged: (val) {
                  setIsWriting(val);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: UniversalVariables.greyColor),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: UniversalVariables.separatorColor,
                )),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (!showEmojiPicker) {
                  hideKeyboard();
                  showEmojiContainer();
                } else {
                  hideEmojiContainer();
                  showKeyboard();
                }
              },
              icon: Icon(Icons.face),
            ),
          ])),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          isWriting
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(source: ImageSource.camera),
                  child: Icon(Icons.camera_alt)),
          !isWriting
              ? Container()
              : Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
        ],
      ),
    );
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
      image: selectedImage,
      receiverId: widget.receiver.uid,
      senderId: _currentUserId,
      imageUploadProvider: _imageUploadProvider,
    );
  }

  sendMessage() {
    var text = textFieldController.text;

    Message message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    textFieldController.text = "";

    _repository.addMessageToDb(message, sender, widget.receiver);
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
        title: Text(
          widget.receiver.name,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () => CallUtils.dial(
                  from: sender, to: widget.receiver, context: context)),
          IconButton(icon: Icon(Icons.phone), onPressed: () {})
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false);
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {Key key,
      @required this.title,
      @required this.subtitle,
      @required this.icon,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
          mini: false,
          onTap: onTap,
          leading: Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: UniversalVariables.receiverColor),
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              color: UniversalVariables.greyColor,
              size: 38,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: UniversalVariables.greyColor,
              fontSize: 14,
            ),
          )),
    );
  }
}
