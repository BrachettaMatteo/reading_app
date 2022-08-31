import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  const Book({Key? key, this.name, this.author, this.color}) : super(key: key);
  final String? name;
  final String? author;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    String? documentId = FirebaseAuth.instance.currentUser!.email;

    return SizedBox(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: color,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.book_outlined, size: 70),
              title: Text(name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              subtitle: Text(author!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontStyle: FontStyle.italic)),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: users.doc(documentId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong",
                      style: TextStyle(color: Colors.red));
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
                  if (data['username'] == author) {
                    return ButtonBar(
                      children: <Widget>[
                        TextButton(
                          child: const Text('Read',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {},
                        ),
                      ],
                    );
                  } else {
                    return ButtonBar(
                      buttonPadding: const EdgeInsets.all(5),
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const Text('Collab',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {},
                        ),
                        TextButton(
                          child: const Text('Read',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.white,
                          iconSize: 20,
                          onPressed: (favoriteBook),
                        ),
                      ],
                    );
                  }
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// add book in firebaseCloud users
  favoriteBook() {
    var book = [];

    //reserch id Book
    FirebaseFirestore.instance
        .collection('Books')
        .where("title", isEqualTo: name)
        .where('author', isEqualTo: author)
        .get()
        .then(((value) => {
              //update array to user profile
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .get()
                  .then((dataUser) {
                book.addAll(dataUser['saved']);
                //check the book is contained on saved list
                if (book.contains(value.docs.first.id)) {
                  book.remove(value.docs.first.id);
                } else {
                  book.add(value.docs.first.id);
                }
                //update list with query
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({"saved": book});
              })
            }));
  }
}
