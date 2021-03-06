import 'package:SkypeClone/provider/image_upload_provider.dart';
import 'package:SkypeClone/provider/user_provider.dart';
import 'package:SkypeClone/resources/auth_methods.dart';
import 'package:SkypeClone/screens/home_screen.dart';
import 'package:SkypeClone/screens/login_screen.dart';
import 'package:SkypeClone/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection('users').doc().set({
    //   'name': 'pht',
    // });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageUploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Skype Clone',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              print("home");
              return HomeScreen();
            } else {
              print("login");
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
