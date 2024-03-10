import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late final CalendarController _calendarController;
  late final DateTime _focusedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  // Define a list of meeting rooms
  List<String> meetingRooms = [
    'Meeting Room 1',
    'Meeting Room 2',
    'Meeting Room 3'
  ];
  String selectedMeetingRoom = 'Meeting Room 1';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown to select meeting room
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: selectedMeetingRoom,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMeetingRoom = newValue!;
                  });
                },
                items:
                    meetingRooms.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 1.2,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.width * 0.95,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TableCalendar(
                    //calendarController: _calendarController,
                    focusedDay: _focusedDay,
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    calendarFormat: CalendarFormat.month,
                    onFormatChanged: (format) {},
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDate = selectedDay;
                      });
                    },

                    calendarStyle: CalendarStyle(
                      tablePadding: const EdgeInsets.all(20),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.red),
                      weekdayStyle: TextStyle(color: Colors.black),
                    ),
                    weekendDays: const [
                      DateTime.friday,
                      DateTime.saturday
                    ], // Define Fri and Sat as weekend days
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.week: 'Week',
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20, width: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select a time:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              },
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final hour = index + 8;
                return GestureDetector(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      height: 55,
                      width: 55,
                      child: Center(child: Text('$hour :00'))),
                  onTap: () {
                    final selectedDate = _calendarController.selectedDay;
                    final selectedTime = TimeOfDay(hour: hour, minute: 0);
                    if (kDebugMode) {
                      print(
                          'Selected Date: $selectedDate, Selected Time: $selectedTime');
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarController {
  get selectedDay => null;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReservationPage(),
    );
  }
}
