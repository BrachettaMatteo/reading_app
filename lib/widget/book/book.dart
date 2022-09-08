import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Book extends StatefulWidget {
  const Book({Key? key, this.name, this.author, this.color}) : super(key: key);
  final String? name;
  final String? author;
  final Color? color;
  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
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
        color: widget.color,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.book_outlined, size: 70),
              title: Text(widget.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              subtitle: Text(widget.author!,
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
                  if (data['username'] == widget.author) {
                    return ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    title: const Text("Confirm delete book"),
                                    content: Text("title book: ${widget.name}"),
                                    actions: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Back",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )),
                                      const SizedBox(
                                        width: 100,
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('Books')
                                                .where('author',
                                                    isEqualTo: widget.author)
                                                .where('title',
                                                    isEqualTo: widget.name)
                                                .get()
                                                .then((value) =>
                                                    FirebaseFirestore.instance
                                                        .collection("Books")
                                                        .doc(
                                                            value.docs.first.id)
                                                        .delete());
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "DELETE",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  );
                                });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Update',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          child: const Text('Read',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/read', arguments: {
                              "title": widget.name!,
                              "author": widget.author!
                            });
                          },
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
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                title: const Text('contact'),
                                content: FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection("Users")
                                      .where('username',
                                          isEqualTo: widget.author)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Text(
                                          "Book: ${widget.name} \nAuthor: ${data['username']}\n\nEmail: ${snapshot.data!.docs.first.id} ");
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("back"))
                                ],
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: const Text('Read',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/read', arguments: {
                              "title": widget.name!,
                              "author": widget.author!
                            });
                          },
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
        .where("title", isEqualTo: widget.name)
        .where('author', isEqualTo: widget.author)
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
                  SnackBar sna = SnackBar(
                    width: 300,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.bookmark_remove_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          "remove book to favorite list",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(sna);
                } else {
                  book.add(value.docs.first.id);
                  SnackBar sna = SnackBar(
                    width: 300,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.bookmark_add_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          "add book to favorite list",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    elevation: 6.0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(sna);
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
