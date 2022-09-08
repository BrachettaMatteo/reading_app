import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key? key}) : super(key: key);

  @override
  State<NewBook> createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final validatorForm = GlobalKey<FormState>();

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
                  child: Form(
                      key: validatorForm,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                                hintText: 'Insert your title',
                                labelText: 'Book title ',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                )),
                            validator: (String? value) {
                              FirebaseFirestore.instance
                                  .collection("Books")
                                  .where('title',
                                      isEqualTo: titleController.text)
                                  .get()
                                  .then(((value) => {
                                        setState(() {
                                          if (value.size == 0) {
                                            error = false;
                                          } else {
                                            error = true;
                                          }
                                        })
                                      }));

                              if (value!.length < 2) {
                                return "name is too small";
                              } else if (error) {
                                return "the name is used";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: categoryController,
                            decoration: InputDecoration(
                                hintText: 'Insert book category',
                                labelText: 'category book',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                )),
                            validator: (String? value) {
                              return value!.length <= 2
                                  ? "category is small"
                                  : null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "author: "
                            "${FirebaseAuth.instance.currentUser!.displayName!}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: textController,
                            showCursor: true,
                            minLines: 15,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: 'Insert your text',
                                labelText: 'texts book ',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                hintStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                )),
                            validator: (String? value) {
                              return value!.length <= 2
                                  ? "text is too small"
                                  : null;
                            },
                          ),
                          Row(children: [
                            const Spacer(),
                            TextButton.icon(
                                onPressed: () {
                                  if (validatorForm.currentState!.validate()) {
                                    //add book
                                    addBook(
                                        title: titleController.text,
                                        text: textController.text,
                                        category: categoryController.text);
                                  }
                                },
                                icon: const Icon(Icons.send_outlined),
                                label: const Text("publish book"))
                          ]),
                        ],
                      ))),
            ],
          )),
        )));
  }

  /// checks data and add book on library cloud
  void addBook({String? title, String? text, String? category}) {
    if (title != null && text != null && category != null) {
      FirebaseFirestore.instance
          .collection("Books")
          .add({
            'title': title,
            'author': FirebaseAuth.instance.currentUser!.displayName,
            'text': text,
            'category': category.toUpperCase(),
          })
          .then((value) => {
                showDialog(
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
                            child: const Text(
                              'go library',
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (route) => false),
                            child: const Text(
                              'go homepage',
                            ),
                          ),
                        ],
                      );
                    },
                    context: context)
              })
          .catchError((error) => {
                showDialog(
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        title: const Text("error add book"),
                        content: Text(error),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'review book',
                            ),
                          ),
                        ],
                      );
                    },
                    context: context)
              });
    }
  }
}
