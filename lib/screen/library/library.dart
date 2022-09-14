import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/widget/section/section.dart';
import 'package:flutter/material.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    getElement();
    return SafeArea(
        child: FutureBuilder(
            future: getElement(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Section(material: snapshot.data[index]);
                    });
              }
            }));
  }

  Future<List<String>> getElement() async {
    Future<List<String>> cat =
        booksCollection.orderBy('category').get().then((QuerySnapshot qR) {
      List<String> el = [];
      for (var element in qR.docs) {
        if (!el.contains(element['category'])) {
          el.add(element['category']);
        }
      }
      return el;
    });
    return await cat;
  }
}
