import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: 'Home',
      ),
      floatingActionButton: AddNewReservation(),
      body: MeetingRoomList(),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      shadowColor: const Color.fromARGB(255, 7, 161, 222),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (route) => false);
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.black,
          ),
        )
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AddNewReservation extends StatelessWidget {
  const AddNewReservation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.calendar_month),
      onPressed: () {
        Navigator.pushNamed(context, '/reservation');
      },
    );
  }
}

class MeetingRoomList extends StatefulWidget {
  const MeetingRoomList({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MeetingRoomListState createState() => _MeetingRoomListState();
}

class _MeetingRoomListState extends State<MeetingRoomList> {
  List<String> meetingRooms = ['Room 1', 'Room 2'];
  Map<String, bool> roomSelections = {
    'Room 1': false,
    'Room 2': false,
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      children: [
        Text(
          'Meeting Rooms',
          style: GoogleFonts.dancingScript(
            fontSize: 40.0,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10.0),
        ...meetingRooms.map((room) {
          bool isSelected = roomSelections[room] ?? false;
          return Dismissible(
            key: Key(room),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Row(
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.delete),
                  SizedBox(width: 10),
                  Text('Delete', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blueAccent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rename', style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.edit),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                // Delete room
                _deleteRoom(room);
              } else {
                // Rename room
                _renameRoom(context, room);
              }
            },
            child: RoomCard(
              roomName: room,
              roomDescription: 'The description of $room',
              selected: isSelected,
              onTap: () {
                _showOptions(context, room);
              },
              onFreeRoom: () {
                _freeRoom(room);
              },
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            _addNewRoom(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 227, 225, 225),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text(
            'New Room',
            style: TextStyle(color: Colors.black),
          ),
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
              if (roomSelections[roomName] ==
                  true) // Show button only if the room is selected
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _freeRoom(
                        roomName); // Call _freeRoom method when the button is pressed
                  },
                  child: const Text('Make Room Free'),
                ),
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
                        'You\'ve selected "I need $roomName immediately".',
                      ),
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
          roomName: roomName,
          onSelected: _onMinutesSelected,
        );
      },
    );
  }

  void _onMinutesSelected(String roomName, int minutes) {
    setState(() {
      if (meetingRooms.contains(roomName)) {
        roomSelections[roomName] = true;
        _startCountdownTimer(roomName, minutes);
      }
    });
  }

  void _startCountdownTimer(String roomName, int minutes) {
    Timer(Duration(minutes: minutes), () {
      setState(() {
        roomSelections[roomName] = false;
      });
    });
  }

  void _addNewRoom(BuildContext context) {
    String newRoomName = 'New Room ${meetingRooms.length + 1}';
    setState(() {
      meetingRooms.add(newRoomName);
      roomSelections[newRoomName] = false;
    });
  }

  void _deleteRoom(String roomName) {
    if (meetingRooms.length > 1) {
      setState(() {
        meetingRooms.remove(roomName);
        roomSelections.remove(roomName);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete all rooms.'),
        ),
      );
    }
  }

  void _renameRoom(BuildContext context, String roomName) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Room'),
          // iconPadding: const EdgeInsets.only(right: 20),
          //titlePadding: const EdgeInsets.only(right: 20),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new room name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newName = controller.text.trim();
                if (newName.isNotEmpty && newName != roomName) {
                  Navigator.pop(context);
                  setState(() {
                    int index = meetingRooms.indexOf(roomName);
                    if (index != -1) {
                      meetingRooms[index] = newName;
                      roomSelections[newName] =
                          roomSelections.remove(roomName)!;
                    }
                  });
                }
              },
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _freeRoom(String roomName) {
    setState(() {
      roomSelections[roomName] = false;
    });
  }
}

class MinutesDialog extends StatelessWidget {
  final String roomName;
  final Function(String, int) onSelected;

  const MinutesDialog({
    Key? key,
    required this.roomName,
    required this.onSelected,
  }) : super(key: key);

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
  final VoidCallback onFreeRoom;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.roomDescription,
    required this.selected,
    required this.onTap,
    required this.onFreeRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: selected
              ? const Color.fromARGB(255, 7, 161, 222).withOpacity(0.8)
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color.fromARGB(255, 223, 78, 78).withOpacity(0.4)
                  : const Color.fromARGB(255, 7, 161, 222).withOpacity(0.2),
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
                  color: selected
                      ? const Color.fromARGB(255, 245, 85, 49)
                      : const Color.fromARGB(255, 7, 161, 222),
                ),
                child: Icon(
                  Icons.meeting_room,
                  color: selected
                      ? const Color.fromARGB(255, 211, 223, 245)
                      : const Color.fromARGB(255, 49, 49, 49),
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
                            ? const Color.fromARGB(255, 4, 4, 4)
                                .withOpacity(0.8)
                            : const Color.fromARGB(221, 0, 0, 0),
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
                    ? Row(
                        children: [
                          // Button to free the room
                          ElevatedButton(
                            onPressed: onFreeRoom,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 155, 13),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Free Room',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Selected icon
                          Icon(
                            Icons.check_circle,
                            color: const Color.fromARGB(255, 148, 19, 10),
                            size: 24,
                            key: UniqueKey(),
                          ),
                        ],
                      )
                    : Icon(
                        Icons.circle,
                        color: const Color.fromARGB(255, 7, 161, 222),
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
