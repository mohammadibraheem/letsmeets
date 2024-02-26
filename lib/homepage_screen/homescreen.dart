import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
              context, '/reservation'); // Navigate to ReservationPage
        },
      ),
      body: const MeetingRoomList(),
    );
  }
}

class MeetingRoomList extends StatefulWidget {
  const MeetingRoomList({
    super.key,
  });

  @override
  _MeetingRoomListState createState() => _MeetingRoomListState();
}

class _MeetingRoomListState extends State<MeetingRoomList> {
  bool room1Selected = false;
  bool room2Selected = false;
  List<String> meetingRooms = ['Room 1', 'Room 2'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      children: [
        const Text(
          'Meeting Rooms',
          style: TextStyle(fontSize: 20.0, color: Colors.blueGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        ...meetingRooms.map((room) {
          bool isSelected = room == 'Room 1'
              ? room1Selected
              : room == 'Room 2'
                  ? room2Selected
                  : false;
          return RoomCard(
            roomName: room,
            roomDescription: 'The description of $room',
            selected: isSelected,
            onTap: () {
              _showOptions(context, room);
            },
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            _addNewRoom(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text('Add New Room'),
        ),
      ],
    );
  }

  void _showOptions(BuildContext context, String roomName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for $roomName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showMinutesDialog(context, roomName);
                },
                child: Text('I\'m using $roomName'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'You\'ve selected "I need $roomName immediately".'),
                    ),
                  );
                },
                child: Text('I need $roomName immediately'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMinutesDialog(BuildContext context, String roomName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MinutesDialog(
            key: UniqueKey(),
            roomName: roomName,
            onSelected: _onMinutesSelected);
      },
    );
  }

  void _onMinutesSelected(String roomName, int minutes) {
    setState(() {
      if (roomName == 'Room 1') {
        room1Selected = true;
        _startCountdownTimer(roomName, minutes);
      } else if (roomName == 'Room 2') {
        room2Selected = true;
        _startCountdownTimer(roomName, minutes);
      }
    });
  }

  void _startCountdownTimer(String roomName, int minutes) {
    Timer(Duration(minutes: minutes), () {
      setState(() {
        if (roomName == 'Room 1') {
          room1Selected = false;
        } else if (roomName == 'Room 2') {
          room2Selected = false;
        }
      });
    });
  }

  void _addNewRoom(BuildContext context) {
    String newRoomName = 'New Room ${meetingRooms.length + 1}';
    setState(() {
      meetingRooms.add(newRoomName);
    });
  }
}

class MinutesDialog extends StatelessWidget {
  final String roomName;
  final Function(String, int) onSelected;

  const MinutesDialog(
      {required Key key, required this.roomName, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Minutes for $roomName'),
      content: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select the number of minutes:'),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 150,
              child: ListWheelScrollView(
                itemExtent: 50,
                children: List.generate(
                  60,
                  (index) => Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSelected(roomName, index + 1);
                      },
                      child: Text(
                        '${index + 1} min',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class RoomCard extends StatelessWidget {
  final String roomName;
  final String roomDescription;
  final bool selected;
  final VoidCallback onTap;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.roomDescription,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: selected ? Colors.blueAccent.withOpacity(0.8) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: selected
                  ? Colors.blueAccent.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? Colors.white : Colors.blueAccent,
                ),
                child: Icon(
                  Icons.meeting_room,
                  color: selected ? Colors.blueAccent : Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      roomDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: selected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                        key: UniqueKey(),
                      )
                    : Icon(
                        Icons.circle,
                        color: Colors.grey,
                        size: 24,
                        key: UniqueKey(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
