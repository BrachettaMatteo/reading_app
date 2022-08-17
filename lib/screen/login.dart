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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final control = GlobalKey<FormState>();

  String _err = "";

  bool _isObscure1 = false;

  @override
  Widget build(BuildContext context) {
    const Color green = Color.fromARGB(255, 39, 179, 14);
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Login",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "welcome to ReadingApp",
          style: Theme.of(context)
              .textTheme
              .subtitle2
              ?.copyWith(color: Colors.green, fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 10,
        ),
        Form(
            key: control,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Insert your username',
                        labelText: 'Username ',
                        labelStyle: Theme.of(context).textTheme.bodyText2,
                        hintStyle: Theme.of(context).textTheme.bodyText2,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        )),
                    validator: (String? value) {
                      return value == null || !value.contains("@")
                          ? "isn't emil"
                          : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isObscure1,
                    decoration: InputDecoration(
                      hintText: 'Insert your paswsord',
                      labelText: 'password ',
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure1 ? Icons.visibility : Icons.visibility_off,
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
                      return value == null || value.length <= 4
                          ? "pasword small"
                          : null;
                    },
                  )
                ]))),
        const SizedBox(
          height: 10,
        ),
        Text(
          _err,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: Colors.red),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextButton.icon(
              onPressed: () async {
                if (control.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => App()));
                    }
                  } on FirebaseAuthException catch (e) {
                    _err = "Error credential";
                    if (e.code == 'user-not-found') {
                      debugPrint('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      debugPrint('Wrong password provided for that user.');
                    }
                  } catch (e) {
                    _err = "Error credential";
                  }
                  setState(() {});
                }
              },
              icon: const Icon(Icons.lock_outline_rounded),
              label: const Text("Login"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(10)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          side: BorderSide(color: green)))),
            )),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You not acces? Don't worry"),
            TextButton(onPressed: (newUser), child: const Text("Register me"))
          ],
        ))
      ]),
    ))));
  }

  newUser() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Register()));
  }
}
