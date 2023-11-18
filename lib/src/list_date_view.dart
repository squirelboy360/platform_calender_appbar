import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateListView extends StatefulWidget {
  final Color accent;
  final Color bright;
  final String locale;
  final List datesWithEnteries;
  final Color dark;
  final List<DateTime> pastDates;
  final void Function(DateTime) onDateChanged;

  const DateListView(
      {super.key,
      required this.pastDates,
      required this.onDateChanged,
      required this.accent,
      required this.bright,
      required this.dark,
      required this.locale,
      required this.datesWithEnteries});

  @override
  DateListViewState createState() => DateListViewState();
}

class DateListViewState extends State<DateListView> {
  DateTime selectedDate = DateTime.now(); // Provide an initial value
  DateTime referenceDate = DateTime.now(); // Provide an initial value
  int position = 1; // Provide an initial value

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: widget.pastDates.length < 5
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width *
                    (5 - widget.pastDates.length) /
                    10)
            : const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: widget.pastDates.length,
        itemBuilder: (context, index) {
          DateTime date = widget.pastDates[index];
          bool isSelected = position == index + 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                  referenceDate = selectedDate;
                  position = index + 1;
                });
                widget.onDateChanged(selectedDate);
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 5 - 4.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    //Date highlighter widget
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.width / 5 - 4.0,
                        width: MediaQuery.of(context).size.width / 5 - 4.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360.0),
                          color: isSelected ? widget.bright : null,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.datesWithEnteries
                                    .contains(date.toString().split(" ").first)
                                ? Container(
                                    width: 5.0,
                                    height: 5.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? widget.accent
                                          : widget.bright.withOpacity(0.6),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 5.0,
                                  ),
                            const SizedBox(height: 10),
                            Text(
                              DateFormat("dd").format(date),
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: isSelected
                                      ? widget.accent
                                      : widget.bright.withOpacity(0.6),
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat.E(Locale(widget.locale).toString())
                                  .format(date),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: isSelected
                                      ? widget.accent
                                      : widget.bright.withOpacity(0.6),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
