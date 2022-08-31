import 'package:flutter/material.dart';
import 'package:reading_app/component/section.dart';
import 'package:reading_app/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                    onPressed: () => {},
                    icon: const Icon(Icons.library_add_outlined, size: 40),
                    label: const Text('add document'),
                  ))),
          const SizedBox(height: 20),
          Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton.icon(
                    onPressed: (goLibrary),
                    icon: const Icon(Icons.search, size: 40),
                    label: const Text("read more books"),
                  ))),
        ],
      ),
    ));
  }

  goLibrary() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const App(page: library)));
  }
}
