library platform_calendar_appbar;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';

class PlatformCalenderAppBar extends StatefulWidget {
  ///accent color of UI
  final Color? accent;

  ///definiton of your specific shade of white
  final Color? white;

  ///definiton of your specific shade of black
  final Color? black;

  ///the last date shown on the calendar
  final DateTime lastDate;

  ///the first date shown on the calendar
  final DateTime? firstDate;

  //the selected date shown on the calendar
  final DateTime? selectedDate;

  ///list of dates with specific event (shown as a dot above the date)
  final List<DateTime>? events;

  ///function which returns currently selected date
  final Function onDateChanged;

  ///definition of your custom padding
  final double? padding;

  ///definition of the atribute which shows full calendar view when pressing on date
  final bool? fullCalendar;

  ///[backButton] shows BackButton in set to true
  final bool? backButton;

  ///definiton of the calendar language
  final String? locale;
  final ScrollController? controller;
  const PlatformCalenderAppBar(
      {super.key,
      this.controller,
      this.accent,
      this.white,
      this.black,
      required this.lastDate,
      this.firstDate,
      this.selectedDate,
      this.events,
      required this.onDateChanged,
      this.padding,
      this.fullCalendar,
      this.backButton,
      this.locale});

  @override
  State<PlatformCalenderAppBar> createState() => _PlatformCalenderAppBarState();
}

class _PlatformCalenderAppBarState extends State<PlatformCalenderAppBar> {
  ///defininon of [selectedDate] variable of current selected date
  DateTime selectedDate = DateTime.now();

  ///defininon of [firstDate] variable of current selected date
  DateTime firstDate = DateTime.now();

  ///defininon of [position] variable of current selected calendar card
  late int position;

  ///definition of the last selected date
  late DateTime referenceDate;

  ///list of dates with specific event (shown as a dot above the date)
  List<String> datesWithEnteries = [];

  ///definiton of your specific shade of white
  late Color white;

  ///accent color of UI
  late Color accent;

  ///definiton of your specific shade of black
  late Color black;

  ///definition of your custom padding
  late double padding;

  ///definition of the atribute which shows full calendar view when pressing on date
  late bool fullCalendar;

  ///[backButton] shows BackButton in set to true
  late bool backButton;

  ///[locale] is used for current local language of the library
  String get _locale => widget.locale ?? 'en';
  @override
  Widget build(BuildContext context) {
    ///changing all dates to correct form for easier

    ///intitializing first date and setting it to midnight
    DateTime first =
        DateTime.parse("${firstDate.toString().split(" ").first} 00:00:00.000");

    ///intitializing last date and setting it to 11 pm due to the time saving
    DateTime last = DateTime.parse(
        "${widget.lastDate.toString().split(" ").first} 23:00:00.000");

    ///creating date for List generation
    DateTime basicDate =
        DateTime.parse("${first.toString().split(" ").first} 12:00:00.000");

    ///List of all dates that will be shown in scroller
    List<DateTime> pastDates = List.generate(
        (last.difference(first).inHours / 24).round(),
        (index) => basicDate.add(Duration(days: index)));

    ///Sorting dates in descending order
    pastDates.sort((b, a) => a.compareTo(b));

    //!
    //!

    Widget listDateView() => ListView.builder(
        padding: pastDates.length < 5
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width *
                    (5 - pastDates.length) /
                    10)
            : const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        reverse: true,
        //controller: widget.controller ?? ScrollController(),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: pastDates.length,
        itemBuilder: (context, index) {
          ///definition date which is set to the current building date from dates list
          DateTime date = pastDates[index];

          ///if position of currently selected is equal to index + 1 (counting of positions starts with 1)
          bool isSelected = position == index + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              ///if pressed on specific date, set it as selected
              onTap: () {
                setState(() {
                  ///if user taps on this card set all parameters to this date
                  selectedDate = date;
                  referenceDate = selectedDate;
                  position = index + 1;
                });
                widget.onDateChanged(selectedDate);
              },

              ///different UI for nonselected containers and the selected ones
              ///this is the definition of the main container of calendar card
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 5 - 4.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Container(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width / 5 - 4.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: isSelected ? white : null,
                        boxShadow: [
                          isSelected
                              ? BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              : BoxShadow(
                                  color: Colors.grey.withOpacity(0.0),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                )
                        ],
                      ),

                      ///definition of content inside of calendar card
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///indicators of event on specific date
                          datesWithEnteries
                                  .contains(date.toString().split(" ").first)
                              ? Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? accent
                                        : white.withOpacity(0.6),
                                  ),
                                )
                              : const SizedBox(
                                  height: 5.0,
                                ),
                          const SizedBox(height: 10),

                          ///date number
                          Text(
                            DateFormat("dd").format(date),
                            style: TextStyle(
                                fontSize: 22.0,
                                color: isSelected
                                    ? accent
                                    : white.withOpacity(0.6),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),

                          ///day of the week
                          Text(
                            DateFormat.E(Locale(_locale).toString())
                                .format(date),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: isSelected
                                    ? accent
                                    : white.withOpacity(0.6),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    //!
    //!

    return PlatformScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: ScrollController(),
        slivers: <Widget>[
          Platform.isIOS
              ? const CupertinoSliverNavigationBar(
                  largeTitle: Text('Stats'),
                )
              : const SliverAppBar.large(
                  floating: true,
                  pinned: true,
                  key: ValueKey('nav_bar'),
                  title: Text('test'),
                ),

          // const SliverToBoxAdapter(
          //   child: Text('Test'),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.zero,
          //   sliver:
          SliverFillRemaining(
            child: listDateView(),
          ),
        ],
      ),
    );
  }
}
