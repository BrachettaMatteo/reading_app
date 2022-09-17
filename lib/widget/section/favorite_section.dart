import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/widget/book/book.dart';

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({Key? key}) : super(key: key);

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<DocumentSnapshot>(
                  stream: usersCollection
                      .doc(emaiCurrentlUser)
                      .snapshots(includeMetadataChanges: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && !snapshot.data!.exists ||
                        snapshot.hasError) {
                      return const Text(
                        "Something went wrong",
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    //get list books saved
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    List listBooks = data['saved'];
                    if (listBooks.isEmpty) {
                      return emptyListBooks();
                    }
                    return books(listBooks);
                  }))
        ]));
  }

  /// get book of the insert list
  Widget books(List listBooks) {
    return ListView(scrollDirection: Axis.horizontal, children: [
      for (String idBook in listBooks)
        FutureBuilder<DocumentSnapshot>(
          future: booksCollection.doc(idBook).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError ||
                snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Book(
                name: data['title'],
                author: data['author'],
                color: Colors.green,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        )
    ]);
  }

  Widget emptyListBooks() {
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
}
