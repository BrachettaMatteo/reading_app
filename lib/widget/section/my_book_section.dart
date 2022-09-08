import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../book/book.dart';

class MyBookSection extends StatefulWidget {
  const MyBookSection({Key? key}) : super(key: key);

  @override
  State<MyBookSection> createState() => _MyBookSectionState();
}

class _MyBookSectionState extends State<MyBookSection> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String? documentId = FirebaseAuth.instance.currentUser!.email;
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
            height: 150.0,
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(documentId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                    "Something went wrong",
                    style: TextStyle(color: Colors.red),
                  );
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text(
                    "Information does not exist",
                    style: TextStyle(color: Colors.red),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Books')
                        .where('author', isEqualTo: data['username'])
                        .snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          'Something went wrong',
                          style: TextStyle(color: Colors.red),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'Book not found',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (snapshot.data!.size == 0) {
                        return const Center(
                          child: Text(
                            "you don't create book",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
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
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ))
      ]),
    );
  }
}
