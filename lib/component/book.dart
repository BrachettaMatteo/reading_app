import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  const Book({Key? key, this.name, this.author, this.color}) : super(key: key);
  final String? name;
  final String? author;
  final Color? color;
  @override
  Widget build(BuildContext context) {
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
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: const Text('Collabora',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('Visualizza',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
