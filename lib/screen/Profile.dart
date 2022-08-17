import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/main.dart';
import '../component/SEC.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          const Center(
              child: CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
            backgroundColor: Colors.transparent,
          )),
          TextButton.icon(
            onPressed: () {
              //implement db setting
              debugPrint("press ProfileSetting");
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text("change imagae"),
          ),
          const SizedBox(height: 20),
          Column(children: [
            const Sec(
              nameSec: "Data Information",
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  children: const [
                    Spacer(),
                    Text("Name"),
                    SizedBox(width: 10),
                    Text("NameUser"),
                    Spacer(),
                    Text("Surname"),
                    SizedBox(width: 10),
                    Text("Surname User"),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                Row(children: const [
                  Spacer(),
                  Text("Username"),
                  SizedBox(width: 10),
                  Text("email Users"),
                  Spacer()
                ]),
                Row(
                  children: const [
                    Spacer(),
                    Text("email"),
                    SizedBox(width: 10),
                    Text("email Users"),
                    Spacer()
                  ],
                )
              ],
            ),
            TextButton.icon(
              onPressed: () {
                //todo: implementare Query db
                debugPrint("requenst change date profile");
              },
              icon: const Icon(Icons.settings, size: 18),
              label: const Text("change imagae"),
            ),
          ]),
          const SizedBox(height: 20),
          const Sec(
            nameSec: "Collaboration",
          ),
          const SizedBox(height: 20),
          TextButton.icon(
              onPressed: (_logout),
              icon: const Icon(Icons.exit_to_app_outlined),
              label: const Text("Logout"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white))),
        ]));
  }

  void _logout() async {
    //Logout firebase  user
    await FirebaseAuth.instance.signOut();
    // controll correct logout
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const App()));
  }
}
