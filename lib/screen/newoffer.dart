import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/screen/offer.dart';

String active_user = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

class NewOffer extends StatefulWidget {
  NewOffer({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewOfferState();
  }
}

class _NewOfferState extends State<NewOffer> {
  final _formKey = GlobalKey<FormState>();
  String _nama = "";
  String _keterangan = "";
  String _foto = "";
  String _jenisHewan = "";

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
        Uri.parse("https://ubaya.me/flutter/160421059/uas/newoffer.php"),
        body: {
          'nama': _nama,
          'keterangan': _keterangan,
          'foto': _foto,
          'jenis_hewan': _jenisHewan,
          'idpemilik': active_user,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses, Menambah offer baru!')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Offer()));
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
          title: Text("New Offer Animal"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                    ),
                    onChanged: (value) {
                      _nama = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                    ),
                    onChanged: (value) {
                      _keterangan = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Keterangan Deskripsi harus diisi agar dapat meyakinkan pemilik';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'URL Foto',
                    ),
                    onChanged: (value) {
                      _foto = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'URL foto harus diisi!';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Jenis Hewan',
                    ),
                    onChanged: (value) {
                      _jenisHewan = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis hewan harus diisi!';
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
