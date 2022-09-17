import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:reading_app/firebase_options.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isObscure1 = false;
  bool _isObscure2 = false;
  bool _confirmPolicy = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();
  bool errorUsername = false;
  bool errorEmail = false;

  late TextStyle policyStyle;
  @override
  Widget build(BuildContext context) {
    if (_confirmPolicy) {
      policyStyle = TextStyle(color: Theme.of(context).hintColor);
    } else {
      policyStyle = const TextStyle(color: Colors.red);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Subscribe',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "welcome to ReadingApp",
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Colors.green, fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("Enter your data and create your account",
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Form(
                      key: formGlobalKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                                hintText: 'Insert your Username',
                                labelText: 'Username',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                )),
                            validator: (String? value) {
                              if (usernameController.text.isEmpty) {
                                return "The username is required ";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: 'Insert your email',
                                labelText: 'Email',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                )),
                            validator: (String? value) {
                              if (value != null && !value.contains('@')) {
                                return "email isn't corret";
                              }
                              usersCollection
                                  .doc(emailController.text)
                                  .get()
                                  .then((DocumentSnapshot dS) {
                                if (dS.exists) {
                                  setState(() {
                                    errorEmail = true;
                                  });
                                } else {
                                  setState(() {
                                    errorEmail = false;
                                  });
                                }
                              });
                              if (errorEmail) {
                                return "The email is already registered";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: !_isObscure1,
                            decoration: InputDecoration(
                              hintText: 'Insert your password',
                              labelText: 'Password ',
                              labelStyle: Theme.of(context).textTheme.bodyText2,
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure1 = !_isObscure1;
                                  });
                                },
                              ),
                            ),
                            validator: (String? value) {
                              return (value != null && value.length <= 5)
                                  ? 'the password is small'
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: checkPasswordController,
                            keyboardType: TextInputType.text,
                            obscureText:
                                !_isObscure2, //This will obscure text dynamically
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
                              labelText: 'Confirm password ',
                              labelStyle: Theme.of(context).textTheme.bodyText2,
                              hintStyle: Theme.of(context).textTheme.bodyText2,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).hintColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                },
                              ),
                            ),
                            validator: (String? value) {
                              return (value != passwordController.text)
                                  ? "the password isn't equal"
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm privacy policy ReadingApp",
                      style: policyStyle,
                    ),
                    Checkbox(
                        value: _confirmPolicy,
                        onChanged: (bool? value) {
                          setState(() {
                            _confirmPolicy = value!;
                          });
                        },
                        checkColor: Colors.green,
                        fillColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (_confirmPolicy) {
                            return Theme.of(context).primaryColor;
                          } else {
                            return Colors.red;
                          }
                        }))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton.icon(
                    onPressed: (newAccount),
                    icon: const Icon(Icons.person_add),
                    label: const Text("Subscribe"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  newAccount() async {
    if (formGlobalKey.currentState!.validate() && _confirmPolicy) {
      usersCollection
          .where('username', isEqualTo: usernameController.text)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(errorUsernameMessage());
          return;
        } else {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

            usersCollection.doc(emailController.text).set({
              "name": "",
              "saved": [],
              'username': usernameController.text,
              'surname': '',
              'photo': defaultPhoto,
            });

            log("correct register account and login: email:${FirebaseAuth.instance.currentUser!.email}");
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              log('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              log('The account already exists for that email.');
            }
          } catch (e) {
            log("error: $e");
          }
        }
      });
    }
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
