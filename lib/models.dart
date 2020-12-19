import 'package:flutter/material.dart';

// class EachDay with ChangeNotifier {
//   List<Map> listTime = [];

//   void addTime(String time, String work) {
//     listTime.add({time: work});
//     notifyListeners();
//   }

//   void checkTime(String time) {}

//   get scheduleList {
//     return listTime;
//   }
// }

class ScheduleDays with ChangeNotifier {
  List<Map> days;
  void addDay(String date) {
    // before adding a day check for existing days
    Days da = Days();
    days.add({date: da});
    // add days to the list of scheduled days
  }

  void checkDayExists(String date) {
    if (days.contains(date)) {
      // implement logic if date exists
    } else {
      addDay(date);
    }
  }
}

class Days {
  List<Map> schedule;
  void addTime(String time, String work) {
    schedule.add({time: work});
    // notifyListeners();
  }
}

// import 'package:flutter/material.dart';

class SelectedDate with ChangeNotifier {
  DateTime startDate;
  DateTime endDate;

  void DateSelected(DateTime strt) {
    startDate = strt;
    notifyListeners();
  }

  void DateSelectedRange(DateTime strt, DateTime end) {
    startDate = strt;
    endDate = end;
    notifyListeners();
  }

  get DateSel {
    return startDate;
  }
}
