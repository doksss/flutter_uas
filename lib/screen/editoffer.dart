import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:uas_project/class/adopt.dart';

class EditOffer extends StatefulWidget {
  int offerID;
  EditOffer({super.key, required this.offerID});

  @override
  EditOfferState createState() {
    return EditOfferState();
  }
}

class EditOfferState extends State<EditOffer> {
  late Adopts
      pm; //PAKE CLASS ADOPTS SAJA KARENA BENTUK DATA MEMBER YG DIBUTUHKAN SAMA

  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaCont = TextEditingController();
  TextEditingController _keteranganCont = TextEditingController();
  TextEditingController _fotoCont = TextEditingController();
  TextEditingController _jenisHewanCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    bacaData();
  }


  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/updateoffer.php"),
        body: {
          'nama': pm.nama,
          'keterangan': pm.keterangan,
          'foto': pm.foto,
          'jenis_hewan': pm.jenis_hewan,
          'id':widget.offerID.toString(),
        });
    if (response.statusCode == 200) {
      // print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/detailoffer.php"),
        body: {'id': widget.offerID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      pm = Adopts.fromJson(json['data']);
      setState(() {
        _namaCont.text = pm.nama;
        _keteranganCont.text = pm.keterangan;
        _fotoCont.text = pm.foto;
        _jenisHewanCont.text = pm.jenis_hewan;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Offer"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
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
                            pm.nama = value;
                          },
                          controller: _namaCont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'nama harus diisi';
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
                            pm.keterangan = value;
                          },
                          controller: _keteranganCont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Keterangan Harus Diisi';
                            }
                            return null;
                          },
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Foto',
                          ),
                          onChanged: (value) {
                            pm.foto = value;
                          },
                          controller: _fotoCont,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Jenis Hewan',
                          ),
                          onChanged: (value) {
                            pm.jenis_hewan = value;
                          },
                          controller: _jenisHewanCont,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jenis Hewan harus diisi';
                            }
                            return null;
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          var state = _formKey.currentState;
                          if (state == null || !state.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Harap Isian diperbaiki')));
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
