import 'package:flutter/material.dart';

import 'package:reading_app/widget/section/section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          const Section(material: "SAVED"),
          const Section(material: "MYPAPER"),
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton.icon(
                    onPressed: (goNewDocument),
                    icon: const Icon(Icons.library_add_outlined, size: 40),
                    label: const Text('add document'),
                  ))),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }

  goNewDocument() {
    Navigator.pushNamed(context, '/new_book');
  }
}
