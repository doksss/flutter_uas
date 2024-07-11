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
              'PetAdopt',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              'PetAdopt adalah sebuah website dimana pengguna dapat bernegosiasi untuk mengadopsi hewan peliharaan dari pengguna lainnya. Terdapat 3 hal yang dapat dilakukan oleh pengguna, yaitu browse, offer, dan adopt\n' +
                  '1. Pada halaman browse ditampilkan beberapa daftar hewan yang ditawarkan bagi pengguna. Jika ada hewan yang ingin diadopsi, maka pengguna bisa menekan tombol propose. Proses propose ini akan menunggu konfirmasi dari pemilik hewan tersebut.\n' +
                  '2. Pada halaman offer ditampilkan beberapa hewan yang pernah diposting oleh pengguna. Apabila terdapat pengguna lain yang ingin mengadopsi hewan milik pengguna, akan muncul tombol decision yang dimana pengguna dapat memutuskan untuk memilih satu dari calon-calon pengadopsi. Jika belum, tombol decision tidak akan muncul namun terdapat tombol edit dan delete untuk mengubah ataupun menghapus penawaran. Pada halaman ini pengguna juga dapat membuat penawaran baru untuk hewan yang ingin ditawarkan.\n' +
                  '3. Pada halaman adopt ditampilkan hewan-hewan yang sedang di propose, gagal adopsi, maupun yang telah disetujui untuk diadopsi',
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
