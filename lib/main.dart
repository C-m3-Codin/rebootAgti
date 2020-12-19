// import 'dart:html';

import 'package:PlatIssue/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:io';

import 'package:weather/weather.dart';

import 'SelectedDatepage.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SelectedDate())],
        child: MaterialApp(
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
            // t  he app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: DefaultTabController(
            length: 4,
            child: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
          routes: {"dateSelected": (context) => SelectedDatePage()},
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
  int temp, humid;
  double td, valu;
  // void readDate() {

  //   databaseRef.child("Humidity").once().then((DataSnapshot data) =>
  //       {print("${data.value}"), humidity = data.value.toString()});
  //   databaseRef.child("Temperature").once().then((DataSnapshot data) =>
  //       {print("${data.value}"), temperature = data.value.toString()});
  // }

  Future<String> readDate() async {
    databaseRef.child("Humidity").once().then((DataSnapshot data) => {
          print("${data.value}"),
          humidity = data.value.toString(),
          humid = int.parse(humidity)
        });
    databaseRef.child("Temperature").once().then((DataSnapshot data) => {
          print("${data.value}"),
          temperature = data.value.toString(),
          temp = int.parse(temperature),
          td = temp - ((100 - humid) / 100),
          valu = 100 - (((temp - td) / temp) * 100)
        });
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
    final prov = Provider.of<SelectedDate>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.cloud)),
            Tab(icon: Icon(Icons.image)),
            Tab(icon: Icon(Icons.web)),
            Tab(icon: Icon(Icons.web)),
          ],
        ),
        title: Text('Plantech'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, 'dateSelected');
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
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
                    Container(
                      color: Colors.blue,
                      height: 30,
                      child: temperature.isEmpty
                          ? Text("temperature", textAlign: TextAlign.center)
                          : Card(
                              child: Text("Temperature is $temperature",
                                  textAlign: TextAlign.center)),
                    ),
                    // Text("Humidity"),
                    Container(
                      color: Colors.blue,
                      height: 30,
                      child: temperature.isEmpty
                          ? Text("Not Fetched", textAlign: TextAlign.center)
                          : Card(
                              child: Text("Humidity is $humidity",
                                  textAlign: TextAlign.center)),
                    ),
                    // Text("Dew Point"),
                    Container(
                      color: Colors.blue,
                      child: temperature.isEmpty
                          ? Text("Not fetched")
                          : Card(
                              child: Text("dew point is ${td.toString()}",
                                  textAlign: TextAlign.center)),
                    ),
                    Container(
                      color: Colors.blue,
                      child: temperature.isEmpty
                          ? Text("No values yet")
                          : Card(
                              child: Text(
                                  humid > 75
                                      ? "Chance of Rainfall"
                                      : "Irringation in urgently required",
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
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("Proccess Image"),
              )
            ],
          ),
        ),
        Webvie(),
        DataPik(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    ));
  }
}

class Webvie extends StatefulWidget {
  const Webvie({
    Key key,
  }) : super(key: key);

  @override
  _WebvieState createState() => _WebvieState();
}

class _WebvieState extends State<Webvie> {
  String key = '176b2f2855900163213c8eebf2aedbd6';
  WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double lat = 10.3558, lon = 76.2126;
  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat, lon);
    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    return Center(
      child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          // return ListTile(
          //   title: Text(_data[index].toString()),
          // );
          return Card(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
              child: ExpansionTile(
                title: Text("${_data[index].date.toString()}"),
                children: <Widget>[
                  Text("Cloudiness ${_data[index].cloudiness.toString()}"),
                  Text('Humidity ${_data[index].humidity.toString()}'),
                  Text(' Pressure ${_data[index].pressure.toString()}'),
                  Text(
                      ' rain last 3 hours ${_data[index].rainLast3Hours.toString()}'),
                  Text(' Temperature ${_data[index].temperature.toString()}'),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
        margin: EdgeInsets.all(25),
        child: Column(children: [
          Text(
            'Fetching Weather...',
            style: TextStyle(fontSize: 20),
          ),
        ]));
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  void _saveLat(String input) {
    lat = double.tryParse(input);
    print(lat);
  }

  void _saveLon(String input) {
    lon = double.tryParse(input);
    print(lon);
  }

  Widget _coordinateInputs() {
    return Row(
      children: <Widget>[],
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(2),
          child: FlatButton(
            child: Text(
              'weather',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: queryWeather,
            color: Colors.blue,
          ),
        ),
        Container(
            margin: EdgeInsets.all(2),
            child: FlatButton(
              child: Text(
                'forecast',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: queryForecast,
              color: Colors.blue,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _coordinateInputs(),
        Container(margin: EdgeInsets.all(2), child: Text("From Web")),
        _buttons(),
        Divider(
          height: 20.0,
          thickness: 2.0,
        ),
        Expanded(child: _resultView())
      ],
    );
  }
}

class DataPik extends StatelessWidget {
  const DataPik({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SelectedDate>(context);
    return Container(
      child: SfDateRangePicker(
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          final DateTime rangeStart = args.value.startDate;
          print(
              "\n\n\n from $rangeStart to ${(args.value.endDate.runtimeType)}");
          if (args.value.endDate == null) {
            print("\n\n\tits not  range");
            prov.DateSelected(rangeStart);
          } else {
            print("\n\n\n its a range");
            prov.DateSelectedRange(rangeStart, args.value.ednDate);
          }
        },
        selectionMode: DateRangePickerSelectionMode.range,
      ),
    );
  }
}
