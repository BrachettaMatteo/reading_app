import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Registrer"),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
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
                    decoration: const InputDecoration(
                        hintText: 'Insert your password',
                        labelText: 'password ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
