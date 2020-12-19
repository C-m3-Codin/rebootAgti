// import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
          length: 3,
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  String title;
  MyHomePage({this.title});
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseRef = FirebaseDatabase.instance.reference();
  String humidity = "";
  String temperature = "";
  // void readDate() {

  //   databaseRef.child("Humidity").once().then((DataSnapshot data) =>
  //       {print("${data.value}"), humidity = data.value.toString()});
  //   databaseRef.child("Temperature").once().then((DataSnapshot data) =>
  //       {print("${data.value}"), temperature = data.value.toString()});
  // }

  Future<String> readDate() async {
    databaseRef.child("Humidity").once().then((DataSnapshot data) =>
        {print("${data.value}"), humidity = data.value.toString()});
    databaseRef.child("Temperature").once().then((DataSnapshot data) =>
        {print("${data.value}"), temperature = data.value.toString()});
    var dat = await databaseRef.child("Humidity").once();
    var da = dat.value;
    return da.toString();
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.cloud)),
            Tab(icon: Icon(Icons.image)),
            Tab(icon: Icon(Icons.web)),
          ],
        ),
        title: Text('Tabs Demo'),
      ),
      body: TabBarView(children: [
        Padding(
          padding: const EdgeInsets.all(48.0),
          child: Container(
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Container(
                    //   height: 40,
                    //   child: RaisedButton(
                    //     onPressed: null,
                    //     child: Text("camera"),
                    //   ),
                    // ),
                    Container(
                      color: Colors.blue,
                      height: 30,
                      child: temperature.isEmpty
                          ? Text("temperature", textAlign: TextAlign.center)
                          : Card(
                              child: Text(temperature,
                                  textAlign: TextAlign.center)),
                    ),
                    Container(
                      color: Colors.blue,
                      height: 30,
                      child: temperature.isEmpty
                          ? Text("Humidity", textAlign: TextAlign.center)
                          : Card(
                              child:
                                  Text(humidity, textAlign: TextAlign.center)),
                    ),
                    Container(
                      color: Colors.blue,
                      child: temperature.isEmpty
                          ? Text("temperature")
                          : Card(
                              child: Text(temperature,
                                  textAlign: TextAlign.center)),
                    ),
                    RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          print("\n\n\n tadaaa$temperature");
                          humidity = await readDate();
                          print("hum,$humidity");
                          setState(() {});
                        },
                        child: Text("fetch values")),
                  ],
                )),
          ),
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: _image == null
                    ? Text("Havent selected picture")
                    : Center(
                        child: Image.file(_image),
                      ),
              )
            ],
          ),
        ),
        Icon(Icons.directions_bike),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    ));
  }
}
