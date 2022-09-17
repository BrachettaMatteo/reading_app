import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/widget/book/book.dart';

class MyBookSection extends StatefulWidget {
  const MyBookSection({Key? key}) : super(key: key);

  @override
  State<MyBookSection> createState() => _MyBookSectionState();
}

class _MyBookSectionState extends State<MyBookSection> {
  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  String? usernameCurrentUser = FirebaseAuth.instance.currentUser!.displayName;
  TextStyle errrorMesageStyle = const TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "My Paper",
          style: TextStyle(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'RobotoMono'),
        ),
        SizedBox(
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
            stream: booksCollection
                .where('author', isEqualTo: usernameCurrentUser)
                .snapshots(includeMetadataChanges: true),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Text(
                  'Something went wrong',
                  style: errrorMesageStyle,
                );
              }

              if (snapshot.data!.size == 0) {
                return Center(
                  child: Text(
                    "You didn't create any book.",
                    style: errrorMesageStyle,
                  ),
                );
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
        )
      ]),
    );
  }
}
