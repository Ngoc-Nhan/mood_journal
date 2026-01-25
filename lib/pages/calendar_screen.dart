import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/components/listview/build_note_detail.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:mood_journal/widgets/note_card.dart';
import 'package:provider/provider.dart';
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
  late final ValueNotifier<List<NoteModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  List<NoteModel> _getEventsForDay(
    DateTime day,
    Map<String, List<NoteModel>> groupedNotes,
  ) {
    return groupedNotes[_formatDate(day)] ?? [];
  }

  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
    Map<String, List<NoteModel>> groupedNotes,
  ) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay, groupedNotes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        // Initialize the selected events for the first time
        if (_selectedEvents.value.isEmpty &&
            noteProvider.groupedNotes.containsKey(_formatDate(_focusedDay))) {
          _selectedEvents.value = _getEventsForDay(
            _focusedDay,
            noteProvider.groupedNotes,
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Calendar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
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
                          _focusedDay = DateTime(
                            _selectedYear,
                            _selectedMonth,
                            1,
                          );
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
                          _focusedDay = DateTime(
                            _selectedYear,
                            _selectedMonth,
                            1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TableCalendar<NoteModel>(
                  rowHeight: 48,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  eventLoader: (day) =>
                      _getEventsForDay(day, noteProvider.groupedNotes),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: _calendarFormat,
                  locale: 'en_US',
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selected, focused) => _onDaySelected(
                    selected,
                    focused,
                    noteProvider.groupedNotes,
                  ),
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
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.primary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 1,
                    markerDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    todayDecoration: BoxDecoration(
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
                ),
              ),
              const Divider(),
              ValueListenableBuilder<List<NoteModel>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  if (value.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("No notes for this day."),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return BuildNoteDetail(note: value[index]);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
