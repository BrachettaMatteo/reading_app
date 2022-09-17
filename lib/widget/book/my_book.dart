import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

class MyBook extends StatefulWidget {
  const MyBook({Key? key, this.author, this.title}) : super(key: key);
  final String? title;
  final String? author;
  final color = Colors.green;
  @override
  State<MyBook> createState() => _MyBookState();
}

class _MyBookState extends State<MyBook> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: widget.color,
            elevation: 10,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: const Icon(Icons.book_outlined, size: 70),
                title: Text(widget.title!,
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
              ButtonBar(
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                      onPressed: (deleteAction)),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/updateBook', arguments: {
                        "title": widget.title!,
                        "author": widget.author!
                      });
                    },
                    child: const Text('Update',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    child: const Text('Read',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/read', arguments: {
                        "title": widget.title!,
                        "author": widget.author!
                      });
                    },
                  ),
                ],
              )
            ])));
  }

  void deleteAction() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Confirm delete book"),
            content: Text("title book: ${widget.title}"),
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
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
              const SizedBox(
                width: 100,
              ),
              TextButton(
                  onPressed: () {
                    booksCollection
                        .where('author', isEqualTo: widget.author)
                        .where('title', isEqualTo: widget.title)
                        .get()
                        .then((value) {
                      //delete book to saved Section

                      usersCollection
                          .where('saved', arrayContains: value.docs.first.id)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        for (var doc in querySnapshot.docs) {
                          List savedBook = doc['saved'];
                          savedBook.remove(value.docs.first.id);
                          usersCollection.doc(doc.id).set(
                            <String, dynamic>{'saved': savedBook},
                            SetOptions(merge: true),
                          );
                        }
                      });
                      //delete book
                      booksCollection.doc(value.docs.first.id).delete();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "DELETE",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }
}
