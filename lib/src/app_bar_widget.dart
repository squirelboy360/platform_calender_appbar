//This file contains app bar
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:platform_calender_appbar/src/list_date_view.dart';

class AppBarWidget extends StatefulWidget {
  final int? position;
  final void Function(String) showFullCalendar;
  final Color accent;
  final List<DateTime> pastDates;
  final double padding;
  final bool showBackButton;
  final void Function(DateTime) onDateChanged;
  final String locale;
  final bool shouldShowFullCalender;
  final Color bright;
  final Color dark;
  final Color? bgColor;

  final DateTime selectedDate;
  final DateTime referenceDate;
  final List<dynamic> datesWithEnteries;
  const AppBarWidget({
    Key? key,
    required this.accent,
    required this.padding,
    required this.showBackButton,
    required this.bright,
    required this.dark,
    required this.selectedDate,
    required this.pastDates,
    required this.locale,
    required this.onDateChanged,
    required this.datesWithEnteries,
    required this.shouldShowFullCalender,
    required this.referenceDate,
    this.position,
    required this.showFullCalendar,
    this.bgColor,
  }) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor ?? Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.sizeOf(context).height / 6,

      ///it is based on stack of widgets
      child: Column(
        children: [
          DateListView(
              pastDates: widget.pastDates,
              onDateChanged: widget.onDateChanged,
              accent: widget.accent,
              bright: widget.bright,
              dark: widget.dark,
              locale: widget.locale,
              datesWithEnteries: widget.datesWithEnteries),
        ],
      ),
    );
  }
}
