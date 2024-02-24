import 'package:flutter/material.dart';
import 'package:letsmeet/Auth_screens/company.dart';
import 'package:letsmeet/Auth_screens/signup.dart';
import 'package:letsmeet/Screens/Auth/login_screen.dart';
import 'package:letsmeet/homepage_screen/homescreen.dart';
import 'package:letsmeet/services_screens/reservation.dart';

void main() {
  runApp(const ReservationApp());
}

class ReservationApp extends StatelessWidget {
  const ReservationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CompanyNamePage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/reservation': (context) => const ReservationPage(),
        '/login': (context) => const LoginPage()
      },
    );
  }
}
