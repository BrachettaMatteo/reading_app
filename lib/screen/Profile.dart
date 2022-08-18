import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/main.dart';
import 'package:reading_app/screen/settingUser.dart';
import '../component/SEC.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String? documentId = FirebaseAuth.instance.currentUser!.email;

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
            label: const Text("Change image"),
          ),
          const SizedBox(height: 20),
          Column(children: [
            const Sec(
              nameSec: "Data Information",
            ),
            const SizedBox(height: 10),
            FutureBuilder<DocumentSnapshot>(
              future: users.doc(documentId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text(
                    "Information does not exist",
                    style: TextStyle(color: Colors.red),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            "Full Name: ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(data['name']),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Text(
                            "Surname: ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(data['surname']),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(children: [
                        const Spacer(),
                        Text(
                          "Username: ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(data['username']),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Text(
                          "Email: ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(documentId!),
                        const Spacer()
                      ]),
                    ],
                  );
                }

                return const Center(
                  child: Text(
                    "loading data",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const SettingUserInfo()));
              },
              icon: const Icon(Icons.settings, size: 18),
              label: const Text("change information"),
            ),
          ]),
          const SizedBox(height: 20),
          const Sec(
            nameSec: "Collaboration",
          ),
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextButton.icon(
                onPressed: (_logout),
                icon: const Icon(Icons.exit_to_app_outlined),
                label: const Text("Logout"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            side: BorderSide(color: Colors.redAccent))))),
          ))
        ]));
  }

  void _logout() async {
    //Logout firebase  user
    await FirebaseAuth.instance.signOut();
    // controll correct logout
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const App(page: 0)));
  }
}
