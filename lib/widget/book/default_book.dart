import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

class DefaultBook extends StatefulWidget {
  const DefaultBook({Key? key, this.author, this.title}) : super(key: key);
  final String? title;
  final String? author;
  final Color color = Colors.blue;
  @override
  State<DefaultBook> createState() => _DefaultBookState();
}

class _DefaultBookState extends State<DefaultBook> {
  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                        title: const Text('Contact'),
                        content: FutureBuilder(
                          future: usersCollection
                              .where('username', isEqualTo: widget.author)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                  "Book: ${widget.title} \nAuthor: ${widget.author}\n\nEmail: ${snapshot.data!.docs.first.id} ");
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        actions: [
                          const SizedBox(
                            width: 20,
                          ),
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
                  child:
                      const Text('Read', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/read', arguments: {
                      "title": widget.title!,
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
            )
          ],
        ),
      ),
    );
  }

  /// add book in firebaseCloud users
  favoriteBook() {
    List book = [];
    //reserch id Book and add book on personal list
    booksCollection
        .where("title", isEqualTo: widget.title)
        .where('author', isEqualTo: widget.author)
        .get()
        .then(((value) => {
              //update array to user profile
              usersCollection.doc(emaiCurrentlUser).get().then((dataUser) {
                book.addAll(dataUser['saved']);
                // book.addAll(dataUser['saved']);
                //check the book is contained on saved list
                if (book.contains(value.docs.first.id)) {
                  //remove book to favorite List
                  book.remove(value.docs.first.id);
                  //show warning message
                  ScaffoldMessenger.of(context)
                      .showSnackBar(removeBookMessage());
                } else {
                  //add book to favorite List
                  book.add(value.docs.first.id);
                  //show warning message
                  ScaffoldMessenger.of(context).showSnackBar(addBookMessage());
                }
                //update list with query
                usersCollection.doc(emaiCurrentlUser).update({"saved": book});
              })
            }));
  }

  ///Snackbar message to warn the add book to favorite list.
  SnackBar addBookMessage() {
    return SnackBar(
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
  }

  ///Snackbar message to warn the remove book to favorite list.
  SnackBar removeBookMessage() {
    return SnackBar(
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
  }
}
