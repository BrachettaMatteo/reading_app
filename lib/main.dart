import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reading_app/screen/Library.dart';
import 'package:reading_app/screen/Profile.dart';
import 'package:reading_app/screen/homePage.dart';
import 'package:reading_app/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.ltr, child: child!);
      },
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          )),
      home: App()));
}

class App extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<App> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    Library(),
    Profile()
  ];
  static const List<Text> _nameOptions = <Text>[
    Text('Home'),
    Text("Library"),
    Text("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const Login();
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: _nameOptions.elementAt(_selectedIndex),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.library_books,
                    text: "Library",
                  ),
                  GButton(
                    icon: Icons.person_outline,
                    text: "Profile",
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      );
    }
  }
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}
