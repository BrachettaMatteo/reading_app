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
    //getCategory();
    return SafeArea(
        child: FutureBuilder(
            future: getCategory(),
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

  /// get List of category book
  Future<List<String>> getCategory() async {
    Future<List<String>> cat =
        booksCollection.orderBy('category').get().then((QuerySnapshot qR) {
      List<String> categroy = [];
      for (var element in qR.docs) {
        if (!categroy.contains(element['category'])) {
          categroy.add(element['category']);
        }
      }
      return categroy;
    });
    return await cat;
  }
}
