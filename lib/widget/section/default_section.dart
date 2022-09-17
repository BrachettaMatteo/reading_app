import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/widget/book/book.dart';

class DefaultSection extends StatefulWidget {
  const DefaultSection({Key? key, required this.material}) : super(key: key);
  final String? material;

  @override
  State<DefaultSection> createState() => _DefaultSectionState();
}

class _DefaultSectionState extends State<DefaultSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          titleSection(),
          bodySection(),
        ]));
  }

  /// Costum title section.
  ///
  /// It's composte to title and count book
  Widget titleSection() {
    return Row(
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
          stream: booksCollection
              .where('category', isEqualTo: widget.material!)
              .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Something went wrong',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      )));
            }

            return Text(
              "Total book: ${snapshot.data!.docs.length.toString()}",
              style: Theme.of(context).textTheme.labelLarge,
            );
          },
        ),
      ],
    );
  }

  ///costum body section
  ///
  ///It's composted for set of book
  Widget bodySection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 150.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: booksCollection
            .where('category', isEqualTo: widget.material!)
            .snapshots(includeMetadataChanges: true),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
    );
  }
}
