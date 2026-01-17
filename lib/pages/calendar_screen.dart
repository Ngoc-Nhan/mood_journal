import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

final List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

final List<int> _years = List.generate(15, (index) => 2020 + index);

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(18),

      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),

          Row(
            //month
            children: [
              SizedBox(width: 16),
              DropdownButton(
                value: _selectedMonth,
                underline: SizedBox(),
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_months[index]),
                  );
                }),
                onChanged: (value) {
                  if (value == null || value == _selectedMonth) return;

                  setState(() {
                    _selectedMonth = value;
                    _focusedDay = DateTime(_selectedYear, _selectedMonth, 1);
                  });
                },
              ),
              // SizedBox(width: 16),
              //year
              DropdownButton<int>(
                value: _selectedYear,
                underline: const SizedBox(),
                items: _years.map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value == null || value == _selectedYear) return;
                  setState(() {
                    _selectedYear = value;
                    _focusedDay = DateTime(_selectedYear, _selectedMonth, 1);
                  });
                },
              ),
            ],
          ),
          TableCalendar(
            rowHeight: 48,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            // focusedDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            locale: 'en_US',
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDate, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDate)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDate;
                  _focusedDay = focusedDay;
                });
              }
            },
            // onFormatChanged: (format) {
            //   if (_calendarFormat != format) {
            //     // Call `setState()` when updating calendar format
            //     setState(() {
            //       _calendarFormat = format;
            //     });
            //   }
            // },
            // onPageChanged: (focusedDay) {
            //   // No need to call `setState()` here
            //   _focusedDay = focusedDay;
            // },
            onPageChanged: (focusedDay) {
              if (_focusedDay.month != focusedDay.month ||
                  _focusedDay.year != focusedDay.year) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedMonth = focusedDay.month;
                  _selectedYear = focusedDay.year;
                });
              }
            },

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blueGrey),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.blueGrey,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyle(color: Colors.black),
              todayDecoration: BoxDecoration(
                // style: TextStyle(color: Colors.black),
                border: Border.all(
                  color: const Color.fromARGB(255, 236, 146, 176),

                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 146, 176),
                shape: BoxShape.circle,
              ),
            ),
            // selectedDecoration: BoxDecoration(
            //   color: Colors.orange,
            //   shape: BoxShape.circle,
            // ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
