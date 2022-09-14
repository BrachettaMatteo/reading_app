import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

class SettingUser extends StatefulWidget {
  const SettingUser({Key? key}) : super(key: key);

  @override
  State<SettingUser> createState() => _SettingUserState();
}

class _SettingUserState extends State<SettingUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  User currentUser = FirebaseAuth.instance.currentUser!;

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Setting Profile",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: false,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(5),
          child: FutureBuilder<DocumentSnapshot>(
            future: usersCollection.doc(emaiCurrentlUser).get(),
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
                              Text(
                                "current Name: ${data['name']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
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
                                height: 5,
                              ),
                              Text(
                                "current Surname: ${data['surname']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
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
                                height: 5,
                              ),
                              Text(
                                "current Username: ${data['username']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 5,
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
                                height: 5,
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
                  usersCollection.doc(emaiCurrentlUser).get().then((value) {
                    currentUser.updateDisplayName(usernameController.text);
                    usersCollection.doc(emaiCurrentlUser).set(
                      <String, dynamic>{
                        "name": nameController.text,
                        "surname": surnameController.text,
                        "username": usernameController.text,
                      },
                      SetOptions(merge: true),
                    );
                    booksCollection
                        .where('author', isEqualTo: value['username'])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      for (var doc in querySnapshot.docs) {
                        booksCollection.doc(doc.id).set(
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

                  Navigator.pushNamedAndRemoveUntil(
                      context, "/profile", (route) => false)
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
