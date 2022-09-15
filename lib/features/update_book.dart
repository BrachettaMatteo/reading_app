import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

/// Scaffolid for managing the update of a book.
/// It includes the modification of all or part of the book data.
class UpdateBook extends StatefulWidget {
  const UpdateBook({Key? key}) : super(key: key);

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
  /// Controller for entring title book.
  TextEditingController titleController = TextEditingController();

  /// Controller for entring text book.
  TextEditingController textController = TextEditingController();

  /// Controller for entering category.
  TextEditingController categoryController = TextEditingController();

  /// Controller for data entry.
  final validatorForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /// Map of topics from  navigator.
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Book"),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<QuerySnapshot>(
                    future: booksCollection
                        .where('title', isEqualTo: arguments['title'])
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError ||
                          snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                          child: Text("error"),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text("error"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return FutureBuilder<DocumentSnapshot>(
                            future: booksCollection
                                .doc(snapshot.data!.docs.first.id)
                                .get(),
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
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                titleController.text = data['title'];
                                categoryController.text = data['category'];
                                textController.text = data['text'];
                                return createForm(
                                    idBook: snapshot.data!.id,
                                    title: arguments['title']);
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            });
                      }
                      return const Center(child: CircularProgressIndicator());
                    })
              ],
            ),
          ),
        )));
  }

  /// Widget create form insert title, category and text fo book
  Widget createForm({idBook, title}) {
    /// Personlized text field for entering a new title of a book
    TextFormField titleFormField = TextFormField(
      controller: titleController,
      decoration: InputDecoration(
          hintText: 'Insert your title',
          labelText: 'Book title ',
          labelStyle: Theme.of(context).textTheme.bodyText2,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        if (titleController.text == title) return null;

        if (value!.length < 2) {
          return "name is too small";
        } else {
          return null;
        }
      },
    );

    /// Personlized text field for entering a new category of a book
    TextFormField categoryFormField = TextFormField(
      controller: categoryController,
      decoration: InputDecoration(
          hintText: 'Insert book category',
          labelText: 'category book',
          labelStyle: Theme.of(context).textTheme.bodyText2,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        return value!.length <= 2 ? "category is small" : null;
      },
    );

    /// Personlized text field for entering a new text of a book
    TextFormField textBookFormField = TextFormField(
      controller: textController,
      showCursor: true,
      minLines: 15,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: 'Insert your text',
          labelText: 'texts book ',
          labelStyle: Theme.of(context).textTheme.bodyText2,
          hintStyle: Theme.of(context).textTheme.bodyText2,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          )),
      validator: (String? value) {
        return value!.length <= 2 ? "text is too small" : null;
      },
    );

    /// Personlized message for error insert title
    SnackBar snackErrorTitle = SnackBar(
      width: 300,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          Text(
            "The title is used",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );

    /// Custom alert to confirm or change the data entered
    AlertDialog dialogConfirm = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: const Text("confirm data"),
      content: const Text("are you sure change data?"),
      actions: [
        TextButton(
          onPressed: () {
            if (validatorForm.currentState!.validate()) {
              Navigator.pop(context);
              booksCollection
                  .where('title', isEqualTo: titleController.text)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                if (querySnapshot.docs.isEmpty ||
                    title == titleController.text) {
                  booksCollection.doc(idBook).set(
                    <String, dynamic>{
                      "title": titleController.text,
                      "category": categoryController.text,
                      "text": textController.text,
                    },
                    SetOptions(merge: true),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/library", (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackErrorTitle);
                }
              });
            }
          },
          child: const Text("Apply", style: TextStyle(color: Colors.green)),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Back",
              style: TextStyle(color: Colors.red),
            ))
      ],
    );

    /// Custom icon button for data verification
    TextButton updateBotton = TextButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialogConfirm;
            });
      },
      label: const Text("update book"),
      icon: const Icon(Icons.send),
    );

    return Form(
        key: validatorForm,
        child: Column(
          children: [
            titleFormField,
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            categoryFormField,
            const SizedBox(
              height: 20,
            ),
            textBookFormField,
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              const Spacer(),
              updateBotton,
            ]),
          ],
        ));
  }
}
