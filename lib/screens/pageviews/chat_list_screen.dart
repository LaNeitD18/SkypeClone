import 'package:SkypeClone/models/contact.dart';
import 'package:SkypeClone/provider/user_provider.dart';
import 'package:SkypeClone/resources/auth_methods.dart';
import 'package:SkypeClone/resources/chat_methods.dart';
import 'package:SkypeClone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:SkypeClone/screens/pageviews/widgets/contact_view.dart';
import 'package:SkypeClone/screens/pageviews/widgets/new_chat_button.dart';
import 'package:SkypeClone/screens/pageviews/widgets/quite_box.dart';
import 'package:SkypeClone/screens/pageviews/widgets/user_circle.dart';
import 'package:SkypeClone/utils/universal_variables.dart';
import 'package:SkypeClone/utils/utilities.dart';
import 'package:SkypeClone/widgets/appbar.dart';
import 'package:SkypeClone/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/search_screen");
            }),
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: UniversalVariables.blackColor,
          appBar: customAppBar(context),
          floatingActionButton: NewChatButton(),
          body: ChatListContainer()),
    );
  }
}

// Chat List Container
class ChatListContainer extends StatelessWidget {
  final ChatMethods chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: chatMethods.fetchContacts(userId: userProvider.getUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("hasData");
              // represents the contact list of the currently logged in user
              var docList = snapshot.data.docs;
              if (docList.isEmpty) {
                print("empty");
                return QuiteBox();
              }
              print("not empty");
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());
                  return ContactView(
                    contact: contact,
                  );
                },
              );
            }
            print("no data");
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }),
    );
  }
}
