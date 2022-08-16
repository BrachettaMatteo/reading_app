import 'package:flutter/material.dart';

class Sec extends StatelessWidget {
  const Sec({Key? key, this.nameSec}) : super(key: key);
  final nameSec;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(nameSec,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      ],
    );
  }
}
