import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../book/book.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({Key? key}) : super(key: key);

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String? documentId = FirebaseAuth.instance.currentUser!.email;

    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Saved",
            style: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'RobotoMono'),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                      //get list books saved
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      List listBooks = data['saved'];
                      if (listBooks.isEmpty) {
                        return Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You haven't saved book",
                              style: TextStyle(color: Colors.red),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/library", (route) => false);
                                },
                                child: const Text("research book"))
                          ],
                        ));
                      }

                      return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (String idBook in listBooks)
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("Books")
                                    .doc(idBook)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong");
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return const Text(
                                        "Document does not exist");
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Book(
                                      name: data['title'],
                                      author: data['author'],
                                      color: Colors.green,
                                    );
                                  }

                                  return const CircularProgressIndicator();
                                },
                              )
                          ]);
                    }
                    return const CircularProgressIndicator();
                  }))
        ]));
  }
}
