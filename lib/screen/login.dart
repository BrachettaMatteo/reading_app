import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_app/screen/registrer.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    const Color green = Color.fromARGB(255, 39, 179, 14);
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "welcome to ReadingApp",
          style: TextStyle(color: green),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(children: [
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Insert your username',
                    labelText: 'Username ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    )),
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Insert your paswsord',
                    labelText: 'password ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextButton.icon(
                    onPressed: (() => {checkLogin()}),
                    icon: const Icon(Icons.lock_outline_rounded),
                    label: const Text("Login"),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    side: BorderSide(color: green)))),
                  )),
            ])),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You not acces? Don't worry"),
            TextButton(onPressed: (newUser), child: const Text("registr me"))
          ],
        ))
      ]),
    ))));
  }

  newUser() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Register()));
  }

  checkLogin() async {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "prova.prova@prova.prova", password: "Prova123");
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => App()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }
}
