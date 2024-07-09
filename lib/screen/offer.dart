import 'package:flutter/material.dart';

class Offer extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: const Text('Home'),
    backgroundColor: Colors.cyan,
   ),
   body: const Center(
    child: Text("This is offer "),
   ),
  );
 }
}
