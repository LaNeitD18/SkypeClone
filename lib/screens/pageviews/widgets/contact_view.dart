import 'package:SkypeClone/models/contact.dart';
import 'package:SkypeClone/models/user.dart';
import 'package:SkypeClone/provider/user_provider.dart';
import 'package:SkypeClone/resources/auth_methods.dart';
import 'package:SkypeClone/resources/chat_methods.dart';
import 'package:SkypeClone/screens/chatscreens/chat_screen.dart';
import 'package:SkypeClone/screens/chatscreens/widgets/cached_image.dart';
import 'package:SkypeClone/screens/pageviews/widgets/last_message_container.dart';
import 'package:SkypeClone/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:SkypeClone/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView({this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;

          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _authMethods.getUserDetailsById(contact.uid),
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    receiver: contact,
                  ))),
      title: Text(
        // contact?.name  <==> contact != null ? contact.name : null
        // contact.name ?? ".."   <==> contact.name != null ? contact.name : ".."
        contact?.name ?? "..",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Arial",
          fontSize: 19,
        ),
      ),
      subtitle: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
              senderId: userProvider.getUser.uid, receiverId: contact.uid)),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
