import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/main.dart';
import 'package:http/http.dart' as http;
import 'package:uas_project/screen/login.dart';

class MyRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  String _user_name = "";
  String _user_password = "";
  String _message = "";

// void doLogin() async {
  //   final response = await http.post(
  //       Uri.parse("http://ubaya.me/flutter/160421059/login.php"),
  //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //       body: {'userid': _user_id, 'userpassword': _user_password});
  //   if (response.statusCode == 200) {
  //     Map json = jsonDecode(response.body);
  //     if (json['result'] == 'success') {
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("user_id", _user_id);
  //       prefs.setString("user_name", json['user_name']);
  //       main();
  //     } else {
  //       setState(() {
  //         error_login = "Incorrect user or password";
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to read API');
  //   }
  // }
  void doRegister() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421059/uas/register.php"),
      body: {
        'user_name': _user_name,
        'user_password': _user_password,
      },
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        setState(() {
          _message = "Registration successful";
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        });
      } else {
        setState(() {
          _message = "Registration failed: ${json['message']}";
        });
      }
    } else {
      setState(() {
        _message = "Failed to connect to server";
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
          height: 300,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 20)]),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  _user_name = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                  _user_password = v;
                },
                // obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      doRegister();
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                _message,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ]),
        ));
  }
}
