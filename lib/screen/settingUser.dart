import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SettingUserInfo extends StatefulWidget {
  const SettingUserInfo({Key? key}) : super(key: key);

  @override
  State<SettingUserInfo> createState() => _SettingUserInfoState();
}

class _SettingUserInfoState extends State<SettingUserInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final _key = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String? documentId = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 35,
              color: Colors.blue,
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const App(
                          page: profile,
                        ))),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(5),
          child: FutureBuilder<DocumentSnapshot>(
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
                nameController.text = data['name'];
                surnameController.text = data['surname'];
                usernameController.text = data['username'];
                return Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 36,
                                  ),
                                  Text(
                                    "Setting Profile",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "current Name: ${data['name']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    hintText: 'Insert your name',
                                    labelText: 'Setting Name',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    )),
                                validator: (String? value) {
                                  if ((value == data['name'] &&
                                          value!.isEmpty) ||
                                      value == null) {
                                    return null;
                                  }

                                  if (value.length <= 3) {
                                    return "The name is too short";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "current Surname: ${data['surname']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: surnameController,
                                decoration: InputDecoration(
                                    hintText: 'Insert surname',
                                    labelText: 'Setting surname',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    )),
                                validator: (String? value) {
                                  if ((value == data['surname'] &&
                                          value!.isEmpty) ||
                                      value == null) {
                                    return null;
                                  }

                                  if (value.length <= 3) {
                                    return "The surname is too short";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "current Username: ${data['username']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                    hintText: 'Insert new username',
                                    labelText: 'Setting username',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    labelStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                    )),
                                validator: (String? value) {
                                  if ((value == data['username'] &&
                                          value!.isEmpty) ||
                                      value == null) {
                                    return null;
                                  }
                                  if (value.length <= 2) {
                                    return "The username is too short";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextButton.icon(
                                    onPressed: (_save),
                                    icon: const Icon(Icons.save_alt_outlined),
                                    label: const Text("Save"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                        )))),
                              )),
                              const Spacer(),
                              const Spacer(),
                              const Spacer(),
                            ],
                          ),
                        )));
              }

              return const Center(
                child: Text(
                  "loading data",
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        )));
  }

  /// implement data verification, confirm data and update data on the cloud
  _save() {
    if (_key.currentState!.validate()) {
      //dialog to confirm data
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Confirm data"),
            content: Text(
                "Riepilogo:\n \n name: ${nameController.text} \n surname: ${surnameController.text} \n username: ${usernameController.text}"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Review data',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () => {
                  //get oldUsername

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get()
                      .then((value) {
                    users.doc(documentId).set(<String, dynamic>{
                      "name": nameController.text,
                      "surname": surnameController.text,
                      "username": usernameController.text,
                    });
                    FirebaseFirestore.instance
                        .collection('Books')
                        .where('author', isEqualTo: value['username'])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        FirebaseFirestore.instance
                            .collection('Books')
                            .doc(doc.id)
                            .set(
                          <String, dynamic>{
                            "author": usernameController.text,
                          },
                          SetOptions(merge: true),
                        );
                      }
                    });
                  }),

                  //update author book
                  //query research username

                  // change information

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const App(
                            page: profile,
                          )))
                },
                child: const Text(
                  'Apply change',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
