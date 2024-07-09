import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/class/browse.dart';
import 'package:uas_project/main.dart';
import 'package:uas_project/screen/propose.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

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
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421059/uas/browse.php"),
        body: {'iduser': active_user});
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
  
      });
    });
  }

  void doPropose(int animalid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("animal_id", animalid.toString());
  }

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            active_user = value;
            if (active_user.isNotEmpty) {
              bacaData();
            }
          },
        ));
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
                                    builder: (context) => Propose(animalID: Animals[index].id,)));
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
            height: MediaQuery.of(context).size.height - 100,
            // child: DaftarPopActor(PAsArray),
            child: DaftarBrowseAnimal(BrowseArray),
          )
        ]));
  }
}
