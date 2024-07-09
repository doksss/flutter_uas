import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/class/decision.dart';
import 'package:uas_project/screen/offer.dart';

class Decision extends StatefulWidget {
  int animalID;
  Decision({super.key, required this.animalID});
  @override
  State<StatefulWidget> createState() {
    return _DecisionState();
  }
}

class _DecisionState extends State<Decision> {
  Decisions? _pm;

  bool onGoBack(dynamic value) {
    //  print("masuk goback");
    setState(() {
      bacaData();
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/decision.php"),
        body: {'id': widget.animalID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  void chooseAdopter(int _idAdopter) async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/addDecision.php"),
        body: {
          'id': _idAdopter.toString(),
          'idanimal': widget.animalID.toString(),
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sukses Menambahkan Adopter Baru')));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Offer()));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pm = Decisions.fromJson(json['data']);
      setState(() {});
    });
  }

  Widget tampilData() {
    if (_pm == null) {
      return const CircularProgressIndicator();
    }
    return Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Text(_pm!.nama + "-" + _pm!.jenis_hewan,
              style: const TextStyle(fontSize: 25)),
          Image.network(_pm!.foto),
          Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Text(_pm!.keterangan, style: const TextStyle(fontSize: 15))),
          Padding(padding: EdgeInsets.all(10), child: Text("Adopter:")),
          Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pm?.adopters?.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama: " +
                              _pm?.adopters?[index]['username'] +
                              "\n" +
                              _pm?.adopters?[index]['deskripsi'],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle button press
                            chooseAdopter(_pm?.adopters?[index]['id']);
                          },
                          child: Text('Choose Adopter'),
                        ),
                      ],
                    );
                  })),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       delete(widget.movieID.toString());
          //     },
          //     child: Row(
          //       mainAxisSize: MainAxisSize
          //           .min, // Untuk menyesuaikan ukuran tombol dengan konten
          //       children: [
          //         Icon(
          //           Icons.delete,
          //           color: Colors.red,
          //           size: 24.0,
          //         ),
          //         SizedBox(width: 8.0), // Memberi jarak antara ikon dan teks
          //         Text(
          //           "Delete",
          //           style:
          //               TextStyle(color: Colors.red), // Menyesuaikan warna teks
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //     padding: EdgeInsets.all(10),
          //     child: ElevatedButton(
          //       child: Text('Edit'),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) =>
          //                 EditPopMovie(movieID: widget.movieID),
          //           ),
          //         ).then(onGoBack);
          //       },
          //     )),
        ]));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail of Popular Movie'),
        ),
        body: ListView(children: <Widget>[
          tampilData(),
        ]));
  }
}
