import 'package:flutter/material.dart';

import '../component/section.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: const <Section>[
          Section(material: "Geometria"),
          Section(material: "Algebra"),
          Section(material: "AI"),
          Section(material: "Informatica")
        ],
      ),
    );
  }
}
