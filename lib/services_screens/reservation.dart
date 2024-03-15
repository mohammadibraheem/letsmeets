import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late final DateTime _focusedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  DateTime? selectedDate;
  int? selectedFromTimeSlot;
  int? selectedToTimeSlot;

  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildTimeSlotSelection('From', () {
              setState(() {
                selectedFromTimeSlot = selectedToTimeSlot;
              });
            }),
            const SizedBox(height: 20),
            _buildTimeSlotSelection('To', () {
              setState(() {
                selectedToTimeSlot = selectedToTimeSlot;
              });
            }),
            const SizedBox(height: 20),
            _buildReserveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select a Date:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 400,
          child: TableCalendar(
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
              cellMargin: const EdgeInsets.all(4.0),
              cellPadding: const EdgeInsets.all(4.0),
              canMarkersOverflow: false,
              todayDecoration: const BoxDecoration(
                color: Color.fromRGBO(0, 6, 11, 0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.red),
              outsideDaysVisible: false,
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
            weekendDays: const [DateTime.friday, DateTime.saturday],
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection(String title, Function() onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select $title Time:',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final hour = index + 8;
              final isSelected = title == 'From'
                  ? selectedFromTimeSlot == index
                  : selectedToTimeSlot == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedToTimeSlot = index;
                    onSelect();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  height: 55,
                  width: 55,
                  child: Center(
                    child: Text(
                      '$hour:00',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReserveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _showReservationConfirmationDialog();
        },
        child: const Text('Reserve'),
      ),
    );
  }

  void _showReservationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reservation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${selectedDate.toString()}'), // remove zeros
              Text('From Time: ${(selectedFromTimeSlot! + 8).toString()}:00'),
              Text('To Time: ${(selectedToTimeSlot! + 8).toString()}:00'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _confirmReservation();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _confirmReservation() {
    // Perform the reservation confirmation logic here
    print('Reservation confirmed!');
  }
}
