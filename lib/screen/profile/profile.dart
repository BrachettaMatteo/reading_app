import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reading_app/firebase_options.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  initState() {
    super.initState();
    // check the dispaly name is present
    String? email = FirebaseAuth.instance.currentUser!.email;
    log("email: ${email!}");
    usersCollection.doc(email).get().then((DocumentSnapshot dS) {
      Map<String, dynamic> data = dS.data() as Map<String, dynamic>;
      FirebaseAuth.instance.currentUser!.updateDisplayName(data['username']);
      log("username:${FirebaseAuth.instance.currentUser!.displayName!}");
    });
  }

  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  String? usernameCurrentUser = FirebaseAuth.instance.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(children: [
          StreamBuilder<DocumentSnapshot>(
            stream: usersCollection.doc(emaiCurrentlUser).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.data() == null) {
                return const Center(
                  child: Text(
                    "image not found",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return getImageProflie(data['photo']);
            },
          ),
          const SizedBox(height: 20),
          Column(children: [
            newSectionTitle("Information"),
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
                    style: Theme.of(context).textTheme.bodyText1,
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
                      "Book create: ${snapshot.data?.docs.length.toString()}",
                      style: Theme.of(context).textTheme.bodyText1,
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ]),
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
          )),
          const SizedBox(
            height: 10,
          ),
          Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextButton(
                      onPressed: (confirmDeleteAcount),
                      child: Text(
                        'Delete profile',
                        style: Theme.of(context).textTheme.bodySmall,
                      )))),
        ]));
  }

  void _logout() async {
    //Logout firebase  user
    await FirebaseAuth.instance.signOut();

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  File? image;

  /// Get image form Gallery
  _getFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      log(e.toString());
    }

    try {
      final storageCollection =
          FirebaseStorage.instance.ref().child("${emaiCurrentlUser}Img");
      File imgFile = File(image!.path);
      await storageCollection.putFile(imgFile);
      String photoLink = await FirebaseStorage.instance
          .ref()
          .child("${emaiCurrentlUser}Img")
          .getDownloadURL();
      usersCollection
          .doc(emaiCurrentlUser)
          .update(<String, dynamic>{"photo": photoLink});
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  confirmDeleteAcount() {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text(
              "Remove account",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
                "Deleting the account will delete all your data and your created books.Are you sure to delete the account?"),
            actions: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                      ),
                    ),
                    TextButton(
                      onPressed: (deleteProfile),
                      child: const Text('delete profile',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ]),
            ],
          );
        },
        context: context);
  }

  Future<void> deleteProfile() async {
    //eliminate book
    usersCollection.doc(emaiCurrentlUser).get().then((DocumentSnapshot dS) {
      Map<String, dynamic> data = dS.data() as Map<String, dynamic>;

      booksCollection
          .where('author', isEqualTo: data['username'])
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          booksCollection.doc(doc.id).delete();
        }
        log('delete books');
      });
      usersCollection.doc(emaiCurrentlUser).delete();
      log('delete information');
      FirebaseAuth.instance.currentUser!.delete();
      log('delete account');
    });
    //delete profile cloud firestone

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  Widget getImageProflie(urlPhoto) {
    return Column(
      children: [
        Center(
            child: CircleAvatar(
          radius: 100.0,
          backgroundImage: NetworkImage(urlPhoto),
          backgroundColor: Colors.transparent,
        )),
        TextButton.icon(
          onPressed: (_getFromGallery),
          icon: const Icon(Icons.settings, size: 18),
          label: const Text("Change image"),
        ),
      ],
    );
  }

  Widget newSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
