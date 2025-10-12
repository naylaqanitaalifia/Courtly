import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sewa_lapangan_app/pages/landing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Court Booking",
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}