import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/widget/book/my_book.dart';

import 'default_book.dart';

class Book extends StatefulWidget {
  const Book({Key? key, this.name, this.author, this.color}) : super(key: key);
  final String? name;
  final String? author;
  final Color? color;
  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  String? emaiCurrentlUser = FirebaseAuth.instance.currentUser!.email;
  String? usernameCurrentUser = FirebaseAuth.instance.currentUser!.displayName;
  @override
  Widget build(BuildContext context) {
    if (widget.author == usernameCurrentUser) {
      return MyBook(
        author: widget.author,
        title: widget.name,
      );
    } else {
      return DefaultBook(
        author: widget.author,
        title: widget.name,
      );
    }
  }
}
