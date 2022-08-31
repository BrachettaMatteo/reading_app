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
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        primaryColor: Colors.black),
    darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        primaryColor: Colors.white),
    home: const App(page: 0),
  ));
}

///Global constat, rappresent the HOMEPAGE SCREEN
const homepage = 0;

///Global constat, rappresent the LIBRARY SCREEN
const library = 1;

///Global constat, rappresent the PROFILE SCREEN
const profile = 2;

class App extends StatefulWidget {
  final int page;

  const App({Key? key, required this.page}) : super(key: key);

  @override
  _MainApp createState() {
    return _MainApp(page);
  }
}

class _MainApp extends State<App> {
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

  _MainApp(int page) {
    page < 0 || page > 3 ? _selectedIndex = 0 : _selectedIndex = page;
  }

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
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
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
                tabBackgroundColor: Colors.grey[100]!.withOpacity(0.9),
                color: Theme.of(context).primaryColor.withOpacity(0.9),
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
