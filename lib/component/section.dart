import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/component/book.dart';

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
      return getSavedSection();
    }
    if (widget.material == "MYPAPER") {
      return getSectionMyPaper();
    }
    return defaultSectioMaterial();
  }

  Widget getSectionMyPaper() {
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

  Widget getSavedSection() {
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
                    if (snapshot == null) {
                      return const CircularProgressIndicator();
                    }

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

                      if (data['saved'] == null || data['saved'] == []) {
                        return const Center(
                            child: Text(
                          'You have no books saved',
                          style: TextStyle(color: Colors.red),
                        ));
                      }
                      List listBooks = data['saved'];

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

  Widget defaultSectioMaterial() {
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
