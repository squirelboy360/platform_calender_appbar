// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:platform_calender_appbar/src/dependant_components/month.dart';

///definition of full calendar shown in modal bottom sheet
class FullCalendar extends StatefulWidget {
  ///same variables as in PlatformCalendarAppBar class
  ///the first date shown on the calendar
  final DateTime startDate;

  ///the last date shown on the calendar
  final DateTime endDate;

  ///currently selected date
  final DateTime selectedDate;

  ///definiton of your specific shade of black
  final Color dark;

  ///accent color of UI
  final Color accent;

  ///definiton of your specific shade of white
  final Color bright;

  ///definition of your custom padding
  final double padding;

  ///definition of height
  final double height;

  ///definition of locale
  final String locale;

  ///list of dates with specific event (shown as a dot above the date)
  final List<String> events;

  ///function which returns currently selected date
  final Function(DateTime) onDateChange;

  const FullCalendar({
    Key? key,
    required this.startDate,
    required this.padding,
    required this.onDateChange,
    required this.endDate,
    required this.dark,
    required this.accent,
    required this.bright,
    required this.height,
    required this.locale,
    required this.selectedDate,
    required this.events,
  }) : super(key: key);
  @override
  FullCalendarState createState() => FullCalendarState();
}

class FullCalendarState extends State<FullCalendar> {
  ///definition of [endDate]
  late DateTime endDate;

  ///definition of [startDate]
  late DateTime startDate;

  ///definition of [events]
  List<String>? events = [];

  ///transforming variables to correct form
  @override
  void initState() {
    setState(() {
      ///parsing [startDate] String to DateTime
      startDate = DateTime.parse(
          "${widget.startDate.toString().split(" ").first} 00:00:00.000");

      ///parsing [endDate] String to DateTime
      endDate = DateTime.parse(
          "${widget.endDate.toString().split(" ").first} 23:00:00.000");

      ///initializing [events]
      events = widget.events;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///transforming variables to correct form

    ///creating List of parts [partsStart] of DateTime String format
    List<String> partsStart = startDate.toString().split(" ").first.split("-");

    ///parsing [partsStart] List of Strings to DateTime
    DateTime firstDate = DateTime.parse(
        "${partsStart.first}-${partsStart[1].padLeft(2, '0')}-01 00:00:00.000");

    ///creating List of parts [partsEnd] of DateTime String format
    List<String> partsEnd = endDate.toString().split(" ").first.split("-");

    ///parsing [partsStart] List of Strings to DateTime
    DateTime lastDate = DateTime.parse(
            "${partsEnd.first}-${(int.parse(partsEnd[1]) + 1).toString().padLeft(2, '0')}-01 23:00:00.000")
        .subtract(const Duration(days: 1));

    ///calculating the height based of the screen height
    double width = MediaQuery.of(context).size.width - (2 * widget.padding);

    ///definition of DateTime list dates
    List<DateTime?> dates = [];

    /// definition of [referenceDate]
    DateTime referenceDate = firstDate;

    ///creating list for calendar matrix
    while (referenceDate.isBefore(lastDate)) {
      List<String> referenceParts = referenceDate.toString().split(" ");
      DateTime newDate = DateTime.parse("${referenceParts.first} 12:00:00.000");
      dates.add(newDate);

      ///adding next date
      referenceDate = newDate.add(const Duration(days: 1));
    }

    ///check if range is in the same month
    if (firstDate.year == lastDate.year && firstDate.month == lastDate.month) {
      return Padding(
          padding:
              EdgeInsets.fromLTRB(widget.padding, 40.0, widget.padding, 0.0),
          child: Month(
            dates: dates,
            width: width,
            locale: widget.locale,
            onDateChange: widget.onDateChange,
            events: widget.events,
            accent: widget.accent,
            padding: widget.padding,
            startDate: startDate,
            endDate: endDate,
            dark: widget.dark,
            bright: widget.bright,
            //dates, width, widget.locale
          ));
    } else {
      ///creating the list of the month in the range
      List<DateTime?> months = [];
      for (int i = 0; i < dates.length; i++) {
        if (i == 0 || (dates[i]!.month != dates[i - 1]!.month)) {
          months.add(dates[i]);
        }
      }

      ///sort months
      months.sort((b, a) => a!.compareTo(b!));
      return Padding(
        padding: EdgeInsets.fromLTRB(widget.padding, 40.0, widget.padding, 0.0),
        child: Container(
          ///scrolling of calendar
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: months.length,
              itemBuilder: (context, index) {
                DateTime? date = months[index];
                List<DateTime?> daysOfMonth = [];
                for (var item in dates) {
                  if (date!.month == item!.month && date.year == item.year) {
                    daysOfMonth.add(item);
                  }
                }

                ///check if the date is the last
                bool isLast = index == 0;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 25.0),
                  child: Month(
                    dates: dates,
                    width: width,
                    locale: widget.locale,
                    events: widget.events,
                    padding: widget.padding,
                    startDate: startDate,
                    endDate: endDate,
                    dark: widget.dark,
                    bright: widget.bright,
                    onDateChange: widget.onDateChange,
                    accent: widget.accent,
                  ),
                );
              }),
        ),
      );
    }
  }
}

// daysOfMonth, width, widget.locale