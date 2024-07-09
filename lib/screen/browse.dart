import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/class/browse.dart';
import 'package:uas_project/screen/propose.dart';

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<Browse> {
  List<Animal> BrowseArray = [];
  String _temp = "Waiting API respond";

  Future<String> fetchData() async {
    final response = await http
        .get(Uri.parse("https://ubaya.me/flutter/160421059/uas/browse.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var act in json['data']) {
        Animal pa = Animal.fromJson(act);
        BrowseArray.add(pa);
      }
      setState(() {
        _temp = BrowseArray[0].nama;
        print('State updated: $BrowseArray');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarBrowseAnimal(Animals) {
    if (Animals != null) {
      return ListView.builder(
          itemCount: Animals.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(
                    Animals[index].foto,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 15, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Display the card's title using a font size of 24 and a dark grey color
                        Text(
                          Animals[index].nama +
                              " - " +
                              Animals[index].jenis_hewan,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.grey[800],
                          ),
                        ),
                        // Add a space between the title and the text
                        Container(height: 10),
                        // Display the card's text using a font size of 15 and a light grey color
                        Text(
                          Animals[index].keterangan,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(height: 10),
                        Text(
                          'Tertarik: ' + Animals[index].num_interes.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Propose()));
                          },
                          child: Text(
                            'Propose',
                            style: TextStyle(color: Colors.green, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 10),
                ],
              ),
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Browse Animals')),
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 200,
            // child: DaftarPopActor(PAsArray),
            child: DaftarBrowseAnimal(BrowseArray),
          )
        ]));
  }
}
