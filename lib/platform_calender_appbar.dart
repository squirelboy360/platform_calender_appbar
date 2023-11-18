library platform_calendar_appbar;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:platform_calender_appbar/src/app_bar_calender_scroll.dart';
import 'package:platform_calender_appbar/src/app_bar_widget.dart';

class PlatformCalenderAppBar extends StatefulWidget {
  ///accent color of UI
  final Color? accent;

  ///definiton of your specific shade of white
  final Color? bright;

  ///definiton of your specific shade of black
  final Color? dark;

  ///the last date shown on the calendar
  final DateTime lastDate;

  ///the first date shown on the calendar
  final DateTime? firstDate;

  //the selected date shown on the calendar
  final DateTime? selectedDate;

  ///list of dates with specific event (shown as a dot above the date)
  final List<DateTime>? events;

  ///function which returns currently selected date
  final Function(DateTime) onDateChanged;

  ///definition of your custom padding
  final double? padding;

  ///definition of the atribute which shows full calendar view when pressing on date
  final bool? shouldShowFullCalender;

  ///[backButton] shows BackButton in set to true
  final bool? showBackButton;

  ///[scrollController] controls Scrollview
  final ScrollController scrollController;

  ///[fullCalendarBgColor] background color of full Calendar on expanded
  final Color? fullCalendarBgColor;

  ///definiton of the calendar language
  final String? locale;
  final ScrollController? controller;
  const PlatformCalenderAppBar(
      {super.key,
      this.controller,
      this.accent,
      required this.lastDate,
      this.firstDate,
      this.selectedDate,
      this.events,
      required this.onDateChanged,
      this.padding,
      this.shouldShowFullCalender,
      this.showBackButton,
      this.locale,
      this.bright,
      this.dark,
      required this.scrollController,
      this.fullCalendarBgColor});

  @override
  State<PlatformCalenderAppBar> createState() => _PlatformCalenderAppBarState();
}

class _PlatformCalenderAppBarState extends State<PlatformCalenderAppBar> {
//!initialization and re-assignment of events values
  @override
  void initState() {
    ///initializing accent
    accent = widget.accent ?? Colors.blue;

    ///initilizing first date
    firstDate = widget.firstDate ?? DateTime(1950);

    ///initializing white
    bright = widget.bright ?? Colors.white;

    ///initializing black
    dark = widget.dark ?? Colors.black87;

    ///initializing padding
    padding = widget.padding ?? 25.0;

    ///initializing backbutton
    showBackButton = widget.showBackButton ?? false;

    //! ///initializing fullCalendar
    //! fullCalendar = fullCalendar;
    //! Initializing fullCalendar correctly
    fullCalendar = widget.shouldShowFullCalender ?? false;

    ///initializing firstDate
    selectedDate = widget.selectedDate ?? widget.lastDate;

    ///initializing referenceDate
    referenceDate = referenceDate;

    ///initializing language
    initializeDateFormatting(locale);

    ///initializing position to 1
    position = 1;

    ///changing event list to specific form
    if (widget.events != null) {
      ///for each item from event list, add just date String without time
      for (var element in widget.events!) {
        datesWithEnteries.add(element.toString().split(" ").first);
      }
    }
    super.initState();
  }

  ///defininon of [selectedDate] variable of current selected date
  DateTime selectedDate = DateTime.now();

  ///defininon of [firstDate] variable of current selected date
  DateTime firstDate = DateTime.now();

  ///defininon of [position] variable of current selected calendar card
  int position = 0;

  ///definition of the last selected date
  DateTime referenceDate = DateTime.now();

  ///list of dates with specific event (shown as a dot above the date)
  List<String> datesWithEnteries = [];

  ///definiton of your specific shade of white
  Color bright = Colors.white;

  ///accent color of UI
  Color accent = const Color.fromRGBO(3, 169, 244, 1);

  ///definiton of your specific shade of black
  Color dark = Colors.black;

  ///definition of your custom padding
  double padding = 0.0;

  ///definition of the atribute which shows full calendar view when pressing on date
  bool fullCalendar = false;

  ///[backButton] shows BackButton in set to true
  bool showBackButton = false;

  ///[locale] is used for current local language of the library
  String get locale => widget.locale ?? 'en';
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

    ///this function show full calendar view currently shown as modal bottom sheet
    // it would be passed down to the widget tree.
    showFullCalendar(String locale) {
      showPlatformModalSheet<void>(
        cupertino: CupertinoModalSheetData(semanticsDismissible: true),
        material: MaterialModalSheetData(
          isScrollControlled: true,
          backgroundColor: widget.fullCalendarBgColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          double height;
          DateTime? endDate = widget.lastDate;

          if (firstDate.year == endDate.year &&
              firstDate.month == endDate.month) {
            height =
                ((MediaQuery.of(context).size.width - 2 * padding) / 7) * 5 +
                    150.0;
          } else {
            height = (MediaQuery.of(context).size.height - 100.0);
          }
          return Container(
            height: height,

            ///usage of full calender widget, which is defined below
            child: FullCalendar(
              height: height,
              startDate: firstDate,
              endDate: endDate,
              padding: padding,
              accent: accent,
              black: dark,
              white: bright,
              events: datesWithEnteries,
              selectedDate: referenceDate,
              locale: locale,
              onDateChange: (value) {
                ///systematics of selecting specific date
                //HapticFeedback.lightImpact();

                ///hide modal bottom sheet
                Navigator.pop(context);

                ///define new variables
                DateTime referentialDate = DateTime.parse(
                    "${value.toString().split(" ").first} 12:00:00.000");

                ///definition of [oldPosition]
                int? oldPosition;

                ///definition of [positionDifference]
                late int positionDifference;

                ///calculate new position of scrollview
                setState(() {
                  ///setting current position to old position
                  oldPosition = position;

                  ///counting the difference between dates
                  positionDifference =
                      -((referentialDate.difference(referenceDate).inHours / 24)
                          .round());
                });

                ///saving current offset
                double offset = widget.scrollController.offset;

                ///counting card width (similar to above)
                double widthUnit = MediaQuery.of(context).size.width / 5 - 4.0;

                ///wait to modal bottom sheet to hide
                Future.delayed(const Duration(milliseconds: 100), () {
                  ///definition maximal offset based on maxScrollExtent
                  double maxOffset =
                      widget.scrollController!.position.maxScrollExtent;

                  ///definition of minimal offset
                  double minOffset = 0.0;

                  ///counting current offset based of curren positon
                  double newOffset =
                      (offset + (widthUnit * positionDifference));

                  ///if current offset is out of bounderies set it to maximal or minimal offset
                  if (newOffset > maxOffset) {
                    newOffset = maxOffset;
                  } else if (newOffset < minOffset) {
                    newOffset = minOffset;
                  }

                  ///scroll the calendar scroller to the selected date
                  widget.scrollController?.animateTo(newOffset,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);

                  ///wait on animation to be finished
                  Future.delayed(const Duration(milliseconds: 550), () {
                    setState(() {
                      ///set slected date to current value
                      selectedDate = value;

                      ///set refernece date to selected date
                      referenceDate = selectedDate;

                      ///change position to current position
                      position = oldPosition! + positionDifference;
                    });
                  });
                });

                ///call function to return new selected date
                widget.onDateChanged(value);
              },
            ),
          );
        },
      );
    }

//!
//!AppBar
    Widget topButtons() {
      return Row(
        children: [
          //Houses the optional Backbutton and FullCalender
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.padding ?? 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (widget.padding! * 2),
              child: widget.showBackButton ?? false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: widget.bright,
                              ),
                              onTap: () => Navigator.pop(context)),
                          GestureDetector(
                            onTap: () => widget.shouldShowFullCalender ?? false
                                ? showFullCalendar(widget.locale ?? 'en')
                                : null,
                            child: Text(
                              DateFormat.yMMMM(
                                      Locale(widget.locale ?? 'en').toString())
                                  .format(
                                      widget.selectedDate ?? DateTime.now()),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: widget.bright,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => widget.shouldShowFullCalender ?? false
                              ? showFullCalendar(widget.locale ?? 'en')
                              : null,
                          child: Text(
                            DateFormat.yMMMM(
                                    Locale(widget.locale ?? 'en').toString())
                                .format(widget.selectedDate ?? DateTime.now()),
                            style: TextStyle(
                                fontSize: 20.0,
                                color: widget.bright,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    }
    //!

//Main AppBar code begins here
    return PlatformScaffold(
      body: CustomScrollView(
        clipBehavior: Clip.hardEdge,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        controller: ScrollController(),
        slivers: <Widget>[
          Platform.isIOS
              ? SliverToBoxAdapter(
                  //AppBar
                  child: Column(
                    children: [
                      Platform.isIOS
                          ? CupertinoNavigationBar(
                              middle: topButtons(),
                            )
                          : AppBar(),
                      AppBarWidget(
                          accent: accent,
                          bgColor: widget.fullCalendarBgColor,
                          padding: padding,
                          showBackButton: widget.showBackButton ?? false,
                          bright: bright,
                          dark: dark,
                          selectedDate: selectedDate,
                          pastDates: pastDates,
                          locale: widget.locale ?? 'en',
                          onDateChanged: widget.onDateChanged,
                          datesWithEnteries: datesWithEnteries,
                          shouldShowFullCalender:
                              widget.shouldShowFullCalender ?? false,
                          referenceDate: referenceDate,
                          showFullCalendar: showFullCalendar),
                    ],
                  ),
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
        ],
      ),
    );
  }
}
