import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_app/features/update_book.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reading_app/features/new_book.dart';
import 'package:reading_app/features/reading_book.dart';
import 'package:reading_app/screen/library/library.dart';
import 'package:reading_app/screen/login/registrer.dart';
import 'package:reading_app/screen/profile/profile.dart';
import 'package:reading_app/screen/homepage/home_page.dart';
import 'package:reading_app/screen/login/login.dart';
import 'package:reading_app/screen/profile/setting_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ThemeData costumDarkTheme = ThemeData(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            backgroundColor: Colors.transparent),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        displaySmall: TextStyle(color: Colors.white70),
        labelLarge: TextStyle(fontFamily: 'RobotoMono', color: Colors.green),
        bodySmall: TextStyle(color: Colors.red),
      ),
      primaryColor: Colors.white);

  ThemeData costomLigthTheme = ThemeData(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          backgroundColor: Colors.transparent),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        displaySmall: TextStyle(color: Colors.black54),
        labelLarge:
            TextStyle(fontFamily: 'RobotoMono', color: Colors.redAccent),
        bodySmall: TextStyle(color: Colors.red),
      ),
      primaryColor: Colors.black);

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      // principal 'screen'
      '/home': (context) => const App(page: homepage),
      '/library': (context) => const App(page: library),
      '/profile': (context) => const App(page: profile),
      //other 'screen'
      '/login': (context) => const Login(),
      '/register': (context) => const Register(),
      '/setting_user': (context) => const SettingUser(),
      '/new_book': (context) => const NewBook(),
      '/read': (context) => const ReadingBook(),
      '/updateBook': (context) => const UpdateBook(),
    },
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    debugShowCheckedModeBanner: false,
    theme: costomLigthTheme,
    darkTheme: costumDarkTheme,
  ));
}

///Global constat, rappresent the HOMEPAGE SCREEN
const homepage = 0;

///Global constat, rappresent the LIBRARY SCREEN
const library = 1;

///Global constat, rappresent the PROFILE SCREEN
const profile = 2;

class App extends StatefulWidget {
  /// page of the principal 'screen'
  ///
  /// The principal screen are: [homepage], [library] and [profile]
  final int page;

  const App({Key? key, required this.page}) : super(key: key);

  @override
  _MainApp createState() {
    return _MainApp();
  }
}

class _MainApp extends State<App> {
  /// the currente selection page
  late int _selectedIndex = widget.page;

  /// Option widget list of the principal screen
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Library(),
    Profile()
  ];

  /// Option title list of the principal screen
  static const List<Text> _nameOptions = <Text>[
    Text('Home'),
    Text("Library"),
    Text("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    // check user is log
    if (FirebaseAuth.instance.currentUser == null) {
      return const Login();
    } else {
      return Scaffold(
          appBar: costumAppBar(),
          body: SafeArea(
            child: Center(
              // select 'screen' of the list
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
          bottomNavigationBar: costumBottomBar());
    }
  }

  /// Change the principal section of scren.
  ///
  /// The principal screen are HomePage, Library and Profile
  change(int val) {
    setState(() {
      _selectedIndex = val;
    });
  }

  ///Get bottom bar.
  ///
  ///It Personalized GNav from google dependencis
  costumBottomBar() {
    return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    );
  }

  /// Personalize app bar
  costumAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).canvasColor,
      bottomOpacity: 0.0,
      elevation: 0.0,
      title: _nameOptions.elementAt(_selectedIndex),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
    );
  }
}
