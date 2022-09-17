import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key? key}) : super(key: key);

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  @override
  initState() {
    super.initState();
    // check the dispaly name is present
    if (FirebaseAuth.instance.currentUser!.displayName == null) {
      String? email = FirebaseAuth.instance.currentUser!.email;
      usersCollection.doc(email!).get().then((DocumentSnapshot dS) {
        Map<String, dynamic> data = dS.data() as Map<String, dynamic>;
        FirebaseAuth.instance.currentUser!.updateDisplayName(data['username']);
      });
    }
  }

  String? usernameCurrentUser = FirebaseAuth.instance.currentUser!.displayName;

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final _validatorForm = GlobalKey<FormState>();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: const Text("New Book"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("description"),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: newBookForm())
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Add book on Firestone cloud
  ///
  /// It's check the data and show message to confirm or error
  void addBook() {
    if (_validatorForm.currentState!.validate()) {
      //control name
      booksCollection
          .where('title', isEqualTo: titleController.text)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          booksCollection.add({
            'title': titleController.text,
            'author': usernameCurrentUser,
            'text': textController.text,
            'category': categoryController.text.toUpperCase(),
          }).then((value) => {showCorrcetInsertDialog()});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(errorTitleMessage());
        }
      });
    }
  }

  /// Form content all input text for create new book
  ///
  /// input: title ,category and text
  Widget newBookForm() {
    return Form(
        key: _validatorForm,
        child: Column(
          children: [
            titleTextFormField(),
            const SizedBox(height: 20),
            categoryTextFormField(),
            const SizedBox(height: 20),
            Text(
              "author: "
              "$usernameCurrentUser",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            textTextFromField(),
            Row(children: [
              const Spacer(),
              TextButton.icon(
                  onPressed: (addBook),
                  icon: const Icon(Icons.send_outlined),
                  label: const Text("publish book"))
            ]),
          ],
        ));
  }

  /// input for title book.
  Widget titleTextFormField() {
    return TextFormField(
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
          if (value!.length < 2) {
            return "name is too small";
          }
          return null;
        });
  }

  /// input for category book.
  TextFormField categoryTextFormField() {
    return TextFormField(
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
  }

  /// input for text book.
  TextFormField textTextFromField() {
    return TextFormField(
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
  }

  /// message error title.
  ///
  /// It show when the title alredy exist
  SnackBar errorTitleMessage() {
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
            "title is alredy use",
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

  /// message correctly add book in cloud forestone
  showCorrcetInsertDialog() {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text("Book add"),
            content: const Text(
                "Congratulations, your book is correctly added to library"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/library", (route) => false);
                },
                child: const Text('go library'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (route) => false),
                child: const Text('go homepage'),
              ),
            ],
          );
        },
        context: context);
  }
}
