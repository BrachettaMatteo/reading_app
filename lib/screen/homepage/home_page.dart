import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/widget/section/section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    // check the dispaly name is present
    String? email = FirebaseAuth.instance.currentUser!.email;
    log("email: ${email!}");
    usersCollection.doc(email).get().then((DocumentSnapshot dS) {
      Map<String, dynamic> data = dS.data() as Map<String, dynamic>;
      FirebaseAuth.instance.currentUser!.updateDisplayName(data['username']);
      log("username:${FirebaseAuth.instance.currentUser!.displayName!}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          const Section(material: labelFavoriteCategory),
          const Section(material: labelPersonalCategory),
          const SizedBox(height: 20),
          buttomAddBok(),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }

  ///personalize buttom for add document
  buttomAddBok() {
    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextButton.icon(
              onPressed: (goNewDocument),
              icon: const Icon(Icons.library_add_outlined, size: 40),
              label: const Text('add document'),
            )));
  }

  /// go to new_book_screen
  goNewDocument() {
    Navigator.pushNamed(context, '/new_book');
  }
}
