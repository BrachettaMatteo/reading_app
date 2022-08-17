import 'package:flutter/material.dart';
import 'package:reading_app/component/book.dart';

class Section extends StatelessWidget {
  const Section({Key? key, required this.material}) : super(key: key);
  final String? material;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Row(
            children: [
              Text(
                material!,
                style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              const Spacer(),
              const Text(
                "1000",
                style: TextStyle(color: Colors.red, fontFamily: 'RobotoMono'),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 150.0,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: const <Book>[
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
        ]));
  }
}
