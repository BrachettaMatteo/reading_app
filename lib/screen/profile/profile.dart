import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  String? usernameCurrentUser = FirebaseAuth.instance.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          FutureBuilder<DocumentSnapshot>(
            future: usersCollection.doc(emaiCurrentlUser).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Center(
                        child: CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage(data['photo']),
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
                  ],
                );
              }

              return const Center(child: Text("loading"));
            },
          ),
          const SizedBox(height: 20),
          Column(children: [
            Text(
              "Information",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
                stream: usersCollection
                    .doc(emaiCurrentlUser)
                    .snapshots(includeMetadataChanges: true),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && !snapshot.data!.exists ||
                      snapshot.hasError) {
                    return const Text(
                      "Something went wrong",
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 2, 2),
                      child: Column(
                        children: [
                          Row(children: [
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
                          ]),
                          Row(
                            children: [
                              Text(
                                "Email: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(emaiCurrentlUser!),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
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
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Surname: ",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(data['surname']),
                            ],
                          ),
                        ],
                      ));
                }),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/setting_user');
              },
              icon: const Icon(Icons.settings, size: 18),
              label: const Text("change information"),
            ),
            Text(
              "Activity",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: usersCollection.doc(emaiCurrentlUser).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && !snapshot.data!.exists ||
                    snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List saved = data['saved'];
                  return Text(
                    "Favorite Book: ${saved.length}",
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            FutureBuilder<QuerySnapshot>(
                future: booksCollection
                    .where('author', isEqualTo: usernameCurrentUser)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                        "Book create: ${snapshot.data?.docs.length.toString()}");
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ]),
          const SizedBox(height: 10),
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

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
