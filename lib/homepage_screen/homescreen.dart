import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
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
  const MeetingRoomList({super.key});

  @override
  _MeetingRoomListState createState() => _MeetingRoomListState();
}

class _MeetingRoomListState extends State<MeetingRoomList> {
  bool room1Selected = false;
  bool room2Selected = false;
  List<String> meetingRooms = [
    'Room 1',
    'Room 2'
  ]; // Initialize with existing rooms

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
          return RoomListItem(
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

class RoomListItem extends StatelessWidget {
  final String roomName;
  final String roomDescription;
  final bool selected;
  final VoidCallback onTap;

  const RoomListItem({
    super.key,
    required this.roomName,
    required this.roomDescription,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.meeting_room,
        color: selected ? Colors.red : null,
      ),
      title: Text(roomName),
      subtitle: Text(roomDescription),
      onTap: onTap,
    );
  }
}
