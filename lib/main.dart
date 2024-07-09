import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/class/adopt.dart';
import 'package:uas_project/screen/adopt.dart';
import 'package:uas_project/screen/browse.dart';
import 'package:uas_project/screen/home.dart';
import 'package:uas_project/screen/login.dart';
import 'package:uas_project/screen/offer.dart';

String active_user = "";
Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_name = prefs.getString("user_name") ?? '';
  return user_name;
}

void main() {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UAS PROJECT'),
      routes: {
        'browser': (context) => Browse(), //stringnya itu bisa diganti
        'offer': (context) => Offer(), //stringnya itu bisa diganti
        'adopt': (context) => Adopt(), //stringnya itu bisa diganti
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  // final List<Widget> _screens = [Home(), Search(), History()];
  final List<Widget> _screens = [Browse(), Offer()];

  String _username = "";
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _username = value;
          },
        ));
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_name");
    main();
  }

  Widget funWidgetDrawer() {
    //Buat function lagi supaya ga semua dimasukin ke Scaffold
    return Drawer(
      elevation: 16.0,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("Pengguna: " + _username),
              accountEmail: Text(""),),
          ListTile(
            title: new Text("Logout"),
            leading: new Icon(Icons.logout),
            onTap: () {
              doLogout();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.orange,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   'assets/images/logo.png',
            //   width: 300,
            //   height: 300,
            // ),
            Expanded(
              child: TutorialCard(),
            ),
          ],
        ),
      ),
      drawer: funWidgetDrawer(),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TutorialCard extends StatelessWidget {
  const TutorialCard({Key? key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tutorial',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              '1. Pertama kali game akan menampilkan 5 gambar secara acak dan bergantian dan harus diingat oleh pemain\n' +
                  '2.  sistem akan menampilkan 4 opsi gambar yang harus ditebak oleh user. Salah satu dari 4 opsi yang tersedia merupakan\n' +
                  'gambar yang harus diingat pemain, sedangkan 3 gambar lainnya hanyalah pengecoh/tipuan\n' +
                  '3. Setiap pertanyaan hanya diberikan waktu 30 detik dan jika waktu habis maka akan menampilkan pertanyaan selanjutnya\n' +
                  '4. Jawaban benar akan bernilai 1 point dan jika salah maka bernilai 0 point',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Browse()),
                );
              },
              child: Text('Browse'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Offer()),
                );
              },
              child: Text('Offer'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Adopt()),
                );
              },
              child: Text('Adopt'),
            ),
          ],
        ),
      ),
    );
  }
}
