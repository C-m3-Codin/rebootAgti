import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package/DateModelProv.dart';
import 'models.dart';

class SelectedDatePage extends StatefulWidget {
  @override
  _SelectedDatePageState createState() => _SelectedDatePageState();
}

class _SelectedDatePageState extends State<SelectedDatePage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<SelectedDate>(context);
    DateTime start = prov.DateSel;
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse("2020-12-27 13:27:00");
    List<String> days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(days[start.weekday]),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(start.toString()),
            ),
            Card(
              child: Container(
                  child: Text(start.isBefore(tempDate)
                      ? "Its Hot out here bitches get me some hot crops"
                      : "fak its cold again where the heaters at and let me sleep")),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // add appointment
        },
      ),
    );
  }
}
