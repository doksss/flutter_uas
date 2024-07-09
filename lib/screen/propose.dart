import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/screen/browse.dart';

String active_user = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

class Propose extends StatefulWidget {
  int animalID;
  Propose({super.key, required this.animalID});
  @override
  State<StatefulWidget> createState() {
    return _ProposeState();
  }
}

class _ProposeState extends State<Propose> {
  final _formKey = GlobalKey<FormState>();
  String _deskripsi = "";

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            active_user = value;
          },
        ));
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/propose.php"),
        body: {
          'deskripsi': _deskripsi,
          'idhewan': widget.animalID.toString(),
          'idadopter': active_user,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses, Harap menunggu Konfirmasi')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Browse()));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Propose Animal"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Keterangan Deskripsi',
                    ),
                    onChanged: (value) {
                      _deskripsi = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Keterangan Deskripsi harus diisi agar dapat meyakinkan pemilik';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
