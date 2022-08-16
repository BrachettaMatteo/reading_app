import 'package:flutter/material.dart';
import 'package:reading_app/component/SEC.dart';
import 'package:reading_app/main.dart';
import '../component/book.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(children: [
        const Sec(
          nameSec: "Saved",
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 150.0,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: const [
              Book(
                name: 'la solitudine dei numeri primi',
                author: "sconosciuto 1",
                color: Colors.lightBlue,
              ),
              Book(
                name: 'la solitudine dei numeri primi',
                author: "sconosciuto 1",
                color: Colors.lightBlue,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Sec(
          nameSec: "Topics",
        ),
        SizedBox(
          height: 150.0,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: const [
              Book(
                name: 'la solitudine dei numeri primi',
                author: "sconosciuto 1",
                color: Colors.lightBlue,
              ),
              Book(
                name: 'la solitudine dei numeri primi',
                author: "sconosciuto 1",
                color: Colors.lightBlue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () {
              main();
              //todo: implementare apertura New book
              debugPrint("requenst change date profile");
            },
            icon: const Icon(Icons.library_add, size: 50),
            label: const Text("Create new Document"),
          ),
        )
      ]),
    );
  }
}
