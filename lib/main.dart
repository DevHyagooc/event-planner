import 'package:flutter/material.dart';
import 'pages/agenda.dart';

void main() {
  runApp(const EventPlannerApp());
}

class EventPlannerApp extends StatelessWidget {
  const EventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Agenda(),
    );
  }
}
