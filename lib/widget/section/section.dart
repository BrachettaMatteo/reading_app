import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/widget/book/book.dart';
import 'package:reading_app/widget/section/my_book_section.dart';

import 'favorite_section.dart';

class Section extends StatefulWidget {
  const Section({Key? key, required this.material}) : super(key: key);
  final String? material;

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  @override
  Widget build(BuildContext context) {
    if (widget.material == "SAVED") {
      return const FavoriteSection();
    }
    if (widget.material == "MYPAPER") {
      return const MyBookSection();
    } else {
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              children: [
                Text(
                  widget.material!,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: 'RobotoMono'),
                ),
                const Spacer(),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Books')
                      .where('category', isEqualTo: widget.material!)
                      .snapshots(includeMetadataChanges: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Something went wrong',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              )));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      const Center(child: CircularProgressIndicator());
                    }
                    return Text(
                      snapshot.data!.docs.length.toString(),
                      style: const TextStyle(
                          color: Colors.redAccent, fontFamily: 'RobotoMono'),
                    );
                  },
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 150.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .where('category', isEqualTo: widget.material!)
                    .snapshots(includeMetadataChanges: true),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data == null) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Book(
                        name: data['title'],
                        author: data['author'],
                        color: Colors.blue,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ]));
    }
  }
}
