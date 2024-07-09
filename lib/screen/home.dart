import 'package:flutter/material.dart';

class Home extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home'),
    backgroundColor: Colors.cyan,
   ),
   body: const Center(
    child: Text("This is Home "),
   ),
  );
 }
}
