import 'package:flutter/material.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFE76E50);
    const bg = Color(0xFFF8F6F4);
    const textDark = Color(0xFF111111);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E2DE), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFAE2DC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: coral,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'EventPlanner',
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }
}
