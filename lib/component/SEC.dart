import 'package:flutter/material.dart';

class Sec extends StatefulWidget {
  const Sec({Key? key, this.nameSec}) : super(key: key);
  final nameSec;

  @override
  State<Sec> createState() => _SecState();
}

class _SecState extends State<Sec> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.nameSec,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      ],
    );
  }
}
