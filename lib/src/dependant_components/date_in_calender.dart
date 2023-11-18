import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInCalendar extends StatelessWidget {
  final DateTime date;
  final bool outOfRange;
  final double width;
  final bool event;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  final Color accent;
  final Color white;
  final Color black;

  const DateInCalendar({
    super.key,
    required this.date,
    required this.outOfRange,
    required this.width,
    required this.event,
    required this.selectedDate,
    required this.onDateChange,
    required this.accent,
    required this.white,
    required this.black,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelectedDate = date.toString().split(" ").first ==
        selectedDate.toString().split(" ").first;

    return Container(
      child: GestureDetector(
        onTap: () => outOfRange ? null : onDateChange(date),
        child: Container(
          width: width / 7,
          height: width / 7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelectedDate ? accent : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  DateFormat("dd").format(date),
                  style: TextStyle(
                    color: outOfRange
                        ? isSelectedDate
                            ? white.withOpacity(0.9)
                            : black.withOpacity(0.4)
                        : isSelectedDate
                            ? white
                            : black,
                  ),
                ),
              ),
              event
                  ? Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelectedDate ? white : accent,
                      ),
                    )
                  : const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
