import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/main.dart';

class ReadingBook extends StatefulWidget {
  const ReadingBook({Key? key}) : super(key: key);

  @override
  State<ReadingBook> createState() {
    return _ReadingBookState();
  }
}

class _ReadingBookState extends State<ReadingBook> {
  double sizeText = 15;

  @override
  Widget build(BuildContext context) {
    String appBartitle = "";
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    arguments['title'].length > 20
        ? appBartitle = arguments['title'].substring(0, 20) + "..."
        : appBartitle = arguments['title'];

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text(
            appBartitle,
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                children: [
              StreamBuilder<QuerySnapshot>(
                  stream: booksCollection
                      .where('author', isEqualTo: arguments['author'])
                      .where('title', isEqualTo: arguments['title'])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Error: ${snapshot.hasError.toString()}",
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const App(page: library)));
                              },
                              child: const Text(
                                "go to library",
                              ))
                        ],
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    String idBook = snapshot.data!.docs.first.id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: booksCollection.doc(idBook).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError ||
                            snapshot.hasData && !snapshot.data!.exists) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Error"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "go to library",
                                  ))
                            ],
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return Text(
                            data["text"],
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: sizeText),
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }),
              const SizedBox(
                height: 80,
              ),
              Text(
                "author: ${arguments['author']}",
                style: TextStyle(fontSize: sizeText),
              ),
            ])),
        floatingActionButton: settingBottons());
  }

  ///show the setting botton on the read book
  settingBottons() {
    return SpeedDial(
      icon: Icons.settings,
      spacing: 10,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.text_increase_outlined),
            label: "decrease text size",
            onTap: () => {
                  setState(() {
                    sizeText = sizeText + 2;
                  }),
                }),
        SpeedDialChild(
            child: const Icon(Icons.text_decrease_outlined),
            label: "decrease text size",
            onTap: () => {
                  setState(() {
                    sizeText > 2 ? sizeText = sizeText - 2 : sizeText;
                  }),
                }),
        SpeedDialChild(
            child: const Icon(Icons.exit_to_app_outlined),
            label: "go library",
            onTap: () => {Navigator.pop(context)}),
      ],
    );
  }
}
