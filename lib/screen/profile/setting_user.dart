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
  @override
  initState() {
    super.initState();
    usersCollection.doc(emaiCurrentlUser).get().then((DocumentSnapshot dS) {
      Map<String, dynamic> data = dS.data() as Map<String, dynamic>;

      nameController.text = data['name'];
      surnameController.text = data['surname'];
      usernameController.text = data['username'];
    });
  }

  //perosonal old data
  String? name;
  String? surname;
  String? username;

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  User currentUser = FirebaseAuth.instance.currentUser!;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool usernameError = false;

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
            child: Center(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: getFromSettingUser())))));
  }

  /// implement data verification, confirm data and update data on the cloud
  _save() {
    if (_key.currentState!.validate()) {
      usersCollection
          .where('username', isEqualTo: usernameController.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(errorUsernameMessage());
        }
      });
    }
  }

  Widget getFromSettingUser() {
    //update personal data
    usersCollection.doc(emaiCurrentlUser).get().then((DocumentSnapshot dS) {
      Map<String, dynamic> data = dS.data() as Map<String, dynamic>;
      if (data.isNotEmpty) {
        setState(() {
          name = data['name'];
          surname = data['surname'];
          username = data['username'];
        });
      }
    });

    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentInfo("current Name: $name"),
                  const SizedBox(height: 5),
                  nameTextFormField(),
                  const SizedBox(height: 5),
                  currentInfo("current Surname: $surname"),
                  const SizedBox(height: 5),
                  surnameTextFormField(),
                  const SizedBox(height: 5),
                  currentInfo("current Username: $username"),
                  const SizedBox(height: 5),
                  usernameTextFromField(),
                  const SizedBox(height: 5),
                  saveButton(),
                ],
              ),
            )));
  }

  TextFormField nameTextFormField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
          hintText: 'Insert your name',
          labelText: 'Setting Name',
          hintStyle: Theme.of(context).textTheme.bodyText2,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        if (value!.isEmpty) return "name is empty";
        if (value == name) {
          return null;
        }

        if (value.length <= 3) {
          return "The name is too short";
        } else {
          return null;
        }
      },
    );
  }

  TextFormField surnameTextFormField() {
    return TextFormField(
      controller: surnameController,
      decoration: InputDecoration(
          hintText: 'Insert surname',
          labelText: 'Setting surname',
          hintStyle: Theme.of(context).textTheme.bodyText2,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        if (value == surname) return null;
        if (value!.isEmpty) return "surname is empty";
        if (value.length <= 3) return "The surname is too short";

        return null;
      },
    );
  }

  TextFormField usernameTextFromField() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
          hintText: 'Insert new username',
          labelText: 'Setting username',
          hintStyle: Theme.of(context).textTheme.bodyText2,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        if (value == username) return null;
        if (value!.length < 2) return "username is too small";
        return null;
      },
    );
  }

  Widget saveButton() {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton.icon(
          onPressed: (_save),
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text("Save"),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              )))),
    ));
  }

  Text currentInfo(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  SnackBar errorUsernameMessage() {
    return SnackBar(
      width: 300,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.bookmark_remove_outlined,
            color: Colors.white,
          ),
          Text(
            "username is alredy use",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }
}
