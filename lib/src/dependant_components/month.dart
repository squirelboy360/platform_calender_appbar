// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:platform_calender_appbar/src/dependant_components/date_in_calender.dart';

class Month extends StatelessWidget {
  final List dates;
  final double width;
  final String locale;
  final Function(DateTime) onDateChange;
  final List events;
  final Color accent;
  final double padding;
  final DateTime startDate;
  final DateTime endDate;
  final Color dark;
  final Color bright;

  const Month({
    Key? key,
    required this.dates,
    required this.width,
    required this.locale,
    required this.onDateChange,
    required this.events,
    required this.accent,
    required this.padding,
    required this.startDate,
    required this.endDate,
    required this.dark,
    required this.bright,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///definition of first and initializing it on the first date int the month
    DateTime first = dates.first;
    while (DateFormat("E").format(dates.first) != "Mon") {
      ///add "empty fields" to the list to get offset of the days
      dates.add(dates.first.subtract(const Duration(days: 1)));

      ///sort all the dates
      dates.sort();
    }

    ///logically show all the dates in the month
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///name of the month
          Text(
            DateFormat.MMMM(Locale(locale).toString()).format(first),
            style: TextStyle(
                fontSize: 18.0, color: dark, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: daysOfWeek(width, locale, dark),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              ///calculate the number of rows with dates based on number of days in the month
              height: dates.length > 28
                  ? dates.length > 35
                      ? 6 * width / 7
                      : 5 * width / 7
                  : 4 * width / 7,
              width: MediaQuery.of(context).size.width - 2 * padding,

              ///show all days in the month
              child: GridView.builder(
                itemCount: dates.length,

                ///Since each calendar is drawn separatly it shouldn't be scrollable
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemBuilder: (context, index) {
                  ///create date for each day in the month
                  DateTime date = dates[index];

                  ///check if it is empty field
                  bool outOfRange =
                      date.isBefore(startDate) || date.isAfter(endDate);

                  ///if it is empty field return empty container
                  if (date.isBefore(first)) {
                    return Container(
                      width: width / 7,
                      height: width / 7,
                      color: Colors.transparent,
                    );
                  }

                  ///otherwise return date container
                  else {
                    return DateInCalendar(
                        date: date,
                        outOfRange: outOfRange,
                        width: width,
                        event:
                            events.contains(date.toString().split(" ").first) &&
                                !outOfRange,
                        selectedDate: date,
                        onDateChange: onDateChange,
                        accent: accent,
                        white: bright,
                        black: dark);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
//  date,
//                       outOfRange,
//                       width,

///definiton of week row that shows the day of the week for specific week
Widget daysOfWeek(double width, String? locale, Color dark) {
  List daysNames = [];
  for (var day = 12; day <= 19; day++) {
    daysNames.add(
        DateFormat.E(locale.toString()).format(DateTime.parse('1970-01-$day')));
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      dayName(width / 7, daysNames[0], dark),
      dayName(width / 7, daysNames[1], dark),
      dayName(width / 7, daysNames[2], dark),
      dayName(width / 7, daysNames[3], dark),
      dayName(width / 7, daysNames[4], dark),
      dayName(width / 7, daysNames[5], dark),
      dayName(width / 7, daysNames[6], dark),
    ],
  );
}

///definition of day widget
Widget dayName(double width, String text, Color color) {
  return Container(
    width: width,
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: color.withOpacity(0.8)),
    ),
  );
}
